//
//  pLDrawerController.m
//  PrayList
//
//  Created by Peter Opheim on 6/17/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLDrawerController.h"

@interface pLDrawerController ()

@end

@implementation pLDrawerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"requestFeed"];
    self.shouldAddPanGestureRecognizerToTopViewSnapshot = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
