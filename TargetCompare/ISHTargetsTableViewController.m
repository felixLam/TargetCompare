//
//  ISHTargetsTableViewController.m
//  TargetCompare
//
//  Created by Felix Lamouroux on 09.08.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import "ISHTargetsTableViewController.h"
#import <XcodeEditor/XCProject.h>

NSString const *kUserDefaultsPathKey = @"ISHUserDefaultsPathKey";

@interface ISHTargetsTableViewController ()
@property (strong) NSString * projectFilePath;
@property (strong) XCProject *project;
@end

@implementation ISHTargetsTableViewController

-(void)awakeFromNib {
    [self setProjectFilePath:[[NSUserDefaults standardUserDefaults] stringForKey:(NSString *)kUserDefaultsPathKey]];
    
    [self.readProjectButton setEnabled:[[self projectFilePath] length]];
        
    [self.startComparisonButton setEnabled:NO];
    
    if (self.projectFilePath) {
        [self.filePathTextField setStringValue:self.projectFilePath];
        [self readProject:self.readProjectButton];
    }
}


- (IBAction)selectFilePath:(id)sender {
    NSInteger result = 0;
    NSArray *fileTypes = [NSArray arrayWithObject:@"xcodeproj"];
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    
    [oPanel setAllowsMultipleSelection:NO];
    [oPanel setAllowedFileTypes:fileTypes];
    result = [oPanel runModal];
    
    if (result == NSOKButton) {
        NSArray *filesToOpen = [oPanel URLs];
        NSUInteger count = [filesToOpen count];
        
        for (int i = 0; i < count; i++) {
            NSURL *selectedUrl = [filesToOpen objectAtIndex:i];
            NSString *aFile = [selectedUrl relativePath];
            
            [self setProjectFilePath:aFile];
            [self.filePathTextField setStringValue:aFile];
            [[NSUserDefaults standardUserDefaults] setObject:aFile forKey:(NSString *)kUserDefaultsPathKey];
        }
    }
    
    [self.readProjectButton setEnabled:[[self projectFilePath] length]];
}

- (IBAction)readProject:(id)sender {
    if (!self.projectFilePath) {
        return;
    }
    
    XCProject *project = [XCProject projectWithFilePath:self.projectFilePath];
    NSLog(@"targets: %@", [project targets]);
    
    [self setProject:project];
    [self.targetsTableViewLeft reloadData];
    [self.targetsTableViewRight reloadData];
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.project.targets.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSString *name = [[self.project.targets objectAtIndex:rowIndex] name];
    
    return name;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSInteger selectedIndexLeft = [self.targetsTableViewLeft selectedRow];
    NSInteger selectedIndexRight = [self.targetsTableViewRight selectedRow];

    BOOL comparisonPossible = (selectedIndexLeft >= 0 && selectedIndexRight >= 0 && selectedIndexLeft != selectedIndexRight);
    
    [self.startComparisonButton setEnabled:comparisonPossible];
}

- (IBAction)startComparison:(id)sender {
    
    NSInteger selectedIndexLeft = [self.targetsTableViewLeft selectedRow];
    NSInteger selectedIndexRight = [self.targetsTableViewRight selectedRow];
    
    XCTarget *targetLeft = [self.project.targets objectAtIndex:selectedIndexLeft];
    XCTarget *targetRight = [self.project.targets objectAtIndex:selectedIndexRight];
    
    
    
    [self.targetComparisonController compareLeftTarget:targetLeft withRightTarget:targetRight];
}
@end
