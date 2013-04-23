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
@property (nonatomic, retain) NSArray* circlenames;
@property (nonatomic, retain) NSNumber* praycount;

@end
