/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSObject.h"

@class NSLock, NSMutableArray, NSMutableDictionary, NSString;

@interface DictionaryBook : NSObject
{
    NSString *_title;
    NSMutableArray *_dictionaryList;
    NSMutableArray *_dictionariesWithFrontMatter;
    BOOL _needRebuildInfo;
    BOOL _usedInBrowserWindow;
    int _targetConsolidationID;
    NSMutableDictionary *_properties;
    NSLock *_propertyLock;
}

- (id)initWithDictionaryList:(id)arg1 withTitle:(id)arg2;
- (id)initWithDictionaryList:(id)arg1 withDefaultTitle:(id)arg2;
- (id)initWithDictionaryObj:(id)arg1;
- (void)dealloc;
- (void)addDictionaryObj:(id)arg1;
- (void)removeDictionaryObj:(id)arg1;
- (int)dictionaryCount;
- (id)dictionaryList;
- (id)dictionariesWithFrontMatter;
- (id)title;
- (void)setTitle:(id)arg1;
- (BOOL)userChoiceForDictionary:(id)arg1;
- (void)setUserChoice:(BOOL)arg1 forDictionary:(id)arg2;
- (BOOL)userChoiceByDictionaryIndex:(int)arg1;
- (void)setUserChoice:(BOOL)arg1 byDictionaryIndex:(int)arg2;
- (id)properties;
- (void)setProperties:(id)arg1;
- (id)propertyForDictionary:(id)arg1 withKey:(id)arg2;
- (void)setProperty:(id)arg1 forDictionary:(id)arg2 withKey:(id)arg3;
- (void)removeProperty:(id)arg1 forDictionary:(id)arg2;
- (void)findKeyAsync:(id)arg1 byMethod:(unsigned int)arg2 maxRecordForEach:(int)arg3 notifyTarget:(id)arg4 didEndSelector:(SEL)arg5 transactionID:(int)arg6;
- (BOOL)hasAsyncFindCompleted;
- (BOOL)hasAsyncLocalFindCompleted;
- (BOOL)hasDealyedFindCompletedForDictionary:(id)arg1;
- (void)notifyAsyncFindCompletionOfDictionary:(id)arg1;
- (void)addDelayedSearchQueue:(id)arg1;
- (void)clearDelayedSearchStatus:(id)arg1;
- (void)markAsSearchingDictionary:(id)arg1;
- (void)_detachedFindThreadForEachDictionary:(id)arg1;
- (id)findKey:(id)arg1 byMethod:(unsigned int)arg2 maxRecordForEach:(int)arg3;
- (BOOL)checkRecordExistenceInAllDictionaries:(id)arg1 localOnly:(BOOL)arg2;
- (id)dataStringForRecord:(id)arg1;
- (id)findByReferenceID:(id)arg1 withAnchor:(id)arg2;
- (BOOL)usedInBrowserWindow;
- (void)setUsedInBrowserWindow:(BOOL)arg1;
- (void)setTargetConsolidationID:(int)arg1;
- (BOOL)_shouldPostponeSearchDictionary:(id)arg1;

@end

