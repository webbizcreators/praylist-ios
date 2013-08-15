//
//  pLEditGroupViewController.m
//  PrayList
//
//  Created by Peter Opheim on 3/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLEditGroupViewController.h"
#import "pLAppUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "pLGroupMemberCell.h"
#import "pLSelectGroupMemberViewController.h"
#import "NSArray+sortBy.h"
#import "pLAppDelegate.h"
#import "pLViewGroupMembersViewController.h"
#import "pLGroupNotifSettingsViewController.h"

@interface pLEditGroupViewController ()

@end

@implementation pLEditGroupViewController

@synthesize group;
@synthesize groupmemberimages;
@synthesize groupinviteesimages;
@synthesize grouprequestorsimages;


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
    
    
    
    UIImage *image = [UIImage imageNamed:@"background_iPhone5"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = (UITableView*)self.view;
    tableView.backgroundView = imageView;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    if(group){
        groupname.text = group.groupname;
        groupdescription.text = group.groupdescription;
        
        [self displaymembers];
        
        
        if([group.grouptype isEqualToString:@"Private"]){
            grouptypeicon.image = [UIImage imageNamed:@"privategroupicon.png"];
            grouptypelabel.text = @"Private Group";
        }else if([group.grouptype isEqualToString:@"Public"]){
            grouptypeicon.image = [UIImage imageNamed:@"publicgroupicon.png"];
            grouptypelabel.text = @"Public Group";
        }
       
    }
    
    [self displayactionbutton];
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissGroupMemberController)
                                                 name:@"ViewGroupMemberControllerDismissed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(memberapprove:)
                                                 name:@"MemberApprove"
                                               object:nil];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSString*useremail=[pLAppUtils securitytoken].email;
    
    CGFloat retval =0;
    
    if(indexPath.row==0){
        retval=70;
    }
    else if(indexPath.row==1){
        retval=45;
    }
    else if(indexPath.row==2){
        retval=80;
    }
    
    else if(indexPath.row==3){
        retval=80;
        if(![group.groupmembers containsObject:useremail]&&![group.invitees containsObject:useremail]){
          retval =0;
        membercell.hidden="YES";
        }
    }
    else if(indexPath.row==4){
        retval=80;
        if(![group.groupmembers containsObject:useremail]&&![group.invitees containsObject:useremail])
        {retval =0;
        inviteecell.hidden="YES";
        }
    }
    else if(indexPath.row==5){
        retval=80;
        if(![group.groupmembers containsObject:useremail]&&![group.invitees containsObject:useremail])
        {retval =0;
         requestorcell.hidden="YES";
        }
    }else if(indexPath.row==6){
        retval=44;
    }
    
    return retval;
}

-(void)displaymembers{
    
    
    
    membercountlabel.text = [[[NSNumber numberWithInt:[group.groupmembers count]] stringValue] stringByAppendingString:@" members"];
    
    inviteecountlabel.text = [[[NSNumber numberWithInt:[group.invitees count]] stringValue] stringByAppendingString:@" invited"];
    
    requestorcountlabel.text = [[[NSNumber numberWithInt:[group.requestors count]] stringValue] stringByAppendingString:@" requesting"];
    
    int i =0;
    for (UIImageView *iview in [groupmemberimages sortByObjectTag]) {
        [iview setImage:nil];
        if(i<[group.groupmembers count])
            [iview setImage:[pLAppUtils userimgFromEmail:[group.groupmembers objectAtIndex:i]]];
        i++;
    }
    
    i =0;
    for (UIImageView *iview in [groupinviteesimages sortByObjectTag]) {
        [iview setImage:nil];
        if(i<[group.invitees count])
            [iview setImage:[pLAppUtils userimgFromEmail:[group.invitees objectAtIndex:i]]];
        i++;
    }
    
    i =0;
    for (UIImageView *iview in [grouprequestorsimages sortByObjectTag]) {
        [iview setImage:nil];
        if(i<[group.requestors count])
            [iview setImage:[pLAppUtils userimgFromEmail:[group.requestors objectAtIndex:i]]];
        i++;
    }

    
    
}

