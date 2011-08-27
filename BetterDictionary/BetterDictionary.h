//
//  BetterDictionary.h
//  BetterDictionary
//
//  Created by Pooria Azimi on 27/8/11.
//  Copyright 2011 IRMUG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"


@interface BetterDictionary : NSObject {
@private
	NSApplication* mainApplication;
    NSToolbar* dictionaryBrowserToolbar;
	
	NSWindow* dictionaryBrowserWindow;
	NSView* dictionaryWebView;
	NSView* dictionarySearchView;
	
	NSView* dictionarySidebar;
	
	float viewWidth;
	float viewHeight;
	float sidebarWidth;
	
	
	id betterDictionary;
}

+ (void)load;

- (void)instantiateToolbarItems;
- (void)createMenuItems;

- (void)addSidebar:(id)sender;
- (void)showSidebar;
- (void)hideSidebar:(id)sender;

- (void)saveWord:(NSString*)wordToSave;
- (void)removeWord:(NSString*)wordToRemove;
- (void)removeAllSavedWords;

- (void)addMethod:(IMP)newMethodIMP forSelector:(SEL)oldMethodSelector toClass:(Class)class;
- (void)addMethod:(SEL)newMethodSelector toClass:(Class)class;


@end
