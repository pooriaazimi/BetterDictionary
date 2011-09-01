//
//  BetterDictionary.m
//  BetterDictionary
//
//  Created by Pooria Azimi on 27/8/11.
//  Copyright 2011 IRMUG. All rights reserved.
//

#import "BetterDictionary.h"


@implementation BetterDictionary

@synthesize savedWordsArray;

+ (void)load
{
	[[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
		DebugLog(@"INIT");
		
		//TODO: insert code for checking OS version here
		
		betterDictionaryBundle = [NSBundle bundleWithIdentifier:@"com.pooriaazimi.betterdictionary"];
		
//		sidebarController = [[SidebarController alloc] init];
		sidebarWidth = 130;
		sidebarIsVisible = NO;
		
		mainApplication = [NSApplication sharedApplication];
		dictionaryBrowserWindowController = [[mainApplication mainWindow] windowController];
		dictionaryBrowserWindow = [dictionaryBrowserWindowController window];
		dictionaryBrowserToolbar = [dictionaryBrowserWindow toolbar];

		[self initToolbarItems];
		[self addSidebar];
		[self createMenuItems];
		
//		[self addMethod:@selector(saveWord:) toClass:[[dictionaryBrowserWindow windowController] class]];
//		[self addMethod:@selector(hideSidebar:) toClass:[[dictionaryBrowserWindow windowController] class]];
//		[self addMethod:@selector(showHideSidebar) toClass:[[dictionaryBrowserWindow windowController] class]];
		
//		DebugLog(@"CHILDREN: %@", [[[dictionarySearchView subviews] objectAtIndex:0] subviews]);
		
		
//		savedWordsArray = [[NSMutableArray alloc] initWithObjects:@"hello", @"there", @"how", @"are", @"you", @"?", nil];
//		DebugLog(@"----::::: %ld", [savedWordsArray count]);
//		[dictionarySidebar reloadData];
		[self initSavedWordsArray];
	
		
		
		
    }
    
    return self;
}




- (void)initToolbarItems
{
	DebugLog(@"INIT TOOLBAR ITEMS");

	NSString* sampleItemIentifier = [[[dictionaryBrowserToolbar items] objectAtIndex:0] itemIdentifier];
	
	// -----------------------------------------------------------------------------------------
	// Add 'Show all saved words' button to the toolbar
	//
	
	sidebarShowAllImageDarkImage = [[NSImage alloc] initWithContentsOfFile:[betterDictionaryBundle pathForResource:@"sidebar-dark" ofType:@"png"]];
	sidebarShowAllImageLightImage = [[NSImage alloc] initWithContentsOfFile:[betterDictionaryBundle pathForResource:@"sidebar-light" ofType:@"png"]];
	
	[dictionaryBrowserToolbar insertItemWithItemIdentifier:sampleItemIentifier atIndex:0];
	NSToolbarItem* showAllToolbarItem = [[dictionaryBrowserToolbar items] objectAtIndex:0];
	
	showAllToolbarButton = [[NSButton alloc] init];		
	[showAllToolbarButton setBordered:YES];	
	[showAllToolbarButton setBezelStyle:NSTexturedSquareBezelStyle];
	[showAllToolbarButton setButtonType:NSPushOnPushOffButton];
	[showAllToolbarButton setTarget:self];	
	[showAllToolbarButton setImage:sidebarShowAllImageDarkImage];
	[showAllToolbarButton setAction:@selector(showHideSidebar:)];
	
	[showAllToolbarItem setView: showAllToolbarButton];
	[showAllToolbarItem setMaxSize:NSMakeSize(25, 25)];
	[showAllToolbarItem setMinSize:NSMakeSize(25, 25)];
	
	
	// -----------------------------------------------------------------------------------------
	// Add 'Save word' button to the toolbar
	//
	
	saveWordImage = [[NSImage alloc] initWithContentsOfFile:[betterDictionaryBundle pathForResource:@"add" ofType:@"png"]];
	removeWordImage = [[NSImage alloc] initWithContentsOfFile:[betterDictionaryBundle pathForResource:@"remove" ofType:@"png"]];
	
	[dictionaryBrowserToolbar insertItemWithItemIdentifier:sampleItemIentifier atIndex:1];
	NSToolbarItem* saveWordToolbarItem = [[dictionaryBrowserToolbar items] objectAtIndex:1];
	
	saveWordToolbarButton = [[NSButton alloc] init];		
	[saveWordToolbarButton setBordered:YES];	
	[saveWordToolbarButton setBezelStyle:NSTexturedSquareBezelStyle];
	[saveWordToolbarButton setTarget:self];
	[saveWordToolbarButton setTitle:@"Save Word"];
	[saveWordToolbarButton setImage:saveWordImage];
	[saveWordToolbarButton setAction:@selector(_saveWord:)];
	
	[saveWordToolbarItem setView: saveWordToolbarButton];
	[saveWordToolbarItem setMaxSize:NSMakeSize(25, 25)];
	[saveWordToolbarItem setMinSize:NSMakeSize(25, 25)];
	
	
	// -----------------------------------------------------------------------------------------
	// Add a seperator between our items and dectionary's default items
	//
	[dictionaryBrowserToolbar insertItemWithItemIdentifier:NSToolbarSeparatorItemIdentifier atIndex:2];
	
}

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
	
	[editMenu insertItem:[NSMenuItem separatorItem] atIndex:startIndex];
	
	NSMenuItem* saveWordMenuItem = [[NSMenuItem alloc] initWithTitle:@"Save This Word" action:@selector(_saveWord:) keyEquivalent:@"s"];
	[editMenu insertItem:saveWordMenuItem atIndex:startIndex+1];
	[saveWordMenuItem setTarget:self];
	
	NSMenuItem* removeWordMenuItem = [[NSMenuItem alloc] initWithTitle:@"Remove This Word" action:@selector(_removeWord:) keyEquivalent:@"r"];
	[removeWordMenuItem setTarget:self];
	[editMenu insertItem:removeWordMenuItem atIndex:startIndex+2];
	
	NSMenuItem* removeAllWordsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Remove All Saved Words" action:@selector(_removeAllSavedWords:) keyEquivalent:@"r"];
	[removeAllWordsMenuItem setKeyEquivalentModifierMask:(NSShiftKeyMask| NSCommandKeyMask)];
	[removeAllWordsMenuItem setTarget:self];
	[editMenu insertItem:removeAllWordsMenuItem atIndex:startIndex+3];
	
	NSMenuItem* showSidebarMenuItem = [[NSMenuItem alloc] initWithTitle:@"Show All Saved Words" action:@selector(showHideSidebar:) keyEquivalent:@"d"];
	[showSidebarMenuItem setKeyEquivalentModifierMask:(NSShiftKeyMask| NSCommandKeyMask)];
	[showSidebarMenuItem setTarget:self];
	[editMenu insertItem:showSidebarMenuItem atIndex:startIndex+4];

}

