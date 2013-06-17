//
//  pLGroupMemberCell.h
//  PrayList
//
//  Created by Peter Opheim on 5/9/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pLGroupMemberCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UILabel *username;
@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (nonatomic, retain) NSString*email;
@property (nonatomic, retain) IBOutlet UIButton*removebutton;

@end
