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

void saveWordIMP(id self, SEL _cmd)
{
	NSLog(@"-");
}


/*
 * Swizzles methods.
 */
- (void)swizzleMethods
{
	Class browserWindowControllerClass = objc_getClass("BrowserWindowController");
	[self swizzleMethod:(IMP)saveWordIMP withSelector:@selector(saveWord:) inClass:browserWindowControllerClass];	
}
																			  
- (void)swizzleMethod:(IMP)methodIMP withSelector:(SEL)methodSelector inClass:(Class)class
{
    const char *types = method_getTypeEncoding(class_getInstanceMethod(class, methodSelector));
    class_addMethod(class, methodSelector, methodIMP, types);
}

/*
 * Adds 'Save this word' and 'Show all saved words' menubar items to 'Edit' menubar.
 */
- (void)addItemsToMenuBar
{
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
