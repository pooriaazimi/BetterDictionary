//
//  BetterDictionary.m
//  BetterDictionary
//
//  Created by Pooria Azimi on 27/8/11.
//  Copyright 2011 IRMUG. All rights reserved.
//

#import "BetterDictionary.h"


@implementation BetterDictionary

+ (void)load
{
	[[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
		
		//TODO: insert code for checking OS version here
		
		betterDictionaryBundle = [NSBundle bundleWithIdentifier:@"com.pooriaazimi.betterdictionary"];
		
		sidebarWidth = 170;
		sidebarIsVisible = NO;
		
		mainApplication = [NSApplication sharedApplication];
		dictionaryBrowserWindow = [[[mainApplication mainWindow] windowController] window];
		dictionaryBrowserToolbar = [dictionaryBrowserWindow toolbar];

		[self instantiateToolbarItems];
		[self addSidebar];
		[self createMenuItems];
		
//		[self addMethod:@selector(saveWord:) toClass:[[dictionaryBrowserWindow windowController] class]];
//		[self addMethod:@selector(hideSidebar:) toClass:[[dictionaryBrowserWindow windowController] class]];
//		[self addMethod:@selector(showHideSidebar) toClass:[[dictionaryBrowserWindow windowController] class]];
		
    }
    
    return self;
}




- (void)instantiateToolbarItems
{
	NSLog(@"INSTANTIATE TOOLBAR ITEMS");	
	
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
	[saveWordToolbarButton setAction:@selector(saveWord:)];
	
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
	NSLog(@"CREATE MENU ITEMS");
	
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
	
	NSMenuItem* saveWordMenuItem = [[NSMenuItem alloc] initWithTitle:@"Save This Word" action:@selector(saveWord:) keyEquivalent:@"s"];
	[editMenu insertItem:saveWordMenuItem atIndex:startIndex+1];
	[saveWordMenuItem setTarget:self];
	
	NSMenuItem* showSidebarMenuItem = [[NSMenuItem alloc] initWithTitle:@"Show All Saved Words" action:@selector(showHideSidebar:) keyEquivalent:@"d"];
	[showSidebarMenuItem setKeyEquivalentModifierMask:(NSShiftKeyMask| NSCommandKeyMask)];
	[showSidebarMenuItem setTarget:self];
	[editMenu insertItem:showSidebarMenuItem atIndex:startIndex+2];

}

- (void)addSidebar
{
	NSLog(@"ADD SIDEBAR");
	
	dictionaryWebView = [[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:1];
	dictionarySearchView = [[[dictionaryBrowserWindow contentView] subviews] objectAtIndex:2];

	viewWidth = [[dictionaryBrowserWindow contentView] frame].size.width;
	viewHeight = [dictionaryWebView frame].size.height;

	//XXX 
	dictionarySidebar = [[NSButton alloc] init]; 
	[dictionarySidebar setFrame:CGRectMake(-5, 0, 5, viewHeight)];
	[dictionarySidebar setAutoresizesSubviews:YES];
	[dictionarySidebar setAutoresizingMask:NSViewHeightSizable];
	
	[[dictionaryBrowserWindow contentView] addSubview:dictionarySidebar];
	
	
	

}

- (void)showHideSidebar:(id)sender
{
	if ([sender isMemberOfClass:[NSMenuItem class]]) {
		// if invoked from the menu, just pass it to the button
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
	NSLog(@"SHOW SIDEBAR");
	
//	[showAllToolbarButton highlight:YES];
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.08f]; 
	
	[[dictionarySidebar animator] setFrame:CGRectMake(0, 0, sidebarWidth, viewHeight)];
	[[dictionaryWebView animator] setFrame:CGRectMake(sidebarWidth, 0, viewWidth-sidebarWidth, viewHeight)];
	[[dictionarySearchView animator] setFrame:CGRectMake(sidebarWidth, 0, viewWidth-sidebarWidth, viewHeight)];

	[NSAnimationContext endGrouping];
	
	[showAllToolbarButton setImage:sidebarShowAllImageLightImage];
	
	sidebarIsVisible = YES;
}

- (void)_hideSidebar
{
	NSLog(@"HIDE SIDEBAR");
	
//	[showAllToolbarButton highlight:NO];
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.08f]; 
	
	[[dictionarySidebar animator] setFrame:CGRectMake(-5, 0, 5, viewHeight)];
	[[dictionaryWebView animator] setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
	[[dictionarySearchView animator] setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
	
	[NSAnimationContext endGrouping];
	
	[showAllToolbarButton setImage:sidebarShowAllImageDarkImage];
	
	sidebarIsVisible = NO;
}

- (void)saveWord:(NSString*)wordToSave
{
	NSLog(@"SAVE WORD: %@, %f, %@", wordToSave, viewWidth, self);
	
	//FIXME: saveWord needs a wrapper (to hide sender)
}

- (void)removeWord:(NSString*)wordToRemove
{
	NSLog(@"REMOVE WORD: %@", wordToRemove);	
}

- (void)removeAllSavedWords
{
	NSLog(@"REMOVE ALL SAVED WORDS");		
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

@end
