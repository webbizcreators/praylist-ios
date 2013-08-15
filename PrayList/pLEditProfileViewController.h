//
//  pLEditProfileViewController.h
//  PrayList
//
//  Created by Peter Opheim on 7/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pLEditProfileViewController : UITableViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    
    IBOutlet UIImageView*profilepic;
    IBOutlet UILabel*emailaddress;
    IBOutlet UILabel*fullname;
    IBOutlet UITextView*description;
    IBOutlet UILabel*orgname;
    
}

-(void)updatevaluetostring:(NSString*)value;

@end
