//
//  pLEditCircleViewController.m
//  PrayList
//
//  Created by Peter Opheim on 3/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLEditCircleViewController.h"

@interface pLEditCircleViewController ()

@end

@implementation pLEditCircleViewController

@synthesize circle;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [circle.circlemembers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString * c;
    c = (NSString*)[circle.circlemembers objectAtIndex:indexPath.row];
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
	circlename.text = circle.circlename;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
