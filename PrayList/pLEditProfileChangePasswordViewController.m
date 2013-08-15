//
//  pLEditProfileChangePasswordViewController.m
//  PrayList
//
//  Created by Peter Opheim on 7/23/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLEditProfileChangePasswordViewController.h"
#import "pLAppUtils.h"
#import "pLPasswordUpdateRequest.h"
#import "pLResponse.h"

@interface pLEditProfileChangePasswordViewController ()

@end

@implementation pLEditProfileChangePasswordViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(IBAction)savebutton:(id)sender{
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Changing Password"];
    pLPasswordUpdateRequest*pur = [[pLPasswordUpdateRequest alloc]init];
    
    pur.email = [pLAppUtils securitytoken].email;
    pur.oldpassword = oldpassword.text;
    pur.newpassword = newpassword.text;
    
    [[RKObjectManager sharedManager] postObject:pur path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        pLResponse*r = mappingResult.firstObject;
        
        if([r.status isEqualToString:@"Success"]){
            [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [pLAppUtils hideActivityIndicator];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:r.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
        }
        
        
        
    }
                                        failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                            [pLAppUtils showActivityIndicatorWithMessage:@"Failed"];
                                            
                                        }];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
