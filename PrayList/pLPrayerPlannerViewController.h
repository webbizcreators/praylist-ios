//
//  pLPrayerPlannerViewController.h
//  PrayList
//
//  Created by Peter Opheim on 6/17/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface pLPrayerPlannerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    IBOutlet UITableView*listtableView;
    IBOutlet UITableView*calendartableView;
    IBOutlet UILabel*topdatelabel;
    
}

-(void)opencommentsfromsender:(id)sender;
-(void)planrequestfromsender:(id)sender;
-(void)deleterequestfromsender:(id)sender;

@end
