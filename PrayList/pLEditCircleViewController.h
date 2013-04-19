//
//  pLEditCircleViewController.h
//  PrayList
//
//  Created by Peter Opheim on 3/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pLCircle.h"

@interface pLEditCircleViewController : UIViewController<UITableViewDelegate>{
    
    IBOutlet UILabel * circlename;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIBarButtonItem *cancelButton;
    IBOutlet UITableView * tableView;
    
}

@property (nonatomic, retain) pLCircle *circle;

@end
