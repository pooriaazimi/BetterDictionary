//
//  Sidebar.h
//  BetterDictionary
//
//  Created by Pooria Azimi on 27/8/11.
//  Copyright 2011 Tehran Polytechnic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SidebarController : NSObject<NSTableViewDataSource, NSTableViewDelegate> {
@private
	int numberOfRows;
}

@end
