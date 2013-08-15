//
//  pLViewRequestViewController.h
//  PrayList
//
//  Created by Peter Opheim on 6/6/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "pLPrayerRequest.h"
#import "pLPrayerRequestListItem.h"

@interface pLViewRequestViewController : UIViewController<UITableViewDelegate>{
    
    IBOutlet UIBarButtonItem *backbutton;
    IBOutlet UIBarButtonItem *postcommentbutton;
    IBOutlet UITableView *tableView;
    
    IBOutlet UIView *listview;
    
}

@property (nonatomic, retain) IBOutlet UITextField *commentfield;
@property (nonatomic, strong) pLPrayerRequest *prayerrequest;
@property (nonatomic, strong) pLPrayerRequestListItem *prayerrequestlistitem;

@end
