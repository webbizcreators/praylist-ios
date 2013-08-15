//
//  pLPrayerPlannerViewController.m
//  PrayList
//
//  Created by Peter Opheim on 6/17/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPrayerPlannerViewController.h"
#import "ECSlidingViewController.h"
#import "pLSideMenuViewController.h"
#import "pLAppUtils.h"
#import "pLPrayerRequestScheduleItemCell.h"
#import "pLViewRequestViewController.h"
#import "pLPlanPrayerRequestViewController.h"
#import "pLScheduleDateCell.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 297.0f
#define CELL_CONTENT_MARGIN 24.0f

@interface pLPrayerPlannerViewController ()

@end

@implementation pLPrayerPlannerViewController

NSMutableArray *prayerrequests;
NSDate *lastdataload;
NSDate *today;
NSInteger*viewdateindex;
NSDate*startdate;
NSDate*enddate;

NSMutableArray*loadeddates;
NSMutableArray*loadeddatesstr;
NSMutableArray*hiddendates;
NSMutableArray*hiddendatesstr;
NSMutableArray*visibledates;
NSMutableArray*visibledatesstr;

NSMutableArray*hiddendateindexes;
NSMutableDictionary*prayerrequestfordates;

BOOL refreshing;
BOOL atend;
BOOL atbeginning;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"background_iPhone5"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    listtableView.backgroundView = imageView;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    [self loadinitialdata];

}

-(void)loadinitialdata{
    
    prayerrequestfordates = [[NSMutableDictionary alloc]init];
    today = [[NSDate alloc]init];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-30];
    NSDateComponents *offsetComponents2 = [[NSDateComponents alloc] init];
    [offsetComponents2 setDay:30];
    
    startdate = [gregorian dateByAddingComponents:offsetComponents
                                           toDate:today options:0];
    enddate = [gregorian dateByAddingComponents:offsetComponents2
                                         toDate:today options:0];
    
    loadeddatesstr = [[NSMutableArray alloc]init];
    loadeddates = [[NSMutableArray alloc]init];
    
    [self loadPrayerRequestsforDateRange:startdate enddate:enddate withNotification:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"requestdetails"])
    {
        pLPrayerRequestScheduleItemCell * lic = (pLPrayerRequestScheduleItemCell*)sender;
        pLViewRequestViewController *vc = [segue destinationViewController];
        vc.prayerrequestlistitem = lic.listitem;
        vc.prayerrequest = NULL;
        
    }else if([[segue identifier] isEqualToString:@"planrequest"]){
        
        pLPrayerRequestScheduleItemCell * lic = (pLPrayerRequestScheduleItemCell*)sender;
        // Get reference to the destination view controller
        pLPlanPrayerRequestViewController *vc = [segue destinationViewController];
        vc.prayerrequestlistitem = lic.listitem;
        vc.isedit = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDismissRescheduleViewController)
                                                     name:@"PrayerRequestRescheduleDismissed"
                                                   object:nil];
        
    }
}


-(void)didDismissRescheduleViewController {

    [self loadinitialdata];
    
}


-(void)opencommentsfromsender:(id)sender{
    
    [self performSegueWithIdentifier:@"requestdetails" sender:sender];
    
}

-(void)planrequestfromsender:(id)sender{
    
    [self performSegueWithIdentifier:@"planrequest" sender:sender];
    
}

