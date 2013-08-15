//
//  pLNotificationsPopupViewController.m
//  PrayList
//
//  Created by Peter Opheim on 5/22/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLNotificationsPopupViewController.h"
#import "pLAppUtils.h"
#import "pLNotificationCell.h"
#import "pLNotification.h"
#import "pLViewRequestViewController.h"
#import "pLAppDelegate.h"
#import "ECSlidingViewController.h"
#import "pLDrawerController.h"
#import "pLGroup.h"
#import "pLEditGroupViewController.h"

@interface pLNotificationsPopupViewController ()

@end

@implementation pLNotificationsPopupViewController

NSMutableArray*notifications;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loadData{
    
    NSString *objectpath = @"notifications/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  notifications = [NSMutableArray arrayWithArray:mappingResult.array];
                                                  
                                                  if(notifications.count>0){
                                                      
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"notificationdate" ascending:NO];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      notifications = [NSMutableArray arrayWithArray:[notifications sortedArrayUsingDescriptors:sortDescriptors]];
                                                      [tableView reloadData];
                                                  }
                                                  //lastdataload = [[NSDate alloc]init];
                                                  
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [notifications count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"notificationcell";
    
    pLNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"pLNotificationCellView" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[pLNotificationCell class]])
                
                cell = (pLNotificationCell *)oneObject;
    }
    
    // Set the data for this cell:
    pLNotification * c;
    c = (pLNotification*)[notifications objectAtIndex:indexPath.row];
    cell.notif = c;
    cell.notificationtext.text = c.notiftext;
    cell.notificationdate.text = [pLAppUtils formatPostDate:c.notificationdate];
    cell.img.image = [pLAppUtils userimgFromEmail: c.fromemail];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    pLNotificationCell *notifcell = (pLNotificationCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if([notifcell.notif.notiftype isEqualToString:@"Prayed"]||[notifcell.notif.notiftype isEqualToString:@"Commented"]){
    
        [pLAppUtils dismissnotifs];
        [pLAppUtils showActivityIndicatorWithMessage:@"Loading"];
        
            NSString *objectpath = @"lists/";
            NSString *path = [[[objectpath stringByAppendingString: [pLAppUtils securitytoken].email] stringByAppendingString:@"/"] stringByAppendingString:notifcell.notif.entityid];
            
            
            [[RKObjectManager sharedManager] getObjectsAtPath:path
                                                   parameters:nil
                                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                          
                                                          pLPrayerRequestListItem*pr = mappingResult.firstObject;
                                                          if(pr){
                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                                                              pLViewRequestViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"postDetail"];
                                                              
                                                              lvc.prayerrequestlistitem = pr;
                                                              
                                                              pLAppDelegate *appDelegate = (pLAppDelegate *)[[UIApplication sharedApplication] delegate];
                                                              
                                                              pLDrawerController*pv=(pLDrawerController*)appDelegate.window.rootViewController;
                                                              UINavigationController*navcontroller = (UINavigationController*)pv.topViewController;
                                                              
                                                              [navcontroller pushViewController:lvc animated:YES];
                                                              [pLAppUtils dismissnotifs];
                                                          }
                                                          
                                                          [pLAppUtils hideActivityIndicator];
                                                          
                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          NSLog(@"Encountered an error: %@", error);
                                                          [pLAppUtils dismissnotifs];
                                                          [pLAppUtils hideActivityIndicator];
                                                      }];
            

        
    }else if([notifcell.notif.notiftype isEqualToString:@"GroupInvite"]){
        
        NSString *objectpath = @"groups/";
        NSString *path = [objectpath stringByAppendingString: [[pLAppUtils securitytoken].orgid stringByAppendingString:[@"/" stringByAppendingString:notifcell.notif.entityid]]];
        
        
        [[RKObjectManager sharedManager] getObjectsAtPath:path
                                               parameters:nil
         
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      
                                                      pLGroup* group = (pLGroup*)mappingResult.firstObject;
                                                      
                                                      if(group){
                                                          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                                                          pLEditGroupViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"editgroupview"];
                                                          
                                                          lvc.group = group;
                                                          
                                                          pLAppDelegate *appDelegate = (pLAppDelegate *)[[UIApplication sharedApplication] delegate];
                                                          
                                                          pLDrawerController*pv=(pLDrawerController*)appDelegate.window.rootViewController;
                                                          UINavigationController*navcontroller = (UINavigationController*)pv.topViewController;
                                                          
                                                          [navcontroller pushViewController:lvc animated:YES];
                                                          [pLAppUtils dismissnotifs];
                                                      }
                                                      
                                                      
                                                      [pLAppUtils hideActivityIndicator];
                                                      
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      NSLog(@"Encountered an error: %@", error);
                                                      [pLAppUtils dismissnotifs];
                                                      [pLAppUtils hideActivityIndicator];
                                                  }];

        
    }else if([notifcell.notif.notiftype isEqualToString:@"GroupRequest"]){
        
        NSString *objectpath = @"groups/";
        NSString *path = [objectpath stringByAppendingString: [[pLAppUtils securitytoken].orgid stringByAppendingString:[@"/" stringByAppendingString:notifcell.notif.entityid]]];
        
        
        [[RKObjectManager sharedManager] getObjectsAtPath:path
                                               parameters:nil
         
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      
                                                      pLGroup* group = (pLGroup*)mappingResult.firstObject;
                                                      
                                                      if(group){
                                                          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                                                          pLEditGroupViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"editgroupview"];
                                                          
                                                          lvc.group = group;
                                                          
                                                          pLAppDelegate *appDelegate = (pLAppDelegate *)[[UIApplication sharedApplication] delegate];
                                                          
                                                          pLDrawerController*pv=(pLDrawerController*)appDelegate.window.rootViewController;
                                                          UINavigationController*navcontroller = (UINavigationController*)pv.topViewController;
                                                          
                                                          [navcontroller pushViewController:lvc animated:YES];
                                                          [pLAppUtils dismissnotifs];
                                                      }
                                                      
                                                      
                                                      [pLAppUtils hideActivityIndicator];
                                                      
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      NSLog(@"Encountered an error: %@", error);
                                                      [pLAppUtils dismissnotifs];
                                                      [pLAppUtils hideActivityIndicator];
                                                  }];
        
    }

}


@end
