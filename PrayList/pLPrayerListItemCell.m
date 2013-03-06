//
//  pLPrayerListItemCell.m
//  PrayList
//
//  Created by Peter Opheim on 11/16/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//

#import "pLPrayerListItemCell.h"

@implementation pLPrayerListItemCell

@synthesize requestdate;
@synthesize requesttitle;
@synthesize requesttext;
@synthesize img;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
