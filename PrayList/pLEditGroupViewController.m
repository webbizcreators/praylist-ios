//
//  pLEditGroupViewController.m
//  PrayList
//
//  Created by Peter Opheim on 3/21/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLEditGroupViewController.h"
#import "pLAppUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "pLGroupMemberCell.h"

@interface pLEditGroupViewController ()

@end

@implementation pLEditGroupViewController

@synthesize group;

NSMutableArray *groupmembers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [groupmembers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"groupmember";
    
    pLGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    NSString * c;
    c = (NSString*)[groupmembers objectAtIndex:indexPath.row];
    cell.img.image = [pLAppUtils userimgFromEmail: c];
    cell.username.text = [pLAppUtils fullnamefromEmail:c];
    
    return cell;
    
}


-(IBAction)savebutton:(id)sender{
    
    //[spinner startAnimating];
    
    if(!group){
    
    pLGroup *gp = [[pLGroup alloc] init];
    
    gp.owneremail = [pLAppUtils securitytoken].email;
    gp.groupname = groupname.text;

    gp.groupmembers = groupmembers;
    
    [[RKObjectManager sharedManager] putObject:gp path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EditGroupViewControllerDismissed"
                                                                object:nil
                                                              userInfo:nil];
            //[spinner stopAnimating];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
                                       failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                           
                                           
                                       }];
        
    }
    else{
        
        
        pLGroup *gp = group;
        
        gp.groupname = groupname.text;
        gp.groupmembers = groupmembers;
        
        [[RKObjectManager sharedManager] postObject:gp path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
            
            if(mappingResult.array.count>0){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"EditGroupViewControllerDismissed"
                                                                    object:nil
                                                                  userInfo:nil];
                //[spinner stopAnimating];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        }
                                           failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                               
                                               
                                           }];
        
        
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background_iPhone5"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    generalsubview.layer.cornerRadius = 5.0;
    generalsubview.layer.masksToBounds = YES;
    
    if(group){
        groupname.text = group.groupname;
        groupmembers = [NSMutableArray arrayWithArray:group.groupmembers];
        if([group.grouptype isEqualToString:@"Personal"]){
            grouptypeicon.image = [UIImage imageNamed:@"personalgroupicon_title.png"];
            grouptypedescription.text = @"Personal Group";
        }else if([group.grouptype isEqualToString:@"Private"]){
            grouptypeicon.image = [UIImage imageNamed:@"privategroupicon_title.png"];
            grouptypedescription.text = @"Private Group";
        }else if([group.grouptype isEqualToString:@"Public"]){
            grouptypeicon.image = [UIImage imageNamed:@"publicgroupicon_title.png"];
            grouptypedescription.text = @"Public Group";
        }
       
    }
    else
    {
        groupmembers = [[NSMutableArray alloc]init];
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
                [groupmembers removeObjectAtIndex:indexPath.row];
                [groupmembertableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
