//
//  pLViewGroupMembersViewController.m
//  PrayList
//
//  Created by Peter Opheim on 6/5/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLViewGroupMembersViewController.h"
#import "pLGroupMemberCell.h"
#import "pLAppUtils.h"
#import "pLSelectGroupMemberViewController.h"

@interface pLViewGroupMembersViewController ()

@end

@implementation pLViewGroupMembersViewController

@synthesize group;
@synthesize mode;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removemember:)
                                                 name:@"removeMember"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelinvite:)
                                                 name:@"cancelInvite"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(acceptmember:)
                                                 name:@"acceptMember"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(declinemember:)
                                                 name:@"declineMember"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissGroupMemberController)
                                                 name:@"GroupMemberControllerDismissed"
                                               object:nil];

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
    NSInteger*retval = 0;
    
    if([mode isEqualToString:@"member"]){
        retval= [group.groupmembers count];
    }
    else if([mode isEqualToString:@"invitee"]){
         retval= [group.invitees count];
    }else if([mode isEqualToString:@"requestor"]){
        retval= [group.requestors count];
    }
    
    return retval;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier;
    NSString * c;
    
    
    if([mode isEqualToString:@"member"]){
        CellIdentifier = @"groupmembercell";
        c = (NSString*)[group.groupmembers objectAtIndex:indexPath.row];
    }
    else if([mode isEqualToString:@"invitee"]){
        CellIdentifier = @"groupinviteecell";
        c = (NSString*)[group.invitees objectAtIndex:indexPath.row];
    }else if([mode isEqualToString:@"requestor"]){
        c = (NSString*)[group.requestors objectAtIndex:indexPath.row];
        CellIdentifier = @"grouprequestorcell";
    }
    
    pLGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.img.image = [pLAppUtils userimgFromEmail: c];
    cell.username.text = [pLAppUtils fullnamefromEmail:c];
    cell.email = c;
    
    cell.removebutton.hidden=NO;
    if([c isEqualToString:[pLAppUtils securitytoken].email]){
        cell.removebutton.hidden=YES;
    }
    
    return cell;
}

-(void)removemember:(NSNotification*) notification{
    
    id cellid=[notification object];
    pLGroupMemberCell*cell = (pLGroupMemberCell*)cellid;
    NSString*email = cell.email;
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Removing Member"];
    NSString *objectpath = @"groups/";
    NSString *path = [[[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:group.groupid] stringByAppendingString:@"/remove/"] stringByAppendingString:email];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  
                                                  NSMutableArray*newmembers = [NSMutableArray arrayWithArray:group.groupmembers];
                                                  [newmembers removeObject:email];
                                                  group.groupmembers = newmembers;
                                                  
                                                  [self.tableView reloadData];
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
}

-(void)cancelinvite:(NSNotification*) notification{
    
    id cellid=[notification object];
    pLGroupMemberCell*cell = (pLGroupMemberCell*)cellid;
    NSString*email = cell.email;
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Cancelling invite"];
    NSString *objectpath = @"groups/";
    NSString *path = [[[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:group.groupid] stringByAppendingString:@"/cancel/"] stringByAppendingString:email];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  
                                                  NSMutableArray*newinvitees = [NSMutableArray arrayWithArray:group.invitees];
                                                  [newinvitees removeObject:email];
                                                  group.invitees = newinvitees;
                                                  
                                                  [self.tableView reloadData];
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
}


-(void)acceptmember:(NSNotification*) notification{
    
    id cellid=[notification object];
    pLGroupMemberCell*cell = (pLGroupMemberCell*)cellid;
    NSString*email = cell.email;
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Accepting Member"];
    NSString *objectpath = @"groups/";
    NSString *path = [[[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:group.groupid] stringByAppendingString:@"/accept/"] stringByAppendingString:email];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSMutableArray*newrequestors = [NSMutableArray arrayWithArray:group.requestors];
                                                  [newrequestors removeObject:email];
                                                  group.requestors = newrequestors;
                                                  
                                                  NSMutableArray*newmembers = [NSMutableArray arrayWithArray:group.groupmembers];
                                                  [newmembers addObject:email];
                                                  group.groupmembers = newmembers;
                                                  
                                                  [self.tableView reloadData];
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
}

-(void)declinemember:(NSNotification*) notification{
    
    id cellid=[notification object];
    pLGroupMemberCell*cell = (pLGroupMemberCell*)cellid;
    NSString*email = cell.email;
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Declining Member"];
    NSString *objectpath = @"groups/";
    NSString *path = [[[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:group.groupid] stringByAppendingString:@"/decline/"] stringByAppendingString:email];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSMutableArray*newrequestors = [NSMutableArray arrayWithArray:group.requestors];
                                                  [newrequestors removeObject:email];
                                                  group.requestors = newrequestors;
                                                  
                                                  [self.tableView reloadData];
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewGroupMemberControllerDismissed"
                                                        object:nil
                                                      userInfo:nil];
    
}

-(void)didDismissGroupMemberController{
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Inviting Members"];
    
    [[RKObjectManager sharedManager] postObject:group path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
        [self.tableView reloadData];
        
    }
                                        failure:^(RKObjectRequestOperation *operation , NSError *error ){
                                            [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                            
                                        }];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"addGroupInvitees"])
    {
        if(!group.invitees){
            group.invitees = [[NSMutableArray alloc]init];
        }
        pLSelectGroupMemberViewController *vc = [segue destinationViewController];
        vc.groupmembersadd = group.invitees;
    }
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
