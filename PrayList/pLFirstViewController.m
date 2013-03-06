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

#define FONT_SIZE 11.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface pLFirstViewController ()

@end

@implementation pLFirstViewController


NSArray *prayerrequests;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self loadData];
    
}

-(void)loadData{
    
    NSString *objectpath = @"prayerrequests/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  prayerrequests = mappingResult.array;
                                                  
                                                  if(prayerrequests.count>0){
                                                      
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"requestdate"
                                                                                                    ascending:NO];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      prayerrequests = [prayerrequests sortedArrayUsingDescriptors:sortDescriptors];
                                                      
                                                      [tableView reloadData];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
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
    cell.requestdate.text = pRequest.requestdatetimeago;
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
    pLPrayerRequest *pRequest = [prayerrequests objectAtIndex:[indexPath row]];
    NSString *text = pRequest.requesttext;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2) + 70;
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



-(IBAction)refreshbutton:(id)sender{
    
    [self loadData];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
