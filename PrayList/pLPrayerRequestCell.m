//
//  pLPrayerRequestCell.m
//  PrayList
//
//  Created by Peter Opheim on 2/9/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPrayerRequestCell.h"
#import "pLFirstViewController.h"
#import "pLAppUtils.h"

@implementation pLPrayerRequestCell

@synthesize requestdate;
@synthesize requesttitle;
@synthesize requesttext;
@synthesize requeststats;
@synthesize requestoremail;
@synthesize requestid;
@synthesize img;
@synthesize listitem;
@synthesize groupnames;
@synthesize praybutton;

pLFirstViewController*tvc;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

          
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) configureView:(pLPrayerRequest*)li inTableViewController:(pLFirstViewController*)_tvc;
{
    tvc = _tvc;
    listitem = li;
}

- (IBAction)opencomments:(UIButton *)sender {
    [tvc opencommentsfromsender:self];
}

-(IBAction)deleterequest:(UIButton*)sender{
    [tvc deleterequestfromsender:self];
}

-(IBAction)prayFor:(id)sender{
    
    
    if([listitem.iprayed intValue]==0){
        
        [pLAppUtils showActivityIndicatorWithMessage:@"Saving"];
        
        NSString *objectpath = @"prayerrequests/prayfor/";
        NSString *path = [objectpath stringByAppendingString: [listitem.requestoremail stringByAppendingString:[@"/" stringByAppendingString:listitem.requestid]]];
        
        
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
        NSString *path = [objectpath stringByAppendingString: [listitem.requestoremail stringByAppendingString:[@"/" stringByAppendingString:listitem.requestid]]];
        
        
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
