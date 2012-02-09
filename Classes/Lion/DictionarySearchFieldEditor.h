/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSTextView.h"

@class DictionarySearchField;

@interface DictionarySearchFieldEditor : NSTextView
{
    DictionarySearchField *_searchField;
    BOOL _changingTextSilently;
}

- (void)didChangeText;
- (void)doCommandBySelector:(SEL)arg1;
- (BOOL)_isValidTextChange;
- (void)_setChangingTextSilently:(BOOL)arg1;
@property DictionarySearchField *searchField; // @synthesize searchField=_searchField;

@end

