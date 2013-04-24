//
//  pLCommentCell.m
//  PrayList
//
//  Created by Peter Opheim on 4/23/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLCommentCell.h"

@implementation pLCommentCell

@synthesize commentdate;
@synthesize commenttext;
@synthesize commenttitle;
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
