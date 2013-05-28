//
//  pLNotificationCell.h
//  PrayList
//
//  Created by Peter Opheim on 5/22/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pLNotificationCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UILabel *notificationtext;
@property (nonatomic, retain) IBOutlet UILabel *notificationdate;
@property (nonatomic, retain) IBOutlet UIImageView *img;

@end