- (void)addSidebar
{
	DebugLog(@"ADD SIDEBAR");
	
	dictionaryWebView = [[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:1];
	dictionarySearchView = [[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:2];

	
	NSRect scrollFrame = NSMakeRect( -5, 0, 5, self.viewHeight );
    dictionarySidebarScrollView = [[[NSScrollView alloc] initWithFrame:scrollFrame] autorelease];
	
    [dictionarySidebarScrollView setBorderType:2];
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
	
	[[dictionaryBrowserWindow contentView] addSubview:dictionarySidebarScrollView];
	
	
	// create sidebar's context menu
	NSMenuItem* sidebarRemoveMenuItem = [[NSMenuItem alloc] initWithTitle:@"Remove This Word" action:@selector(_removeWord:) keyEquivalent:@"r"];
	[sidebarRemoveMenuItem setTarget:self];
	
	NSMenu* sidebarItemMenu = [[[NSMenu alloc] init] autorelease];
	[sidebarItemMenu addItem:sidebarRemoveMenuItem];
	[sidebarItemMenu setTitle:@"SIDEBAR_CONTEXT_MENU"];
	
	[dictionarySidebar setMenu:sidebarItemMenu];

}

- (void)showHideSidebar:(id)sender
{
	if ([sender isMemberOfClass:[NSMenuItem class]]) {
		// if invoked from the menu, just pass it to the button.
		// that'll call this method again (with a different sender though).
		[showAllToolbarButton performClick:self];
	} else {
		if (sidebarIsVisible)
			[self _hideSidebar];
		else
			[self _showSidebar];
	}
}

- (void)_showSidebar
{
	DebugLog(@"SHOW SIDEBAR");
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.08f]; 
	
	[[dictionarySidebarScrollView animator] setFrame:CGRectMake(0, 0, sidebarWidth, self.viewHeight)];
	[[dictionaryWebView animator] setFrame:CGRectMake(sidebarWidth, 0, self.viewWidth-sidebarWidth, self.viewHeight)];
	[[dictionarySearchView animator] setFrame:CGRectMake(sidebarWidth, 0, self.viewWidth-sidebarWidth, self.viewHeight)];

	[NSAnimationContext endGrouping];
	
	[showAllToolbarButton setImage:sidebarShowAllImageLightImage];
	
	sidebarIsVisible = YES;
	
	// XXX: Not working
	[dictionarySidebarScrollView becomeFirstResponder];
}

- (void)_hideSidebar
{
	DebugLog(@"HIDE SIDEBAR");
		
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.08f]; 
	
	[[dictionarySidebarScrollView animator] setFrame:CGRectMake(-5, 0, 5, self.viewHeight)];
	[[dictionaryWebView animator] setFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
	[[dictionarySearchView animator] setFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
	
	[NSAnimationContext endGrouping];
	
	[showAllToolbarButton setImage:sidebarShowAllImageDarkImage];
	
	sidebarIsVisible = NO;
}

- (NSString*)searchedWord
{
	object_getInstanceVariable(dictionaryBrowserWindowController, "_searchText", (void**)&searchedText);
	return searchedText;
}


- (BOOL)hasSavedWord:(NSString*)word
{
	// TODO: use an stemmer (preferably Porter's) 
	return [savedWordsArray containsObject:word];
}


- (void)_saveWord:(id)sender
{
	[self saveWord:[self searchedWord]];
}

- (void)saveWord:(NSString*)wordToSave
{
	wordToSave = [[wordToSave capitalizedString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([self hasSavedWord:wordToSave])
		return;
	
	[savedWordsArray addObject:wordToSave];
	[dictionarySidebar reloadData];
	[self writeSavedWordsArrayToDisk];
	
	DebugLog(@"SAVED WORD: %@", wordToSave);
}


- (void)_removeWord:(id)sender
{
	if (![sender isKindOfClass:[NSMenuItem class]])
		return;
	
	if ([[[(NSMenuItem*)sender menu] title] isEqualToString:@"SIDEBAR_CONTEXT_MENU"]) {
		// it's from the sidebar context menu bar
		NSInteger clickedRow = [dictionarySidebar clickedRow];
		if (clickedRow != -1)
			[self removeWord:[savedWordsArray objectAtIndex:clickedRow]];
	} else {
		// it's from the application menu bar
		[self removeWord:[self searchedWord]];
	}
}

- (void)removeWord:(NSString*)wordToRemove
{
	wordToRemove = [wordToRemove capitalizedString];
	
	if (![self hasSavedWord:wordToRemove])
		return;
	
	DebugLog(@"CLICKED ROW: %ld, SELECTED ROW: %ld",[dictionarySidebar selectedRow],[dictionarySidebar clickedRow]);
	
	[savedWordsArray removeObject:wordToRemove];
	[dictionarySidebar reloadData];
	[self writeSavedWordsArrayToDisk];
	
	DebugLog(@"REMOVED WORD: %@", wordToRemove);
}


- (void)_removeAllSavedWords:(id)sender
{
	[self removeAllSavedWords];
}

- (void)removeAllSavedWords
{
	savedWordsArray = [[NSMutableArray alloc] init];
	[dictionarySidebar reloadData];
	[self writeSavedWordsArrayToDisk];
	
	DebugLog(@"REMOVED ALL SAVED WORDS");		
}


-(void) searchWord:(NSString*)wordToSearch
{
	DebugLog(@"SEARCH WORD: %@", wordToSearch);
	
	if ([wordToSearch isEqualToString:[self searchedWord]])
		return;
	
	// -----------------------------------------------------------------------------------
	// here we keep removed dictionaries (those from Wikipedia) safe
	//
	id _dictionaryController = [dictionaryBrowserWindowController performSelector:@selector(_dictionaryController)];
	id _dictionaryBook = [_dictionaryController performSelector:@selector(dictionaryBook)];
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


- (float)viewWidth
{
	return [[dictionaryBrowserWindow contentView] frame].size.width;
}

- (float)viewHeight
{
	return [dictionaryWebView frame].size.height;
}


/*
 * Adds a method to a class, for the specified selector with given implementation.
 */
- (void)addMethod:(IMP)newMethodIMP forSelector:(SEL)oldMethodSelector toClass:(Class)class
{
    const char *types = method_getTypeEncoding(class_getInstanceMethod(class, oldMethodSelector));
    class_addMethod(class, oldMethodSelector, newMethodIMP, types);
}

/*
 *
 */
- (void)addMethod:(SEL)newMethodSelector toClass:(Class)class
{
	Method newMethod = class_getInstanceMethod([self class], newMethodSelector); 
	[self addMethod:(IMP)method_getImplementation(newMethod) forSelector:newMethodSelector toClass:class];	
}


- (void)dealloc
{
    [super dealloc];
}












- (void)initSavedWordsArray
{
	savedWordsArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedWordsArray"];
	
	if (savedWordsArray == nil)
		savedWordsArray = [[NSMutableArray alloc] init];

	[dictionarySidebar reloadData];
	DebugLog(@"???????????????????????????11 %@", savedWordsArray);
}


- (void)writeSavedWordsArrayToDisk
{
	DebugLog(@"???????????????????????????22 %@", savedWordsArray);
	[[NSUserDefaults standardUserDefaults] setObject:savedWordsArray forKey:@"savedWordsArray"];
}









- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [savedWordsArray count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return [savedWordsArray objectAtIndex:row];
}





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
	[self searchWord:[savedWordsArray objectAtIndex:selectedRow ]];
}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification
{
	NSInteger selectedRow = [(NSTableView*)[notification object] selectedRow];
	[self searchWord:[savedWordsArray objectAtIndex:selectedRow ]];
//	[(NSTableView*)[notification object] reloadData];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return 22;
}














- (void) keyDown:(NSEvent *) event
{
//    unsigned newRow = row, newCol = column;
//    switch ([event keyCode])
//    {
//        case 126: // Up
//            if (row)
//				newRow = row - 1;
//            break;
//			
//			
//		case 125: // Down
//			if (row &lt; [theTable numberOfRows] - 1)
//				newRow = row + 1;
//			break;
//			
//			
//		case 123: // Left
//			if (column &gt; 1)
//				newCol = column - 1;
//			break;
//			
//			
//		case 124: // Right
//			if (column &lt; [theTable numberOfColumns] - 1)
//				newCol = column + 1;
//			break;
//			
//			
//		default:
			[super keyDown:event];
//			return;
//	}
	
	NSLog(@"_______: %@", event);
	
	
//	[theTable selectRow:newRow byExtendingSelection:NO];
//	[theTable editColumn:newCol row:newRow withEvent:nil select:YES];
//	row = newRow;
//	column = newCol;
	
	
}





@end



