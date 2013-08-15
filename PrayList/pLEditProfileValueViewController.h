//
//  pLEditProfileValueViewController.h
//  PrayList
//
//  Created by Peter Opheim on 7/22/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pLEditProfileViewController.h"

@interface pLEditProfileValueViewController : UITableViewController{
    
    IBOutlet UITextField*editvaluefield;
    
}

@property (nonatomic,retain) NSString*editvalue;
@property (nonatomic,retain) pLEditProfileViewController*vc;

@end
