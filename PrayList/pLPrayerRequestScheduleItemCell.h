//
//  pLPrayerRequestScheduleItemCell.h
//  PrayList
//
//  Created by Peter Opheim on 7/11/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "pLPrayerPlannerViewController.h"
#import "pLPrayerRequestListItem.h"

@interface pLPrayerRequestScheduleItemCell : UITableViewCell{
    
    
    UILabel *requesttitle;
    UILabel *requesttext;
    UILabel *requestdate;
    UIImageView *img;
    UIButton*praybutton;
    
}

@property (nonatomic, retain) IBOutlet UILabel *requesttitle;
@property (nonatomic, retain) IBOutlet UILabel *requesttext;
@property (nonatomic, retain) IBOutlet UILabel *requestdate;
@property (nonatomic, retain) IBOutlet UILabel *groupnames;
@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (nonatomic, retain) IBOutlet UIButton *praybutton;
@property (nonatomic, retain) IBOutlet UIButton *commentbutton;
@property (nonatomic, retain) IBOutlet UILabel *requeststats;
@property (nonatomic, retain) NSString *requestoremail;
@property (nonatomic, retain) NSString *requestid;
@property (nonatomic, retain) pLPrayerRequestListItem* listitem;

- (void) configureView:(pLPrayerRequestListItem*)li inTableViewController:(pLPrayerPlannerViewController*)_tvc;


@end
