//
//  pLCircleListViewController.h
//  PrayList
//
//  Created by Peter Opheim on 3/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pLGroupListViewController : UIViewController<UITableViewDelegate>{
    
    IBOutlet UITableView *tableView;
    IBOutlet UISegmentedControl *typeselect;
    IBOutlet UIView *buttonview;
    IBOutlet UIButton *addprivategroupbtn;
    IBOutlet UIButton *addpublicgroupbtn;
    
}


@end
