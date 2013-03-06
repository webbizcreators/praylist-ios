//
//  pLPrayerRequestCell.h
//  PrayList
//
//  Created by Peter Opheim on 2/9/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface pLPrayerRequestCell : UITableViewCell{
    
    
    UILabel *requesttitle;
    UILabel *requesttext;
    UILabel *requestdate;
    UIImageView *img;
    UIView * mainview;
    
}

@property (nonatomic, retain) IBOutlet UILabel *requesttitle;
@property (nonatomic, retain) IBOutlet UILabel *requesttext;
@property (nonatomic, retain) IBOutlet UILabel *requestdate;
@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (nonatomic, retain) IBOutlet UIView * mainview;

@end
