/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSObject.h"

@class NSMutableDictionary;

@interface SlidingAnimation : NSObject
{
    id _delegate;
    NSMutableDictionary *_views;
    BOOL _sliding;
    BOOL _paused;
}

- (id)init;
- (void)dealloc;
- (void)setDestinationForView:(id)arg1 to:(struct _NSPoint)arg2 travelTime:(double)arg3;
- (struct _NSPoint)destinationForView:(id)arg1;
- (void)stopView:(id)arg1;
- (void)stop;
- (void)setDelegate:(id)arg1;
- (void)pause;
- (void)resume;
- (void)_updateViewPosition:(id)arg1;
- (void)_updateTimer;
- (void)_showNextFrame;
- (void)_sendViewToDestination:(id)arg1;

@end

