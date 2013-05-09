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
#import "pLGroupCollectionCell.h"
#import "pLGroup.h"

@implementation pLPostRequestController

NSMutableArray *sourcegroups;
NSMutableArray *selectedgroups;
UIActivityIndicatorView *spinner;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background_iPhone5"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    spinner = [pLAppUtils addspinnertoview:self.view];
    userImage.image = [pLAppUtils userimgFromEmail: [pLAppUtils securitytoken].email];
    selectedgroups = [[NSMutableArray alloc]init];
    [self getgroups];
    
}

-(IBAction)cancelbutton:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
 
}

-(void)getgroups{
    
    
    NSString *objectpath = @"groups/p/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

                                                  sourcegroups = [[NSMutableArray alloc] initWithArray:mappingResult.array];
                                                  
                                                  
                                                  if(sourcegroups.count>0){
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupname"
                                                                                                   ascending:YES];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      sourcegroups = [[NSMutableArray alloc] initWithArray:[sourcegroups sortedArrayUsingDescriptors:sortDescriptors]];
                                                      [spinner stopAnimating];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
    
    
}


-(IBAction)postbutton:(id)sender{
    
    [spinner startAnimating];
    
    NSMutableArray *groupnames = [[NSMutableArray alloc]init];
    
    for(pLGroup *cr in sourcegroups){
        [groupnames addObject:cr.groupname];
    }
    
    pLPrayerRequest *pr = [[pLPrayerRequest alloc] init];
    
    pr.requestoremail = [pLAppUtils securitytoken].email;
    pr.requesttext = requestText.text;
    pr.requestdate = [[NSDate alloc]init];
    pr.groupnames = groupnames;
    
    [[RKObjectManager sharedManager] putObject:pr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostViewControllerDismissed"
                                                                object:nil
                                                              userInfo:nil];
            [spinner stopAnimating];
            [self dismissModalViewControllerAnimated:YES];
            
        }
        
    }
                                       failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                           
                                           
                                       }];
    
    
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
        vc.sourcegroups = sourcegroups;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDismissGroupSelectViewController)
                                                     name:@"GroupSelectViewControllerDismissed"
                                                   object:nil];
    }
}


-(void)didDismissGroupSelectViewController{
    
    [groupView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

    return [selectedgroups count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (pLGroupCollectionCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [groupView registerClass:[pLGroupCollectionCell class] forCellWithReuseIdentifier:@"groupsCell"];
    [groupView registerNib:[UINib nibWithNibName:@"pLGroupCollectionCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"groupsCell"];
    
    
    pLGroupCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"groupsCell" forIndexPath:indexPath];
    
    pLGroup *cc = [selectedgroups objectAtIndex:indexPath.row];
    
    cell.title.text = cc.groupname;
    //cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    pLGroup *cc = [selectedgroups objectAtIndex:indexPath.row];
    NSNumber *charlength = [NSNumber numberWithInt:[cc.groupname length]];
    CGSize retval;
    retval.height = 20;
    retval.width = [charlength floatValue] * [[NSNumber numberWithInt:8] floatValue];
    return retval;
}

@end
