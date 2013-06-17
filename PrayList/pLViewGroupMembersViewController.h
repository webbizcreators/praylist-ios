//
//  pLViewGroupMembersViewController.h
//  PrayList
//
//  Created by Peter Opheim on 6/5/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pLGroup.h"

@interface pLViewGroupMembersViewController : UITableViewController

@property (nonatomic, retain) pLGroup *group;
@property (nonatomic, retain) NSString*mode;


@end
