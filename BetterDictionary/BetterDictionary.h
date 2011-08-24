//
//  BetterDictionary.h
//  BetterDictionary
//
//  Created by Pooria Azimi on 24/8/11.
//  Copyright 2011 Tehran Polytechnic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"


@interface BetterDictionary : NSObject {
@private
    
}

+ (void)load;

- (void)swizzleMethods;
- (void)addItemsToMenuBar;
- (void)swizzleMethod:(IMP)methodIMP withSelector:(SEL)methodSelector inClass:(Class)class;
- (void)saveWord:(NSString*)wordToSave;

@end
