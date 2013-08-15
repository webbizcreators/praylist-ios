//
//  pLPlanPrayerRequestViewController.m
//  PrayList
//
//  Created by Peter Opheim on 6/20/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPlanPrayerRequestViewController.h"
#import "pLAppUtils.h"
#import "pLPlanPrayerRequestDateViewController.h"

@interface pLPlanPrayerRequestViewController ()

@end

@implementation pLPlanPrayerRequestViewController

@synthesize prayerrequestlistitem;
@synthesize isedit;

NSDate*startingondate;
NSDate*endingondate;
NSNumber*prayinterval;
NSString*startingondatestr;
NSString*endingondatestr;


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

    startingondate = [NSDate date];
    endingondate = [[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 90];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    startingon.text = [dateFormat stringFromDate:startingondate];
    endingon.text = [dateFormat stringFromDate:endingondate];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    startingondatestr = [dateFormat2 stringFromDate:startingondate];
    endingondatestr = [dateFormat2 stringFromDate:endingondate];
    
    if(isedit){
        [dateresetcell setHidden:NO];
        [deleteitemcell setHidden:NO];
    }
    
}

-(IBAction)donebutton:(id)sender{
    [self scheduleprayer];
}


-(void)scheduleprayer
{
 
    [pLAppUtils showActivityIndicatorWithMessage:@"Adding to Schedule"];
    
    NSString *objectpath = @"schedule/";
    NSString *path = [objectpath stringByAppendingString: [[pLAppUtils securitytoken].email stringByAppendingString:[@"/" stringByAppendingString:[prayerrequestlistitem.requestid stringByAppendingString:[@"/" stringByAppendingString:[startingondatestr stringByAppendingString:[@"/" stringByAppendingString:[endingondatestr stringByAppendingString:[@"/" stringByAppendingString:[prayinterval stringValue]]]]]]]]]];
    
    if(isedit){
        if(resetdatesw.on){
        path = [path stringByAppendingString:@"/YES"];
            }
        else{
           path = [path stringByAppendingString:@"/NO"]; 
        }
                
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"PrayerRequestRescheduleDismissed"
                                                                                                      object:nil
                                                                                                    userInfo:nil];
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  
                                                  
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
}


-(void)deleterequest{
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Do you want to delete the schedule for this prayer request?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil, nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    
    [popupQuery showInView:self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        [self unscheduleprayer];
    }else if (buttonIndex==1){
        
    }
    
}


-(void)unscheduleprayer{
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Removing from Schedule"];
    
    NSString *objectpath = @"schedule/";
    NSString *path = [objectpath stringByAppendingString: [[pLAppUtils securitytoken].email stringByAppendingString:[@"/" stringByAppendingString:prayerrequestlistitem.requestid]]];
    

    
    [[RKObjectManager sharedManager]  deleteObject:nil path: path parameters: nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"PrayerRequestRescheduleDismissed"
                                                                                                      object:nil
                                                                                                    userInfo:nil];
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  
                                                  
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"selectscheduledate"])
    {
        pLPlanPrayerRequestDateViewController *vc = [segue destinationViewController];
        vc.selecteddate = startingondate;
        vc.openingcontroller = self;
        vc.mode = @"start";
    }else if  ([[segue identifier] isEqualToString:@"selectscheduleenddate"]){
        pLPlanPrayerRequestDateViewController *vc = [segue destinationViewController];
        vc.selecteddate = endingondate;
        vc.openingcontroller = self;
        vc.mode = @"end";
    }
}

-(void)setStartingDate:(NSDate*)date{
    
    startingondate=date;
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    startingondatestr = [dateFormat2 stringFromDate:startingondate];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    startingon.text = [dateFormat stringFromDate:startingondate];
}

-(void)setEndingDate:(NSDate*)date{
    
    endingondate=date;
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    endingondatestr = [dateFormat2 stringFromDate:endingondate];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    endingon.text = [dateFormat stringFromDate:endingondate];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0){
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
        if(indexPath.row==0)prayinterval=[NSNumber numberWithInt:1];
        if(indexPath.row==1)prayinterval=[NSNumber numberWithInt:2];
        if(indexPath.row==2)prayinterval=[NSNumber numberWithInt:4];
        if(indexPath.row==3)prayinterval=[NSNumber numberWithInt:7];
    }
    else if (indexPath.section==4){
        [self deleterequest];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
}

@end
