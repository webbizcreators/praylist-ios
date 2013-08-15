//
//  pLGroupNotifSettingsViewController.m
//  PrayList
//
//  Created by Peter Opheim on 7/24/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLGroupNotifSettingsViewController.h"
#import "pLAppUtils.h"

@interface pLGroupNotifSettingsViewController ()

@end

@implementation pLGroupNotifSettingsViewController

@synthesize group;

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
    
    UIImage *image = [UIImage imageNamed:@"background_iPhone5"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = (UITableView*)self.view;
    tableView.backgroundView = imageView;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    [notifyallws setOn:[group.notifyall containsObject:[pLAppUtils securitytoken].email]];
    [notifyurgentsw setOn:[group.notifyurgent containsObject:[pLAppUtils securitytoken].email]];
    
    group.notifyurgent = [group.notifyurgent mutableCopy];
    group.notifyall = [group.notifyall mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)donebutton:(id)sender{
    
    NSString *objectpath = @"groups/";
    NSString *path2 = [[[objectpath stringByAppendingString: group.orgid] stringByAppendingString:@"/"] stringByAppendingString:group.groupid];
    NSString*path;
    
    if(notifyurgentsw.on){
         path = [path2 stringByAppendingString:[@"/addnotifyurgent/" stringByAppendingString:[pLAppUtils securitytoken].email]];
    }else
    {
      path = [path2 stringByAppendingString:[@"/removenotifyurgent/" stringByAppendingString:[pLAppUtils securitytoken].email]];
    }
    
    
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  if(notifyurgentsw.on){
                                                      [group.notifyurgent addObject:[pLAppUtils securitytoken].email];
                                                  }else{
                                                      [group.notifyurgent removeObject:[pLAppUtils securitytoken].email];
                                                  }
                                                  
                                                  [self finishsave];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
    
}

-(void)finishsave{
    
    NSString *objectpath = @"groups/";
    NSString *path2 = [[[objectpath stringByAppendingString: group.orgid] stringByAppendingString:@"/"] stringByAppendingString:group.groupid];
    NSString*path;
    
    if(notifyallws.on){
        path = [path2 stringByAppendingString:[@"/addnotifyall/" stringByAppendingString:[pLAppUtils securitytoken].email]];
    }else
    {
        path = [path2 stringByAppendingString:[@"/removenotifyall/" stringByAppendingString:[pLAppUtils securitytoken].email]];
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  if(notifyallws.on){
                                                      [group.notifyall addObject:[pLAppUtils securitytoken].email];
                                                  }else{
                                                      [group.notifyall removeObject:[pLAppUtils securitytoken].email];
                                                  }
                                                  
                                                  
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];

    
    
}

@end
