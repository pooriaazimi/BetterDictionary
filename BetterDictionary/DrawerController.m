//
//  DrawerController.m
//  BetterDictionary
//
//  Created by Pooria Azimi on 14/Nov/13.
//  Copyright (c) 2013 Tehran Polytechnic. All rights reserved.
//

#import "DrawerController.h"

#import "DrawerController.h"

@implementation DrawerController

- (void)setupWithWindow:(NSWindow *)parentWindow {
    _parentWindow = parentWindow;
    [self setupDrawer];
    [self setDrawerOffsets];
}

- (void)windowDidResize:(NSNotification *)notification {
    [self setDrawerOffsets];
}

- (void)setContentView:(NSView *)view
{
    drawer.contentView = view;
}




- (void)setupDrawer
{
    NSSize contentSize = NSMakeSize(175, 0);
    drawer = [[NSDrawer alloc] initWithContentSize:contentSize preferredEdge:NSMinXEdge];
    [drawer setParentWindow:_parentWindow];
    [drawer setMinContentSize:contentSize];
    [drawer setMaxContentSize:contentSize];
}

- (void)openDrawer:(id)sender
{
    [drawer openOnEdge:NSMinXEdge];
}

- (void)closeDrawer:(id)sender
{
    [drawer close];
}

- (void)toggleDrawer:(id)sender
{
    NSDrawerState state = [drawer state];
    if (NSDrawerOpeningState == state || NSDrawerOpenState == state) {
        [drawer close];
    } else {
        [drawer openOnEdge:NSMinXEdge];
    }
}

- (void)setDrawerOffsets
{
    [drawer setLeadingOffset:55-25];
    [drawer setTrailingOffset:15];
}

@end
