//
//  DrawerController.h
//  BetterDictionary
//
//  Created by Pooria Azimi on 14/Nov/13.
//  Copyright (c) 2013 Tehran Polytechnic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@interface DrawerController : NSObject <NSDrawerDelegate> {
    NSDrawer *drawer;
}

- (void)setupWithWindow:(NSWindow *)parentWindow;
- (void)setContentView:(NSView *)view;

- (void)openDrawer:(id)sender;
- (void)closeDrawer:(id)sender;
- (void)toggleDrawer:(id)sender;

@property (assign) NSWindow *parentWindow;

@end
