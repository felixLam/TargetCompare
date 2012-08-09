//
//  ISHTargetsTableViewController.h
//  TargetCompare
//
//  Created by Felix Lamouroux on 09.08.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISHTargetsComparisonController.h"

@interface ISHTargetsTableViewController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTextField *filePathTextField;
@property (weak) IBOutlet NSButton *filePathSelectButton;
- (IBAction)selectFilePath:(id)sender;
@property (weak) IBOutlet NSButton *readProjectButton;
- (IBAction)readProject:(id)sender;

@property (weak) IBOutlet NSTableView *targetsTableViewLeft;
@property (weak) IBOutlet NSTableView *targetsTableViewRight;

@property (weak) IBOutlet NSButton *startComparisonButton;
- (IBAction)startComparison:(id)sender;

@property (strong) IBOutlet ISHTargetsComparisonController *targetComparisonController;
@end