-(void)deleterequestfromsender:(id)sender{
    
    pLPrayerRequestScheduleItemCell*cell=(pLPrayerRequestScheduleItemCell*)sender;
    NSIndexPath*indexPath = [listtableView indexPathForCell:cell];
    
    
    NSString*datestr = [visibledatesstr objectAtIndex:indexPath.section];
    NSMutableArray*items = (NSMutableArray*)[prayerrequestfordates objectForKey:datestr];
    
    pLPrayerRequestListItem*item = (pLPrayerRequestListItem*)cell.listitem;
    
    
    
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Deleting"];
    
    NSString*path=[@"schedule/delete/" stringByAppendingString:[item.requestoremail stringByAppendingString:[@"/" stringByAppendingString:[item.requestid  stringByAppendingString:[@"/" stringByAppendingString:item.scheduleddate]]]]];
    
    [[RKObjectManager sharedManager] deleteObject:nil path: path parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
            [items removeObject:item];
        
            if([items count]==0){
                
                int findindex=0;
                
                while ([(NSNumber*)[hiddendateindexes objectAtIndex:findindex] intValue]<[loadeddatesstr indexOfObject:datestr]){
                    findindex++;
                }
                
                [hiddendateindexes insertObject:[NSNumber numberWithInt:[loadeddatesstr indexOfObject:datestr]] atIndex:findindex];
                [hiddendatesstr insertObject:datestr atIndex:findindex];
                [hiddendates insertObject:[loadeddates objectAtIndex:[loadeddatesstr indexOfObject:datestr]] atIndex:findindex];
                
                NSMutableIndexSet*set = [[NSMutableIndexSet alloc]init];
                
                [set addIndex:indexPath.section];
    
                [visibledates removeObjectsAtIndexes:set];
                [visibledatesstr removeObjectsAtIndexes:set];
                
                [prayerrequestfordates removeObjectForKey:datestr];
                
                [listtableView deleteSections:set withRowAnimation:UITableViewRowAnimationLeft];
                
            }
            else{
                
                [listtableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
        
        
    }
                                          failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                              
                                              [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                          }];

    
}



-(void)viewDidAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[pLSideMenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightPeekAmount:80.0f];
    
    
}


-(void)loadPrayerRequestsforDateRange:(NSDate*)startdate enddate:(NSDate*)enddate withNotification:(BOOL)withnotif{
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    
    NSDate*intdate=[startdate copy];
    
    while([intdate timeIntervalSince1970]<=[enddate timeIntervalSince1970]){
        
        NSString*datestr=[dateFormat2 stringFromDate:intdate];
        
        [loadeddatesstr addObject:datestr];
        [loadeddates addObject:intdate];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:1];
        
        intdate = [gregorian dateByAddingComponents:offsetComponents
                                             toDate:intdate options:0];
    }

    
    NSString*startdatestr = [dateFormat2 stringFromDate:startdate];
    NSString*enddatestr = [dateFormat2 stringFromDate:enddate];
    
    if(withnotif)[pLAppUtils showActivityIndicatorWithMessage:@"Loading"];
    
    NSString *objectpath = @"schedule/";
    NSString *path = [objectpath stringByAppendingString: [[pLAppUtils securitytoken].email stringByAppendingString:[@"/" stringByAppendingString:[startdatestr stringByAppendingString:[@"/" stringByAppendingString:enddatestr]]]]];
    
    
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
                                                      
                                                      for(pLPrayerRequestListItem*p in prayerrequests) {
                                                          
                                                          if([prayerrequestfordates objectForKey:p.scheduleddate]==nil){
                                                              [prayerrequestfordates setObject:[[NSMutableArray alloc]init] forKey:p.scheduleddate];
                                                          }
                                                          
                                                          NSMutableArray*prs = [prayerrequestfordates objectForKey:p.scheduleddate];
                                                          
                                                          [prs addObject:p];
                                                          
                                                      }
                                                      
                                                      
                                                  }
                                                  else{
                                                      atend=YES;
                                                  }
     
                                                  
                                                    [self buildTableSections];                                             
                                                  
                                                  lastdataload = [[NSDate alloc]init];
                                                  if(withnotif)[pLAppUtils hideActivityIndicator];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  if(withnotif)[pLAppUtils hideActivityIndicator];
                                                  
                                              }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [visibledatesstr count];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSDate*date= [visibledates objectAtIndex:section];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"EEE MMM dd"];
    NSString*datestr = [dateFormat2 stringFromDate:date];
    
    return datestr;
    
}

