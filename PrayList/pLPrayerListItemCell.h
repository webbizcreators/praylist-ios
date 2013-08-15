//
//  pLPrayerListItemCell.h
//  PrayList
//
//  Created by Peter Opheim on 11/16/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "pLSecondViewController.h"
#import "pLPrayerRequestListItem.h"

@interface pLPrayerListItemCell : UITableViewCell{
    
    
    UILabel *requesttitle;
    UILabel *requesttext;
    UILabel *requestdate;
    UIImageView *img;
    UIButton*praybutton;
    IBOutlet UIButton*editbutton;
    
}

@property (nonatomic, retain) IBOutlet UILabel *requesttitle;
@property (nonatomic, retain) IBOutlet UILabel *requesttext;
@property (nonatomic, retain) IBOutlet UILabel *requestdate;
@property (nonatomic, retain) IBOutlet UILabel *groupnames;
@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (nonatomic, retain) IBOutlet UIButton *praybutton;
@property (nonatomic, retain) IBOutlet UIButton *planbutton;
@property (nonatomic, retain) IBOutlet UIButton *commentbutton;
@property (nonatomic, retain) IBOutlet UILabel *requeststats;
@property (nonatomic, retain) NSString *requestoremail;
@property (nonatomic, retain) NSString *requestid;
@property (nonatomic, retain) pLPrayerRequestListItem* listitem;

- (void) configureView:(pLPrayerRequestListItem*)li inTableViewController:(pLSecondViewController*)_tvc;


@end
