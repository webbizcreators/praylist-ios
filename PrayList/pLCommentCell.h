//
//  pLCommentCell.h
//  PrayList
//
//  Created by Peter Opheim on 4/23/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pLCommentCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UILabel *commenttitle;
@property (nonatomic, retain) IBOutlet UILabel *commenttext;
@property (nonatomic, retain) IBOutlet UILabel *commentdate;
@property (nonatomic, retain) IBOutlet UIImageView *img;

@end
