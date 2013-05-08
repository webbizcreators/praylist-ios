//
//  pLGroupCell.h
//  PrayList
//
//  Created by Peter Opheim on 5/7/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pLGroupCell : UITableViewCell



@property (nonatomic, retain) IBOutlet UILabel *groupname;
@property (nonatomic, retain) IBOutlet UILabel *groupdesc;
@property (nonatomic, retain) IBOutlet UILabel *membercount;
@property (nonatomic, retain) IBOutlet UIImageView *img;

@end
