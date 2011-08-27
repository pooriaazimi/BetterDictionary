//
//  Sidebar.m
//  BetterDictionary
//
//  Created by Pooria Azimi on 27/8/11.
//  Copyright 2011 Tehran Polytechnic. All rights reserved.
//

#import "SidebarController.h"


@implementation SidebarController

- (id)init
{
    self = [super init];
    if (self) {
		numberOfRows = 20;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}




- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return numberOfRows;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return [NSString stringWithFormat:@"----: %ld", row];
}





- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return NO;
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView
{
	return YES;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
	NSLog(@"%ld", [(NSTableView*)[notification object] selectedRow] );
}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification
{
	NSLog(@"%ld", [(NSTableView*)[notification object] selectedRow] );
	numberOfRows--;
	[(NSTableView*)[notification object] reloadData];	
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return 25;
}



@end
