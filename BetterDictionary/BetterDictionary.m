//
//  BetterDictionary.m
//  BetterDictionary
//
//  Created by Pooria Azimi on 27/8/2011.
//  2011-2014 by Pooria Azimi. No rights reserved.
//

#import "BetterDictionary.h"

#define SAVED_WORDS_ARRAY @"savedWordsArray"

@implementation BetterDictionary

/*
 Original implementation of setSearchText:/asyncDictionarySearchDidFound: methods
 */
static IMP originalSetSearchText; // Snow Leopard
static IMP originalAsyncDictionarySearchDidFound; // (Mountain) Lion
static IMP originalClearSearchResult; // (Mountain) Lion

@synthesize savedWordsArray;

#pragma mark -
/*
 SIMBL calls this method when the bundle is first loaded.
 */
+ (void)load
{
	[[self alloc] init];
}

/*
 Init
 */
- (id)init
{
    self = [super init];
    if (self) {
		DebugLog(@"INIT");

		sidebarWidth = 130;
		sidebarIsVisible = NO;
		searchedWord = @"";

		betterDictionaryBundle = [NSBundle bundleWithIdentifier:@"com.pooriaazimi.betterdictionary"];

		mainApplication = [NSApplication sharedApplication];

        idleWhileNoMainMenu = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(pollMainWindow) userInfo:nil repeats:YES];
	}

	return self;
}

- (void)pollMainWindow {

    mainWindow = [mainApplication mainWindow];
    DebugLog(@"mainWindow: %@", mainWindow);

    if (!mainWindow) {
        DebugLog(@"No Main Menu... Idling");
        return;
    } else {
        [idleWhileNoMainMenu invalidate];
    }

    dictionaryBrowserWindowController = [mainWindow windowController];
    DebugLog(@"dictionaryBrowserWindowController: %@", dictionaryBrowserWindowController);

    dictionaryBrowserWindow = [dictionaryBrowserWindowController window];
    DebugLog(@"dictionaryBrowserWindow: %@", dictionaryBrowserWindow);

    dictionaryController = [dictionaryBrowserWindowController performSelector:@selector(_dictionaryController)];
    DebugLog(@"dictionaryController: %@", dictionaryController);

    dictionaryBrowserToolbar = [[mainApplication mainWindow] toolbar];
    DebugLog(@"dictionaryBrowserToolbar: %@", dictionaryBrowserToolbar);


    [self determineApplicationVersion];

    [self initToolbarItems];
    [self addSidebar];
    [self createMenuItems];
    [self initSavedWordsArray];
    [self startInterceptingSearchTextMethod];
    [self searchedWord];
    [self setSaveOrRemoveToolbarButtonAccordingly];
}

/*
 Checks the application version (Snow Leopard, Lion or Mountain Lion), by checking whether DictionaryController responds to certain selectors or not.
 */
