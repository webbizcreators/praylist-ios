//
//  pLGroupNotifSettingsViewController.h
//  PrayList
//
//  Created by Peter Opheim on 7/24/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pLGroup.h"

@interface pLGroupNotifSettingsViewController : UITableViewController{

    IBOutlet UISwitch*notifyurgentsw;
    IBOutlet UISwitch*notifyallws;
    
}

@property (nonatomic,retain) pLGroup*group;

@end
