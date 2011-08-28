//
//  NSObjectAdditions.h
//  BetterDictionary
//
//  Created by Pooria Azimi on 28/8/11.
//  Copyright 2011 Tehran Polytechnic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (NSObjectAdditions)

- (id) performSelector: (SEL) selector withObject: (id) p1
			withObject: (id) p2 withObject: (id) p3;

- (id) performSelector: (SEL) selector withObjects: (NSArray*)argumentArray;

@end
