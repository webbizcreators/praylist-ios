//
//  pLFirstViewController.m
//  PrayList
//
//  Created by Peter Opheim on 11/14/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//

#import "pLFirstViewController.h"
#import "pLPrayerRequest.h"
#import "pLPrayerRequestCell.h"
#import "pLAppUtils.h"
#import "pLResponse.h"
#import "BarButtonBadge.h"
#import "CustomBadge.h"
#import "FPPopoverController.h"
#import "pLNotificationsPopupViewController.h"
#import "pLViewRequestViewController.h"
#import "pLAppDelegate.h"
#import "ECSlidingViewController.h"
#import "pLSideMenuViewController.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 297.0f
#define CELL_CONTENT_MARGIN 24.0f

#define kReleaseToReloadStatus 0
#define kPullToReloadStatus 1
#define kLoadingStatus 2

@interface pLFirstViewController ()

@end

@implementation pLFirstViewController

NSDate *lastdataload;
NSMutableArray *prayerrequests;

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
	[vartableView addSubview:refreshHeaderView];
	vartableView.showsVerticalScrollIndicator = YES;
    

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
    
    [pLAppUtils clearnotifs];
    [pLAppUtils shownotifsfromview:notifbutton.subviews[0]];
    
}

-(void)loadDatawithIndicator:(BOOL)withindicator{
    
    if(withindicator)
    [pLAppUtils showActivityIndicatorWithMessage:@"Loading"];
    
    NSString *objectpath = @"prayerrequests/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  prayerrequests = [NSMutableArray arrayWithArray:mappingResult.array];
                                                  
                                                  if(prayerrequests.count>0){
                                                      
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"requestdate"
                                                                                                   ascending:NO];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      prayerrequests = [NSMutableArray arrayWithArray:[prayerrequests sortedArrayUsingDescriptors:sortDescriptors]];
                                                      
                                                  }
                                                  lastdataload = [[NSDate alloc]init];
                                                  [vartableView reloadData];
                                                  [self dataSourceDidFinishLoadingNewData];
                                                  if(withindicator) [pLAppUtils hideActivityIndicator];
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
		vartableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f,
                                                  0.0f);
		[UIView commitAnimations];
	}
	else
	{
		vartableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f,
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
	[vartableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[refreshHeaderView setStatus:kPullToReloadStatus];
	[refreshHeaderView toggleActivityView:NO];
	[UIView commitAnimations];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [pLAppUtils showActivityIndicatorWithMessage:@"Deleting"];
        pLPrayerRequest *pr = [prayerrequests objectAtIndex:indexPath.row];
        
        [[RKObjectManager sharedManager] deleteObject:pr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
            
            if(mappingResult.array.count>0){
                
                [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                    [prayerrequests removeObjectAtIndex:indexPath.row];
                    [vartableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
        }
                                              failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                                  
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [prayerrequests count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"PrayerRequestCell";
    pLPrayerRequestCell *cell = (pLPrayerRequestCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; 
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrayerRequestCellView" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[pLPrayerRequestCell class]])
                
                cell = (pLPrayerRequestCell *)oneObject;
        
        
    }
    
    pLPrayerRequest *pRequest = [prayerrequests objectAtIndex:indexPath.row];
    
    [cell configureView:pRequest inTableViewController:self];
    cell.requesttitle.text= [pLAppUtils fullnamefromEmail:pRequest.requestoremail];
    cell.requesttext.text = pRequest.requesttext;
    cell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
    cell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
    cell.requeststats.text = [pLAppUtils calculaterequeststats:pRequest.praycount commentcount:pRequest.commentcount totalpraycount:[NSNumber numberWithInt:0]];
    
    NSString*groupnames=@"";
    
    for(NSString*s in pRequest.groupids){
        if(![[pLAppUtils groupnamefromID:s] isEqualToString:@""]){
            groupnames = [[groupnames stringByAppendingString:[pLAppUtils groupnamefromID:s]] stringByAppendingString:@", "];
        }
    }
    cell.groupnames.text = groupnames;
    
    if([pRequest.iprayed intValue]>0){
        [cell.praybutton setHighlighted:YES];
    }
    else{
        [cell.praybutton setHighlighted:NO];
    }
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    pLPrayerRequest *pRequest = [prayerrequests objectAtIndex:[indexPath row]];
    NSString *text = pRequest.requesttext;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 19.0f);
    
    return height + 150;
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
		if([vartableView.dataSource respondsToSelector:
            @selector(reloadTableViewDataSource)]){
			[self showReloadAnimationAnimated:YES];
			[self reloadTableViewDataSource];
		}
	}
	checkForRefresh = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self opencommentsfromsender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"requestdetails"])
    {
        pLPrayerRequestCell * lic = (pLPrayerRequestCell*)sender;
        // Get reference to the destination view controller
        pLViewRequestViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.prayerrequest = lic.listitem;
        vc.prayerrequestlistitem = NULL;
        
        
    }
}

-(void)deleterequestfromsender:(id)sender{
    
    pLPrayerRequestCell*cell=(pLPrayerRequestCell*)sender;
    
    NSIndexPath*indexPath = [vartableView indexPathForCell:cell];
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Deleting"];
    pLPrayerRequest *pr = [prayerrequests objectAtIndex:indexPath.row];
    
    [[RKObjectManager sharedManager] deleteObject:pr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
            [prayerrequests removeObjectAtIndex:indexPath.row];
            [vartableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
    }
                                          failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                              
                                              [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                          }];

    
}

-(void)opencommentsfromsender:(id)sender{
    
    [self performSegueWithIdentifier:@"requestdetails" sender:sender];
    
//    pLPrayerRequestCell * lic = (pLPrayerRequestCell*)sender;
//    
//    [pLAppUtils showActivityIndicatorWithMessage:@"Loading"];
//    
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
//    pLViewRequestViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"postDetail"];
//    lvc.prayerrequestlistitem = NULL;
//    lvc.prayerrequest = lic.listitem;
//    
//    pLAppDelegate *appDelegate = (pLAppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    UIViewController*pv=appDelegate.window.rootViewController.presentedViewController;
//    
//    [pv presentViewController:lvc animated:YES completion:nil];
//    
//    [pLAppUtils hideActivityIndicator];

}

@end
