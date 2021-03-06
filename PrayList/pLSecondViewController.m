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
#import "pLViewRequestViewController.h"
#import "BarButtonBadge.h"
#import "CustomBadge.h"
#import "pLNotificationsPopupViewController.h"
#import "FPPopoverController.h"
#import "pLAppDelegate.h"
#import "ECSlidingViewController.h"
#import "pLSideMenuViewController.h"
#import "pLPlanPrayerRequestViewController.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 297.0f
#define CELL_CONTENT_MARGIN 24.0f

#define kReleaseToReloadStatus 0
#define kPullToReloadStatus 1
#define kLoadingStatus 2

@interface pLSecondViewController ()

@end

@implementation pLSecondViewController

NSDate *lastdataload;
NSMutableArray *prayerrequests2;
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

    
    [self loadDatawithIndicator:YES];
    
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
    
    [super viewWillAppear:animated];

    if (![self.slidingViewController.underLeftViewController isKindOfClass:[pLSideMenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightPeekAmount:80.0f];
    
    
    NSDate*now=[[NSDate alloc]init];
    double intervalInSeconds = [now timeIntervalSinceDate:lastdataload];
    
    if(intervalInSeconds>10){
        [self loadDatawithIndicator:NO];
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
    
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationsPopupView" owner:self options:nil];
//    pLNotificationsPopupViewController*controller;
//    
//    for (id oneObject in nib)
//        if ([oneObject isKindOfClass:[pLNotificationsPopupViewController class]])
//            
//            controller = (pLNotificationsPopupViewController *)oneObject;
//    
//    controller.title = @"Notifications";
//    //our popover
//    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
//    
//    popover.contentSizeForViewInPopover = CGSizeMake(280,350);
//    popover.contentSize = CGSizeMake(280,350);
//    
//    //the popover will be presented from the okButton view
//    [popover presentPopoverFromView:notifbutton.subviews[0]];
    
    [pLAppUtils shownotifsfromview:notifbutton.subviews[0]];
    
    
}



-(void)loadDatawithIndicator:(BOOL)withindicator{

    if(withindicator)[pLAppUtils showActivityIndicatorWithMessage:@"Loading"];
    
    NSString *objectpath = @"lists/myprayerlist/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  prayerrequests2 = [NSMutableArray arrayWithArray:mappingResult.array];
                                                  
                                                  if(prayerrequests2.count>0){
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"requestdate"
                                                                                                   ascending:NO];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      prayerrequests2 = [NSMutableArray arrayWithArray:[prayerrequests2 sortedArrayUsingDescriptors:sortDescriptors]];
                                                      
                                                  }
                                                  lastdataload = [[NSDate alloc]init];
                                                  [tableView reloadData];
                                                  [self dataSourceDidFinishLoadingNewData];
                                                  if(withindicator)[pLAppUtils hideActivityIndicator];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [self dataSourceDidFinishLoadingNewData];
                                              }];
    

    
}



