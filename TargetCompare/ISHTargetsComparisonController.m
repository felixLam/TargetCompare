//
//  ISHTargetsComparisonController.m
//  TargetCompare
//
//  Created by Felix Lamouroux on 09.08.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import "ISHTargetsComparisonController.h"

@interface ISHTargetsComparisonController ()
@property (strong) NSArray *membersMissingInTargetLeft;
@property (strong) NSArray *membersMissingInTargetRight;
@end


@implementation ISHTargetsComparisonController
- (id)initWithLeftTarget:(XCTarget *)leftTarget rightTarget:(XCTarget *)rightTarget {
    self = [super initWithWindowNibName:@"ISHTargetsComparisonController"];

    if (self) {
        [self setTargetLeft:leftTarget];
        [self setTargetRight:rightTarget];
    }

    return self;
}

- (void)showResults {
    
    BOOL showTables = (self.membersMissingInTargetRight.count + self.membersMissingInTargetLeft.count > 0);
    [self.imageView setHidden:showTables];
    [self.tableContainerView setHidden:!showTables];

    [self.tableViewLeft reloadData];
    [self.tableViewRight reloadData];

    [[self window] makeKeyAndOrderFront:nil];
}

- (void)windowDidLoad {
    [[self leftTargetTitle] setTitleWithMnemonic:self.targetLeft.name];
    [[self rightTargetTitle] setTitleWithMnemonic:self.targetRight.name];
    
    // create set of paths of target members
    NSArray *leftPathsArray = [self.targetLeft.members valueForKeyPath:@"pathRelativeToProjectRoot"];
    NSArray *rightPathsArray = [self.targetRight.members valueForKeyPath:@"pathRelativeToProjectRoot"];
    
    // add paths to targets' resources
    leftPathsArray = [leftPathsArray arrayByAddingObjectsFromArray:[self.targetLeft.resources valueForKeyPath:@"pathRelativeToProjectRoot"]];
    rightPathsArray = [rightPathsArray arrayByAddingObjectsFromArray:[self.targetRight.resources valueForKeyPath:@"pathRelativeToProjectRoot"]];
    
    // create set from arrays
    NSSet *leftPaths = [NSSet setWithArray:leftPathsArray];
    NSSet *rightPaths = [NSSet setWithArray:rightPathsArray];
    
    // substract the to set from each other to identify missing elements
    NSMutableSet *membersMissingInLeft = [NSMutableSet setWithSet:rightPaths];
    [membersMissingInLeft minusSet:leftPaths];
    NSMutableSet *membersMissingInRight = [NSMutableSet setWithSet:leftPaths];
    [membersMissingInRight minusSet:rightPaths];
    
    [self setMembersMissingInTargetLeft:[membersMissingInLeft.allObjects sortedArrayUsingSelector:@selector(compare:)]];
    [self setMembersMissingInTargetRight:[membersMissingInRight.allObjects sortedArrayUsingSelector:@selector(compare:)]];

}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == self.tableViewLeft) {
        return self.membersMissingInTargetLeft.count;
    }
    
    return self.membersMissingInTargetRight.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSArray *data = self.membersMissingInTargetLeft;
    if (self.tableViewRight == aTableView) {
        data = self.membersMissingInTargetRight;
    }
    
    if ([[aTableColumn identifier] isEqualToString:@"file"]) {
        NSString *name = [data objectAtIndex:rowIndex];
        
        return name;
    }
    
    return @"Missing";
}

@end