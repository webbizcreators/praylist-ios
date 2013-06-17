//
//  pLViewRequestViewController.m
//  PrayList
//
//  Created by Peter Opheim on 6/6/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLViewRequestViewController.h"
#import "pLCommentCell.h"
#import "pLComment.h"
#import "pLAppUtils.h"
#import "pLPrayerRequestCell.h"
#import "pLPrayerListItemCell.h"
#import "pLViewPrayerButtonCell.h"
#import "pLViewPrayerStatsCell.h"

#define FONT_SIZE 11.0f
#define CELL_CONTENT_WIDTH 297.0f
#define CELL_CONTENT_MARGIN 24.0f

#define kReleaseToReloadStatus 0
#define kPullToReloadStatus 1
#define kLoadingStatus 2

#define kOFFSET_FOR_KEYBOARD_PORTRAIT 216.0
#define kOFFSET_FOR_KEYBOARD_LANDSCAPE 162.0

@interface pLViewRequestViewController ()

@end

@implementation pLViewRequestViewController

@synthesize prayerrequest;
@synthesize prayerrequestlistitem;

NSMutableArray *comments;
BOOL stayup2 = NO;
BOOL isup2 = NO;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background_iPhone5"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    
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
                                                  
                                                  comments = [NSMutableArray arrayWithArray:mappingResult.array];
                                                  
                                                  if(comments.count>0){
                                                      
                                                      NSSortDescriptor *sortDescriptor;
                                                      sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"commentdate"
                                                                                                   ascending:YES];
                                                      NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                      comments = [NSMutableArray arrayWithArray:[comments sortedArrayUsingDescriptors:sortDescriptors]];
                                                      
                                                  }
                                                  
                                                  [tableView reloadData];
                                                  
                                                  if(scrolltobottom){
                                                      NSIndexPath* ipath = [NSIndexPath indexPathForRow: comments.count inSection: 0];
                                                      [tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
                                                  }
                                                  
                                                  commentfield.text = NULL;
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                                                  
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
    NSInteger retval=[comments count]+3;
    return retval;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    
    if( indexPath.row == 0 ) {
        if(prayerrequest){
            
            static NSString *CustomCellIdentifier = @"PrayerRequestListItemCell";
            pLPrayerListItemCell *pcell = (pLPrayerListItemCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
            
            
            pLPrayerRequest *pRequest = prayerrequest;
            pcell.praybutton.hidden=YES;
            pcell.commentbutton.hidden=YES;
            pcell.requesttitle.text= [pLAppUtils fullnamefromEmail:pRequest.requestoremail];
            pcell.requesttext.text = pRequest.requesttext;
            pcell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
            pcell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
            pcell.requeststats.text = [pLAppUtils calculaterequeststats:pRequest.praycount commentcount:[NSNumber numberWithInt:0]];
            
            NSString*groupnames=@"";
            
            for(NSString*s in pRequest.groupids){
                if(![[pLAppUtils groupnamefromID:s] isEqualToString:@""]){
                    groupnames = [[groupnames stringByAppendingString:[pLAppUtils groupnamefromID:s]] stringByAppendingString:@", "];
                }
            }
            pcell.groupnames.text = groupnames;
            
            cell = pcell;
            
        }
        else
        {
            
            
            static NSString *CustomCellIdentifier = @"PrayerRequestListItemCell";
            pLPrayerListItemCell *picell = (pLPrayerListItemCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
            
            pLPrayerRequestListItem *pRequest = prayerrequestlistitem;
            picell.commentbutton.hidden=YES;
            picell.requesttitle.text= [pLAppUtils fullnamefromEmail:pRequest.requestoremail];
            picell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
            picell.requestid = pRequest.requestid;
            picell.requestoremail = pRequest.requestoremail;
            picell.requesttext.text = pRequest.requesttext;
            picell.requeststats.text = [pLAppUtils calculaterequeststats:pRequest.praycount commentcount:[NSNumber numberWithInt:0]];
            
            if([pRequest.iprayed isEqualToNumber:[NSNumber numberWithInt:1]]){
                [picell.praybutton setTitle:@"Prayed" forState:UIControlStateNormal];
                picell.praybutton.titleLabel.text = @"Prayed";
            }
            
            picell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
            
            cell = picell;
            
        }
        
    }
    else if (indexPath.row == 2){
        static NSString *CustomCellIdentifier = @"prayedforcell";
        pLViewPrayerStatsCell *pfcell = (pLViewPrayerStatsCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    
        NSString*prayedname;
        NSInteger*praycount;
        pfcell.statlabel.text =@"";
        if(prayerrequest){
            if([prayerrequest.peopleprayed count]>0){
            prayedname = [pLAppUtils fullnamefromEmail:[prayerrequest.peopleprayed objectAtIndex:0]];
            praycount = [prayerrequest.praycount integerValue]-1;
            if(praycount>0){
                pfcell.statlabel.text = [[[prayedname stringByAppendingString:@" and "] stringByAppendingString:[[NSNumber numberWithInt:praycount] stringValue]] stringByAppendingString:@" other people prayed"];
            }
            else{
                pfcell.statlabel.text = [prayedname stringByAppendingString:@" prayed for you"];
            }
            }
        }
        else{
            
            praycount = [prayerrequestlistitem.praycount integerValue];
            NSNumber*lesscount = [NSNumber numberWithInt:([[NSNumber numberWithInt:praycount] floatValue]-[[NSNumber numberWithInt:1] floatValue])];
            if(praycount>0){
                if([prayerrequestlistitem.iprayed isEqualToNumber:[NSNumber numberWithInt:1]]){
                    pfcell.statlabel.text = [@"You and " stringByAppendingString:[[lesscount stringValue] stringByAppendingString:@" people prayed"]];
                }
                else
                {
                    pfcell.statlabel.text = [[[NSNumber numberWithInt:praycount]stringValue] stringByAppendingString:@" people prayed"];
                }
            }
    else{
        pfcell.statlabel.text = @"No one has prayed yet.";
    }
        }

        cell = pfcell;
    
    }
else if (indexPath.row == 1){
    static NSString *CustomCellIdentifier = @"prayerbuttonscell";
    pLViewPrayerButtonCell *pfcell = (pLViewPrayerButtonCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    
    if(prayerrequestlistitem){
        
        pfcell.listitem=prayerrequestlistitem;
        
        if([prayerrequestlistitem.iprayed isEqualToNumber:[NSNumber numberWithInt:1]]){
            [pfcell.praybutton setHighlighted:YES];
        }
        else{
            [pfcell.praybutton setHighlighted:NO];
        }
        
    }
    
    cell = pfcell;
    
}


    else
    {
        
        static NSString *CustomCellIdentifier = @"CommentCell";
        pLCommentCell *ccell = (pLCommentCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
        
        pLComment *comment = [comments objectAtIndex:indexPath.row-3];
        
        //[cell configureView:pRequest inTableViewController:self];
        
        ccell.commenttitle.text= [pLAppUtils fullnamefromEmail:comment.email];
        ccell.commentdate.text = [pLAppUtils formatPostDate:comment.commentdate];
        ccell.commenttext.text = comment.commenttext;
        
        ccell.img.image = [pLAppUtils userimgFromEmail: comment.email];
        
        cell = ccell;
        
        
    }
    
    
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if( indexPath.row > 2 ) {
        pLComment *comment = [comments objectAtIndex:indexPath.row-3];
        NSString *text = comment.commenttext;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 19.0f);
        
        return height + 80;
    }
    else if (indexPath.row ==1){
        return 44;
    }
    else if (indexPath.row ==2){
        return 30;
    }
    else
    {
        if(prayerrequestlistitem){
            pLPrayerRequestListItem *pRequest = prayerrequestlistitem;
            NSString *text = pRequest.requesttext;
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 19.0f);
            
            return height + 130;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL retval=NO;
    
    if(indexPath.row>2){retval=YES;}
    
    return retval;
    
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
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Posting Comment"];
    [commentfield resignFirstResponder];
    
    
    
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
            

            [self loadData:YES];
            
            
        }
        
    }
                                       failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                           
                                           [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                       }];
    
    
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [pLAppUtils showActivityIndicatorWithMessage:@"Deleting"];
        pLComment *comm = [comments objectAtIndex:indexPath.row-3];
        
        [[RKObjectManager sharedManager] deleteObject:comm path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
            
            if(mappingResult.array.count>0){
                
                [pLAppUtils hideActivityIndicatorWithMessage:@"Done"];
                [comments removeObjectAtIndex:indexPath.row-3];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
        }
                                              failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                                  
                                                  [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                              }];
    }
}



- (void)keyboardWillHide:(NSNotification *)notif {
    [self setViewMoveUp:NO];
}


- (void)keyboardWillShow:(NSNotification *)notif{
    [self setViewMoveUp:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    stayup2 = YES;
    [self setViewMoveUp:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    stayup2 = NO;
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
        
        if (isup2 == NO) {
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
            isup2 = YES;
        }
        
    }
    else
    {
        if (stayup2 == NO) {
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
            isup2 = NO;
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
        if(isup2==YES){
            
        }
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        //load the landscape view
    }
}

@end
