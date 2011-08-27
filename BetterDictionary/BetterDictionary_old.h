//
//  BetterDictionary.h
//  BetterDictionary
//
//  Created by Pooria Azimi on 24/8/11.
//  Copyright 2011 Tehran Polytechnic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"
#import <QuartzCore/QuartzCore.h> 

@interface BetterDictionary_old : NSObject {
@private
	
}

//+ (void)load;

- (void)swizzleMethods;
- (void)addItemsToMenuBar;
- (void)addMethod:(IMP)methodIMP forSelector:(SEL)methodSelector toClass:(Class)class;
- (void)addSidebar;
- (void)swizzleMethodWithSelector:(SEL)origSelector fromClass:(Class)origClass WithMwthodWithSelector:(SEL)replSelector fromClass:(Class)replClass;

- (BOOL)hasSidebar;

- (void)setDictionaryBook:(id)arg1;

- (void)_searchText:(id)arg1 inDictionaryContoller:(id)arg2 withSelection:(id)arg3;
- (void)searchText:(id)arg1;
- (float)toolbarHeightForWindow:(NSWindow*)window;



@end
