//
//  pLCircleListViewController.m
//  PrayList
//
//  Created by Peter Opheim on 3/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLCircleListViewController.h"
#import "pLAppUtils.h"
#import "pLPrayerRequest.h"
#import "pLSelectCircleforPostViewController.h"
#import "pLCircleCollectionCell.h"
#import "plCircle.h"
#import "pLEditCircleViewController.h"

@interface pLCircleListViewController ()

@end

@implementation pLCircleListViewController

NSMutableArray *sourcecircles;
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
    NSString *objectpath = @"circles/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  sourcecircles = [[NSMutableArray alloc] initWithArray:mappingResult.array];
                                                  
                                                  
                                                  if(sourcecircles.count>0){
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"circlename"
                                                                                                   ascending:YES];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      sourcecircles = [[NSMutableArray alloc] initWithArray:[sourcecircles sortedArrayUsingDescriptors:sortDescriptors]];
                                                      [spinner stopAnimating];
                                                      tableView.hidden = NO;
                                                      [tableView reloadData];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sourcecircles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    pLCircle * c;
    c = (pLCircle*)[sourcecircles objectAtIndex:indexPath.row];
    cell.textLabel.text = c.circlename;
    
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"editCircle"])
    {
        // Get reference to the destination view controller
        pLEditCircleViewController *vc = [segue destinationViewController];
        
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [tableView indexPathForCell: cell];
        // Pass any objects to the view controller here, like...
        vc.circle = [sourcecircles objectAtIndex:indexPath.row];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDismissCircleEditViewController)
                                                     name:@"CircleEditViewControllerDismissed"
                                                   object:nil];
    }
}

-(void)didDismissCircleEditViewController{

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
