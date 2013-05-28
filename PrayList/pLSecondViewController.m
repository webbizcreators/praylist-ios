//
//  pLSecondViewController.m
//  PrayList
//
//  Created by Peter Opheim on 11/14/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//

#import "pLSecondViewController.h"
#import "pLPrayerRequestListItem.h"
#import "pLPrayerListItemCell.h"
#import "pLSecurityToken.h"
#import "pLAppUtils.h"
#import "pLRequestCommentViewController.h"
#import "BarButtonBadge.h"
#import "CustomBadge.h"
#import "pLNotificationsPopupViewController.h"
#import "FPPopoverController.h"

#define FONT_SIZE 11.0f
#define CELL_CONTENT_WIDTH 297.0f
#define CELL_CONTENT_MARGIN 24.0f

#define kReleaseToReloadStatus 0
#define kPullToReloadStatus 1
#define kLoadingStatus 2

@interface pLSecondViewController ()

@end

@implementation pLSecondViewController

NSDate *lastdataload;
NSArray *prayerrequests2;
UIActivityIndicatorView *spinner;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background_iPhone5"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                         CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                    320.0f, self.view.bounds.size.height)];
	[tableView addSubview:refreshHeaderView];
	tableView.showsVerticalScrollIndicator = YES;
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotificationBadge)
                                                 name:@"NotificationUpdate"
                                               object:nil];

    
    [self loadData];
    
}

- (void)updateNotificationBadge{
    
    for (UIView *subView in notifbutton.subviews)
    {
        if ([subView isKindOfClass:[CustomBadge class]])
        {
            [subView removeFromSuperview];
        }
    }
    
    NSNumber *notifcount = [pLAppUtils notifcount];
    if([notifcount unsignedIntValue]>0){
        [BarButtonBadge addBadgetoButton:notifbutton badgeString: [notifcount stringValue] atRight:NO];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    NSDate*now=[[NSDate alloc]init];
    double intervalInSeconds = [now timeIntervalSinceDate:lastdataload];
    
    if(intervalInSeconds>10){
        [self loadData];
    }
    
    [self updateNotificationBadge];
    
}


-(IBAction)opennotifs:(id)sender{
    
    for (UIView *subView in notifbutton.subviews)
    {
        if ([subView isKindOfClass:[CustomBadge class]])
        {
            [subView removeFromSuperview];
        }
    }
    
    [pLAppUtils clearnotifs];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationsPopupView" owner:self options:nil];
    pLNotificationsPopupViewController*controller;
    
    for (id oneObject in nib)
        if ([oneObject isKindOfClass:[pLNotificationsPopupViewController class]])
            
            controller = (pLNotificationsPopupViewController *)oneObject;
    
    controller.title = @"Notifications";
    //our popover
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    popover.contentSizeForViewInPopover = CGSizeMake(280,350);
    popover.contentSize = CGSizeMake(280,350);
    
    //the popover will be presented from the okButton view
    [popover presentPopoverFromView:notifbutton.subviews[0]];
    
    
    
    
}



-(void)loadData{

    NSString *objectpath = @"lists/myprayerlist/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  prayerrequests2 = mappingResult.array;
                                                  
                                                  if(prayerrequests2.count>0){
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"requestdate"
                                                                                                   ascending:NO];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      prayerrequests2 = [prayerrequests2 sortedArrayUsingDescriptors:sortDescriptors];
                                                      
                                                  }
                                                  lastdataload = [[NSDate alloc]init];
                                                  [tableView reloadData];
                                                  [self dataSourceDidFinishLoadingNewData];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [self dataSourceDidFinishLoadingNewData];
                                              }];
    

    
}


#pragma mark State Changes

- (void) showReloadAnimationAnimated:(BOOL)animated
{
	reloading = YES;
	[refreshHeaderView toggleActivityView:YES];
    
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f,
                                                  0.0f);
		[UIView commitAnimations];
	}
	else
	{
		tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f,
                                                  0.0f);
	}
}

- (void) reloadTableViewDataSource
{
	[self loadData];
    
}

- (void)dataSourceDidFinishLoadingNewData
{
	reloading = NO;
	[refreshHeaderView flipImageAnimated:NO];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[refreshHeaderView setStatus:kPullToReloadStatus];
	[refreshHeaderView toggleActivityView:NO];
	[UIView commitAnimations];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [prayerrequests2 count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"PrayerRequestListItemCell";
    pLPrayerListItemCell *cell = (pLPrayerListItemCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrayerListItemCellView" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[pLPrayerListItemCell class]])
                
                cell = (pLPrayerListItemCell *)oneObject;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
    }
    
    pLPrayerRequestListItem *pRequest = [prayerrequests2 objectAtIndex:indexPath.row];
    
    [cell configureView:pRequest inTableViewController:self];
    
    cell.requesttitle.text= [pLAppUtils fullnamefromEmail:pRequest.requestoremail];
    cell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
    cell.requestid = pRequest.requestid;
    cell.requestoremail = pRequest.requestoremail;
    cell.requesttext.text = pRequest.requesttext;
    cell.requeststats.text = [pLAppUtils calculaterequeststats:pRequest.praycount commentcount:pRequest.commentcount];
    
    NSLog(@"Title Label: %@", [[cell.praybutton titleLabel] text ]);
    
    if([pRequest.iprayed isEqualToNumber:[NSNumber numberWithInt:1]]){
        [cell.praybutton setHighlighted:YES];
    }
    else{
        [cell.praybutton setHighlighted:NO];
    }
    
    cell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
    
    //NSString *text = pRequest.requesttext;
    
    //CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    //CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    //if (!cell.requesttext)
    //    cell.requesttext = (UILabel*)[cell viewWithTag:1];
    
    //[cell.requesttext setText:pRequest.requesttext];
    //[cell.requesttext setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    pLPrayerRequestListItem *pRequest = [prayerrequests2 objectAtIndex:[indexPath row]];
    NSString *text = pRequest.requesttext;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 19.0f);
    
    return height + 130;
}


#pragma mark Scrolling Overrides
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (!reloading)
	{
		checkForRefresh = YES;  //  only check offset when dragging
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (reloading) return;
    
	if (checkForRefresh) {
		if (refreshHeaderView.isFlipped
            && scrollView.contentOffset.y > -65.0f
            && scrollView.contentOffset.y < 0.0f
            && !reloading) {
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kPullToReloadStatus];
			
            
		} else if (!refreshHeaderView.isFlipped
                   && scrollView.contentOffset.y < -65.0f) {
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kReleaseToReloadStatus];
			
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
	if (reloading) return;
    
	if (scrollView.contentOffset.y <= - 65.0f) {
		if([tableView.dataSource respondsToSelector:
            @selector(reloadTableViewDataSource)]){
			[self showReloadAnimationAnimated:YES];
			[self reloadTableViewDataSource];
		}
	}
	checkForRefresh = NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showComments"])
    {
        // Get reference to the destination view controller
        pLRequestCommentViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        pLPrayerListItemCell * lic = (pLPrayerListItemCell*)sender;
        vc.prayerrequest = NULL;
        vc.prayerrequestlistitem = lic.listitem;
        

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
