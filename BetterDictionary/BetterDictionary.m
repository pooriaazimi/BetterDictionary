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
		
		sidebarWidth = 170;
		betterDictionary = self;
		
		mainApplication = [NSApplication sharedApplication];
		dictionaryBrowserWindow = [[[mainApplication mainWindow] windowController] window];
		dictionaryBrowserToolbar = [dictionaryBrowserWindow toolbar];

		[self instantiateToolbarItems];
		[self addSidebar:self];
		[self createMenuItems];
		
//		[self addMethod:@selector(saveWord:) toClass:[[dictionaryBrowserWindow windowController] class]];
//		[self addMethod:@selector(hideSidebar:) toClass:[[dictionaryBrowserWindow windowController] class]];
//		[self addMethod:@selector(showSidebar) toClass:[[dictionaryBrowserWindow windowController] class]];
		
    }
    
    return self;
}




- (void)instantiateToolbarItems
{
	NSLog(@"INSTANTIATE TOOLBAR ITEMS");	
	
	NSString* sampleItemIentifier = [[[dictionaryBrowserToolbar items] objectAtIndex:0] itemIdentifier];
	
	// -----------------------------------------------------------------------------------------
	// Add 'Save word' button to the toolbar
	//
	[dictionaryBrowserToolbar insertItemWithItemIdentifier:sampleItemIentifier atIndex:2];
	NSToolbarItem* saveWordToolbarItem = [[dictionaryBrowserToolbar items] objectAtIndex:2];
	
	NSButton* saveWordToolbarButton = [[NSButton alloc] init];		
	[saveWordToolbarButton setBordered:YES];	
	[saveWordToolbarButton setBezelStyle:NSTexturedSquareBezelStyle];
	[saveWordToolbarButton setTarget:self];
	[saveWordToolbarButton setTitle:@"Save Word"];
	[saveWordToolbarButton setAction:@selector(saveWord:)];
	
	[saveWordToolbarItem setView: saveWordToolbarButton];
	[saveWordToolbarItem setMaxSize:NSMakeSize(75, 25)];
	[saveWordToolbarItem setMinSize:NSMakeSize(75, 25)];
	
	// -----------------------------------------------------------------------------------------
	// Add 'Show all saved words' button to the toolbar
	//
	[dictionaryBrowserToolbar insertItemWithItemIdentifier:sampleItemIentifier atIndex:3];
	NSToolbarItem* showAllToolbarItem = [[dictionaryBrowserToolbar items] objectAtIndex:3];
	
	NSButton* showAllToolbarButton = [[NSButton alloc] init];		
	[showAllToolbarButton setBordered:YES];	
	[showAllToolbarButton setBezelStyle:NSTexturedSquareBezelStyle];
	[showAllToolbarButton setTarget:self];
	[showAllToolbarButton setTitle:@"Show All"];
	[showAllToolbarButton setAction:@selector(showSidebar)];
	
	[showAllToolbarItem setView: showAllToolbarButton];
	[showAllToolbarItem setMaxSize:NSMakeSize(67, 25)];
	[showAllToolbarItem setMinSize:NSMakeSize(67, 25)];
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
	
	NSMenuItem* saveWord = [[NSMenuItem alloc] initWithTitle:@"Save This Word" action:@selector(saveWord:) keyEquivalent:@"s"];
	[editMenu insertItem:saveWord atIndex:startIndex+1];
	[saveWord setTarget:self];
	
	NSMenuItem* showAllSavedWords = [[NSMenuItem alloc] initWithTitle:@"Show All Saved Words" action:@selector(showSidebar) keyEquivalent:@"d"];
	[showAllSavedWords setKeyEquivalentModifierMask:(NSShiftKeyMask| NSCommandKeyMask)];
	[showAllSavedWords setTarget:self];
	[editMenu insertItem:showAllSavedWords atIndex:startIndex+2];

}

- (void)addSidebar:(id)sender
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

- (void)showSidebar
{
	NSLog(@"SHOW SIDEBAR");
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.1f]; 
	
	[[dictionarySidebar animator] setFrame:CGRectMake(0, 0, sidebarWidth, viewHeight)];
	[[dictionaryWebView animator] setFrame:CGRectMake(sidebarWidth, 0, viewWidth-sidebarWidth, viewHeight)];
	[[dictionarySearchView animator] setFrame:CGRectMake(sidebarWidth, 0, viewWidth-sidebarWidth, viewHeight)];
	
	[NSAnimationContext endGrouping];
}

- (void)hideSidebar:(id)sender
{
	NSLog(@"HIDE SIDEBAR");	
}

- (void)saveWord:(NSString*)wordToSave
{
	NSLog(@"SAVE WORD: %@, %f, %@, %@", wordToSave, viewWidth, self, betterDictionary);
	
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
