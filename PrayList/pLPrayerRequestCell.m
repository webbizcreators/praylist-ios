//
//  pLPrayerRequestCell.m
//  PrayList
//
//  Created by Peter Opheim on 2/9/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPrayerRequestCell.h"

@implementation pLPrayerRequestCell

@synthesize requestdate;
@synthesize requesttitle;
@synthesize requesttext;
@synthesize img;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

          
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
