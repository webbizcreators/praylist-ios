//
//  pLPlanPrayerRequestDateViewController.m
//  PrayList
//
//  Created by Peter Opheim on 8/6/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPlanPrayerRequestDateViewController.h"
#import "TimesSquare/TimesSquare.h"
#import "TSQTACalendarRowCell.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface pLPlanPrayerRequestDateViewController ()

@end

@implementation pLPlanPrayerRequestDateViewController

@synthesize selecteddate;
@synthesize openingcontroller;
@synthesize mode;

TSQCalendarView*calendarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGRect frame = self.view.bounds;
    calendarView = [[TSQCalendarView alloc] initWithFrame:frame];
    calendarView.rowCellClass = [TSQTACalendarRowCell class];
    calendarView.firstDate = [NSDate date];
    calendarView.lastDate = [[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 279.5]; // approximately 279.5 days in the future
    calendarView.pagingEnabled = YES;
    calendarView.delegate = self;
    calendarView.selectedDate = selecteddate;
    [self.view addSubview:calendarView];
    
}

-(IBAction)doneButton:(id)sender{
    if([mode isEqualToString:@"start"]){
    [openingcontroller setStartingDate:calendarView.selectedDate];
    }
    else if([mode isEqualToString:@"end"]){
        [openingcontroller setEndingDate:calendarView.selectedDate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
