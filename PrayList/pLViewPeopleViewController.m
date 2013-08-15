//
//  pLViewPeopleViewController.m
//  PrayList
//
//  Created by Peter Opheim on 7/18/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLViewPeopleViewController.h"
#import "pLGroupMemberCell.h"
#import "pLAppUtils.h"

@interface pLViewPeopleViewController ()

@end

@implementation pLViewPeopleViewController

@synthesize peoplelist;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [peoplelist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contactcell";
    
    pLGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    NSString * c;
    c = (NSString*)[peoplelist objectAtIndex:indexPath.row];
    cell.img.image = [pLAppUtils userimgFromEmail: c];
    cell.username.text = [pLAppUtils fullnamefromEmail:c];
    
    return cell;
}

@end
