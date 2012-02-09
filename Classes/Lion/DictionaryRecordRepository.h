/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSObject.h"

@class DictionaryRecordArray, NSArray, NSMutableDictionary, NSString;

@interface DictionaryRecordRepository : NSObject
{
    NSMutableDictionary *_recordArrays;
    NSString *_searchString;
    NSString *_lastFilterID;
    BOOL _needToBuildHeadwords;
    NSArray *_lastHeadwords;
    BOOL _needToBuildHeadwordRecords;
    NSString *_lastHeadwordFilter;
    unsigned long long _lastHeadwordRefsCount;
    struct __CFArray **_lastHeadwordRefs;
    DictionaryRecordArray *_lastHeadwordRecords;
    NSMutableDictionary *_properties;
}

+ (id)recordRepositoryWithSearchString:(id)arg1;
- (void)dealloc;
- (unsigned long long)count;
- (BOOL)hasRecordInDictionary:(id)arg1;
- (void)addRecordsFromRecordArray:(id)arg1 fromDictionary:(id)arg2;
- (void)addRecordsFromRepository:(id)arg1;
- (void)removeRecordsFromDictionary:(id)arg1;
- (id)headwordsInDictionary:(id)arg1;
- (id)recordsWithHeadword:(id)arg1 inDictionary:(id)arg2;
- (id)recordsWithKeyword:(id)arg1 inDictionary:(id)arg2;
- (id)currentFirstRecord;
- (id)searchKeyForHeadword:(id)arg1;
- (void)setProperty:(id)arg1 forKey:(id)arg2;
- (id)propertyForKey:(id)arg1;
- (void)setProperty:(id)arg1 forDictionary:(id)arg2 withKey:(id)arg3;
- (id)propertyForDictionary:(id)arg1 withKey:(id)arg2;
- (void)_setSearchString:(id)arg1;
- (id)_searchString;
- (id)_recordArrays;
- (id)_properties;
- (void)_addRecords:(id)arg1 withIdentifier:(id)arg2;
- (unsigned long long)_createRecordRefList:(const struct __CFArray ***)arg1 filterID:(id)arg2;

@end

