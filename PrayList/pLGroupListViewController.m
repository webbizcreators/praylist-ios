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
#import "pLGroupCell.h"

@interface pLGroupListViewController ()

@end

@implementation pLGroupListViewController


NSMutableArray *privategroups;
NSMutableArray *publicgroups;

UIActivityIndicatorView *spinner;

UIImage *privateimg;
UIImage *publicimg;

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
    
    privateimg = [UIImage imageNamed:@"privategroupicon.png"];
    publicimg = [UIImage imageNamed:@"publicgroupicon.png"];
    
    [self loadGroups];

	// Do any additional setup after loading the view.
}





-(void)loadGroups{
    spinner = [pLAppUtils addspinnertoview:self.view];


    privategroups = [[NSMutableArray alloc]init];
    publicgroups = [[NSMutableArray alloc]init];
    
    
    NSString *objectpath = @"groups/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSMutableArray* groups = [[NSMutableArray alloc] initWithArray:mappingResult.array];
                                                  
                                                  
                                                  if(groups.count>0){
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupname"
                                                                                                   ascending:YES];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      groups = [[NSMutableArray alloc] initWithArray:[groups sortedArrayUsingDescriptors:sortDescriptors]];
                                                      
                                                      for(NSObject *o in groups){
                                                          pLGroup* g = (pLGroup*)o;
                                                          
                                                          if([g.grouptype isEqualToString:@"Private"]){
                                                              [privategroups addObject:g];
                                                          } else if ([g.grouptype isEqualToString:@"Public"]){
                                                              [publicgroups addObject:g];
                                                          }
                                                          
                                                          
                                                          
                                                      }
                                                      
                                                      
                                                  }
                                                  
                                                  [spinner stopAnimating];

                                                  [tableView reloadData];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(typeselect.selectedSegmentIndex==0){
        return [privategroups count];
    }
    else if (typeselect.selectedSegmentIndex==1) {
      return [publicgroups count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CustomCellIdentifier = @"groupcell";
    
    pLGroupCell *cell = (pLGroupCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    
    
    pLGroup * c;
    
    if(typeselect.selectedSegmentIndex==0){
        c = (pLGroup*)[privategroups objectAtIndex:indexPath.row];
    }
    else if (typeselect.selectedSegmentIndex==1) {
        c = (pLGroup*)[publicgroups objectAtIndex:indexPath.row];
    }
    
    
    
    
    
    cell.groupname.text = c.groupname;
    cell.groupdesc.text = @"";
    
    if([c.grouptype isEqualToString:@"Private"]){
        cell.img.image = privateimg;
    }
    else if ([c.grouptype isEqualToString:@"Public"]){
        cell.img.image = publicimg;
    }
    
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
        
        if(typeselect.selectedSegmentIndex==0){
            vc.group = [privategroups objectAtIndex:indexPath.row];
        }
        else if (typeselect.selectedSegmentIndex==1) {
            vc.group = [publicgroups objectAtIndex:indexPath.row];
        }
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDismissGroupEditViewController)
                                                     name:@"GroupEditViewControllerDismissed"
                                                   object:nil];
    }
}

-(void)didDismissGroupEditViewController{

    
}

-(IBAction)switchtypeview:(id)sender{
 
    [tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
