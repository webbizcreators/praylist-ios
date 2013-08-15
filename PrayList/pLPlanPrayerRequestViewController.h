//
//  pLPlanPrayerRequestViewController.h
//  PrayList
//
//  Created by Peter Opheim on 6/20/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pLPrayerRequestListItem.h"

@interface pLPlanPrayerRequestViewController : UITableViewController{
    
    IBOutlet UILabel*startingon;
    IBOutlet UILabel*endingon;
    IBOutlet UITableViewCell*dateresetcell;
    IBOutlet UITableViewCell*deleteitemcell;
    IBOutlet UISwitch*resetdatesw;
}


@property (nonatomic, retain) pLPrayerRequestListItem *prayerrequestlistitem;
@property (nonatomic)BOOL isedit;

-(void)setStartingDate:(NSDate*)date;
-(void)setEndingDate:(NSDate*)date;

@end
