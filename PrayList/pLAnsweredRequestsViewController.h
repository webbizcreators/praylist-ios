//
//  pLAnsweredRequestsViewController.h
//  PrayList
//
//  Created by Peter Opheim on 7/20/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "EGORefreshTableHeaderView.h"

@interface pLAnsweredRequestsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *notifbutton;
    EGORefreshTableHeaderView *refreshHeaderView;
    
	BOOL checkForRefresh;
	BOOL reloading;
    
}

- (void)dataSourceDidFinishLoadingNewData;
- (void) showReloadAnimationAnimated:(BOOL)animated;
-(void)opencommentsfromsender:(id)sender;

@end
