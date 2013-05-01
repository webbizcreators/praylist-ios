//
//  pLFirstViewController.h
//  PrayList
//
//  Created by Peter Opheim on 11/14/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "EGORefreshTableHeaderView.h"

@interface pLFirstViewController : UIViewController <UITableViewDelegate>{
    
    IBOutlet UITableView *vartableView;
    IBOutlet UIBarButtonItem *addbutton;
    
    EGORefreshTableHeaderView *refreshHeaderView;
    
	BOOL checkForRefresh;
	BOOL reloading;
    
}

@property (nonatomic, strong) NSOperationQueue *imageDownloadingQueue;

- (void)dataSourceDidFinishLoadingNewData;
- (void) showReloadAnimationAnimated:(BOOL)animated;

@end
