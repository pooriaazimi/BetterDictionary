/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSObject.h"

@class NSMutableArray, NSString;

@interface ApplicationController : NSObject
{
    NSMutableArray *_availableDictionaries;
    BOOL _appInitializeDone;
    BOOL _appTerminatedOnceInTAL;
    NSString *_activeDictionaryGlobalVars;
}

+ (id)sharedAppController;
- (void)awakeFromNib;
- (void)applicationDidFinishLaunching:(id)arg1;
- (id)_prepareMyPreferences;
- (void)_delayedDidFinishLaunching;
- (BOOL)applicationShouldHandleReopen:(id)arg1 hasVisibleWindows:(BOOL)arg2;
- (BOOL)_handleSearchTextAppleEvent;
- (void)applicationWillTerminate:(id)arg1;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(id)arg1;
- (void)showAboutBox:(id)arg1;
- (void)newBrowserWindow:(id)arg1;
- (void)selectDictionary:(id)arg1;
- (void)backHistory:(id)arg1;
- (void)forwardHistory:(id)arg1;
- (void)selectNextDictionary:(id)arg1;
- (void)selectPrevDictionary:(id)arg1;
- (void)showPreferences:(id)arg1;
- (void)openDictionaryFolder:(id)arg1;
- (void)doPageSetup:(id)arg1;
- (void)doPrint:(id)arg1;
- (void)selectSearchField:(id)arg1;
- (id)availableDictionaries;
- (void)setAvailableDictionaries:(id)arg1;
- (void)upodateDictionaries:(id)arg1 inWindow:(id)arg2;
@property(readonly) NSString *activeDictionaryGlobalVars; // @synthesize activeDictionaryGlobalVars=_activeDictionaryGlobalVars;
- (void)updateScopebarForAllWindows;
- (void)saveWindowStatesWithSettings:(BOOL)arg1 afterDelay:(double)arg2;
- (void)updatePreference;
- (id)userAgentName;
- (void)clearWebKitCacheDebug:(id)arg1;
- (void)activeDictionariesDidChanged:(id)arg1;
- (BOOL)panel:(id)arg1 shouldShowFilename:(id)arg2;
- (BOOL)validateMenuItem:(id)arg1;
- (id)_dictionaryWindowList;
- (void)_saveWindowStatesWithSettings:(id)arg1;
- (void)_prepareWindows;
- (BOOL)_restoreSavedWindows:(id)arg1 foundNewDicts:(char *)arg2;
- (long long)_generateWindowIDForWindow:(id)arg1;
- (BOOL)_shouldOpenNewWindowForExternalRequest;
- (void)_prepareTerminationForTAL;
- (void)_prepareWindowsForTAL;
- (void)doLookupService:(id)arg1 userData:(id)arg2 error:(id *)arg3;
- (void)application:(id)arg1 runTest:(unsigned long long)arg2 duration:(double)arg3;
@property(readonly) BOOL appInitializeDone; // @synthesize appInitializeDone=_appInitializeDone;

@end

