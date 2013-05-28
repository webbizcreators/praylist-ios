//
//  pLRequestCommentViewController.m
//  PrayList
//
//  Created by Peter Opheim on 4/22/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLRequestCommentViewController.h"
#import "pLCommentCell.h"
#import "pLComment.h"
#import "pLAppUtils.h"
#import "pLPrayerRequestCell.h"
#import "pLPrayerListItemCell.h"

#define FONT_SIZE 11.0f
#define CELL_CONTENT_WIDTH 297.0f
#define CELL_CONTENT_MARGIN 24.0f

#define kReleaseToReloadStatus 0
#define kPullToReloadStatus 1
#define kLoadingStatus 2

#define kOFFSET_FOR_KEYBOARD_PORTRAIT 216.0
#define kOFFSET_FOR_KEYBOARD_LANDSCAPE 162.0


@interface pLRequestCommentViewController ()

@end

@implementation pLRequestCommentViewController

@synthesize prayerrequest;
@synthesize prayerrequestlistitem;

NSArray *comments;
BOOL stayup = NO;
BOOL isup = NO;

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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tableView addGestureRecognizer:tapGestureRecognizer];
    
    [self loadData:NO];
	// Do any additional setup after loading the view.
}


-(void)loadData:(BOOL*)scrolltobottom{
    
    NSString *path;
    
    if(prayerrequest){
        path = [@"prayerrequests/" stringByAppendingString:[[[prayerrequest.requestoremail stringByAppendingString:@"/"]
                                                             stringByAppendingString:prayerrequest.requestid]
                                                            stringByAppendingString:@"/comments"]];
    }
    else
    {
        path = [@"prayerrequests/" stringByAppendingString:[[[prayerrequestlistitem.requestoremail stringByAppendingString:@"/"]
                                                             stringByAppendingString:prayerrequestlistitem.requestid]
                                                            stringByAppendingString:@"/comments"]];
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  comments = mappingResult.array;
                                                  
                                                  if(comments.count>0){
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"commentdate"
                                                                                                   ascending:YES];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      comments = [comments sortedArrayUsingDescriptors:sortDescriptors];
                                                    
                                                  }
                                                  
                                                  [tableView reloadData];
                                                  
                                                  if(scrolltobottom){
                                                      NSIndexPath* ipath = [NSIndexPath indexPathForRow: comments.count inSection: 0];
                                                      [tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
                                                  }
                                                  
                                                  commentfield.text = NULL;
                                                  
                                                  [spinner stopAnimating];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger retval;
    retval = [comments count]+1;
    
    return retval;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    
    if( indexPath.row == 0 ) {
        if(prayerrequest){
            
            static NSString *CustomCellIdentifier = @"PrayerRequestCell";
            pLPrayerRequestCell *pcell = (pLPrayerRequestCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
            
            [pcell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            if (pcell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrayerRequestCellView" owner:self options:nil];
                
                for (id oneObject in nib)
                    if ([oneObject isKindOfClass:[pLPrayerRequestCell class]])
                        
                        pcell = (pLPrayerRequestCell *)oneObject;
                
                [pcell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                
            }
            
            pLPrayerRequest *pRequest = prayerrequest;
            
            pcell.requesttitle.text= [pLAppUtils fullnamefromEmail:pRequest.requestoremail];
            pcell.requesttext.text = pRequest.requesttext;
            pcell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
            pcell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
            pcell.requeststats.text = [pLAppUtils calculaterequeststats:pRequest.praycount commentcount:[NSNumber numberWithInt:0]];
            
            cell = pcell;
            
        }
        else
        {
            
            
            static NSString *CustomCellIdentifier = @"PrayerRequestListItemCell";
            pLPrayerListItemCell *picell = (pLPrayerListItemCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
            
            [picell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
            if (picell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrayerListItemCellView" owner:self options:nil];
                
                for (id oneObject in nib)
                    if ([oneObject isKindOfClass:[pLPrayerListItemCell class]])
                        
                        picell = (pLPrayerListItemCell *)oneObject;
                
                [picell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                
            }
            
            pLPrayerRequestListItem *pRequest = prayerrequestlistitem;
            
            picell.requesttitle.text= pRequest.requestoremail;
            picell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
            picell.requestid = pRequest.requestid;
            picell.requestoremail = pRequest.requestoremail;
            picell.requesttext.text = pRequest.requesttext;
            
            
            if([pRequest.iprayed isEqualToNumber:[NSNumber numberWithInt:1]]){
                [picell.praybutton setTitle:@"Prayed" forState:UIControlStateNormal];
                picell.praybutton.titleLabel.text = @"Prayed";
            }
            
            picell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
            
            cell = picell;
            
        }
        
    }
    else
    {
        
        static NSString *CustomCellIdentifier = @"CommentCell";
        pLCommentCell *ccell = (pLCommentCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
        
        [ccell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
        if (ccell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"pLCommentCellView" owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[pLCommentCell class]])
                    
                    ccell = (pLCommentCell *)oneObject;
            
            [ccell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            
        }
        
        pLComment *comment = [comments objectAtIndex:indexPath.row-1];
        
        //[cell configureView:pRequest inTableViewController:self];
        
        ccell.commenttitle.text= comment.email;
        ccell.commentdate.text = [pLAppUtils formatPostDate:comment.commentdate];
        ccell.commenttext.text = comment.commenttext;
        
        ccell.img.image = [pLAppUtils userimgFromEmail: comment.email];
        
        cell = ccell;
        
        
    }
    
    
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if( indexPath.row > 0 ) {
        pLComment *comment = [comments objectAtIndex:indexPath.row-1];
        NSString *text = comment.commenttext;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 19.0f);
        
        return height + 80;
    }
    else
    {
        if(prayerrequestlistitem){
            pLPrayerRequestListItem *pRequest = prayerrequestlistitem;
            NSString *text = pRequest.requesttext;
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 19.0f);
            
            return height + 110;
        }
        else
        {
            pLPrayerRequest *pRequest = prayerrequest;
            NSString *text = pRequest.requesttext;
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 19.0f);
            
            return height + 130;
            
        }
    }
}


-(IBAction)backButton:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)handleTap:(UITapGestureRecognizer*)tapRecognizer
{
    if(tapRecognizer.state == UIGestureRecognizerStateEnded)
    {
        
        //Figure out where the user tapped
        CGPoint p = [tapRecognizer locationInView:commentfield];
        CGRect textFieldBounds = commentfield.bounds;
        CGRect clearButtonBounds = CGRectMake(textFieldBounds.origin.x + textFieldBounds.size.width - 44, textFieldBounds.origin.y, 44, textFieldBounds.size.height);
        
        if(CGRectContainsPoint(clearButtonBounds, p))
            commentfield.text = @"";
        
        if(CGRectContainsPoint(textFieldBounds, p))
            return;
        
        [commentfield resignFirstResponder];
        //remove the tap gesture recognizer that was added.
        for(id element in tableView.gestureRecognizers)
        {
            if([element isKindOfClass:[UITapGestureRecognizer class]])
            {
                [tableView removeGestureRecognizer:element];
            }
        }
    }
}



-(IBAction)postCommentButton:(id)sender{

    
        [commentfield resignFirstResponder];
        [spinner startAnimating];
        

        
        pLComment *comm = [[pLComment alloc] init];
    
        
        comm.email = [pLAppUtils securitytoken].email;
        comm.commenttext = commentfield.text;
        comm.commentdate = [[NSDate alloc]init];
        if(prayerrequestlistitem){
            comm.requestid = prayerrequestlistitem.requestid;
            comm.requestemail = prayerrequestlistitem.requestoremail;
        }
        else
        {
            comm.requestid = prayerrequest.requestid;
            comm.requestemail = prayerrequest.requestoremail;
        }
    
        [[RKObjectManager sharedManager] putObject:comm path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
            
            if(mappingResult.array.count>0){
                
                if(prayerrequestlistitem){
                    prayerrequestlistitem.commentcount = [NSNumber numberWithFloat:([prayerrequestlistitem.commentcount floatValue] + [[NSNumber numberWithInt:1] floatValue])];
                }
                else{
                    prayerrequest.commentcount = [NSNumber numberWithFloat:([prayerrequest.commentcount floatValue] + [[NSNumber numberWithInt:1] floatValue])];
                }
                
                
                
                [spinner stopAnimating];
                [self loadData:YES];
                
            }
            
        }
                                           failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                               
                                               
                                           }];
        
    
    
}


- (void)keyboardWillHide:(NSNotification *)notif {
    [self setViewMoveUp:NO];
}


- (void)keyboardWillShow:(NSNotification *)notif{
    [self setViewMoveUp:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    stayup = YES;
    [self setViewMoveUp:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    stayup = NO;
    [self setViewMoveUp:NO];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMoveUp:(BOOL)moveUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    //TODO: Finish code to properly adjust orientation of keyboard and view in event of orientation change with keyboard open
    CGRect rect = self.view.frame;
    if (moveUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        
        if (isup == NO) {
            if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                rect.size.width -= kOFFSET_FOR_KEYBOARD_LANDSCAPE;
            }
            else if(self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
            {
                rect.size.width -= kOFFSET_FOR_KEYBOARD_LANDSCAPE;
                rect.origin.x += kOFFSET_FOR_KEYBOARD_LANDSCAPE;
            }
            else if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
            {
                rect.size.height -= kOFFSET_FOR_KEYBOARD_PORTRAIT;
            }
            isup = YES;
        }
        
    }
    else
    {
        if (stayup == NO) {
            if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                rect.size.width += kOFFSET_FOR_KEYBOARD_LANDSCAPE;
            }
            else if(self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
            {
                rect.size.width += kOFFSET_FOR_KEYBOARD_LANDSCAPE;
                rect.origin.x -= kOFFSET_FOR_KEYBOARD_LANDSCAPE;
            }
            else if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
            {
                rect.size.height += kOFFSET_FOR_KEYBOARD_PORTRAIT;
            }
            isup = NO;
        }
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}


- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        if(isup==YES){
            
        }
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        //load the landscape view
    }
}

@end
