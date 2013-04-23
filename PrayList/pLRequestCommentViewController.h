//
//  pLRequestCommentViewController.h
//  PrayList
//
//  Created by Peter Opheim on 4/22/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "pLPrayerRequest.h"
#import "pLPrayerRequestListItem.h"

@interface pLRequestCommentViewController : UIViewController <UITableViewDelegate>{
    
    IBOutlet UITableView *tableView;
    IBOutlet UIBarButtonItem *backbutton;
    IBOutlet UIBarButtonItem *postcommentbutton;
    
    IBOutlet UITextField *commentfield;
    
    IBOutlet UILabel *requesttitle;
    IBOutlet UILabel *requesttext;
    IBOutlet UILabel *requestdate;
    IBOutlet UIImageView *img;
    
}

@property (nonatomic, strong) pLPrayerRequest *prayerrequest;
@property (nonatomic, strong) pLPrayerRequestListItem *prayerrequestlistitem;

@end
