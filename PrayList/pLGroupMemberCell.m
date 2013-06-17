//
//  pLGroupMemberCell.m
//  PrayList
//
//  Created by Peter Opheim on 5/9/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLGroupMemberCell.h"
#import "pLAppUtils.h"

@implementation pLGroupMemberCell
@synthesize email;

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


-(IBAction)removeButton:(id)sender{
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMember"
                                                        object:self
                                                      userInfo:nil];
}


-(IBAction)cancelinviteButton:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelInvite"
                                                        object:self
                                                      userInfo:nil];
}

-(IBAction)acceptButton:(id)sender{
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"acceptMember"
                                                        object:self
                                                      userInfo:nil];
    
}

-(IBAction)declineButton:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"declineMember"
                                                        object:self
                                                      userInfo:nil];
    
}

@end
