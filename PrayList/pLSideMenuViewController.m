//
//  pLSideMenuViewController.m
//  PrayList
//
//  Created by Peter Opheim on 6/17/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLSideMenuViewController.h"
#import "ECSlidingViewController.h"
#import "pLAppDelegate.h"
#import "pLStartupViewController.h"
#import "KeychainItemWrapper.h"
#import "pLGroupCell.h"
#import "pLAppUtils.h"
#import "pLGroup.h"

@interface pLSideMenuViewController ()

@end

@implementation pLSideMenuViewController

KeychainItemWrapper *keychainItem;
NSMutableArray*grouplist;
UIImage *privateimg;
UIImage *publicimg;

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
    
    privateimg = [UIImage imageNamed:@"privategroupicon.png"];
    publicimg = [UIImage imageNamed:@"publicgroupicon.png"];
    
    grouplist = [[NSMutableArray alloc]init];
    int x = 0;
    
    for(pLGroup*g in [pLAppUtils getgroupdictionary].allValues){
        if(x<5){
        if([g.groupmembers containsObject:[pLAppUtils securitytoken].email]){
            [grouplist addObject:g];
            x++;
        }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger retval=[grouplist count]+7;
    return retval;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    pLGroupCell *groupcell;
    
    if( indexPath.row == 0 ) {
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"mi_prayerrequests"];
    }
    
    else if (indexPath.row == 1){
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"mi_prayerplanner"];
    }
    
    else if (indexPath.row == 2){
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"mi_answeredprayers"];
    }
    
    else if (indexPath.row == 3){
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"mi_managegroups"];
    }
    
    else if ((indexPath.row > 3)&&(indexPath.row<([grouplist count]+4)))
    {
        groupcell = (pLGroupCell *)[tableView dequeueReusableCellWithIdentifier: @"groupcell"];
        
        pLGroup*g=(pLGroup*)[grouplist objectAtIndex:indexPath.row-4];
        
        groupcell.groupname.text = g.groupname;
        
        if([g.grouptype isEqualToString:@"Private"]){
            groupcell.img.image = privateimg;
        }
        else if ([g.grouptype isEqualToString:@"Public"]){
            groupcell.img.image = publicimg;
        }
        cell = groupcell;
        
    }else if (indexPath.row==([grouplist count]+4)){
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"mi_addgroup"];
    }else if (indexPath.row==([grouplist count]+5)){
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"mi_profile"];
    }else if (indexPath.row==([grouplist count]+6)){
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"mi_logout"];
    }
    
    
    return cell;
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    NSString*identifier=@"";
    
    if([cell.textLabel.text isEqualToString:@"Prayer Requests"]){
        
        identifier=@"requestFeed";
    }else if([cell.textLabel.text isEqualToString:@"Manage Groups"]){
        
        identifier=@"manageGroups";
    }else if([cell.textLabel.text isEqualToString:@"Answered Prayers"]){
        
        identifier=@"answers";
    }else if([cell.textLabel.text isEqualToString:@"Profile"]){
        
        identifier=@"editprofile";
    }else if([cell.textLabel.text isEqualToString:@"Prayer Planner"]){
    
        identifier=@"prayerPlanner";
    }else if([cell.textLabel.text isEqualToString:@"Logout"]){
        
        [keychainItem resetKeychainItem];
        
        pLAppDelegate *appDelegate = (pLAppDelegate *)[[UIApplication sharedApplication] delegate];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        pLStartupViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"startupviewcontroller"];
        
        appDelegate.window.rootViewController = mainViewController;
        
        
    }
    
    if(![identifier isEqualToString:@""]){
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    }
}


@end
