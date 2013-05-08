//
//  pLGroupListViewController.m
//  PrayList
//
//  Created by Peter Opheim on 3/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLGroupListViewController.h"
#import "pLAppUtils.h"
#import "pLPrayerRequest.h"
#import "pLSelectGroupforPostViewController.h"
#import "pLGroupCollectionCell.h"
#import "plGroup.h"
#import "pLEditGroupViewController.h"

@interface pLGroupListViewController ()

@end

@implementation pLGroupListViewController

NSMutableArray *sourcegroups;
UIActivityIndicatorView *spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
	// Do any additional setup after loading the view.
}





-(void)loadData{
    spinner = [pLAppUtils addspinnertoview:self.view];
    tableView.hidden = YES;
    NSString *objectpath = @"groups/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  sourcegroups = [[NSMutableArray alloc] initWithArray:mappingResult.array];
                                                  
                                                  
                                                  if(sourcegroups.count>0){
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupname"
                                                                                                   ascending:YES];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      sourcegroups = [[NSMutableArray alloc] initWithArray:[sourcegroups sortedArrayUsingDescriptors:sortDescriptors]];
                                                      
                                                  }
                                                  
                                                  [spinner stopAnimating];
                                                  tableView.hidden = NO;
                                                  [tableView reloadData];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sourcegroups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    pLGroup * c;
    c = (pLGroup*)[sourcegroups objectAtIndex:indexPath.row];
    cell.textLabel.text = c.groupname;
    
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"editGroup"])
    {
        // Get reference to the destination view controller
        pLEditGroupViewController *vc = [segue destinationViewController];
        
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [tableView indexPathForCell: cell];
        // Pass any objects to the view controller here, like...
        vc.group = [sourcegroups objectAtIndex:indexPath.row];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDismissGroupEditViewController)
                                                     name:@"GroupEditViewControllerDismissed"
                                                   object:nil];
    }
}

-(void)didDismissGroupEditViewController{

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