-(void)loadmoreDatawithIndicator:(BOOL)withindicator{
    
    if(withindicator)[pLAppUtils showActivityIndicatorWithMessage:@"Loading"];
    
    NSString *objectpath = @"lists/myprayerlist/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    pLPrayerRequestListItem*pr = [prayerrequests2 lastObject];

    [[RKObjectManager sharedManager] putObject:pr path: path parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult2){
    
        NSArray*moreprayerrequests = mappingResult2.array;
        
    if(mappingResult2.array.count>0){
        
        if(moreprayerrequests.count>0){
            
            [prayerrequests2 addObjectsFromArray:moreprayerrequests];
            
            [tableView reloadData];
            
        }

        
        
    }
    
        if(withindicator)[pLAppUtils hideActivityIndicator];
        
}
                                   failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                       
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
	[self loadDatawithIndicator:NO];
    
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
    return [prayerrequests2 count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*returncell;
    
    if(indexPath.row==0){
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"requestfeedheadercell"];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"pLRequestFeedHeaderCellView" owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[UITableViewCell class]])
                    
                    cell = (UITableViewCell *)oneObject;
        }
        
        returncell = cell;
        
        
    }
    else if(indexPath.row>0){

    pLPrayerListItemCell *cell = (pLPrayerListItemCell *)[tableView dequeueReusableCellWithIdentifier: @"PrayerRequestListItemCell"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrayerListItemCellView" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[pLPrayerListItemCell class]])
                
                cell = (pLPrayerListItemCell *)oneObject; 
    }
    
    pLPrayerRequestListItem *pRequest = [prayerrequests2 objectAtIndex:indexPath.row-1];
    
    [cell configureView:pRequest inTableViewController:self];
    
    cell.requesttitle.text= [pLAppUtils fullnamefromEmail:pRequest.requestoremail];
    cell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
    cell.requestid = pRequest.requestid;
    cell.requestoremail = pRequest.requestoremail;
    cell.requesttext.text = pRequest.requesttext;
    cell.requeststats.text = [pLAppUtils calculaterequeststats:pRequest.praycount commentcount:pRequest.commentcount totalpraycount:pRequest.totalpraycount];
    
    NSString*groupnames=@"";
    
    for(NSString*s in pRequest.senttoemails){
        
        groupnames = [[groupnames stringByAppendingString:[pLAppUtils fullnamefromEmail:s]] stringByAppendingString:@", "];
        
    }
    
    for(NSString*s in pRequest.groupids){
        
        groupnames = [[groupnames stringByAppendingString:[pLAppUtils groupnamefromID:s]] stringByAppendingString:@", "];
         
        
    }
    
    groupnames = [groupnames substringToIndex:[groupnames length] - 2];
    
    cell.groupnames.text = groupnames;
    
    if([pRequest.iprayed intValue]>0){
        [cell.praybutton setHighlighted:YES];
    }
    else{
        [cell.praybutton setHighlighted:NO];
    }
    
    if(pRequest.prayinterval!=nil){
        [cell.planbutton setHighlighted:YES];
    }
    else{
        [cell.planbutton setHighlighted:NO];
    }

    
    cell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
        
        returncell = cell;
        
    }
    
    return returncell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row==0){
        return 43;
    }
    else{
    pLPrayerRequestListItem *pRequest = [prayerrequests2 objectAtIndex:[indexPath row]-1];
    NSString *text = pRequest.requesttext;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 19.0f);
    
    return height + 150;
    }
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
    
    
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height) {
        [self loadmoreDatawithIndicator:YES];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self opencommentsfromsender:[tableView cellForRowAtIndexPath:indexPath]];
}


-(IBAction)addbutton:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissPostViewController)
                                                 name:@"PostViewControllerDismissed"
                                               object:nil];
    
    [self performSegueWithIdentifier: @"addRequestSegue" sender: self];
    
}


-(void)didDismissPostViewController {
    [pLAppUtils hideActivityIndicatorWithMessage:@"Saved"];
    [self loadDatawithIndicator:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"requestdetails"])
    {
        pLPrayerListItemCell * lic = (pLPrayerListItemCell*)sender;
        // Get reference to the destination view controller
        pLViewRequestViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.prayerrequestlistitem = lic.listitem;
        vc.prayerrequest = NULL;
        

    }else if([[segue identifier] isEqualToString:@"planrequest"]){
        
        pLPrayerListItemCell * lic = (pLPrayerListItemCell*)sender;
        // Get reference to the destination view controller
        pLPlanPrayerRequestViewController *vc = [segue destinationViewController];
        vc.prayerrequestlistitem = lic.listitem;
        vc.isedit=NO;
        
        if(lic.listitem.prayinterval!=nil)vc.isedit=YES;

    }
}

-(void)opencommentsfromsender:(id)sender{
    
    [self performSegueWithIdentifier:@"requestdetails" sender:sender];
    
}

-(void)planrequestfromsender:(id)sender{
    
    [self performSegueWithIdentifier:@"planrequest" sender:sender];
    
}

-(void)deleterequestfromsender:(id)sender{
    
    pLPrayerListItemCell*cell=(pLPrayerListItemCell*)sender;
    
    NSIndexPath*indexPath = [tableView indexPathForCell:cell];
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Deleting"];
    pLPrayerRequestListItem *pr = [prayerrequests2 objectAtIndex:indexPath.row-1];
    
    [[RKObjectManager sharedManager] deleteObject:pr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
            [prayerrequests2 removeObjectAtIndex:indexPath.row-1];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
    }
                                          failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                              
                                              [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                          }];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
