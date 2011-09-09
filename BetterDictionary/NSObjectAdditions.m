//
//  NSObjectAdditions.m
//  BetterDictionary
//
//  Created by Pooria Azimi on 28/8/2011.
//  Copyright 2011 Tehran Polytechnic. All rights reserved.
//

#import "NSObjectAdditions.h"


@implementation NSObject (NSObjectAdditions)

- (id) performSelector: (SEL) selector withObjects: (NSArray*)argumentArray
{
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig)
        return nil;
	
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
	
	for (int i=0; i<[argumentArray count]; i++) {
		id arg = [argumentArray objectAtIndex:i];
		[invo setArgument:&arg atIndex:i+2];
	}
    [invo invoke];
    if (sig.methodReturnLength) {
        id anObject;
        [invo getReturnValue:&anObject];
        return anObject;
    }
    return nil;	
}

- (id) performSelector: (SEL) selector withObject: (id) p1
			withObject: (id) p2 withObject: (id) p3
{
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig)
        return nil;
	
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo invoke];
    if (sig.methodReturnLength) {
        id anObject;
        [invo getReturnValue:&anObject];
        return anObject;
    }
    return nil;
}

@end
