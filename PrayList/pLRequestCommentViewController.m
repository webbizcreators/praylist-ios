//
//  pLRequestCommentViewController.m
//  PrayList
//
//  Created by Peter Opheim on 4/22/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLRequestCommentViewController.h"

@interface pLRequestCommentViewController ()

@end

@implementation pLRequestCommentViewController

NSArray *comments;

- (void)viewDidLoad
{
    [super viewDidLoad];
    comments = [[NSArray init]alloc];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [comments count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"PrayerRequestListItemCell";
    pLPrayerListItemCell *cell = (pLPrayerListItemCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier]; // typecast to customcell
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PrayerListItemCellView" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[pLPrayerListItemCell class]])
                
                cell = (pLPrayerListItemCell *)oneObject;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
    }
    
    pLPrayerRequestListItem *pRequest = [prayerrequests2 objectAtIndex:indexPath.row];
    
    [cell configureView:pRequest inTableViewController:self];
    
    cell.requesttitle.text= pRequest.requestoremail;
    cell.requestdate.text = [pLAppUtils formatPostDate:pRequest.requestdate];
    cell.requestid = pRequest.requestid;
    cell.requestoremail = pRequest.requestoremail;
    cell.requesttext.text = pRequest.requesttext;
    
    if([pRequest.iprayed isEqualToNumber:[NSNumber numberWithInt:1]]){
        [cell.praybutton setTitle:@"Prayed" forState:UIControlStateNormal];
        cell.praybutton.titleLabel.text = @"Prayed";
    }
    
    cell.img.image = [pLAppUtils userimgFromEmail: pRequest.requestoremail];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    pLPrayerRequestListItem *pRequest = [prayerrequests2 objectAtIndex:[indexPath row]];
    NSString *text = pRequest.requesttext;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 19.0f);
    
    return height + 110;
}

@end
