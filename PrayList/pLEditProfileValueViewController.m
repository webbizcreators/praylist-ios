//
//  pLEditProfileValueViewController.m
//  PrayList
//
//  Created by Peter Opheim on 7/22/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLEditProfileValueViewController.h"

@interface pLEditProfileValueViewController ()

@end

@implementation pLEditProfileValueViewController

@synthesize editvalue;
@synthesize vc;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    editvaluefield.text = editvalue;
    
}

-(IBAction)donebutton:(id)sender{
    
    [vc updatevaluetostring:editvaluefield.text];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
