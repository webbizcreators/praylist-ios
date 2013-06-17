//
//  pLSecondViewController.h
//  PrayList
//
//  Created by Peter Opheim on 11/14/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "EGORefreshTableHeaderView.h"

@interface pLSecondViewController : UIViewController <UITableViewDelegate>{
    
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
