//
//  pLStyleView.m
//  PrayList
//
//  Created by Peter Opheim on 6/11/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLStyleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation pLStyleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // border radius
        [self.layer setCornerRadius:4.0f];

        // border
        //[self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        //[self.layer setBorderWidth:0.5f];
        
        // drop shadow
        //[self.layer setShadowColor:[UIColor blackColor].CGColor];
        //[self.layer setShadowOpacity:0.5];
        //[self.layer setShadowRadius:1.0];
        //[self.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
        
    }
    
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
