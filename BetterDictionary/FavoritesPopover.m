//
//  SessionGraphOptionPopover.m
//  
//
//  Created by Stuart Tevendale on 15/11/2011.
//  Copyright (c) 2011 Yellow Field Technologies Ltd. All rights reserved.
//

#import "FavoritesPopover.h"

@implementation OptionPopover

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)_makePopoverIfNeeded {
    if (popover == nil) {
        // Create and setup our popover
        popover = [[NSPopover alloc] init];
        // The popover retains us and we retain the popover. We drop the popover whenever it is closed to avoid a cycle.
        popover.contentViewController = self;
        popover.behavior = NSPopoverBehaviorTransient;
		popover.contentSize = NSMakeSize(100, 100);
//        popover.delegate = self;
    }
}

- (void)showPopup:(NSView *)positioningView {
    [self _makePopoverIfNeeded];
    [popover showRelativeToRect:[positioningView bounds] ofView:positioningView preferredEdge:NSMaxYEdge];
}

- (void)dealloc
{
	[popover release];
	[super release];
}

@end
