//
//  pLLoginViewController.m
//  PrayList
//
//  Created by Peter Opheim on 1/30/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLLoginViewController.h"
#import "pLLoginRequest.h"
#import "pLSecurityToken.h"
#import "pLAppUtils.h"
#import "pLLoginResponse.h"

@interface pLLoginViewController ()

@end

@implementation pLLoginViewController

UITextField *activeField;

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
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    

    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginbutton:(id)sender
{
    
    pLLoginRequest *lr = [[pLLoginRequest alloc] init];
    
    lr.email = emailfield.text;
    lr.password = passwordfield.text;
    
    [[RKObjectManager sharedManager] postObject:lr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            pLLoginResponse *lr = (pLLoginResponse*)mappingResult.firstObject;
            
            [pLAppUtils setSecurityToken: lr.securitytoken];
            NSDictionary *headers = [RKObjectManager sharedManager].defaultHeaders;
            [headers setValue:[pLAppUtils securitytoken].tokenId forKey:@"securitytoken"];
            [headers setValue:[pLAppUtils securitytoken].email forKey:@"securityemail"];
            
            [pLAppUtils loadmycontacts];
            [self performSegueWithIdentifier: @"loginMainSegue" sender: self];
            
        }
        
    }
    failure:^( RKObjectRequestOperation *operation , NSError *error ){
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }];
    
    
        
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}



@end
