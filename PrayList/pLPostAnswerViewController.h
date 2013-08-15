//
//  pLPostAnswerViewController.h
//  PrayList
//
//  Created by Peter Opheim on 6/19/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pLPrayerRequestListItem.h"

@interface pLPostAnswerViewController : UIViewController{

IBOutlet UITextView *answertext;
    IBOutlet UIImageView *userImage;
}
@property (nonatomic, retain) pLPrayerRequestListItem *prayerrequestlistitem;

@end