-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString*datestr = [visibledatesstr objectAtIndex:section];
    NSArray*prs = [prayerrequestfordates objectForKey:datestr];
    if(prs!=nil){
        return [prs count];
    }
    else{
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CustomCellIdentifier = @"PrayerRequestScheduleItemCell";
    pLPrayerRequestScheduleItemCell *cell = (pLPrayerRequestScheduleItemCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrayerRequestScheduleItemCellView" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[pLPrayerRequestScheduleItemCell class]])
                
                cell = (pLPrayerRequestScheduleItemCell *)oneObject;
        
        
    }
    
    
    NSString*datestr = [visibledatesstr objectAtIndex:indexPath.section];
    
    NSArray*prs = [prayerrequestfordates objectForKey:datestr];
    
    pLPrayerRequestListItem *pRequest = [prs objectAtIndex:indexPath.row];
    
    [cell configureView:pRequest inTableViewController:self];
    
    cell.requesttitle.text= [pLAppUtils fullnamefromEmail:pRequest.requestoremail];
    cell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
    cell.requestid = pRequest.requestid;
    cell.requestoremail = pRequest.requestoremail;
    cell.requesttext.text = pRequest.requesttext;
    cell.requeststats.text = [pLAppUtils calculaterequeststats:pRequest.praycount commentcount:pRequest.commentcount totalpraycount:pRequest.totalpraycount];
    
    NSString*groupnames=@"";

    cell.groupnames.text = groupnames;
    
    if([pRequest.iprayed intValue]>0){
        [cell.praybutton setHighlighted:YES];
    }
    else{
        [cell.praybutton setHighlighted:NO];
    }
    
    
    cell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
    
    
    return cell;
        

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    

    NSString*datestr = [visibledatesstr objectAtIndex:indexPath.section];
    
    NSArray*prs = [prayerrequestfordates objectForKey:datestr];
    
    pLPrayerRequestListItem *pRequest = [prs objectAtIndex:indexPath.row];
    NSString *text = pRequest.requesttext;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 19.0f);
    
    return height + 87;

}

-(void)buildTableSections{
    
    int x=0;
    hiddendatesstr = [[NSMutableArray alloc]init];
    hiddendates = [[NSMutableArray alloc]init];
    visibledates = [NSMutableArray arrayWithArray:loadeddates];
    visibledatesstr = [NSMutableArray arrayWithArray:loadeddatesstr];
    
    hiddendateindexes=[[NSMutableArray alloc]init];
    
    while(x<[loadeddatesstr count]){
        
        
        NSMutableArray*pl=[prayerrequestfordates objectForKey:[loadeddatesstr objectAtIndex:x]];
        
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
        
        
        if((pl==nil)&&(![(NSString*)[loadeddatesstr objectAtIndex:x] isEqualToString:[dateFormat2 stringFromDate:[[NSDate alloc]init]]])){
            [hiddendates addObject:[loadeddates objectAtIndex:x]];
            [hiddendatesstr addObject:[loadeddatesstr objectAtIndex:x]];
            [hiddendateindexes addObject:[NSNumber numberWithInt:x]];
        }

        x++;
    }
    if(!self.editing){
        [visibledates removeObjectsInArray:hiddendates];
        [visibledatesstr removeObjectsInArray:hiddendatesstr];
    }
    
    [listtableView reloadData];

    refreshing = NO;
}

-(void)addEmptyDates{
    
    [listtableView beginUpdates];
    
    int x=0;
    
    while(x<[hiddendateindexes count]){
        NSNumber*insertindex = (NSNumber*)[hiddendateindexes objectAtIndex:x];
        
        [visibledates insertObject:[hiddendates objectAtIndex:x] atIndex:[insertindex integerValue]];
        [visibledatesstr insertObject:[hiddendatesstr objectAtIndex:x] atIndex:[insertindex integerValue]];
        x++;
    }
    
    //[loadeddates addObjectsFromArray:hiddendates];
    //[loadeddatesstr addObjectsFromArray:hiddendatesstr];
    
    NSMutableIndexSet*set = [[NSMutableIndexSet alloc]init];
    
    for(NSNumber*n in hiddendateindexes){
        [set addIndex:[n integerValue]];
    }
    
    [listtableView insertSections:set withRowAnimation:UITableViewRowAnimationLeft];
    [listtableView endUpdates];
}

-(void)removeEmptyDates{
    
    [listtableView beginUpdates];
    NSMutableIndexSet*set = [[NSMutableIndexSet alloc]init];
    
    for(NSNumber*n in hiddendateindexes){
        [set addIndex:[n integerValue]];
    }
    
    [visibledates removeObjectsAtIndexes:set];
    [visibledatesstr removeObjectsAtIndexes:set];
    
    [listtableView deleteSections:set withRowAnimation:UITableViewRowAnimationLeft];
    [listtableView endUpdates];
}

-(IBAction)gototoday:(id)sender{
    
    [self scrolltotoday];
    
}

-(void)scrolltotoday{
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    
    CGRect sectionRect = [listtableView rectForSection:[visibledatesstr indexOfObject:[dateFormat2 stringFromDate:[[NSDate alloc]init]] ]];
    sectionRect.size.height = listtableView.frame.size.height;
    [listtableView scrollRectToVisible:sectionRect animated:YES];
}


