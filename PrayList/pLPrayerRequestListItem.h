//
//  pLPrayerRequestListItem.h
//  PrayList
//
//  Created by Peter Opheim on 11/15/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pLPrayerRequestListItem : NSObject

@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSDate* requestdate;
@property (nonatomic, retain) NSString* requestid;
@property (nonatomic, retain) NSString* requestoremail;
@property (nonatomic, retain) NSString* requesttext;
@property (nonatomic, retain) NSString* requestdatetimeago;
@property (nonatomic, retain) NSMutableArray* groupids;
@property (nonatomic, retain) NSNumber* praycount;
@property (nonatomic, retain) NSString* orgid;
@property (nonatomic, retain) NSMutableArray* peopleprayed;
@property (nonatomic, retain) NSMutableArray* senttoemails;
@property (nonatomic, retain) NSString* answer;
@property (nonatomic, retain) NSNumber* commentcount;
@property (nonatomic, retain) NSDate* startplanon;
@property (nonatomic, retain) NSNumber* prayinterval;
@property (nonatomic, retain) NSNumber* iprayed;
@property (nonatomic, retain) NSString* scheduleddate;
@property (nonatomic, retain) NSDate* lastupdateddate;
@property (nonatomic, retain) NSString* requesttype;
@property (nonatomic, retain) NSNumber* totalpraycount;
@property (nonatomic, retain) NSString* scheduleitemid;

@end
