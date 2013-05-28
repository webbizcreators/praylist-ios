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

@interface pLEditGroupViewController ()

@end

@implementation pLEditGroupViewController

@synthesize group;
@synthesize newgrouptype;

NSMutableArray *groupmembers;
NSMutableArray *groupinvitees;
NSMutableArray *grouprequestors;
NSMutableArray *listOfItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [listOfItems count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dictionary = [listOfItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"People"];
    return [array count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        return @"Invited";
    }
    else if(section == 1){
        return @"Requested";
    }
    else{
        return @"Members";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section == 1){
    
        pLGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestorgroupmember"];
        
        NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"People"];
        NSString *c = [array objectAtIndex:indexPath.row];
        cell.img.image = [pLAppUtils userimgFromEmail: c];
        cell.username.text = [pLAppUtils fullnamefromEmail:c];
        cell.email = c;
        return cell;
    
    }
    else{
        pLGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupmember"];
        
        NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"People"];
        NSString *c = [array objectAtIndex:indexPath.row];
        cell.img.image = [pLAppUtils userimgFromEmail: c];
        cell.username.text = [pLAppUtils fullnamefromEmail:c];
        cell.email = c;
        return cell;
        
    }
    
}


-(IBAction)savebutton:(id)sender{
    
    //[spinner startAnimating];
    
    if(!group){
    
    pLGroup *gp = [[pLGroup alloc] init];
    
    gp.owneremail = [pLAppUtils securitytoken].email;
    gp.groupname = groupname.text;
    gp.orgid = [pLAppUtils securitytoken].orgid;
    gp.groupmembers = groupmembers;
        gp.invitees = groupinvitees;
    gp.grouptype = newgrouptype;
    
    [[RKObjectManager sharedManager] putObject:gp path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
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
    else{
        
        
        pLGroup *gp = group;
        
        gp.groupname = groupname.text;
        gp.groupmembers = groupmembers;
        gp.invitees = groupinvitees;
        gp.requestors = grouprequestors;
        
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
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background_iPhone5"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    generalsubview.layer.cornerRadius = 5.0;
    generalsubview.layer.masksToBounds = YES;
    
    membersubview.layer.cornerRadius = 5.0;
    membersubview.layer.masksToBounds = YES;
    
    if(group){
        groupname.text = group.groupname;
        groupmembers = [NSMutableArray arrayWithArray:group.groupmembers];
        groupinvitees = [NSMutableArray arrayWithArray:group.invitees];
        grouprequestors = [NSMutableArray arrayWithArray:group.requestors];
        if([group.grouptype isEqualToString:@"Private"]){
            grouptypeicon.image = [UIImage imageNamed:@"privategroupicon_title.png"];
            grouptypedescription.text = @"Private Group";
        }else if([group.grouptype isEqualToString:@"Public"]){
            grouptypeicon.image = [UIImage imageNamed:@"publicgroupicon_title.png"];
            grouptypedescription.text = @"Public Group";
        }
       
    }
    else
    {
        
        if([newgrouptype isEqualToString:@"Private"]){
            grouptypeicon.image = [UIImage imageNamed:@"privategroupicon_title.png"];
            grouptypedescription.text = @"Private Group";
        }else if([newgrouptype isEqualToString:@"Public"]){
            grouptypeicon.image = [UIImage imageNamed:@"publicgroupicon_title.png"];
            grouptypedescription.text = @"Public Group";
        }
        
        groupmembers = [[NSMutableArray alloc]init];
        groupinvitees = [[NSMutableArray alloc]init];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissGroupMemberController)
                                                 name:@"GroupMemberControllerDismissed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(memberapprove:)
                                                 name:@"MemberApprove"
                                               object:nil];
    
    listOfItems = [[NSMutableArray alloc] init];
    

    NSDictionary *membersdict = [NSDictionary dictionaryWithObject:groupmembers forKey:@"People"];
    NSDictionary *inviteesdict = [NSDictionary dictionaryWithObject:groupinvitees forKey:@"People"];
    NSDictionary *requestorsdict = [NSDictionary dictionaryWithObject:grouprequestors forKey:@"People"];
    
    [listOfItems addObject:inviteesdict];
    [listOfItems addObject:requestorsdict];
    [listOfItems addObject:membersdict];
    
}


- (void)memberapprove:(NSNotification *)membercell {
    
    id cellid=[membercell object];
    pLGroupMemberCell*cell = (pLGroupMemberCell*)cellid;
    NSString*email = cell.email;
    
    [grouprequestors removeObject:email];
    [groupmembers addObject:email];
    [groupmembertableView reloadData];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
                [groupmembers removeObjectAtIndex:indexPath.row];
                [groupmembertableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"addmembersegue"])
    {
        
        pLSelectGroupMemberViewController *vc = [segue destinationViewController];
        
        vc.groupmembersadd = groupinvitees;
        
    }
    
    
    
}

-(void)didDismissGroupMemberController {
    
    
    [groupmembertableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