- (void)determineApplicationVersion
{
	DebugLog(@"%@", dictionaryBrowserWindow);
    if ([dictionaryController respondsToSelector:@selector(tableView:selectionIndexesForProposedSelection:)]) { // Yosemite
        appVersion = YOSEMITE;
    } else if ([dictionaryController respondsToSelector:@selector(updateHeadwordArrayStateAndWindowTitle)]) { // Mavericks
        appVersion = MAVERICKS;
    } else if ([[[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:1] isKindOfClass:[NSTextField class]]) { // Mountain Lion
		appVersion = MOUNTAIN_LION;
	} else if ([dictionaryController respondsToSelector:@selector(dictionaryControllerDidClearPreviousResult:)]) { // Snow Leopard
		appVersion = SNOW_LEOPARD;
	} else if ([dictionaryController respondsToSelector:@selector(_loadMainFramePage)]) { // Lion
		appVersion = LION;
	}

    DebugLog(@"APP VERSION: %@", appVersion==YOSEMITE?@"YOSEMITE":(appVersion==MAVERICKS?@"MAVERICKS":(appVersion==MOUNTAIN_LION?@"MOUNTAIN LION":(appVersion==LION?@"LION":@"SNOW LEOPARD"))));
}

#pragma mark -
#pragma mark Toolbar

/*
 Adds the toolbar items, loads graphics, assigns actions, ...
 */
- (void)initToolbarItems
{
	DebugLog(@"INIT TOOLBAR ITEMS");

	NSString* sampleItemIentifier = [[[dictionaryBrowserToolbar items] objectAtIndex:0] itemIdentifier];

	// -------------------------------------------------------------------------------
	// Add 'Show all saved words' button to the toolbar
	//

	sidebarShowAllImageDarkImage = [[NSImage alloc] initWithContentsOfFile:[betterDictionaryBundle pathForResource:@"sidebar-dark" ofType:@"tiff"]];
	sidebarShowAllImageLightImage = [[NSImage alloc] initWithContentsOfFile:[betterDictionaryBundle pathForResource:@"sidebar-light" ofType:@"tiff"]];

	[dictionaryBrowserToolbar insertItemWithItemIdentifier:sampleItemIentifier atIndex:0];
	NSToolbarItem* showAllToolbarItem = [[dictionaryBrowserToolbar items] objectAtIndex:0];

	showAllToolbarButton = [[NSButton alloc] init];
	[showAllToolbarButton setBordered:YES];
	[showAllToolbarButton setBezelStyle:NSTexturedSquareBezelStyle];
	[showAllToolbarButton setButtonType:NSPushOnPushOffButton];
	[showAllToolbarButton setTarget:self];
	[showAllToolbarButton setImage:sidebarShowAllImageDarkImage];
	[showAllToolbarButton setAction:@selector(_showHideSidebar:)];

	[showAllToolbarItem setView: showAllToolbarButton];
	[showAllToolbarItem setMaxSize:NSMakeSize(25, 25)];
	[showAllToolbarItem setMinSize:NSMakeSize(25, 25)];


	// -------------------------------------------------------------------------------
	// Add 'Save word' button to the toolbar
	//

	saveWordImage = [[NSImage alloc] initWithContentsOfFile:[betterDictionaryBundle pathForResource:@"add" ofType:@"tiff"]];
	removeWordImage = [[NSImage alloc] initWithContentsOfFile:[betterDictionaryBundle pathForResource:@"remove" ofType:@"tiff"]];

	[dictionaryBrowserToolbar insertItemWithItemIdentifier:sampleItemIentifier atIndex:1];
	NSToolbarItem* saveWordToolbarItem = [[dictionaryBrowserToolbar items] objectAtIndex:1];

	saveOrRemoveWordToolbarButton = [[NSButton alloc] init];
	[saveOrRemoveWordToolbarButton setBordered:YES];
	[saveOrRemoveWordToolbarButton setBezelStyle:NSTexturedSquareBezelStyle];
	[saveOrRemoveWordToolbarButton setTarget:self];

	[self setSaveOrRemoveToolbarButtonAccordingly];

	[saveWordToolbarItem setView: saveOrRemoveWordToolbarButton];
	[saveWordToolbarItem setMaxSize:NSMakeSize(25, 25)];
	[saveWordToolbarItem setMinSize:NSMakeSize(25, 25)];


	// -------------------------------------------------------------------------------

	if (appVersion == SNOW_LEOPARD) { // NSToolbarSeparatorItem is deprecated in Lion
		// Add a seperator between our items and dectionary's default items
		[dictionaryBrowserToolbar insertItemWithItemIdentifier:NSToolbarSeparatorItemIdentifier atIndex:2];
	}
}

/*
 Shows save or remove button in the toolbar, and enebles/disables menu bar items depending on searched text;
 */
- (void)setSaveOrRemoveToolbarButtonAccordingly
{
	if ([[self searchedWordCapitalized] isEqualToString:@""]) {
		// Blank input. Must disable menu items & toolbar item.
		[saveOrRemoveWordToolbarButton setImage:saveWordImage];
		[saveOrRemoveWordToolbarButton setEnabled:NO];

		[removeWordMenuItem setHidden:YES];
		[saveWordMenuItem setHidden:YES];

		return;
	} else {
		[saveOrRemoveWordToolbarButton setEnabled:YES];
	}

	if ([savedWordsArray containsObject:[self searchedWordCapitalized]]) {
		// The input is already saved.
		[saveOrRemoveWordToolbarButton setImage:removeWordImage];
		[saveOrRemoveWordToolbarButton setAction:@selector(_removeWord:)];

		[removeWordMenuItem setHidden:NO];
		[saveWordMenuItem setHidden:YES];

	} else {
		// The input was not saved.
		[saveOrRemoveWordToolbarButton setImage:saveWordImage];
		[saveOrRemoveWordToolbarButton setAction:@selector(_saveWord:)];

		[removeWordMenuItem setHidden:YES];
		[saveWordMenuItem setHidden:NO];

	}
}


#pragma mark -
#pragma mark Menubar

/*
 Creates menu items, assigns shortcut keys, ...
 */
- (void)createMenuItems
{
	DebugLog(@"CREATE MENU ITEMS");

	NSMenuItem* editMenuItem = [[mainApplication mainMenu] itemWithTitle:@"Edit"];
	NSMenu* editMenu = [editMenuItem submenu];

	// Find the proper index
	int startIndex = 0;
	NSArray* itemsArray = [editMenu itemArray];
	for (id item in itemsArray) {
		startIndex++;
		if ([[((NSMenuItem*)item) title] isEqualToString:@"Select All"])
			break;
	}

	// -------------------------------------------------------------------------------
	// Add items to edit menu
	[editMenu insertItem:[NSMenuItem separatorItem] atIndex:startIndex];

	saveWordMenuItem = [[NSMenuItem alloc] initWithTitle:@"Save This Word" action:@selector(_saveWord:) keyEquivalent:@"s"];
	[editMenu insertItem:saveWordMenuItem atIndex:startIndex+1];
	[saveWordMenuItem setTarget:self];

	removeWordMenuItem = [[NSMenuItem alloc] initWithTitle:@"Remove This Word" action:@selector(_removeWord:) keyEquivalent:@"r"];
	[removeWordMenuItem setTarget:self];
	[editMenu insertItem:removeWordMenuItem atIndex:startIndex+2];

	NSMenuItem* removeAllWordsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Remove All Saved Words" action:@selector(_removeAllSavedWords:) keyEquivalent:@""];
	[removeAllWordsMenuItem setTarget:self];
	[editMenu insertItem:removeAllWordsMenuItem atIndex:startIndex+3];

	NSMenuItem* showSidebarMenuItem = [[NSMenuItem alloc] initWithTitle:@"Show All Saved Words" action:@selector(_showHideSidebar:) keyEquivalent:@"d"];
	[showSidebarMenuItem setKeyEquivalentModifierMask:(NSShiftKeyMask| NSCommandKeyMask)];
	[showSidebarMenuItem setTarget:self];
	[editMenu insertItem:showSidebarMenuItem atIndex:startIndex+4];

	// -------------------------------------------------------------------------------
	// Add items to application ('Dictionary') menu.
	NSMenuItem* defaultApplicationMenuItem = [[mainApplication mainMenu] itemWithTitle:@"Dictionary"];
	NSMenu* aboutMenu = [defaultApplicationMenuItem submenu];

	NSMenuItem* aboutBetterDictionaryItem = [[NSMenuItem alloc] initWithTitle:@"About BetterDictionary" action:@selector(showAboutBetterDictionaryWindow:) keyEquivalent:@""];
	[aboutMenu insertItem:aboutBetterDictionaryItem atIndex:1];
	[aboutBetterDictionaryItem setTarget:self];
}

/*
 Show About window.
 */
- (void)showAboutBetterDictionaryWindow:(id)sender
{
	NSMutableAttributedString *credits = [[NSMutableAttributedString alloc] init];

	[credits appendAttributedString:[[NSAttributedString alloc] initWithString:@"Acknowledgements:"]];
	[credits applyFontTraits:NSBoldFontMask range:NSMakeRange(0, [credits length])];

	[credits appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nMike Solomon ("]];
	[credits appendAttributedString:[NSAttributedString hyperlinkFromString:@"SIMBL" withURL:[NSURL URLWithString:@"http://www.culater.net/software/SIMBL/SIMBL.php"]]];
    [credits appendAttributedString:[[NSAttributedString alloc] initWithString:@")\n"]];


	[credits appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nSteve Nygard ("]];
	[credits appendAttributedString:[NSAttributedString hyperlinkFromString:@"class-dump" withURL:[NSURL URLWithString:@"http://www.codethecode.com/projects/class-dump/"]]];

	[credits appendAttributedString:[[NSAttributedString alloc] initWithString:@")\nKarl Kraft ("]];
	[credits appendAttributedString:[NSAttributedString hyperlinkFromString:@"DebugLog" withURL:[NSURL URLWithString:@"http://www.karlkraft.com/index.php/2009/03/23/114/"]]];
	[credits appendAttributedString:[[NSAttributedString alloc] initWithString:@")\n"]];

	[credits appendAttributedString:[NSAttributedString hyperlinkFromString:@"NSAttributedString+Hyperlink" withURL:[NSURL URLWithString:@"https://github.com/ChristianS/CloudPost/blob/master/NSAttributedString-Hyperlink.h"]]];

	[credits appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\nFor more information, please visit "]];
	[credits appendAttributedString:[NSAttributedString hyperlinkFromString:@"pooriaazimi.github.io/BetterDictionary" withURL:[NSURL URLWithString:@"http://pooriaazimi.github.io/BetterDictionary"]]];

	NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
	[mutParaStyle setAlignment:NSCenterTextAlignment];
	[credits addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[credits length])];


	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"0.992", @"Version",
							 @"BetterDictionary", @"ApplicationName",
							 credits, @"Credits",
							 @"2011-2014 by Pooria Azimi.\nNo rights reserved.", @"Copyright",
							 @"BetterDictionary v0.992", @"ApplicationVersion",
							 nil];

	[[NSApplication sharedApplication] orderFrontStandardAboutPanelWithOptions:options];
}


#pragma mark -
#pragma mark Sidebar

/*
 Adds the sidebar to window. It does not show the sidebar, just creates the objects. This method gets called only once.
 */
- (void)addSidebar
{
    DebugLog(@"ADD SIDEBAR");
    
    if (appVersion == YOSEMITE) {
        // Subviews: [<DSIndexSplitView>, <DSShadowOverlay>, <DSShadowOverlay>]
        //
        dictionaryWebView = [[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:0];
        dictionarySearchView = [[dictionaryWebView subviews] objectAtIndex:1];
    } else if (appVersion == MAVERICKS) {
        // Subviews: [<DictionaryScopeBar>, <NSPopUpButton>, <DSIndexSplitView>, <DSShadowOverlay>, <DSShadowOverlay>]
        //
        dictionaryWebView = [[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:2];
        dictionarySearchView = [[[[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:2] subviews] objectAtIndex:1];
	} else if (appVersion == MOUNTAIN_LION) {
		// Subviews: [<DictionaryScopeBar>, <NSTextField>, <NSPopUpButton>, <DSIndexSplitView>, <DSShadowOverlay>, <DSShadowOverlay>]
		//                                  (search-view)                       (web-view)
		//
		dictionaryWebView = [[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:3];
		dictionarySearchView = [[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:1];
	} else if (appVersion == LION || appVersion == SNOW_LEOPARD) {
		// Subviews: [<DictionaryScopeBar>, <DSIndexSplitView>, <NSTextField>, <NSPopUpButton>, <DSShadowOverlay>, <DSShadowOverlay>]
		//                                      (web-view)      (search-view)
		//
		dictionaryWebView = [[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:1];
		dictionarySearchView = [[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:2];
    }


	// -------------------------------------------------------------------------------

	NSRect scrollFrame = NSMakeRect(-5, 0, 5, self.viewHeight);
    DebugLog(@"%i", self.viewHeight);
    dictionarySidebarScrollView = [[[NSScrollView alloc] initWithFrame:scrollFrame] autorelease];
    
    if (appVersion == MAVERICKS || appVersion == YOSEMITE) {
        [dictionarySidebarScrollView setBorderType:0];
    } else {
        [dictionarySidebarScrollView setBorderType:2];
    }
    [dictionarySidebarScrollView setHasVerticalScroller:YES];
    [dictionarySidebarScrollView setAutohidesScrollers:YES];

    NSRect clipViewBounds = [[dictionarySidebarScrollView contentView] bounds];
    dictionarySidebar = [[[NSTableView alloc] initWithFrame:clipViewBounds] autorelease];
    [dictionarySidebar  addTableColumn:[[[NSTableColumn alloc] initWithIdentifier:@"listOfWords"] autorelease]];

	[dictionarySidebar setHeaderView:nil];
    [dictionarySidebar setDataSource:self];
    [dictionarySidebar setDelegate:self];

    [dictionarySidebarScrollView setDocumentView:dictionarySidebar];
	[dictionarySidebarScrollView setAutoresizesSubviews:YES];
	[dictionarySidebarScrollView setAutoresizingMask:NSViewHeightSizable];


	if (appVersion == MAVERICKS || appVersion == YOSEMITE) {
        dictionaryDrawer = [[DrawerController alloc] init];
        [dictionaryDrawer setupWithWindow:mainWindow];
        [dictionaryDrawer setContentView:dictionarySidebarScrollView];
    } else {
        [[dictionaryBrowserWindow contentView] addSubview:dictionarySidebarScrollView];
    }


	// -------------------------------------------------------------------------------
	// create sidebar's context menu
	NSMenuItem* sidebarRemoveMenuItem = [[NSMenuItem alloc] initWithTitle:@"Remove This Word" action:@selector(_removeWord:) keyEquivalent:@"r"];
	[sidebarRemoveMenuItem setTarget:self];

	NSMenu* sidebarItemMenu = [[[NSMenu alloc] init] autorelease];
	[sidebarItemMenu addItem:sidebarRemoveMenuItem];
	[sidebarItemMenu setTitle:@"SIDEBAR_CONTEXT_MENU"];

	[dictionarySidebar setMenu:sidebarItemMenu];
    
    
    [showAllToolbarButton performClick:self];
}

/*
 Wrapper. Works for all cases - menu item, shortcut key and toolbar item.
 */
- (void)_showHideSidebar:(id)sender
{
	if ([sender isMemberOfClass:[NSMenuItem class]]) {
		// if invoked from the menu, just pass it to the button.
		// that'll call this method again (with a different sender though).
		[showAllToolbarButton performClick:self];
	} else {
		if (sidebarIsVisible)
			[self hideSidebar];
		else
			[self showSidebar];
	}
}

/*
 Shows the sidebar in a beautiful animation.
 */
- (void)showSidebar
{
	DebugLog(@"SHOW SIDEBAR");

	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.08f];

    if (appVersion == MAVERICKS || appVersion == YOSEMITE) {
        [dictionaryDrawer toggleDrawer:nil];
    } else {
        [[dictionarySidebarScrollView animator] setFrame:CGRectMake(0, 0, sidebarWidth, self.viewHeight)];
        [[dictionaryWebView animator] setFrame:CGRectMake(sidebarWidth, 0, self.viewWidth-sidebarWidth, self.viewHeight)];
        [[dictionarySearchView animator] setFrame:CGRectMake(sidebarWidth, 0, self.viewWidth-sidebarWidth, self.viewHeight)];
    }

	[NSAnimationContext endGrouping];

	[showAllToolbarButton setImage:sidebarShowAllImageLightImage];

	sidebarIsVisible = YES;
}

/*
 Hides the sidebar in a beautiful animation.
 */
- (void)hideSidebar
{
	DebugLog(@"HIDE SIDEBAR");

	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.08f];

    if (appVersion == MAVERICKS || appVersion == YOSEMITE) {
        [dictionaryDrawer closeDrawer:nil];
    } else {
        [[dictionarySidebarScrollView animator] setFrame:CGRectMake(-5, 0, 5, self.viewHeight)];
        [[dictionaryWebView animator] setFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        [[dictionarySearchView animator] setFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    }

	[NSAnimationContext endGrouping];

	[showAllToolbarButton setImage:sidebarShowAllImageDarkImage];

	sidebarIsVisible = NO;
}


#pragma mark -

/* Return the word in reversed 'savedWordsArray'
 */
-(NSString *)wordAtReversedIndex:(NSInteger)index
{
    if (index > -1 && index < [savedWordsArray count])
        return (NSString *)[savedWordsArray objectAtIndex:([savedWordsArray count]-index-1)];
    else
        return nil;
}

/*
 Returns the searched word (what user has typed in the search bar).
 */
- (NSString*)searchedWord
{
	if (appVersion == YOSEMITE || appVersion == MAVERICKS || appVersion == MOUNTAIN_LION || appVersion == LION) {
		object_getInstanceVariable(dictionaryController, "_lastSelectedIndexText", (void**)&searchedWord);
		if (!searchedWord) {
			NSString* lastSearchText;
			object_getInstanceVariable(dictionaryController, "_lastSearchText", (void**)&lastSearchText);
			searchedWord = lastSearchText;
		}
	} else if (appVersion == SNOW_LEOPARD) {
		object_getInstanceVariable(dictionaryBrowserWindowController, "_searchText", (void**)&searchedWord);
	}

	if (searchedWord == nil)
		searchedWord = @"";
	return searchedWord;
}

/*
 Returns the searched word (what user has typed in the search bar), capitalized.
 */
- (NSString*)searchedWordCapitalized
{
	return [[searchedWord capitalizedString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
}

/*
 Returns whether or not we've already saved the given word.
 */
- (BOOL)hasAlreadySavedWord:(NSString*)word
{
	return [savedWordsArray containsObject:word];
}


#pragma mark saveWord

/*
 Wrapper. Feeds search bar's text to saveWord:.
 */
- (void)_saveWord:(id)sender
{
	[self saveWord:[self searchedWord]];
}

/*
 Saves the given word to savedWordsArray, reloades sidebar's data and wrtites changes to disk.
 */
- (void)saveWord:(NSString*)wordToSave
{
	wordToSave = [[wordToSave capitalizedString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	if ([self hasAlreadySavedWord:wordToSave])
		return;

	[savedWordsArray addObject:wordToSave];
	[dictionarySidebar reloadData];
	[self writeSavedWordsArrayToDisk];

	[self setSaveOrRemoveToolbarButtonAccordingly];

	DebugLog(@"SAVED WORD: %@", wordToSave);
}


#pragma mark removeWord

/*
 Wrapper. Checks the sender; If it's from the menubar or shortcut key equivalent, it removes search bar's text. If it's from the context menu, it removes the selected word.
 */
- (void)_removeWord:(id)sender
{
	if ([[[(NSMenuItem*)sender menu] title] isEqualToString:@"SIDEBAR_CONTEXT_MENU"]) {
		// it's from the sidebar context menu bar
		NSInteger clickedRow = [dictionarySidebar clickedRow];
		if (clickedRow != -1) {
			[self removeWord:[self wordAtReversedIndex:clickedRow]];
        }
	} else {
		// it's from the application menu bar
		[self removeWord:[self searchedWord]];
	}

}

/*
 Removes the given word from savedWordsArray, reloades sidebar's data and writes changes to disk.
 */
- (void)removeWord:(NSString*)wordToRemove
{
	wordToRemove = [wordToRemove capitalizedString];

	if (![self hasAlreadySavedWord:wordToRemove])
		return;

	DebugLog(@"CLICKED ROW: %ld, SELECTED ROW: %ld",[dictionarySidebar selectedRow], [dictionarySidebar clickedRow]);

	[savedWordsArray removeObject:wordToRemove];
	[dictionarySidebar reloadData];
	[self writeSavedWordsArrayToDisk];

	[self setSaveOrRemoveToolbarButtonAccordingly];
	DebugLog(@"REMOVED WORD: %@", wordToRemove);
}


#pragma mark removeAllSavedWords

/*
 Wrapper
 */
- (void)_removeAllSavedWords:(id)sender
{
	[self removeAllSavedWords];
}

/*
 Removes all saved words, reloades sidebar's data and writes changes to disk.
 */
- (void)removeAllSavedWords
{
	savedWordsArray = [[NSMutableArray alloc] init];
	[dictionarySidebar reloadData];
	[self writeSavedWordsArrayToDisk];

	[self setSaveOrRemoveToolbarButtonAccordingly];

	DebugLog(@"REMOVED ALL SAVED WORDS");
}


#pragma mark searchWord
/*
 This method is used whenever we want to show a word's definitions (when the user clicks on an item in the sidebar for example).
 Because wikipedia is extremely slow, we need to remove all instances of wikipedia before searching, and restore them afterwards.
 */

-(NSString*) parseNihongoWord:(NSString*)word
{
    NSRange result;
    result = [word rangeOfString:@"【"];
    if (result.location == NSNotFound) return word;

    NSString* parsedword = [word substringToIndex:result.location];
    return parsedword;
}

-(void) searchWord:(NSString*)wordToSearch
{
	DebugLog(@"SEARCH WORD: %@", wordToSearch);

	if (appVersion == YOSEMITE || appVersion == MAVERICKS || appVersion == MOUNTAIN_LION || appVersion == LION) {

        [dictionaryBrowserWindowController performSelector:@selector(setSearchStringValue:displayString:triggerSearch:) withObject:[self parseNihongoWord:wordToSearch] withObject:[self parseNihongoWord:wordToSearch] withObject:[NSNumber numberWithBool:YES]];

	} else if (appVersion == SNOW_LEOPARD) {

		// -----------------------------------------------------------------------------------
		// here we put removed dictionaries (those from Wikipedia) in an array
		//

		id _dictionaryBook = [dictionaryController performSelector:@selector(dictionaryBook)];
		NSMutableArray* dictionaryList = [_dictionaryBook performSelector:@selector(dictionaryList)];

		NSMutableArray *removedDictionaries = [[NSMutableArray alloc] initWithCapacity:2];

		int index = 0;
		while (index < [dictionaryList count]) {
			id dic = [dictionaryList objectAtIndex:index];
			NSString* dicName = [dic performSelector:@selector(dictionaryName)];
			if ([dicName hasPrefix:@"Wikipedia"]) {
				[dictionaryList removeObject:dic];
				[removedDictionaries addObject:dic];
				index--;
			}
			index++;
		}

		// -----------------------------------------------------------------------------------
		// do the actual searching
		//
		NSArray* arguments = [[NSArray alloc] initWithObjects:wordToSearch, [[mainApplication mainWindow] windowController] , wordToSearch, nil];
		[dictionaryBrowserWindowController performSelector:@selector(_searchText:inDictionaryContoller:withSelection:) withObjects:arguments];
		[dictionaryBrowserWindowController performSelector:@selector(_setSearchTextSilently:) withObject:wordToSearch];


		// -----------------------------------------------------------------------------------
		// and here, we put wikipedia dictionaries back
		// TODO: (KNOWN BUG) inserts wikipedia dics at the end, but really should put them back
		//       at their original index.
		//
		for (id doc in removedDictionaries) {
			[dictionaryList addObject:doc];
		}
		// -----------------------------------------------------------------------------------
	}

	[self setSaveOrRemoveToolbarButtonAccordingly];

}


#pragma mark -
#pragma mark View constants

/*
 Returns windows's current width.
 */
- (float)viewWidth
{
	return [[dictionaryBrowserWindow contentView] frame].size.width;
}

/*
 Returns windows's current height.
 */
- (float)viewHeight
{
	return [dictionaryWebView frame].size.height;
}


#pragma mark savedWordsArray

/*
 Populates savedWordsArray from disk (from a UserDefault plist file).
 */
- (void)initSavedWordsArray
{

    fileManager = [NSFileManager defaultManager];
    NSArray* urls = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSURL* applicationSupportDirectory = urls[0];
    NSURL* betterDictionaryApplicationSupportDirectory = [applicationSupportDirectory URLByAppendingPathComponent:@"BetterDictionary" isDirectory:YES];
    NSURL *betterDictionaryApplicationSupportFile = [betterDictionaryApplicationSupportDirectory URLByAppendingPathComponent:@"saved-words.plist" isDirectory:NO];

    if ([fileManager fileExistsAtPath:[betterDictionaryApplicationSupportFile path] isDirectory:nil]) {
        // Already upgraded to the new "database". Don't load NSUserDefaults
        savedWordsArray = [[NSArray arrayWithContentsOfURL:betterDictionaryApplicationSupportFile] mutableCopy];
        DebugLog(@"READ SAVED WORDS ARRAY FROM '%@'", betterDictionaryApplicationSupportFile);
    } else {
        // First load the data from NSUserDefaults
        savedWordsArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:SAVED_WORDS_ARRAY];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SAVED_WORDS_ARRAY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        DebugLog(@"READ SAVED WORDS ARRAY FROM NSUSERDEFAULTS");

        // Then check if the betterDictionaryApplicationSupportDirectory exists or not. If not, create it.
        if (![fileManager fileExistsAtPath:[betterDictionaryApplicationSupportDirectory path] isDirectory:nil]) {
            [fileManager createDirectoryAtURL:betterDictionaryApplicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:nil];
            DebugLog(@"CREATED SUPPORT DIRECTORY ('%@')", betterDictionaryApplicationSupportDirectory);
        }

        [self writeSavedWordsArrayToDisk];
    }

	if (!savedWordsArray || [savedWordsArray isMemberOfClass:[NSMutableArray class]])
		savedWordsArray = [[NSMutableArray alloc] init];

    DebugLog(@"SAVED WORDS ARRAY IS: %@", savedWordsArray);

	[dictionarySidebar reloadData];
}

/*
 Writes savedWordsArray to disk. Currently does ot check for errors or exceptions.
 */
- (void)writeSavedWordsArrayToDisk
{
    NSArray* urls = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSURL* applicationSupportDirectory = urls[0];
    NSURL* betterDictionaryApplicationSupportDirectory = [applicationSupportDirectory URLByAppendingPathComponent:@"BetterDictionary" isDirectory:YES];
    NSURL *betterDictionaryApplicationSupportFile = [betterDictionaryApplicationSupportDirectory URLByAppendingPathComponent:@"saved-words.plist" isDirectory:NO];
    DebugLog(@"URL TO WRITE TO: %@", [betterDictionaryApplicationSupportFile path]);
    [savedWordsArray writeToURL:betterDictionaryApplicationSupportFile atomically:NO];
	DebugLog(@"WRITE SAVED WORDS ARRAY TO DISK");
}


#pragma mark -
#pragma mark NSTableViewDelegate

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return NO;
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView
{
	return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
	NSInteger selectedRow = [(NSTableView*)[notification object] selectedRow];
	[self searchWord:[self wordAtReversedIndex:selectedRow]];
}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification
{
	NSInteger selectedRow = [(NSTableView*)[notification object] selectedRow];
	[self searchWord:[self wordAtReversedIndex:selectedRow]];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return 22;
}

#pragma mark NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [savedWordsArray count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return [self wordAtReversedIndex:row];
}


#pragma mark -
#pragma mark Runtime hacks

/*
 Swaps implementaion of set/clear search word with our 'interceptSetSearchText:' method IMP. And registers BetterDictionary for notifications (with name='searchTextChanged').
 */
- (void)startInterceptingSearchTextMethod
{
    if (appVersion == YOSEMITE)
    {
        DebugLog(@"STARTED INTERCEPTING CALLS TO '_displayIndexSearchSelection:'");
        const char *types = method_getTypeEncoding(class_getInstanceMethod([dictionaryController class], @selector(_displayIndexSearchSelection:)));
        originalAsyncDictionarySearchDidFound = class_replaceMethod([dictionaryController class], @selector(_displayIndexSearchSelection:), (IMP)interceptAsyncDictionarySearchDidFound, types);
        
        DebugLog(@"STARTED INTERCEPTING CALLS TO '_clearSearchResult:'");
        const char *types3 = method_getTypeEncoding(class_getInstanceMethod([dictionaryController class], @selector(_clearSearchResult)));
        originalClearSearchResult = class_replaceMethod([dictionaryController class], @selector(_clearSearchResult), (IMP)interceptClearSearchResult, types3);

    }
    else if (appVersion == MAVERICKS || appVersion == MOUNTAIN_LION)
    {
        DebugLog(@"STARTED INTERCEPTING CALLS TO 'asyncDictionarySearchDidFinished:'");
        const char *types = method_getTypeEncoding(class_getInstanceMethod([dictionaryController class], @selector(asyncDictionarySearchDidFinished:)));
        originalAsyncDictionarySearchDidFound = class_replaceMethod([dictionaryController class], @selector(asyncDictionarySearchDidFinished:), (IMP)interceptAsyncDictionarySearchDidFound, types);
        
        DebugLog(@"STARTED INTERCEPTING CALLS TO '_clearSearchResult:'");
        const char *types2 = method_getTypeEncoding(class_getInstanceMethod([dictionaryController class], @selector(_clearSearchResult)));
        originalClearSearchResult = class_replaceMethod([dictionaryController class], @selector(_clearSearchResult), (IMP)interceptClearSearchResult, types2);
    }
    else if (appVersion == LION)
    {
		DebugLog(@"STARTED INTERCEPTING CALLS TO 'asyncDictionarySearchDidFound:'");
		const char *types = method_getTypeEncoding(class_getInstanceMethod([dictionaryController class], @selector(asyncDictionarySearchDidFound:)));
		originalAsyncDictionarySearchDidFound = class_replaceMethod([dictionaryController class], @selector(asyncDictionarySearchDidFound:), (IMP)interceptAsyncDictionarySearchDidFound, types);

		DebugLog(@"STARTED INTERCEPTING CALLS TO '_clearSearchResult:'");
		const char *types2 = method_getTypeEncoding(class_getInstanceMethod([dictionaryController class], @selector(_clearSearchResult)));
		originalClearSearchResult = class_replaceMethod([dictionaryController class], @selector(_clearSearchResult), (IMP)interceptClearSearchResult, types2);

	}
    else if (appVersion == SNOW_LEOPARD)
    {
		DebugLog(@"STARTED INTERCEPTING CALLS TO 'setSearchText:'");
		const char *types = method_getTypeEncoding(class_getInstanceMethod([dictionaryBrowserWindowController class], @selector(setSearchText:)));
		originalSetSearchText = class_replaceMethod([dictionaryBrowserWindowController class], @selector(setSearchText:), (IMP)interceptSetSearchText, types);
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"searchTextChanged" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"searchTextCleared" object:nil];
}

/*
 Whenever Dictionary.app or BetterDictionary.bundle search for a new word, this method gets called. It informs BetterDictionary (via application-wide notification center) that the queried text has changed. We use this information to swap between add/remove buttons in the toolbar and menu bar.
 */
static void interceptSetSearchText(id self, SEL oldSelector, id arg1, ...)
{
	originalSetSearchText(self, oldSelector, arg1);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"searchTextChanged" object:self];
}
static void interceptAsyncDictionarySearchDidFound(id self, SEL oldSelector, id arg1, ...)
{
	originalAsyncDictionarySearchDidFound(self, oldSelector, arg1);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"searchTextChanged" object:self];
}
static void interceptClearSearchResult(id self, SEL oldSelector, ...)
{
	originalClearSearchResult(self, oldSelector);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"searchTextCleared" object:self];
}

/*
 This method handles notifications. We are only interested in notifications with name=searchTextChanged.
 */
- (void)handleNotification:(NSNotification*)note {
	if ([[note name] isEqualToString:@"searchTextChanged"]) {
		searchedWord = [self searchedWord];
		if (lastSearchedWord != searchedWord) { // not a duplicate notification
			lastSearchedWord = searchedWord;
			DebugLog(@"Searched word has changed: %@", searchedWord);
			[self setSaveOrRemoveToolbarButtonAccordingly];
		}
	} else if ([[note name] isEqualToString:@"searchTextCleared"]) {
		searchedWord = @"";
		lastSearchedWord = @"";
		DebugLog(@"Searched word has been cleared.");
		[self setSaveOrRemoveToolbarButtonAccordingly];
	} else {
		return;
	}

}


#pragma mark Runtime helper methods

/*
 Adds a method to a class, for the specified selector with given implementation.
 */
- (void)addMethod:(IMP)newMethodIMP forSelector:(SEL)oldMethodSelector toClass:(Class)class
{
    const char *types = method_getTypeEncoding(class_getInstanceMethod(class, oldMethodSelector));
    class_addMethod(class, oldMethodSelector, newMethodIMP, types);
}

/*
 Adds a method's implementation (from this class, 'BetterDictionary') to a class, with the same signature.
 */
- (void)addMethod:(SEL)newMethodSelector toClass:(Class)class
{
	Method newMethod = class_getInstanceMethod([self class], newMethodSelector);
	[self addMethod:(IMP)method_getImplementation(newMethod) forSelector:newMethodSelector toClass:class];
}

/*
 Exchanges two methods implementations.
 */
- (void)swizzleMethodWithSelector:(SEL)origSelector fromClass:(Class)origClass WithMwthodWithSelector:(SEL)replSelector fromClass:(Class)replClass
{
	Method orig = class_getInstanceMethod(origClass, @selector(origSelector));
	Method repl = class_getInstanceMethod(replClass, @selector(replSelector));
	method_exchangeImplementations(orig, repl);
}


#pragma mark -
/*
 Don't ever call it!
 */
- (void)dealloc
{
    [super dealloc];
}


@end



