//
//  SessionGraphOptionPopover.h
//  
//
//  Created by Stuart Tevendale on 15/11/2011.
//  Copyright (c) 2011 Yellow Field Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OptionPopover : NSViewController <NSPopoverDelegate> {
    NSPopover *popover;

    
}

- (void)showPopup:(NSView *)positioningView;

@end
