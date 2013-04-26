//
//  pLPrayerListItemCell.m
//  PrayList
//
//  Created by Peter Opheim on 11/16/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//

#import "pLPrayerListItemCell.h"
#import "pLResponse.h"

@implementation pLPrayerListItemCell

@synthesize requestdate;
@synthesize requesttitle;
@synthesize requesttext;
@synthesize img;
@synthesize requestoremail;
@synthesize requestid;
@synthesize praybutton;
@synthesize listitem;

pLSecondViewController*tvc;


- (void) configureView:(pLPrayerRequestListItem*)li inTableViewController:(pLSecondViewController*)_tvc;
{
    tvc = _tvc;
    listitem = li;
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
    [tvc performSegueWithIdentifier:@"showComments" sender:self];
}



-(IBAction)prayFor:(id)sender{
    BOOL *pb = praybutton.highlighted;
    
    if(!praybutton.highlighted){
    
    NSString *objectpath = @"prayerrequests/prayfor/";
    NSString *path = [objectpath stringByAppendingString: [requestoremail stringByAppendingString:[@"/" stringByAppendingString:requestid]]];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  pLResponse *result = mappingResult.firstObject;
                                                  
                                                  if([@"Prayed" isEqualToString:result.description]){
                                                      [praybutton setHighlighted:YES];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
    }
    else
    {
        NSString *objectpath = @"prayerrequests/unprayfor/";
        NSString *path = [objectpath stringByAppendingString: [requestoremail stringByAppendingString:[@"/" stringByAppendingString:requestid]]];
        
        
        [[RKObjectManager sharedManager] getObjectsAtPath:path
                                               parameters:nil
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      
                                                      pLResponse *result = mappingResult.firstObject;
                                                      
                                                      if([@"Unprayed" isEqualToString:result.description]){
                                                          [praybutton setHighlighted:NO];
                                                      }
                                                      
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      NSLog(@"Encountered an error: %@", error);
                                                  }];
    }
    
        
        
}

@end
