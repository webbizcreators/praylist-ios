//
//  pLSelectCircleforPostViewController.h
//  PrayList
//
//  Created by Peter Opheim on 2/26/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface pLSelectCircleforPostViewController : UIViewController<UITableViewDelegate>{

    IBOutlet UITableView *tableView;
    IBOutlet UIBarButtonItem *doneButton;
    IBOutlet UIBarButtonItem *cancelButton;
    
}

@property (nonatomic, retain) NSMutableArray *destcircleArray;
@property (nonatomic, retain) NSMutableArray *sourcecircles;

@end
