//
//  BetterDictionary.m
//  BetterDictionary
//
//  Created by Pooria Azimi on 24/8/11.
//  Copyright 2011 Tehran Polytechnic. All rights reserved.
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
		[self swizzleMethods];
		[self addItemsToMenuBar];
    }
    
    return self;
}

- (void)initializeSidebar
{
	
	NSWindow* win;
	object_getInstanceVariable(self, "_window", (void**)&win);
	
	
	NSButton* ccc = [[NSButton alloc] init];		
	[ccc setBordered:YES];	
	[ccc setBezelStyle:NSTexturedSquareBezelStyle];
	[ccc setTarget:self];
	[ccc setTitle:@"Add"];
	[ccc setAction:@selector(initializeSidebar)];
//	[ccc performClick:self];

	NSString* itd = [[[[win toolbar] items] objectAtIndex:0] itemIdentifier];
	[[win toolbar] insertItemWithItemIdentifier:itd atIndex:2];
	NSToolbarItem* cc = [[[win toolbar] items] objectAtIndex:2];
	
	NSLog(@"STARTED!");
	
	[cc setView: ccc];
	[cc setMaxSize:NSMakeSize(70, 25)];
	[cc setMinSize:NSMakeSize(70, 25)];
	
	
	
	
	
	
	
	
	
	
	
	
	NSView* dictionaryWebView = [[[win contentView] subviews] objectAtIndex:1];
	NSScrollView* dictionarySearchView = [[[win contentView] subviews] objectAtIndex:2];
	//	NSLog(@"dww is of class %@", [dictionaryWebView class]);
	
	
	float viewWidth = [[win contentView] frame].size.width;
	float viewHeight = [dictionaryWebView frame].size.height;
	
	NSButton* tf = [[NSButton alloc] init];
	[tf setTarget:self];
	[tf setAction:@selector(hasSidebar)];
	
	[[tf animator] setFrame:CGRectMake(0, 20, 100, viewHeight)];
	
	
	
	
	
	
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.1f]; 
	
	[[tf animator] setFrame:CGRectMake(0, 20, 100, viewHeight)];
	[[dictionaryWebView animator] setFrame:CGRectMake(100, 0, viewWidth-100, viewHeight)];
	[[dictionarySearchView animator] setFrame:CGRectMake(100, 0, viewWidth-100, viewHeight)];
	
	[NSAnimationContext endGrouping];
	
	
	
	//	[dictionarySearchView insertText:@"fdfdf"];
	//	NSArray* dd = [dictionarySearchView subviews];
	//	NSLog(@"SV: %@", dd);
	//	NSClipView* clv = [dd objectAtIndex:0];
	
	//	[clv setFrameSize:CGSizeMake(100, 100)];
	
	//	NSArray* ss = [clv subviews];
	//	NSLog(@"SV2: %@", ss);
	//	NSTableView* xv = [ss objectAtIndex:0];
	
	//	NSLog(@"DELEGATE IS %@", [xv delegate]);
	//	NSLog(@"DATASOURCE IS %@", [xv dataSource]);
	
	//	id del = [xv delegate];
	//	NSLog(@"DB: %@", [del dictionaryBook]);
	//	[del _setFoundRecords:nil];
	
	
	[tf setAutoresizesSubviews:YES];
	[tf setAutoresizingMask:NSViewHeightSizable];
	
	
	
	[[win contentView] addSubview:tf];
	
}

- (float)toolbarHeightForWindow:(NSWindow*)window
{
	NSToolbar* toolbar = [window toolbar];
	float toolbarHeight = 0.0f;
	NSRect windowFrame;
	
	if (toolbar && [toolbar isVisible]) {
		windowFrame = [NSWindow contentRectForFrameRect:[window frame] styleMask:[window styleMask]];
		toolbarHeight = NSHeight(windowFrame) - NSHeight([[window contentView] frame]);
	}
	return toolbarHeight;
	
}

