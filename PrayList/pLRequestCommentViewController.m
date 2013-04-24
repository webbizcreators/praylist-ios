//
//  pLRequestCommentViewController.m
//  PrayList
//
//  Created by Peter Opheim on 4/22/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLRequestCommentViewController.h"
#import "pLCommentCell.h"
#import "pLComment.h"
#import "pLAppUtils.h"
#import "pLPrayerRequestCell.h"
#import "pLPrayerListItemCell.h"

#define FONT_SIZE 11.0f
#define CELL_CONTENT_WIDTH 297.0f
#define CELL_CONTENT_MARGIN 24.0f

#define kReleaseToReloadStatus 0
#define kPullToReloadStatus 1
#define kLoadingStatus 2

@interface pLRequestCommentViewController ()

@end

@implementation pLRequestCommentViewController

@synthesize prayerrequest;
@synthesize prayerrequestlistitem;

NSArray *comments;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
	// Do any additional setup after loading the view.
}


-(void)loadData{
    
    NSString *path;
    
    if(prayerrequest){
        path = [@"prayerrequests/" stringByAppendingString:[[[prayerrequest.requestoremail stringByAppendingString:@"/"]
                                                             stringByAppendingString:prayerrequest.requestid]
                                                            stringByAppendingString:@"/comments"]];
    }
    else
    {
        path = [@"prayerrequests/" stringByAppendingString:[[[prayerrequestlistitem.requestoremail stringByAppendingString:@"/"]
                                                             stringByAppendingString:prayerrequestlistitem.requestid]
                                                            stringByAppendingString:@"/comments"]];
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  comments = mappingResult.array;
                                                  
                                                  if(comments.count>0){
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"commentdate"
                                                                                                   ascending:NO];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      comments = [comments sortedArrayUsingDescriptors:sortDescriptors];
                                                      
                                                      [tableView reloadData];
                                                      //[self dataSourceDidFinishLoadingNewData];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger retval;
    retval = [comments count]+1;
    
    return retval;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    
    if( indexPath.row == 0 ) {
        if(prayerrequest){
            
            static NSString *CustomCellIdentifier = @"PrayerRequestCell";
            pLPrayerRequestCell *pcell = (pLPrayerRequestCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
            
            [pcell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            if (pcell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrayerRequestCellView" owner:self options:nil];
                
                for (id oneObject in nib)
                    if ([oneObject isKindOfClass:[pLPrayerRequestCell class]])
                        
                        pcell = (pLPrayerRequestCell *)oneObject;
                
                [pcell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                
            }
            
            pLPrayerRequest *pRequest = prayerrequest;
            
            pcell.requesttitle.text= pRequest.requestoremail;
            pcell.requesttext.text = pRequest.requesttext;
            pcell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
            pcell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
            pcell.requeststats.text = [pLAppUtils calculaterequeststats:pRequest.praycount commentcount:[NSNumber numberWithInt:0]];
            
            cell = pcell;
            
        }
        else
        {
            
            
            static NSString *CustomCellIdentifier = @"PrayerRequestListItemCell";
            pLPrayerListItemCell *picell = (pLPrayerListItemCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
            
            [picell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            if (picell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrayerListItemCellView" owner:self options:nil];
                
                for (id oneObject in nib)
                    if ([oneObject isKindOfClass:[pLPrayerListItemCell class]])
                        
                        picell = (pLPrayerListItemCell *)oneObject;
                
                [picell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                
            }
            
            pLPrayerRequestListItem *pRequest = prayerrequestlistitem;
            
            picell.requesttitle.text= pRequest.requestoremail;
            picell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
            picell.requestid = pRequest.requestid;
            picell.requestoremail = pRequest.requestoremail;
            picell.requesttext.text = pRequest.requesttext;
            
            
            if([pRequest.iprayed isEqualToNumber:[NSNumber numberWithInt:1]]){
                [picell.praybutton setTitle:@"Prayed" forState:UIControlStateNormal];
                picell.praybutton.titleLabel.text = @"Prayed";
            }
            
            picell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
            
            cell = picell;
            
        }
        
    }
    else
    {
        
        static NSString *CustomCellIdentifier = @"CommentCell";
        pLCommentCell *ccell = (pLCommentCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
        
        [ccell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
        if (ccell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"pLCommentCellView" owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[pLCommentCell class]])
                    
                    ccell = (pLCommentCell *)oneObject;
            
            [ccell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
        }
        
        pLComment *comment = [comments objectAtIndex:indexPath.row-1];
        
        //[cell configureView:pRequest inTableViewController:self];
        
        ccell.commenttitle.text= comment.email;
        ccell.commentdate.text = [pLAppUtils formatPostDate:comment.commentdate];
        ccell.commenttext.text = comment.commenttext;
        
        ccell.img.image = [pLAppUtils userimgFromEmail: comment.email];
        
        cell = ccell;
        
        
    }
    
    
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if( indexPath.row > 0 ) {
        pLComment *comment = [comments objectAtIndex:indexPath.row-1];
        NSString *text = comment.commenttext;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 19.0f);
        
        return height + 80;
    }
    else
    {
        if(prayerrequestlistitem){
            pLPrayerRequestListItem *pRequest = prayerrequestlistitem;
            NSString *text = pRequest.requesttext;
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 19.0f);
            
            return height + 110;
        }
        else
        {
            pLPrayerRequest *pRequest = prayerrequest;
            NSString *text = pRequest.requesttext;
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 19.0f);
            
            return height + 130;
            
        }
    }
}




@end
