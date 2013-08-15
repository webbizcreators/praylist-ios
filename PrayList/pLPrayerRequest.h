//
//  pLPrayerRequest.h
//  PrayList
//
//  Created by Peter Opheim on 2/9/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pLPrayerRequest : NSObject

@property (nonatomic, retain) NSDate* requestdate;
@property (nonatomic, retain) NSString* requestid;
@property (nonatomic, retain) NSString* requestoremail;
@property (nonatomic, retain) NSString* requesttext;
@property (nonatomic, retain) NSString* requestdatetimeago;
@property (nonatomic, retain) NSArray* groupids;
@property (nonatomic, retain) NSNumber* praycount;
@property (nonatomic, retain) NSString* orgid;
@property (nonatomic, retain) NSArray* peopleprayed;
@property (nonatomic, retain) NSString* answer;
@property (nonatomic, retain) NSNumber* commentcount;
@property (nonatomic, retain) NSDate* startplanon;
@property (nonatomic, retain) NSNumber* prayinterval;
@property (nonatomic, retain) NSNumber* iprayed;
@property (nonatomic, retain) NSMutableArray* senttoemails;

@end
