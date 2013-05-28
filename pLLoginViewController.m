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
#import "KeychainItemWrapper.h"

@interface pLLoginViewController ()

@end

@implementation pLLoginViewController

UITextField *activeField;
KeychainItemWrapper *keychainItem;

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
    

     keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"PrayListLogin" accessGroup:nil];
    
    NSString*test = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    if([keychainItem objectForKey:(__bridge id)kSecAttrAccount]){
        [self autologin];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)autologin{
    
    pLLoginRequest *lr = [[pLLoginRequest alloc] init];
    
    lr.email = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    lr.password = [keychainItem objectForKey:(__bridge id)kSecValueData];
    lr.devicetoken = [pLAppUtils devicetoken];
    
    [[RKObjectManager sharedManager] postObject:lr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            pLLoginResponse *lr = (pLLoginResponse*)mappingResult.firstObject;
            
            [pLAppUtils setSecurityToken: lr.securitytoken];
            NSDictionary *headers = [RKObjectManager sharedManager].defaultHeaders;
            [headers setValue:[pLAppUtils securitytoken].tokenId forKey:@"securitytoken"];
            [headers setValue:[pLAppUtils securitytoken].email forKey:@"securityemail"];
            
            [pLAppUtils loadmycontacts];
            [pLAppUtils loadnotifcount];
            [self performSegueWithIdentifier: @"loginMainSegue" sender: self];
            
        }
        
    }
                                        failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                            
                                            [keychainItem resetKeychainItem];
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Login Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            [alert show];
                                            
                                        }];
    
    
    
    
}

-(IBAction)loginbutton:(id)sender
{
    
    pLLoginRequest *lr = [[pLLoginRequest alloc] init];
    
    lr.email = emailfield.text;
    lr.password = passwordfield.text;
    lr.devicetoken = [pLAppUtils devicetoken];
    
    [[RKObjectManager sharedManager] postObject:lr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            pLLoginResponse *lr = (pLLoginResponse*)mappingResult.firstObject;
            
            [pLAppUtils setSecurityToken: lr.securitytoken];
            NSDictionary *headers = [RKObjectManager sharedManager].defaultHeaders;
            [headers setValue:[pLAppUtils securitytoken].tokenId forKey:@"securitytoken"];
            [headers setValue:[pLAppUtils securitytoken].email forKey:@"securityemail"];
            
            if(autologinsw.on){
                [keychainItem setObject:passwordfield.text forKey:(__bridge id)kSecValueData];
                [keychainItem setObject:emailfield.text forKey:(__bridge id)kSecAttrAccount];
            }
            
            [pLAppUtils loadmycontacts];
            [pLAppUtils loadnotifcount];
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
