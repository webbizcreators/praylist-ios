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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissGroupEditViewController)
                                                 name:@"EditGroupViewControllerDismissed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestgroup:)
                                                 name:@"RequestGroup"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(groupsChanged)
                                                 name:@"GroupsChanged"
                                               object:nil];
    
    [self loadDatawithIndicator:YES];

	// Do any additional setup after loading the view.
}

-(void)groupsChanged{
    
    [self loadDatawithIndicator:NO];
    
}


- (void)requestgroup:(NSNotification *)groupcell {
    
    id cellid=[groupcell object];
    pLGroupCell*cell = (pLGroupCell*)cellid;
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    pLGroup*c;
    
    if(typeselect.selectedSegmentIndex==0){
        c = (pLGroup*)[privategroups objectAtIndex:indexPath.row];
    }
    else{
        c = (pLGroup*)[publicgroups objectAtIndex:indexPath.row];
    }
    
    
    if([c.grouptype isEqualToString:@"Private"]){
        if ([c.invitees containsObject:[pLAppUtils securitytoken].email]){
            [pLAppUtils showActivityIndicatorWithMessage:@"Joining Group"];
            NSString *objectpath = @"groups/";
            NSString *path = [[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:c.groupid] stringByAppendingString:@"/join"];
            [spinner startAnimating];
            
            [[RKObjectManager sharedManager] getObjectsAtPath:path
                                                   parameters:nil
             
                                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                          
                                                          NSMutableArray*ar = [NSMutableArray arrayWithArray:c.groupmembers];
                                                          [ar addObject:[pLAppUtils securitytoken].email];
                                                          c.groupmembers = ar;
                                                          [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                          [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                          
                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          NSLog(@"Encountered an error: %@", error);
                                                          [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                                      }];

            
        }
        else if ([c.groupmembers containsObject:[pLAppUtils securitytoken].email]){
            [pLAppUtils showActivityIndicatorWithMessage:@"Leaving Group"];
                NSString *objectpath = @"groups/";
                NSString *path = [[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:c.groupid] stringByAppendingString:@"/leave"];
                [spinner startAnimating];
                
                [[RKObjectManager sharedManager] getObjectsAtPath:path
                                                       parameters:nil
                 
                                                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                              
                                                              NSMutableArray*ar = [NSMutableArray arrayWithArray:c.groupmembers];
                                                              [ar removeObject:[pLAppUtils securitytoken].email];
                                                              c.groupmembers = ar;
                                                              [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                              [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                              
                                                          }
                                                          failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                              NSLog(@"Encountered an error: %@", error);
                                                              [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                                          }];
        }
        else {
            [pLAppUtils showActivityIndicatorWithMessage:@"Sending Request"];
                NSString *objectpath = @"groups/";
                NSString *path = [[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:c.groupid] stringByAppendingString:@"/request"];
                [spinner startAnimating];
                
                [[RKObjectManager sharedManager] getObjectsAtPath:path
                                                       parameters:nil
                 
                                                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                              
                                                              NSMutableArray*ar = [NSMutableArray arrayWithArray:c.requestors];
                                                              [ar addObject:[pLAppUtils securitytoken].email];
                                                              c.requestors = ar;
                                                              [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                              [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                              
                                                          }
                                                          failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                              NSLog(@"Encountered an error: %@", error);
                                                              [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                                          }];
            
        }
    }
    else
    {
        if ([c.groupmembers containsObject:[pLAppUtils securitytoken].email]){
            [pLAppUtils showActivityIndicatorWithMessage:@"Leaving Group"];
            NSString *objectpath = @"groups/";
            NSString *path = [[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:c.groupid] stringByAppendingString:@"/leave"];
            [spinner startAnimating];
            
            [[RKObjectManager sharedManager] getObjectsAtPath:path
                                                   parameters:nil
             
                                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                          
                                                          NSMutableArray*ar = [NSMutableArray arrayWithArray:c.groupmembers];
                                                          [ar removeObject:[pLAppUtils securitytoken].email];
                                                          c.groupmembers = ar;
                                                          [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                          [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                          
                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          NSLog(@"Encountered an error: %@", error);
                                                          [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                                      }];
        }
        else {
            [pLAppUtils showActivityIndicatorWithMessage:@"Joining Group"];
            NSString *objectpath = @"groups/";
            NSString *path = [[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:c.groupid] stringByAppendingString:@"/join"];
            [spinner startAnimating];
            
            [[RKObjectManager sharedManager] getObjectsAtPath:path
                                                   parameters:nil
             
                                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                          
                                                          NSMutableArray*ar = [NSMutableArray arrayWithArray:c.groupmembers];
                                                          [ar addObject:[pLAppUtils securitytoken].email];
                                                          c.groupmembers = ar;
                                                          [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                          [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                          
                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          NSLog(@"Encountered an error: %@", error);
                                                          [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                                      }];
        }
            
    }
    
    
    
}

-(void)loadDatawithIndicator:(BOOL)withindicator{
    if(withindicator)[pLAppUtils showActivityIndicatorWithMessage:@"Loading"];

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
                                                  
                                                  if(withindicator)[pLAppUtils hideActivityIndicator];

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
    else
    {
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    pLGroupCell *cell;
    
    pLGroup * c;
    
    if(typeselect.selectedSegmentIndex==0){
        c = (pLGroup*)[privategroups objectAtIndex:indexPath.row];
        if([c.owneremail isEqualToString:[pLAppUtils securitytoken].email]){
            cell = (pLGroupCell *)[tableView dequeueReusableCellWithIdentifier: @"groupcell"];
        }
        else if ([c.invitees containsObject:[pLAppUtils securitytoken].email]){
            cell = (pLGroupCell *)[tableView dequeueReusableCellWithIdentifier: @"joingroupcell"];
        }
        else if ([c.groupmembers containsObject:[pLAppUtils securitytoken].email]){
            cell = (pLGroupCell *)[tableView dequeueReusableCellWithIdentifier: @"leavegroupcell"];
        }
        else if ([c.requestors containsObject:[pLAppUtils securitytoken].email]){
            cell = (pLGroupCell *)[tableView dequeueReusableCellWithIdentifier: @"requestedgroupcell"];
        }
        else{
            cell = (pLGroupCell *)[tableView dequeueReusableCellWithIdentifier: @"requestgroupcell"];
        }
        
        
    }
    else if (typeselect.selectedSegmentIndex==1) {
        c = (pLGroup*)[publicgroups objectAtIndex:indexPath.row];
        if([c.owneremail isEqualToString:[pLAppUtils securitytoken].email]){
            cell = (pLGroupCell *)[tableView dequeueReusableCellWithIdentifier: @"groupcell"];
        }
        else if ([c.groupmembers containsObject:[pLAppUtils securitytoken].email]){
            cell = (pLGroupCell *)[tableView dequeueReusableCellWithIdentifier: @"leavegroupcell"];
        }
        else {
            cell = (pLGroupCell *)[tableView dequeueReusableCellWithIdentifier: @"joingroupcell"];
        }
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


-(IBAction)refreshgroups:(id)sender
{
    [self loadDatawithIndicator:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"editgroup"])
    {

        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [tableView indexPathForCell: cell];
        
        pLEditGroupViewController *vc = [segue destinationViewController];
        
        if(typeselect.selectedSegmentIndex==0){
            vc.group = [privategroups objectAtIndex:indexPath.row];
        }
        else if (typeselect.selectedSegmentIndex==1) {
            vc.group = [publicgroups objectAtIndex:indexPath.row];
        }
        
        
        
        
    }else if ([[segue identifier] isEqualToString:@"addGroup"]){
        
        
    }else if ([[segue identifier] hasPrefix:@"viewgroup"]){
    
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [tableView indexPathForCell: cell];
        
        pLEditGroupViewController *vc = [segue destinationViewController];
        
        if(typeselect.selectedSegmentIndex==0){
            vc.group = [privategroups objectAtIndex:indexPath.row];
        }
        else if (typeselect.selectedSegmentIndex==1) {
            vc.group = [publicgroups objectAtIndex:indexPath.row];
        }
        
    }
    
}


-(void)didDismissGroupEditViewController{

    [self loadDatawithIndicator:NO];
    
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
