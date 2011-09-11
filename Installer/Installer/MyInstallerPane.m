//
//  InstallerPane.m
//  Installer
//
//  Created by Pooria Azimi on 11/9/11.
//  Copyright 2011 Tehran Polytechnic. All rights reserved.
//

#import "InstallerPane.h"


@implementation InstallerPane

- (NSString *)title
{
	return [[NSBundle bundleForClass:[self class]] localizedStringForKey:@"PaneTitle" value:nil table:nil];
}

@end
