//
//  pLViewPrayerButtonCell.h
//  PrayList
//
//  Created by Peter Opheim on 6/7/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "pLPrayerRequestListItem.h"
#import "pLViewRequestViewController.h"

@interface pLViewPrayerButtonCell : UITableViewCell{
    
}

@property (nonatomic, retain) pLViewRequestViewController*vc;
@property (nonatomic, retain) pLPrayerRequestListItem *listitem;
@property (nonatomic, retain) IBOutlet UIButton *praybutton;
@property (nonatomic, retain) IBOutlet UIButton *commentbutton;

@end
