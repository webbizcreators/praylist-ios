//
//  pLPostRequestController.m
//  PrayList
//
//  Created by Peter Opheim on 2/19/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPostRequestController.h"
#import "pLAppUtils.h"
#import "pLPrayerRequest.h"
#import "pLSelectGroupforPostViewController.h"
#import "pLGroupCell.h"
#import "pLGroup.h"

@implementation pLPostRequestController

NSMutableArray *selectedgroups;

UIImage*privateimg;
UIImage*publicimg;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background_iPhone5"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    userImage.image = [pLAppUtils userimgFromEmail: [pLAppUtils securitytoken].email];
    selectedgroups = [[NSMutableArray alloc]init];
    
    privateimg = [UIImage imageNamed:@"privategroupicon.png"];
    publicimg = [UIImage imageNamed:@"publicgroupicon.png"];
    
}

-(IBAction)cancelbutton:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
 
}


-(IBAction)postbutton:(id)sender{
    
    if([selectedgroups count]==0){
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select at least one group or person to send this prayer request to." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
    
    }else
    {
        [pLAppUtils showActivityIndicatorWithMessage:@"Posting Prayer Request"];
    
    NSMutableArray *groupids = [[NSMutableArray alloc]init];
    
    for(pLGroup *cr in selectedgroups){
        [groupids addObject:cr.groupid];
    }
    
    pLPrayerRequest *pr = [[pLPrayerRequest alloc] init];
    
    pr.requestoremail = [pLAppUtils securitytoken].email;
    pr.requesttext = requestText.text;
    pr.requestdate = [[NSDate alloc]init];
    pr.groupids = groupids;
    
    [[RKObjectManager sharedManager] putObject:pr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostViewControllerDismissed"
                                                                object:nil
                                                              userInfo:nil];
            
            
        }
        
    }
                                       failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                           
                                           
                                       }];
        
        [self dismissModalViewControllerAnimated:YES];
        
    }
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"openGroupPickerSegue"])
    {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [selectedgroups count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"groupcollectioncell";
    
    pLGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[pLGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set the data for this cell:
    pLGroup * c;
    c = (pLGroup*)[selectedgroups objectAtIndex:indexPath.row];
    
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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
                
                
                [selectedgroups removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            
    }
}

@end
