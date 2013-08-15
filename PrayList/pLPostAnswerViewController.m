//
//  pLPostAnswerViewController.m
//  PrayList
//
//  Created by Peter Opheim on 6/19/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPostAnswerViewController.h"
#import "pLAppUtils.h"

@interface pLPostAnswerViewController ()

@end

@implementation pLPostAnswerViewController

@synthesize prayerrequestlistitem;

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
	UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background_iPhone5"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    answertext.text = prayerrequestlistitem.answer;
    userImage.image = [pLAppUtils userimgFromEmail: [pLAppUtils securitytoken].email];

}


-(IBAction)cancelbutton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(IBAction)postbutton:(id)sender{
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Posting Answer"];
    
    NSString*path = [@"prayerrequests/answer/" stringByAppendingString:[[pLAppUtils securitytoken].email stringByAppendingString:[@"/" stringByAppendingString:prayerrequestlistitem.requestid]]];
    
    prayerrequestlistitem.answer = answertext.text;
    
    [[RKObjectManager sharedManager] postObject:prayerrequestlistitem path: path parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
            
            [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostAnswerControllerDismissed"
                                                                object:nil
                                                              userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
        
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

@end
