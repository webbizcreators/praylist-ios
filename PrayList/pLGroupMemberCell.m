//
//  pLGroupMemberCell.m
//  PrayList
//
//  Created by Peter Opheim on 5/9/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLGroupMemberCell.h"

@implementation pLGroupMemberCell

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

-(IBAction)actionbutton:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MemberApprove"
                                                        object:self
                                                      userInfo:nil];
    
}

@end
