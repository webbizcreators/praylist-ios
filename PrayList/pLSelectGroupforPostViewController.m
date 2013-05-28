//
//  pLSelectGroupforPostViewController.m
//  PrayList
//
//  Created by Peter Opheim on 2/26/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLSelectGroupforPostViewController.h"
#import "pLAppUtils.h"
#import "pLGroup.h"
#import "pLGroupCell.H"

@implementation pLSelectGroupforPostViewController

@synthesize destgroupArray;
@synthesize sourcegroups;

UIImage *privateimg;
UIImage *publicimg;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background_iPhone5"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    privateimg = [UIImage imageNamed:@"privategroupicon.png"];
    publicimg = [UIImage imageNamed:@"publicgroupicon.png"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)doneButton:(id)sender{
    
    [destgroupArray removeAllObjects];
    
    NSArray* selectedRows = [tableView indexPathsForSelectedRows];
    
    for (int i=0; (i<[selectedRows count]); ++i) {
        
        NSIndexPath *thisPath = [selectedRows objectAtIndex:i];
        NSInteger *selectedindex = thisPath.row;
        
        [destgroupArray addObject: [sourcegroups objectAtIndex:selectedindex]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GroupSelectViewControllerDismissed"
                                                        object:nil
                                                      userInfo:nil];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)cancelButton:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [sourcegroups count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    pLGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[pLGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set the data for this cell:
    pLGroup * c;
    c = (pLGroup*)[sourcegroups objectAtIndex:indexPath.row];
    
    cell.groupname.text = c.groupname;
    cell.groupdesc.text = @"";
    
    if([c.grouptype isEqualToString:@"Private"]){
        cell.img.image = privateimg;
    }
    else if ([c.grouptype isEqualToString:@"Public"]){
        cell.img.image = publicimg;
    }
    
    
    int selectedindex = [destgroupArray indexOfObject:c];
    
    if(selectedindex!=2147483647){
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        cell.accessoryView.hidden = NO;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    

    return cell;
}



@end
