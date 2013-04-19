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

-(IBAction)prayFor:(id)sender{
    NSLog(@"Title Label: %@", [[praybutton titleLabel] text ]);
    if([@"Pray" isEqualToString:[[praybutton titleLabel] text ]]){
    
    NSString *objectpath = @"prayerrequests/prayfor/";
    NSString *path = [objectpath stringByAppendingString: [requestoremail stringByAppendingString:[@"/" stringByAppendingString:requestid]]];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  pLResponse *result = mappingResult.firstObject;
                                                  
                                                  if([@"Prayed" isEqualToString:result.description]){
                                                      [praybutton setTitle:@"Prayed" forState:UIControlStateNormal];
                                                      praybutton.titleLabel.text = @"Prayed";
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
                                                          [praybutton setTitle:@"Pray" forState:UIControlStateNormal];
                                                          praybutton.titleLabel.text = @"Pray";
                                                      }
                                                      
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      NSLog(@"Encountered an error: %@", error);
                                                  }];
    }
    
        
        
}

@end
