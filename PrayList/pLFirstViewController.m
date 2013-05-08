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

#define FONT_SIZE 11.0f
#define CELL_CONTENT_WIDTH 297.0f
#define CELL_CONTENT_MARGIN 24.0f

#define kReleaseToReloadStatus 0
#define kPullToReloadStatus 1
#define kLoadingStatus 2

@interface pLFirstViewController ()

@end

@implementation pLFirstViewController


NSMutableArray *prayerrequests;
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
	[vartableView addSubview:refreshHeaderView];
	vartableView.showsVerticalScrollIndicator = YES;
    
    
    [self loadData];
    
}

-(void)loadData{
    
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
                                                  [spinner stopAnimating];
                                                  [vartableView reloadData];
                                                  [self dataSourceDidFinishLoadingNewData];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
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
	[self loadData];
    
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
        
        pLPrayerRequest *pr = [prayerrequests objectAtIndex:indexPath.row];
        
        [[RKObjectManager sharedManager] deleteObject:pr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
            
            if(mappingResult.array.count>0){
                
                pLPrayerRequest *result = mappingResult.firstObject;
                    
                    [prayerrequests removeObjectAtIndex:indexPath.row];
                    [vartableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
        }
                                              failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                                  
                                                  
                                              }];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [prayerrequests count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"PrayerRequestCell";
    pLPrayerRequestCell *cell = (pLPrayerRequestCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrayerRequestCellView" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[pLPrayerRequestCell class]])
                
                cell = (pLPrayerRequestCell *)oneObject;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
    }
    
    pLPrayerRequest *pRequest = [prayerrequests objectAtIndex:indexPath.row];
    
    cell.requesttitle.text= pRequest.requestoremail;
    cell.requesttext.text = pRequest.requesttext;
    cell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
    cell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
    cell.requeststats.text = [pLAppUtils calculaterequeststats:pRequest.praycount commentcount:[NSNumber numberWithInt:0]];
    
    
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
    pLPrayerRequest *pRequest = [prayerrequests objectAtIndex:[indexPath row]];
    NSString *text = pRequest.requesttext;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 19.0f);
    
    return height + 130;
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
    [self loadData];
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

@end
