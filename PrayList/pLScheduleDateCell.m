//
//  pLScheduleDateCell.m
//  PrayList
//
//  Created by Peter Opheim on 7/15/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLScheduleDateCell.h"

@implementation pLScheduleDateCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
