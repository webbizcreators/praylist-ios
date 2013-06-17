//
//  pLViewPrayerItemCell.m
//  PrayList
//
//  Created by Peter Opheim on 6/7/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLViewPrayerItemCell.h"
#import "pLResponse.h"

@implementation pLViewPrayerItemCell


@synthesize requestdate;
@synthesize requesttitle;
@synthesize requesttext;
@synthesize groupnames;
@synthesize img;
@synthesize requestoremail;
@synthesize requestid;
@synthesize praybutton;
@synthesize listitem;
@synthesize requeststats;

pLSecondViewController*tvc2;


- (void) configureView:(pLPrayerRequestListItem*)li inTableViewController:(pLSecondViewController*)_tvc;
{
    tvc2 = _tvc;
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
    [tvc2 opencommentsfromsender:self];
}



-(IBAction)prayFor:(id)sender{
    
    
    if(![listitem.iprayed isEqualToNumber:[NSNumber numberWithInt:1]]){
        
        NSString *objectpath = @"prayerrequests/prayfor/";
        NSString *path = [objectpath stringByAppendingString: [requestoremail stringByAppendingString:[@"/" stringByAppendingString:requestid]]];
        
        
        [[RKObjectManager sharedManager] getObjectsAtPath:path
                                               parameters:nil
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      
                                                      pLResponse *result = mappingResult.firstObject;
                                                      
                                                      
                                                      [praybutton setHighlighted:YES];
                                                      listitem.iprayed = [NSNumber numberWithInt:1];
                                                      listitem.praycount = [NSNumber numberWithFloat:([listitem.praycount floatValue] + [[NSNumber numberWithInt:1] floatValue])];
                                                      
                                                      
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
                                                      
                                                      
                                                      [praybutton setHighlighted:NO];
                                                      listitem.iprayed = [NSNumber numberWithInt:0];
                                                      
                                                      
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      NSLog(@"Encountered an error: %@", error);
                                                  }];
    }
    
    
    
}

@end
