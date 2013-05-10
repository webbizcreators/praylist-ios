//
//  pLEditGroupViewController.h
//  PrayList
//
//  Created by Peter Opheim on 3/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pLGroup.h"

@interface pLEditGroupViewController : UIViewController<UITableViewDelegate>{
    
    IBOutlet UITextField* groupname;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIBarButtonItem *cancelButton;
    IBOutlet UITableView * groupmembertableView;
    IBOutlet UIView *generalsubview;
    IBOutlet UIImageView *grouptypeicon;
    IBOutlet UILabel *grouptypedescription;
    
}

@property (nonatomic, retain) pLGroup *group;

@end
