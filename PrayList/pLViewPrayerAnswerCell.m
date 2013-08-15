//
//  pLViewPrayerAnswerCell.m
//  PrayList
//
//  Created by Peter Opheim on 6/18/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLViewPrayerAnswerCell.h"

@implementation pLViewPrayerAnswerCell

@synthesize answertext;

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
