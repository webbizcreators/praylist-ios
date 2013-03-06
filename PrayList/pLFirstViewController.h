//
//  pLFirstViewController.h
//  PrayList
//
//  Created by Peter Opheim on 11/14/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface pLFirstViewController : UIViewController <UITableViewDelegate>{
    
    IBOutlet UITableView *tableView;
    IBOutlet UIBarButtonItem *addbutton;
    IBOutlet UIBarButtonItem *refreshbutton;
    
}

@property (nonatomic, strong) NSOperationQueue *imageDownloadingQueue;

@end
