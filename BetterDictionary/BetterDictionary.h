//
//  BetterDictionary.h
//  BetterDictionary
//
//  Created by Pooria Azimi on 27/8/11.
//  Copyright 2011 IRMUG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DebugLog.h"
#import "NSObjectAdditions.h"
#import "objc/runtime.h"


@interface BetterDictionary : NSObject<NSTableViewDelegate, NSTableViewDataSource> {
	NSBundle* betterDictionaryBundle;
	
	NSApplication* mainApplication;
    NSToolbar* dictionaryBrowserToolbar;
	
	NSWindow* dictionaryBrowserWindow;
	NSWindowController* dictionaryBrowserWindowController;
	NSView* dictionaryWebView;
	NSView* dictionarySearchView;
	
	NSButton* showAllToolbarButton;
	NSButton* saveWordToolbarButton;
	
	float sidebarWidth;
	BOOL sidebarIsVisible;
	
	NSTableView* dictionarySidebar;
	NSScrollView* dictionarySidebarScrollView;
	NSImage* sidebarShowAllImageDarkImage;
	NSImage* sidebarShowAllImageLightImage;
	NSImage* saveWordImage;
	NSImage* removeWordImage;
	
	NSString* searchedText;
	NSMutableArray* savedWordsArray;

}

+ (void)load;

- (void)initToolbarItems;
- (void)createMenuItems;

- (float)viewWidth;
- (float)viewHeight;

- (void)addSidebar;
- (void)_showHideSidebar:(id)sender;
- (void)showSidebar;
- (void)hideSidebar;

- (void)_saveWord:(id)sender;
- (void)saveWord:(NSString*)wordToSave;
- (void)_removeWord:(id)sender;
- (void)removeWord:(NSString*)wordToRemove;
- (void)_removeAllSavedWords:(id)sender;
- (void)removeAllSavedWords;

- (BOOL)hasAlreadySavedWord:(NSString*)word;

- (NSString*)searchedWord;
-(void) searchWord:(NSString*)wordToSearch;

- (void)initSavedWordsArray;
- (void)writeSavedWordsArrayToDisk;

- (void)addMethod:(IMP)newMethodIMP forSelector:(SEL)oldMethodSelector toClass:(Class)class;
- (void)addMethod:(SEL)newMethodSelector toClass:(Class)class;


@property (assign) NSMutableArray* savedWordsArray;

@end