- (BOOL)hasSidebar
{	
	NSWindow* win;
	object_getInstanceVariable(self, "_window", (void**)&win);
	
	NSArray* subviews = [[win contentView] subviews];
	NSView* sidebar = nil;
	NSView* vv = nil;
	for (int i=0; i<[subviews count]; i++) {
		//		NSLog(@"CLASS at index %d: %@", i, [[subviews objectAtIndex:i] class]);
		NSView* v = [subviews objectAtIndex:i];
		if ([v isMemberOfClass:[NSButton class]]) {
			sidebar = [subviews objectAtIndex:i];
			break;
		} else if ([v isMemberOfClass:objc_getClass("DictionaryWebView")]) {
			//			[v setFrameSize:CGSizeMake(500, 500)];	
			vv = v;
		}
	}
	
	
	id dd = [self _dictionaryController];
	id dictionaryBook;
	object_getInstanceVariable(dd, "_dictionaryBook", (void**)&dictionaryBook);
	
	id dictionaryList;
	object_getInstanceVariable(dictionaryBook, "_dictionaryList", (void**)&dictionaryList);
	
	// -----------------------------------------------------------------------------------
	// here we keep removed dictionaries (those from Wikipedia) safe
	//
	NSMutableArray *removedDictionaries = [[NSMutableArray alloc] initWithCapacity:2];
	
	int index = 0;
	while (index < [dictionaryList count]) {
		id dic = [dictionaryList objectAtIndex:index];
		NSString* dicName = [dic dictionaryName];
		if ([dicName hasPrefix:@"Wikipedia"]) {
			[dictionaryList removeObject:dic];
			[removedDictionaries addObject:dic];
			index--;
		}
		index++;
	}
	// -----------------------------------------------------------------------------------
	
	// -----------------------------------------------------------------------------------
	// do the actual searching 
	//
	NSString* txt = @"Rival";
	[self _setSearchTextSilently:txt];
	[self _searchText:txt inDictionaryContoller:dd withSelection:txt];
	// -----------------------------------------------------------------------------------
	
	// -----------------------------------------------------------------------------------	
	// and here, we put wikipedia dictionaries back
	// TODO: (KNOWN BUG) inserts wikipedia dics at the end, but really should put them back
	//       at their original index.
	//
	for (id doc in removedDictionaries) {
		[dictionaryList addObject:doc];
	}
	// -----------------------------------------------------------------------------------
	
	return (sidebar!=nil);
}

void emptyIMP(id self, SEL _cmd)
{
}

void saveWordIMP(id self, SEL _cmd)
{
	if (![self respondsToSelector:@selector(hasSidebar)])
		return;
	
	BOOL hasSidebar = NO;
	if ([self hasSidebar]) {
		hasSidebar = YES;
	}  else {
		[self initializeSidebar]; // only the first time
	}
	
	
	
}


/*
 * Swizzles methods.
 */
- (void)swizzleMethods
{
	Class browserWindowControllerClass = objc_getClass("BrowserWindowController");
	[self addMethod:(IMP)saveWordIMP forSelector:@selector(saveWord:) toClass:browserWindowControllerClass];	
	[self addMethod:(IMP)emptyIMP forSelector:@selector(initializeSidebar) toClass:browserWindowControllerClass];
	[self addMethod:(IMP)emptyIMP forSelector:@selector(hasSidebar) toClass:browserWindowControllerClass];
	[self addMethod:(IMP)emptyIMP forSelector:@selector(showSidebar) toClass:browserWindowControllerClass];
	[self addMethod:(IMP)emptyIMP forSelector:@selector(hideSidebar) toClass:browserWindowControllerClass];	
	
	//	[self swizzleMethodWithSelector:@selector(hasSidebar) 
	//						  fromClass:browserWindowControllerClass 
	//			 WithMwthodWithSelector:@selector(hasSidebar) 
	//						  fromClass:[self class]];
	
	
	Method orig = class_getInstanceMethod(browserWindowControllerClass, @selector(hasSidebar)); 
	Method repl = class_getInstanceMethod([self class], @selector(hasSidebar)); 
	method_exchangeImplementations(orig, repl);
	
	
	Method orig2 = class_getInstanceMethod(browserWindowControllerClass, @selector(initializeSidebar)); 
	Method repl2 = class_getInstanceMethod([self class], @selector(initializeSidebar)); 
	method_exchangeImplementations(orig2, repl2);
	
	
	
	
	
	
	//	Class dictionaryControllerClass = objc_getClass("BrowserWindowController");
	//	
	//	Method orig3 = class_getInstanceMethod(dictionaryControllerClass, @selector(_searchText:inDictionaryContoller:withSelection:)); 
	//	Method repl3 = class_getInstanceMethod([self class], @selector(_searchText:inDictionaryContoller:withSelection:)); 
	//	method_exchangeImplementations(orig3, repl3);
	
	
	
	
	Class dc2 = objc_getClass("DictionaryBrowserApp");
	[self addMethod:(IMP)emptyIMP forSelector:@selector(searchText:) toClass:dc2];	
	
	Method orig4 = class_getInstanceMethod(dc2, @selector(searchText:)); 
	Method repl4 = class_getInstanceMethod([self class], @selector(searchText:)); 
	method_exchangeImplementations(orig4, repl4);
	
	
}

