//
//  pLNotification.h
//  PrayList
//
//  Created by Peter Opheim on 5/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pLNotification : NSObject

@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSDate* notificationdate;
@property (nonatomic, retain) NSString* notiftext;
@property (nonatomic, retain) NSString* entityid;
@property (nonatomic, retain) NSString* requestoremail;
@property (nonatomic, retain) NSNumber* openedflag;
@property (nonatomic, retain) NSString* fromemail;
@property (nonatomic, retain) NSString* notiftype;

@end
