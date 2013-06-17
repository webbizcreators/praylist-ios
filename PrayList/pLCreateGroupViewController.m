//
//  pLCreateGroupViewController.m
//  PrayList
//
//  Created by Peter Opheim on 5/28/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLCreateGroupViewController.h"
#import "pLSelectGroupPrivacyViewController.h"
#import "pLSelectGroupMemberViewController.h"
#import "pLAppUtils.h"

@interface pLCreateGroupViewController ()

@end

@implementation pLCreateGroupViewController

NSMutableString*grouptype;
NSMutableArray*groupinvitees;

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
                                             selector:@selector(didDismissGroupPrivacyController)
                                                 name:@"GroupPrivacyControllerDismissed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissGroupMemberController)
                                                 name:@"GroupMemberControllerDismissed"
                                               object:nil];
    
    grouptype = [NSMutableString stringWithString:@"Private"];
    groupinvitees = [[NSMutableArray alloc]init];
    
}








- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"selectGroupPrivacy"])
    {
        pLSelectGroupPrivacyViewController *vc = [segue destinationViewController];
        vc.grouptype = grouptype;
    }
    
    if ([[segue identifier] isEqualToString:@"selectGroupInvitees"])
    {
        pLSelectGroupMemberViewController *vc = [segue destinationViewController];
        vc.groupmembersadd = groupinvitees;
    }
    
}


-(void)didDismissGroupPrivacyController{
    
    groupprivacy.text = grouptype;
    
}

-(void)didDismissGroupMemberController{
    
    if([groupinvitees count]==1){
        groupinviteecount.text = [[NSString stringWithFormat:@"%d", [groupinvitees count]] stringByAppendingString:@" Person"];
    }
    else{
        groupinviteecount.text = [[NSString stringWithFormat:@"%d", [groupinvitees count]] stringByAppendingString:@" People"];  
    }
    
}

-(IBAction)doneButton:(id)sender{
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Creating Group"];
    pLGroup *gp = [[pLGroup alloc] init];
    
    gp.owneremail = [pLAppUtils securitytoken].email;
    gp.groupname = groupname.text;
    gp.orgid = [pLAppUtils securitytoken].orgid;
    gp.invitees = groupinvitees;
    gp.grouptype = grouptype;
    gp.groupdescription = groupdesc.text;
    gp.groupmembers = [NSMutableArray arrayWithObject:gp.owneremail];
    
    [[RKObjectManager sharedManager] putObject:gp path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EditGroupViewControllerDismissed"
                                                                object:nil
                                                              userInfo:nil];
            //[spinner stopAnimating];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
                                       failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                           
                                           [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                       }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
