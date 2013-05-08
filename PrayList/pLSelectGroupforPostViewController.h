//
//  pLSelectCircleforPostViewController.h
//  PrayList
//
//  Created by Peter Opheim on 2/26/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface pLSelectGroupforPostViewController : UIViewController<UITableViewDelegate>{

    IBOutlet UITableView *tableView;
    IBOutlet UIBarButtonItem *doneButton;
    IBOutlet UIBarButtonItem *cancelButton;
    
}

@property (nonatomic, retain) NSMutableArray *destgroupArray;
@property (nonatomic, retain) NSMutableArray *sourcegroups;

@end
