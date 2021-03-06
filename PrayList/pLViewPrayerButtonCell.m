//
//  pLViewPrayerButtonCell.m
//  PrayList
//
//  Created by Peter Opheim on 6/7/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "pLViewPrayerButtonCell.h"
#import "pLAppUtils.h"

@implementation pLViewPrayerButtonCell

@synthesize listitem;
@synthesize praybutton;
@synthesize commentbutton;
@synthesize vc;

-(IBAction)praybutton:(id)sender{
        
        
        if(![listitem.iprayed isEqualToNumber:[NSNumber numberWithInt:1]]){
            
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
                                                          [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                          
                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          NSLog(@"Encountered an error: %@", error);
                                                          [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                                      }];
        }
        
        
    }
    
    


-(IBAction)commentbutton:(id)sender{
    
    [vc.commentfield becomeFirstResponder];
    
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

@end
