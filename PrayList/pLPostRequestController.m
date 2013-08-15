//
//  pLPostRequestController.m
//  PrayList
//
//  Created by Peter Opheim on 2/19/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPostRequestController.h"
#import "pLAppUtils.h"
#import "pLPrayerRequestListItem.h"
#import "pLSelectGroupforPostViewController.h"
#import "pLGroupCell.h"
#import "pLGroup.h"
#import "pLGroupMemberCell.h"

@implementation pLPostRequestController

NSMutableArray *selectedgroups;
NSMutableArray *sourcegroups;
NSMutableArray *people;

UIImage*privateimg;
UIImage*publicimg;
BOOL isurgent = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isurgent=NO;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background_iPhone5"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
//    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    userImage.image = [pLAppUtils userimgFromEmail: [pLAppUtils securitytoken].email];
    selectedgroups = [[NSMutableArray alloc]init];
    
    privateimg = [UIImage imageNamed:@"privategroupicon.png"];
    publicimg = [UIImage imageNamed:@"publicgroupicon.png"];
    
    [self loadgroups];
    [self loadpeople];
    
    
    [requestText becomeFirstResponder];
    
}

-(void)loadgroups{
    NSString *objectpath = @"groups/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  sourcegroups = [[NSMutableArray alloc] initWithArray:mappingResult.array];
                                                  NSMutableArray *groupstodelete=[[NSMutableArray alloc]init];
                                                  
                                                  if(sourcegroups.count>0){
                                                      
                                                      
                                                      for(pLGroup*g in sourcegroups){
                                                          if(![g.groupmembers containsObject:[pLAppUtils securitytoken].email]){
                                                              [groupstodelete addObject:g];
                                                          }
                                                      }
                                                      
                                                      [sourcegroups removeObjectsInArray:groupstodelete];
                                                      
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupname"
                                                                                                   ascending:YES];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      sourcegroups = [[NSMutableArray alloc] initWithArray:[sourcegroups sortedArrayUsingDescriptors:sortDescriptors]];
                                                      
                                                      
                                                      
                                                      [tableView reloadData];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    
}

-(void)loadpeople{
    
    people = [NSMutableArray arrayWithArray:[pLAppUtils getcontacts]];
    
}

-(IBAction)cancelbutton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
 
}

-(IBAction)opengroups:(id)sender{
    
    tableView.hidden=NO;
    [requestText resignFirstResponder];
}


-(IBAction)seturgent:(id)sender{
    
    
    if(!isurgent){
        [urgentbutton setSelected:YES];
        isurgent = YES;
    }
    else{
        [urgentbutton setSelected:NO];
        isurgent = NO;
    }
    
}

-(IBAction)postbutton:(id)sender{
    
    pLGroup*g;
    pLPerson*p;
    NSMutableArray *groupids = [[NSMutableArray alloc]init];
    NSMutableArray *peopleids = [[NSMutableArray alloc]init];
    NSArray* selectedRows = [tableView indexPathsForSelectedRows];
    
    for (int i=0; (i<[selectedRows count]); ++i) {
        
        NSIndexPath *thisPath = [selectedRows objectAtIndex:i];
        NSInteger *selectedindex = thisPath.row;
        
        if(thisPath.section==0){
            g = (pLGroup*)[sourcegroups objectAtIndex:selectedindex];
            [groupids addObject:g.groupid];
        }else{
            p=(pLPerson*)[people objectAtIndex:selectedindex];
            [peopleids addObject:p.email];
        }
        
        
    }

    if(([groupids count]==0)&&(peopleids==0)){
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select at least one group or person to send this prayer request to." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
    
    }else
    {
        if([groupids count]==0)groupids=nil;
        if([peopleids count]==0)peopleids=nil;
        
        
    [pLAppUtils showActivityIndicatorWithMessage:@"Posting Prayer Request"];
        
            
    pLPrayerRequestListItem *pr = [[pLPrayerRequestListItem alloc] init];
    
    pr.requestoremail = [pLAppUtils securitytoken].email;
    pr.requesttext = requestText.text;
    pr.requestdate = [[NSDate alloc]init];
    pr.groupids = groupids;
    pr.senttoemails = peopleids;
        
    if(!isurgent){
        pr.requesttype=@"Normal";
    }
    else{
        pr.requesttype=@"Urgent";
    }
        
    [[RKObjectManager sharedManager] putObject:pr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        [pLAppUtils hideActivityIndicator];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
                                       failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                           
                                           [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                       }];
        
        
        
    }
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"openGroupPickerSegue"])
    {
        [requestText resignFirstResponder];
        // Get reference to the destination view controller
        pLSelectGroupforPostViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.destgroupArray = selectedgroups;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDismissGroupSelectViewController)
                                                     name:@"GroupSelectViewControllerDismissed"
                                                   object:nil];
    }
}


-(void)didDismissGroupSelectViewController{
    
    [tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return @"Groups";
    }else{
        return @"People";
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    if(section==0){
        return [sourcegroups count];
    }
    else{
        return [people count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0){
    static NSString *CellIdentifier = @"groupcollectioncell";
    
    pLGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    // Set the data for this cell:
    pLGroup * c;
    c = (pLGroup*)[sourcegroups objectAtIndex:indexPath.row];
    
    cell.groupname.text = c.groupname;
    cell.groupdesc.text = c.grouptype;
    
    if([c.grouptype isEqualToString:@"Private"]){
        cell.img.image = privateimg;
    }
    else if ([c.grouptype isEqualToString:@"Public"]){
        cell.img.image = publicimg;
    }
    
    
    return cell;
        
    }
    else{
        
        static NSString *CellIdentifier = @"groupmembercell";
        
        pLGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        
        // Set the data for this cell:
        pLPerson * c;
        c = (pLPerson*)[people objectAtIndex:indexPath.row];
        
        cell.username.text = c.fullname;
        cell.img.image = [pLAppUtils userimgFromEmail:c.email];
        cell.email = c.email;

        return cell;
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    tableViewCell.backgroundView.backgroundColor =[UIColor colorWithRed:171 green:217 blue:4 alpha:1];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    tableViewCell.backgroundView.backgroundColor =[UIColor whiteColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [requestText resignFirstResponder];
}

-(void)handleTap:(UITapGestureRecognizer*)tapRecognizer
{
    if(tapRecognizer.state == UIGestureRecognizerStateEnded)
    {
        
        //Figure out where the user tapped
        CGPoint p = [tapRecognizer locationInView:requestText];
        CGRect textFieldBounds = requestText.bounds;
        CGRect clearButtonBounds = CGRectMake(textFieldBounds.origin.x + textFieldBounds.size.width - 44, textFieldBounds.origin.y, 44, textFieldBounds.size.height);
        
        if(CGRectContainsPoint(clearButtonBounds, p))
            requestText.text = @"";
        
        if(CGRectContainsPoint(textFieldBounds, p))
            return;
        
        [requestText resignFirstResponder];
        //remove the tap gesture recognizer that was added.
//        for(id element in requestText.gestureRecognizers)
//        {
//            if([element isKindOfClass:[UITapGestureRecognizer class]])
//            {
//                [requestText removeGestureRecognizer:element];
//            }
//        }
    }
}


@end