-(void)displayactionbutton{
    
    deletebutton.hidden = YES;
    if([group.owneremail isEqualToString:[pLAppUtils securitytoken].email])
        deletebutton.hidden=NO;

    
    [actionbutton setEnabled:YES];
    
    if([group.grouptype isEqualToString:@"Private"]){
        if ([group.invitees containsObject:[pLAppUtils securitytoken].email]){
            [actionbutton setTitle:@"Join" forState:UIControlStateNormal];
        }
        else if ([group.groupmembers containsObject:[pLAppUtils securitytoken].email]){
            [actionbutton setTitle:@"Leave" forState:UIControlStateNormal];
            if([group.owneremail isEqualToString:[pLAppUtils securitytoken].email])
                actionbutton.hidden=YES;
        }
        else if ([group.requestors containsObject:[pLAppUtils securitytoken].email]){
            [actionbutton setTitle:@"Requested" forState:UIControlStateNormal];
            [actionbutton setEnabled:NO];
        }
        else {
            [actionbutton setTitle:@"Request" forState:UIControlStateNormal];
        }
    }
    else
    {
        if ([group.groupmembers containsObject:[pLAppUtils securitytoken].email]){
            [actionbutton setTitle:@"Leave" forState:UIControlStateNormal];
            if([group.owneremail isEqualToString:[pLAppUtils securitytoken].email])
                actionbutton.hidden=YES;
        }
        else {
            [actionbutton setTitle:@"Join" forState:UIControlStateNormal];
        }
        
    }
    
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"viewrequestors"])
    {
        pLViewGroupMembersViewController *vc = [segue destinationViewController];
        vc.mode = @"requestor";
        vc.group = group;
    }else if ([[segue identifier] isEqualToString:@"viewinvitees"]){
        
        pLViewGroupMembersViewController *vc = [segue destinationViewController];
        vc.mode = @"invitee";
        vc.group = group;
        
    }else if ([[segue identifier] isEqualToString:@"viewmembers"]){
        
        pLViewGroupMembersViewController *vc = [segue destinationViewController];
        vc.mode = @"member";
        vc.group = group;
    }else if ([[segue identifier] isEqualToString:@"editgroupnotifsettings"]){
        
        pLGroupNotifSettingsViewController *vc = [segue destinationViewController];
        vc.group = group;
    }
    
    
    
}


- (void)memberapprove:(NSNotification *)membercell {
    
    id cellid=[membercell object];
    pLGroupMemberCell*cell = (pLGroupMemberCell*)cellid;
    NSString*email = cell.email;
    
    [group.requestors removeObject:email];
    [group.groupmembers addObject:email];
    
    
}


-(void)didDismissGroupMemberController {
    
    [self displaymembers];

}

-(IBAction)actionbutton:(id)sender{
    
    if([actionbutton.titleLabel.text isEqualToString:@"Join"]){
        [self joingroup];
    } else if ([actionbutton.titleLabel.text isEqualToString:@"Leave"]){
        [self leavegroup];
    } else if ([actionbutton.titleLabel.text isEqualToString:@"Request"]){
        [self requestgroup];
    }
    
    
}
-(IBAction)deletegroup:(id)sender{
    
    
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Do you want to delete this group?" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:@"Delete Group" otherButtonTitles:nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        [self deletegroupconf];
    }
    
}

-(void)deletegroupconf{
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Deleting"];
    
    [[RKObjectManager sharedManager] deleteObject:group path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EditGroupViewControllerDismissed"
                                                                object:nil
                                                              userInfo:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
                                          failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                              
                                              [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                          }];

    
    
}

-(void)joingroup{
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Joining Group"];
    NSString *objectpath = @"groups/";
    NSString *path = [[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:group.groupid] stringByAppendingString:@"/join"];

    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSMutableArray*newmembers = [NSMutableArray arrayWithArray:group.groupmembers];
                                                  [newmembers addObject:[pLAppUtils securitytoken].email];
                                                  group.groupmembers = newmembers;
                                                  
                                                  NSMutableArray*newinvitees = [NSMutableArray arrayWithArray:group.invitees];
                                                  [newinvitees removeObject:[pLAppUtils securitytoken].email];
                                                  group.invitees = newinvitees;
                                                  
                                                  [self displaymembers];
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  [self displayactionbutton];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];

    
}

-(void)leavegroup{
    

    [pLAppUtils showActivityIndicatorWithMessage:@"Leaving Group"];
    NSString *objectpath = @"groups/";
    NSString *path = [[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:group.groupid] stringByAppendingString:@"/leave"];

    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSMutableArray*newmembers = [NSMutableArray arrayWithArray:group.groupmembers];
                                                  [newmembers removeObject:[pLAppUtils securitytoken].email];
                                                  group.groupmembers = newmembers;
                                                  
                                                  [self displaymembers];
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  [self displayactionbutton];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
    
}

-(void)requestgroup{
    
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Sending Request"];
    NSString *objectpath = @"groups/";
    NSString *path = [[[[objectpath stringByAppendingString: [pLAppUtils securitytoken].orgid] stringByAppendingString:@"/"] stringByAppendingString:group.groupid] stringByAppendingString:@"/request"];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSMutableArray*newrequestors = [NSMutableArray arrayWithArray:group.requestors];
                                                  [newrequestors addObject:[pLAppUtils securitytoken].email];
                                                  group.requestors = newrequestors;
                                                  
                                                  [self displaymembers];
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Sent"];
                                                  [self displayactionbutton];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
    
}


-(IBAction)savebutton:(id)sender{
    
    //[spinner startAnimating];
    
        pLGroup *gp = group;
    
        gp.groupname = groupname.text;
        
        [[RKObjectManager sharedManager] postObject:gp path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
            
            if(mappingResult.array.count>0){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"EditGroupViewControllerDismissed"
                                                                    object:nil
                                                                  userInfo:nil];
                //[spinner stopAnimating];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        }
                                           failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                               
                                               
                                           }];
        
        
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