- (IBAction) EditTable:(id)sender{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self removeEmptyDates];
        [listtableView setEditing:NO animated:NO];
        [listtableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self addEmptyDates];
        [listtableView setEditing:YES animated:YES];
        [listtableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        [self.view removeGestureRecognizer:self.slidingViewController.panGesture];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
     toIndexPath:(NSIndexPath *)toIndexPath {
    

    NSString*datestr = [loadeddatesstr objectAtIndex:fromIndexPath.section];
    NSMutableArray*items = (NSMutableArray*)[prayerrequestfordates objectForKey:datestr];
    
    pLPrayerRequestListItem*item = (pLPrayerRequestListItem*)[items objectAtIndex:fromIndexPath.row];
    
    
    NSString*destdate = [loadeddatesstr objectAtIndex:toIndexPath.section];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"YYYY-MM-dd"];
    item.scheduleddate = destdate;
    [items removeObject:item];
    
    if([items count]==0){
        [hiddendateindexes addObject:[NSNumber numberWithInt:fromIndexPath.section]];
        [hiddendatesstr addObject:datestr];
        [hiddendates addObject:[loadeddates objectAtIndex:[loadeddatesstr indexOfObject:datestr]]];
        [prayerrequestfordates removeObjectForKey:datestr];
    }
    
    if([hiddendatesstr containsObject:destdate]){
        [hiddendateindexes removeObject:[NSNumber numberWithInt:toIndexPath.section]];
        [hiddendatesstr removeObject:destdate];
        [hiddendates removeObject:[loadeddates objectAtIndex:[loadeddatesstr indexOfObject:datestr]]];
    }
    
    if([prayerrequestfordates objectForKey:[loadeddatesstr objectAtIndex:toIndexPath.section]]==nil){
        [prayerrequestfordates setObject:[[NSMutableArray alloc]init] forKey:[loadeddatesstr objectAtIndex:toIndexPath.section]];
    }
    
    items = (NSMutableArray*)[prayerrequestfordates objectForKey:[loadeddatesstr objectAtIndex:toIndexPath.section]];
    
    if(toIndexPath.row>0){
        [items insertObject:item atIndex:toIndexPath.row];
    }
    else
    {
        [items addObject:item];
    }
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Saving"];
    
    NSString *objectpath = @"schedule/move/";
    NSString *path = [objectpath stringByAppendingString:[item.scheduleitemid stringByAppendingString:[@"/" stringByAppendingString:item.scheduleddate]]];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                [pLAppUtils hideActivityIndicator];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicator];
                                              }];

    
    
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    NSNumber*contentOffset = [NSNumber numberWithInt:scrollView.contentOffset.y];
    NSNumber*contentHeight = [NSNumber numberWithInt:scrollView.contentSize.height];
    NSNumber*frameHeight = [NSNumber numberWithInt:scrollView.frame.size.height];
    
    NSLog(@"This is it: %@",[[contentOffset stringValue] stringByAppendingString:[@"-" stringByAppendingString:[[contentHeight stringValue] stringByAppendingString:[@"-" stringByAppendingString:[frameHeight stringValue]]]]]);
    
    if(!refreshing){

    if (((self.editing)||(!atend))&&(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height-100))) {
        
        refreshing = YES;
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:1];
        
        startdate  = [gregorian dateByAddingComponents:offsetComponents
                                                toDate:enddate options:0];
        
        
        NSDateComponents *offsetComponents2 = [[NSDateComponents alloc] init];
        [offsetComponents2 setDay:30];

        enddate = [gregorian dateByAddingComponents:offsetComponents2
                                             toDate:startdate options:0];
        
        [self loadPrayerRequestsforDateRange:startdate enddate:enddate withNotification:NO];
    }
        
        if (scrollView.contentOffset.y < -100) {
            
            refreshing = YES;
            
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
            [offsetComponents setDay:-1];
            
            enddate = [gregorian dateByAddingComponents:offsetComponents
                                                  toDate:startdate options:0];
            
            NSDateComponents *offsetComponents2 = [[NSDateComponents alloc] init];
            [offsetComponents2 setDay:-30];
            
            startdate = [gregorian dateByAddingComponents:offsetComponents2
                                                 toDate:enddate options:0];

            
            [self loadPrayerRequestsforDateRange:startdate enddate:enddate withNotification:NO];
        }
        
        
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
