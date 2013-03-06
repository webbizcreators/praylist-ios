//
//  pLLoginViewController.h
//  PrayList
//
//  Created by Peter Opheim on 1/30/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface pLLoginViewController : UIViewController {
    IBOutlet UIButton *loginbutton;
    IBOutlet UIImageView *logo;
    IBOutlet UITextField *emailfield;
    IBOutlet UITextField *passwordfield;
    IBOutlet UIScrollView *scrollView;
    
}

@end
