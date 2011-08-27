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
	NSBundle* betterDictionaryBundle;
	
	NSApplication* mainApplication;
    NSToolbar* dictionaryBrowserToolbar;
	
	NSWindow* dictionaryBrowserWindow;
	NSView* dictionaryWebView;
	NSView* dictionarySearchView;
	
	NSButton* showAllToolbarButton;
	NSButton* saveWordToolbarButton;
	
	NSView* dictionarySidebar;
	NSImage* sidebarShowAllImageDarkImage;
	NSImage* sidebarShowAllImageLightImage;
	NSImage* saveWordImage;
	NSImage* removeWordImage;
	
	float viewWidth;
	float viewHeight;
	float sidebarWidth;
	
	BOOL sidebarIsVisible;
}

+ (void)load;

- (void)instantiateToolbarItems;
- (void)createMenuItems;

- (void)addSidebar;
- (void)showHideSidebar:(id)sender;
- (void)_showSidebar;
- (void)_hideSidebar;

- (void)saveWord:(NSString*)wordToSave;
- (void)removeWord:(NSString*)wordToRemove;
- (void)removeAllSavedWords;

- (void)addMethod:(IMP)newMethodIMP forSelector:(SEL)oldMethodSelector toClass:(Class)class;
- (void)addMethod:(SEL)newMethodSelector toClass:(Class)class;


@end
