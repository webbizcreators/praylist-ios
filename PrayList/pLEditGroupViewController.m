//
//  pLEditGroupViewController.m
//  PrayList
//
//  Created by Peter Opheim on 3/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLEditGroupViewController.h"

@interface pLEditGroupViewController ()

@end

@implementation pLEditGroupViewController

@synthesize group;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [group.groupmembers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString * c;
    c = (NSString*)[group.groupmembers objectAtIndex:indexPath.row];
    cell.textLabel.text = c;
    
    return cell;
    
}

-(IBAction)cancelbutton:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
    
}


-(IBAction)savebutton:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	groupname.text = group.groupname;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
