/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSObject.h"

@interface TextAccessibilityObj : NSObject
{
    id _element;
    struct _NSPoint _lastPoint;
    struct _NSRange _lastTextRange;
    float _scalingFactor;
}

+ (id)objectWithLocation:(struct _NSPoint)arg1;
+ (id)lastObject;
- (id)_initWithLocation:(struct _NSPoint)arg1;
- (BOOL)_isValidUIElement:(id)arg1;
- (void)dealloc;
- (id)textForRequestLength:(int)arg1 resultTextOffset:(int *)arg2 resultMouseOffset:(int *)arg3;
- (struct _NSPoint)lastTextOrigin:(struct _NSRange)arg1;
- (id)lastTextAttributesInRange:(struct _NSRange)arg1;
- (BOOL)pointInSelection:(struct _NSPoint)arg1;
- (int)_offsetForLocation:(struct _NSPoint)arg1;

@end

