//
//  pLEditGroupViewController.h
//  PrayList
//
//  Created by Peter Opheim on 3/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pLGroup.h"

@interface pLEditGroupViewController : UITableViewController<UIActionSheetDelegate>{
    
    IBOutlet UILabel* groupname;
    IBOutlet UITextView *groupdescription;
    IBOutlet UIImageView *grouptypeicon;
    IBOutlet UILabel*grouptypelabel;
    
    IBOutlet UILabel*membercountlabel;
    IBOutlet UILabel*inviteecountlabel;
    IBOutlet UILabel*requestorcountlabel;
    IBOutlet UIButton*actionbutton;
    
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIBarButtonItem *cancelButton;
    
    IBOutlet UIButton*deletebutton;
    
    IBOutlet UITableViewCell *membercell;
    IBOutlet UITableViewCell *inviteecell;
    IBOutlet UITableViewCell *requestorcell;
    
    
}

@property (nonatomic, retain) pLGroup *group;

@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray *groupmemberimages;
@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray *groupinviteesimages;
@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray *grouprequestorsimages;

@end
