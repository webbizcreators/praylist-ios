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
@property (nonatomic, retain) NSString* requestid;
@property (nonatomic, retain) NSString* requestoremail;
@property (nonatomic, retain) NSString* requesttext;
@property (nonatomic, retain) NSDate* requestdate;

@property (nonatomic, retain) NSNumber* praycount;
@property (nonatomic, retain) NSNumber* iprayed;

@end
