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
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    buttonview.hidden=YES;
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
                                             selector:@selector(loadgroups)
                                                 name:@"GroupsChanged"
                                               object:nil];
    
    [self loadGroups];

	// Do any additional setup after loading the view.
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
                                                          [spinner stopAnimating];
                                                          
                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          NSLog(@"Encountered an error: %@", error);
                                                          [spinner stopAnimating];
                                                      }];

            
        }
        else if ([c.groupmembers containsObject:[pLAppUtils securitytoken].email]){
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
                                                              [spinner stopAnimating];
                                                              
                                                          }
                                                          failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                              NSLog(@"Encountered an error: %@", error);
                                                              [spinner stopAnimating];
                                                          }];
        }
        else {
            
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
                                                              [spinner stopAnimating];
                                                              
                                                          }
                                                          failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                              NSLog(@"Encountered an error: %@", error);
                                                              [spinner stopAnimating];
                                                          }];
            
        }
    }
    else
    {
        if ([c.groupmembers containsObject:[pLAppUtils securitytoken].email]){
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
                                                          [spinner stopAnimating];
                                                          
                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          NSLog(@"Encountered an error: %@", error);
                                                          [spinner stopAnimating];
                                                      }];
        }
        else {
            
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
                                                          [spinner stopAnimating];
                                                          
                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          NSLog(@"Encountered an error: %@", error);
                                                          [spinner stopAnimating];
                                                      }];
        }
            
    }
    
    
    
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

-(IBAction)addgroupbutton:(id)sender
{
    if(buttonview.hidden==YES){
       buttonview.hidden=NO; 
    }
    else{
        buttonview.hidden=YES;
    }
    
}

-(IBAction)addprivategroup:(id)sender
{
    [self performSegueWithIdentifier: @"addGroup" sender: addprivategroupbtn];
    buttonview.hidden=YES;
}

-(IBAction)addpublicgroup:(id)sender
{
    [self performSegueWithIdentifier: @"addGroup" sender: addpublicgroupbtn];
    buttonview.hidden=YES;
}

-(IBAction)refreshgroups:(id)sender
{
    [self loadGroups];
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
        
        
        
        
    }else if ([[segue identifier] isEqualToString:@"addGroup"]){
        
        // Get reference to the destination view controller
        pLEditGroupViewController *vc = [segue destinationViewController];
        
        UIButton* btn = (UIButton*)sender;
        
        if([btn.titleLabel.text isEqualToString:@"Private"])
        vc.newgrouptype = @"Private";
        else
        {
         vc.newgrouptype = @"Public";   
        }
        
        
        
    }
    
    
    
}

-(void)handleTap:(UITapGestureRecognizer*)tapRecognizer
{
  buttonview.hidden=YES;  
}


-(void)didDismissGroupEditViewController{

    [self loadGroups];
    
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
