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

- (void)showResults {
    
    BOOL showTables = (self.membersMissingInTargetRight.count + self.membersMissingInTargetLeft.count > 0);
    [self.imageView setHidden:showTables];
    [self.tableContainerView setHidden:!showTables];
    
    [[self window] makeKeyAndOrderFront:nil];
}

- (void)compareLeftTarget:(XCTarget *)targetLeft withRightTarget:(XCTarget *)targetRight {
    [[self leftTargetTitle] setTitleWithMnemonic:targetLeft.name];
    [[self rightTargetTitle] setTitleWithMnemonic:targetRight.name];
    
    // create set of fullpaths
    NSArray *leftPathsArray = [targetLeft.members valueForKeyPath:@"pathRelativeToProjectRoot"];
    NSArray *rightPathsArray = [targetRight.members valueForKeyPath:@"pathRelativeToProjectRoot"];
    
    leftPathsArray = [leftPathsArray arrayByAddingObjectsFromArray:[targetLeft.resources valueForKeyPath:@"pathRelativeToProjectRoot"]];
    rightPathsArray = [rightPathsArray arrayByAddingObjectsFromArray:[targetRight.resources valueForKeyPath:@"pathRelativeToProjectRoot"]];
    
    NSSet *leftPaths = [NSSet setWithArray:leftPathsArray];
    NSSet *rightPaths = [NSSet setWithArray:rightPathsArray];
    
    NSMutableSet *membersMissingInLeft = [NSMutableSet setWithSet:rightPaths];
    [membersMissingInLeft minusSet:leftPaths];
    NSMutableSet *membersMissingInRight = [NSMutableSet setWithSet:leftPaths];
    [membersMissingInRight minusSet:rightPaths];
    
    [self setMembersMissingInTargetLeft:[membersMissingInLeft.allObjects sortedArrayUsingSelector:@selector(compare:)]];
    [self setMembersMissingInTargetRight:[membersMissingInRight.allObjects sortedArrayUsingSelector:@selector(compare:)]];
    
    [self.tableViewLeft reloadData];
    [self.tableViewRight reloadData];
    
    [self showResults];
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