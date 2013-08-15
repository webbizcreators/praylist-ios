//
//  pLPrayerRequest.m
//  PrayList
//
//  Created by Peter Opheim on 2/9/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPrayerRequest.h"
#import "pLAppUtils.h"

@implementation pLPrayerRequest

@synthesize requestdate;
@synthesize requestid;
@synthesize requestoremail;
@synthesize requesttext;
@synthesize requestdatetimeago;
@synthesize groupids;
@synthesize praycount;
@synthesize orgid;
@synthesize peopleprayed;
@synthesize answer;
@synthesize commentcount;
@synthesize startplanon;
@synthesize iprayed;
@synthesize prayinterval;
@synthesize senttoemails;

-(NSDate *) requestdate
{
    return requestdate;
}

- (void) setrequestdate: (NSDate *) pt
{
    requestdate = pt;
    requestdatetimeago = [pLAppUtils formatPostDate:requestdate];
}

@end
