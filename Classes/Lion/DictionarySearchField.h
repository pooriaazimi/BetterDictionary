/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSSearchField.h"

@class NSString;

@interface DictionarySearchField : NSSearchField
{
    NSString *_searchString;
    long long _searchMethod;
}

- (void)awakeFromNib;
- (void)dealloc;
- (id)searchStringValue;
- (void)setSearchStringValue:(id)arg1 displayString:(id)arg2 triggerSearch:(BOOL)arg3;
- (void)setSnapbackButtonWithTarget:(id)arg1 action:(SEL)arg2;
- (void)hideSnapbackButton;
@property long long searchMethod; // @synthesize searchMethod=_searchMethod;

@end

