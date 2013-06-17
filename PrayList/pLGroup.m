//
//  pLGroup.m
//  PrayList
//
//  Created by Peter Opheim on 2/26/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLGroup.h"

@implementation pLGroup

@synthesize owneremail;
@synthesize groupname;
@synthesize groupmembers;
@synthesize grouptype;
@synthesize orgid;
@synthesize groupid;
@synthesize invitees;
@synthesize requestors;
@synthesize groupdescription;


-(NSMutableArray*)getgroupmembers{
    return [NSMutableArray arrayWithArray:groupmembers];
}
-(void)setgroupmembers:(NSArray *)value {
    groupmembers = [NSMutableArray arrayWithArray:value];
}

-(NSMutableArray*)getinvitees{
    return [NSMutableArray arrayWithArray:invitees];
}
-(void)setinvitees:(NSArray *)value {
    invitees = [NSMutableArray arrayWithArray:value];
}


-(NSMutableArray*)getrequestors{
    return [NSMutableArray arrayWithArray:requestors];
}
-(void)setrequestors:(NSArray *)value {
    requestors = [NSMutableArray arrayWithArray:value];
}

@end
