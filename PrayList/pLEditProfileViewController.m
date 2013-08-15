//
//  pLEditProfileViewController.m
//  PrayList
//
//  Created by Peter Opheim on 7/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLEditProfileViewController.h"
#import "pLAppUtils.h"
#import "pLUser.h"
#import "ECSlidingViewController.h"
#import "pLSideMenuViewController.h"
#import "pLEditProfileValueViewController.h"

@interface pLEditProfileViewController ()

@end

@implementation pLEditProfileViewController

pLUser*user;
NSString*mode;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    UITableView *tableView = (UITableView*)self.view;
    tableView.backgroundView = imageView;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    [self loadProfile];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[pLSideMenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightPeekAmount:80.0f];
    
}


-(void)loadProfile{
    
    NSString *basepath = [RKObjectManager sharedManager].baseURL.absoluteString;
    
    NSString *imagepath = [basepath stringByAppendingString:[@"pictures/userimage/" stringByAppendingString: [pLAppUtils securitytoken].email]];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:imagepath]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [theRequest setHTTPMethod:@"GET"];
    [theRequest setValue:[pLAppUtils securitytoken].tokenId forHTTPHeaderField:@"securitytoken"];
    [theRequest setValue:[pLAppUtils securitytoken].email forHTTPHeaderField:@"securityemail"];
    
    
    NSData*serverData = [NSURLConnection sendSynchronousRequest:theRequest
                                              returningResponse:nil error:nil];
    
    [profilepic setImage:[UIImage imageWithData:serverData]];
    
    
    NSString *path = [@"users/" stringByAppendingString:[pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  user = (pLUser*)mappingResult.firstObject;
                                                  emailaddress.text = user.emailaddress;
                                                  fullname.text = user.fullname;
                                                  description.text = user.description;
                                                  orgname.text = user.orgid;
                                                  
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if((indexPath.row==0)&&(indexPath.section==0)){
    
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose from Library", nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
        [popupQuery showInView:self.view];
        
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            //imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            
            [imagePicker setShowsCameraControls:YES];
            [imagePicker setAllowsEditing:YES];
            
            [self presentModalViewController:imagePicker animated:YES];
        }
    }else if(buttonIndex==1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            //imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            
            [imagePicker setAllowsEditing:YES];
            
            [self presentModalViewController:imagePicker animated:YES];
        }
    }
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    CGSize imagesize = CGSizeMake(320, 320);
    
    UIImage *image = [self imageWithImage:[info objectForKey:UIImagePickerControllerEditedImage] scaledToSize:imagesize];
    
    NSString *basepath = [RKObjectManager sharedManager].baseURL.absoluteString;
    
    NSString *imagepath = [basepath stringByAppendingString:[@"pictures/userimage/" stringByAppendingString: [pLAppUtils securitytoken].email]];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:imagepath]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:[pLAppUtils securitytoken].tokenId forHTTPHeaderField:@"securitytoken"];
    [theRequest setValue:[pLAppUtils securitytoken].email forHTTPHeaderField:@"securityemail"];
    [theRequest setHTTPBody:[NSData dataWithData:UIImageJPEGRepresentation(image,0.25)]];
    
    NSData*serverData = [NSURLConnection sendSynchronousRequest:theRequest
                          returningResponse:nil error:nil];

    [profilepic setImage:image];
    [pLAppUtils setuserimgforEmail:[pLAppUtils securitytoken].email image:image];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"editemail"])
    {
        pLEditProfileValueViewController *vc = [segue destinationViewController];
        vc.editvalue = emailaddress.text;
        vc.vc = self;
        vc.navigationItem.title = @"Email Address";
        mode = @"editemail";
    }
    else if ([[segue identifier] isEqualToString:@"editname"])
    {
        pLEditProfileValueViewController *vc = [segue destinationViewController];
        vc.editvalue = fullname.text;
        vc.vc = self;
        vc.navigationItem.title = @"Name";
        mode = @"editname";
    }
    else if ([[segue identifier] isEqualToString:@"editdescription"])
    {
        pLEditProfileValueViewController *vc = [segue destinationViewController];
        vc.editvalue = description.text;
        vc.vc = self;
        vc.navigationItem.title = @"Description";
        mode = @"editdescription";
    }
        
}

-(void)updatevaluetostring:(NSString*)value{
    
    if([mode isEqualToString:@"editmail"]){
        emailaddress.text = value;
        user.emailaddress = value;
    }else if([mode isEqualToString:@"editname"]){
        fullname.text = value;
        user.fullname = value;
        [pLAppUtils setpersonforEmail:[pLAppUtils securitytoken].email person:user];
    }else if([mode isEqualToString:@"editdescription"]){
        description.text = value;
        user.description = value;
    }
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Saving"];
    
    [[RKObjectManager sharedManager] postObject:user path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
        
    }
                                       failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                           [pLAppUtils showActivityIndicatorWithMessage:@"Failed"];
                                           
                                       }];

    
    
}


@end
