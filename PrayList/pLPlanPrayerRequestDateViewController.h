//
//  pLPlanPrayerRequestDateViewController.h
//  PrayList
//
//  Created by Peter Opheim on 8/6/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPlanPrayerRequestViewController.h"
#import "TimesSquare/TimesSquare.h"
#import <UIKit/UIKit.h>

@interface pLPlanPrayerRequestDateViewController : UIViewController<TSQCalendarViewDelegate>

@property(nonatomic,retain)NSString*mode;
@property(nonatomic,retain)NSDate*selecteddate;
@property(nonatomic,retain)pLPlanPrayerRequestViewController*openingcontroller;

@end
