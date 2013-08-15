//
//  pLPrayerRequestCell.h
//  PrayList
//
//  Created by Peter Opheim on 2/9/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "pLPrayerRequest.h"
#import "pLFirstViewController.h"

@interface pLPrayerRequestCell : UITableViewCell{
    
    UILabel *requesttitle;
    UILabel *requesttext;
    UILabel *requeststats;
    UILabel *requestdate;
    UIImageView *img;
    UIView * mainview;
}

@property (nonatomic, retain) IBOutlet UILabel *requesttitle;
@property (nonatomic, retain) IBOutlet UILabel *requesttext;
@property (nonatomic, retain) IBOutlet UILabel *requeststats;
@property (nonatomic, retain) IBOutlet UILabel *groupnames;
@property (nonatomic, retain) IBOutlet UILabel *requestdate;
@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (nonatomic, retain) IBOutlet UIView * mainview;
@property (nonatomic, retain) pLPrayerRequest* listitem;
@property (nonatomic, retain) NSString *requestoremail;
@property (nonatomic, retain) NSString *requestid;
@property (nonatomic, retain) IBOutlet UIButton *praybutton;

- (void) configureView:(pLPrayerRequest*)li inTableViewController:(pLFirstViewController*)_tvc;

@end
