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
#import "pLSelectCircleforPostViewController.h"
#import "pLCircleCollectionCell.h"
#import "plCircle.h"

@implementation pLPostRequestController

NSMutableArray *sourcecircles;
NSMutableArray *selectedcircles;
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
    selectedcircles = [[NSMutableArray alloc]init];
    [self getcircles];
    
}

-(IBAction)cancelbutton:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
 
}

-(void)getcircles{
    
    
    NSString *objectpath = @"circles/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

                                                  sourcecircles = [[NSMutableArray alloc] initWithArray:mappingResult.array];
                                                  
                                                  
                                                  if(sourcecircles.count>0){
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"circlename"
                                                                                                   ascending:YES];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      sourcecircles = [[NSMutableArray alloc] initWithArray:[sourcecircles sortedArrayUsingDescriptors:sortDescriptors]];
                                                      [spinner stopAnimating];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
    
    
}


-(IBAction)postbutton:(id)sender{
    
    [spinner startAnimating];
    
    NSMutableArray *circlenames = [[NSMutableArray alloc]init];
    
    for(pLCircle *cr in selectedcircles){
        [circlenames addObject:cr.circlename];
    }
    
    pLPrayerRequest *pr = [[pLPrayerRequest alloc] init];
    
    pr.requestoremail = [pLAppUtils securitytoken].email;
    pr.requesttext = requestText.text;
    pr.requestdate = [[NSDate alloc]init];
    pr.circlenames = circlenames;
    
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
    if ([[segue identifier] isEqualToString:@"openCirclePickerSegue"])
    {
        // Get reference to the destination view controller
        pLSelectCircleforPostViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.destcircleArray = selectedcircles;
        vc.sourcecircles = sourcecircles;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDismissCircleSelectViewController)
                                                     name:@"CircleSelectViewControllerDismissed"
                                                   object:nil];
    }
}


-(void)didDismissCircleSelectViewController{
    
    [circleView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

    return [selectedcircles count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (pLCircleCollectionCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [circleView registerClass:[pLCircleCollectionCell class] forCellWithReuseIdentifier:@"circlesCell"];
    [circleView registerNib:[UINib nibWithNibName:@"pLCircleCollectionCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"circlesCell"];
    
    
    pLCircleCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"circlesCell" forIndexPath:indexPath];
    
    pLCircle *cc = [selectedcircles objectAtIndex:indexPath.row];
    
    cell.title.text = cc.circlename;
    //cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    pLCircle *cc = [selectedcircles objectAtIndex:indexPath.row];
    NSNumber *charlength = [NSNumber numberWithInt:[cc.circlename length]];
    CGSize retval;
    retval.height = 20;
    retval.width = [charlength floatValue] * [[NSNumber numberWithInt:8] floatValue];
    return retval;
}

@end
