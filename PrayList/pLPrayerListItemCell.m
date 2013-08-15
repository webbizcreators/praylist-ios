//
//  pLPrayerListItemCell.m
//  PrayList
//
//  Created by Peter Opheim on 11/16/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//

#import "pLPrayerListItemCell.h"
#import "pLResponse.h"
#import "pLAppUtils.h"

@implementation pLPrayerListItemCell

@synthesize requestdate;
@synthesize requesttitle;
@synthesize requesttext;
@synthesize img;
@synthesize requestoremail;
@synthesize requestid;
@synthesize praybutton;
@synthesize listitem;
@synthesize requeststats;
@synthesize groupnames;

pLSecondViewController*tvc2;


- (void) configureView:(pLPrayerRequestListItem*)li inTableViewController:(pLSecondViewController*)_tvc;
{
    tvc2 = _tvc;
    listitem = li;
    
    editbutton.hidden=YES;
    if([li.email isEqualToString:li.requestoremail]){
       editbutton.hidden=NO;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)opencomments:(UIButton *)sender {
    [tvc2 opencommentsfromsender:self];
}

- (IBAction)planrequest:(UIButton *)sender {
    [tvc2 planrequestfromsender:self];
}

-(IBAction)deleterequest:(UIButton*)sender{

    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Request" otherButtonTitles: nil, nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    
    [popupQuery showInView:tvc2.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        [tvc2 deleterequestfromsender:self];
    }else if (buttonIndex==1){
        
    }
    
}




-(IBAction)prayFor:(id)sender{
    
    
    if(![listitem.iprayed isEqualToNumber:[NSNumber numberWithInt:1]]){
    
        [pLAppUtils showActivityIndicatorWithMessage:@"Saving"];
        
    NSString *objectpath = @"prayerrequests/prayfor/";
    NSString *path = [objectpath stringByAppendingString: [requestoremail stringByAppendingString:[@"/" stringByAppendingString:requestid]]];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  
                                                      [praybutton setHighlighted:YES];
                                                      listitem.iprayed = [NSNumber numberWithInt:1];
                                                      listitem.praycount = [NSNumber numberWithFloat:([listitem.praycount floatValue] + [[NSNumber numberWithInt:1] floatValue])];
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
    }
    else
    {
        
        [pLAppUtils showActivityIndicatorWithMessage:@"Saving"];
        
        NSString *objectpath = @"prayerrequests/unprayfor/";
        NSString *path = [objectpath stringByAppendingString: [requestoremail stringByAppendingString:[@"/" stringByAppendingString:requestid]]];
        
        
        [[RKObjectManager sharedManager] getObjectsAtPath:path
                                               parameters:nil
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      
                                                      
                                                          [praybutton setHighlighted:NO];
                                                          listitem.iprayed = [NSNumber numberWithInt:0];
                                                      listitem.praycount = [NSNumber numberWithFloat:([listitem.praycount floatValue] - [[NSNumber numberWithInt:1] floatValue])];
                                                      [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];

                                                      
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      NSLog(@"Encountered an error: %@", error);
                                                      [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                                  }];
    }
    
        
        
}

@end