- (void)searchText:(id)arg1
{
	NSLog(@"---: %@", arg1);
}



- (void)setDictionaryBook:(id)arg1;
{
	NSLog(@"SET DICTIONARY BOOK: %@", arg1);
}

- (void)_searchText:(id)arg1 inDictionaryContoller:(id)arg2 withSelection:(id)arg3
{
	NSLog(@"ARG1:\n%@\n\n\nARG2:\n%@\n\n\n\nARG3:\n%@\n\n\n", arg1, arg2, arg3);
	//	return @"fdfd";
	
	//	DictionaryRecord* rr = [[DictionaryRecord alloc] init];
}


/*
 * Adds a method to a class, for the specified selector with given implementation.
 */
- (void)addMethod:(IMP)methodIMP forSelector:(SEL)methodSelector toClass:(Class)class
{
    const char *types = method_getTypeEncoding(class_getInstanceMethod(class, methodSelector));
    class_addMethod(class, methodSelector, methodIMP, types);
}

- (void)swizzleMethodWithSelector:(SEL)origSelector fromClass:(Class)origClass WithMwthodWithSelector:(SEL)replSelector fromClass:(Class)replClass
{
	
	//	Method orig = class_getInstanceMethod(z, @selector(validateToolbarItem:)); 
	//	Method repl = class_getInstanceMethod([self class], @selector(myValidateToolbarItem:)); 
	Method orig = class_getInstanceMethod(origClass, @selector(origSelector)); 
	Method repl = class_getInstanceMethod(replClass, @selector(replSelector)); 
	method_exchangeImplementations(orig, repl);
}

/*
 * Adds 'Save this word' and 'Show all saved words' menubar items to 'Edit' menubar.
 */
- (void)addItemsToMenuBar
{
	
	NSApplication* myApplication = [NSApplication sharedApplication];
	NSLog(@"---------->:::::: %@", myApplication);
	[myApplication searchText:@"fdfdfdfd"];
	NSLog(@"++++++:   %@", [[myApplication mainWindow] windowController]);
	[[[myApplication mainWindow] windowController] initializeSidebar];
	
	
	
	
	
	
	
	NSMenuItem* editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
	NSMenu* editMenu = [editMenuItem submenu];
	
	int startIndex = 0;
	NSArray* itemsArray = [editMenu itemArray];
	for (id item in itemsArray) {
		startIndex++;
		if ([[((NSMenuItem*)item) title] isEqualToString:@"Select All"])
			break;
	}
	
	[editMenu insertItem:[NSMenuItem separatorItem] atIndex:startIndex];
	
	NSMenuItem* saveWord = [[NSMenuItem alloc] initWithTitle:@"Save this word" action:@selector(saveWord:) keyEquivalent:@"s"];
	[editMenu insertItem:saveWord atIndex:startIndex+1];
	
	NSMenuItem* showAllSavedWords = [[NSMenuItem alloc] initWithTitle:@"Show all saved words" action:@selector(showAllSavedWords) keyEquivalent:@"s"];
	[showAllSavedWords setKeyEquivalentModifierMask:(NSShiftKeyMask|NSCommandKeyMask)];
	[editMenu insertItem:showAllSavedWords atIndex:startIndex+2];
}

- (void)dealloc
{
    [super dealloc];
}

@end
