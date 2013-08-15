//
//  pLScheduleDateCell.h
//  PrayList
//
//  Created by Peter Opheim on 7/15/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pLScheduleDateCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *dayofweek;
@property (nonatomic, retain) IBOutlet UILabel *monthday;
@property (nonatomic, retain) IBOutlet UIView *qtybar;

@end
