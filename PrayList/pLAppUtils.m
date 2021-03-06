//
//  pLAppUtils.m
//  PrayList
//
//  Created by Peter Opheim on 2/7/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLAppUtils.h"
#import "pLPrayerRequestListItem.h"
#import "pLPrayerRequest.h"
#import "pLLoginRequest.h"
#import "pLLoginResponse.h"
#import "pLGroup.h"
#import "pLPerson.h"
#import "pLResponse.h"
#import "pLComment.h"
#import "pLNotification.h"
#import "pLNotificationCount.h"
#import "pLAppDelegate.h"
#import "MBProgressHUD.h"
#import "pLNotificationsPopupViewController.h"
#import "FPPopoverController.h"
#import "pLRequestCommentViewController.h"
#import "pLuser.h"
#import "pLPasswordUpdateRequest.h"
#import "pLDrawerController.h"
#import "KeychainItemWrapper.h"

@implementation pLAppUtils

pLSecurityToken* st = nil;
NSMutableDictionary *userImages;
NSMutableDictionary *contacts;
NSMutableDictionary *groups;
NSMutableArray *notifications;
NSNumber *notifcount;
NSString *dt = @"";
FPPopoverController *popover;

BOOL groupsloaded=NO;
BOOL peopleloaded=NO;

UIView*v;
MBProgressHUD *hud;
KeychainItemWrapper *keychainItem;

+(NSArray*)getcontacts{
    NSArray*contactsarray = [contacts allValues];
    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullname"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    contactsarray = [NSMutableArray arrayWithArray:[contactsarray sortedArrayUsingDescriptors:sortDescriptors]];
    
    return contactsarray;
    
}

+(NSString*)devicetoken
{
    return dt;
}

+(void)setDeviceToken:(NSString *)dtt
{
    dt = dtt;
}


+(NSNumber*)notifcount
{
    return notifcount;
}

+(void)setNotifCount:(NSNumber *)dtt
{
    notifcount = dtt;
}




+(pLSecurityToken*) securitytoken
{
    return st;
}

+(void)setSecurityToken:(pLSecurityToken *)stt
{
    st = stt;
}


+(NSString*)formatPostDate:(NSDate*)date
{
    if(date!=NULL){
    NSDate *cur_time = [[NSDate alloc]init];
    
    NSTimeInterval timeint = [cur_time timeIntervalSinceDate:date];
    int diff = timeint;
    
    NSArray *phrase = [[NSArray alloc] initWithObjects:@"second",@"minute",@"hour",@"day",@"week",@"month",@"year",@"decade", nil];
    
    NSArray *lgth = [[NSArray alloc] initWithObjects:
                       [NSNumber numberWithInt:1],
                       [NSNumber numberWithInt:60],
                       [NSNumber numberWithInt:3600],
                       [NSNumber numberWithInt:86400],
                       [NSNumber numberWithInt:604800],
                       [NSNumber numberWithInt:2630880],
                       [NSNumber numberWithInt:31570560],
                       [NSNumber numberWithInt:315705600], nil];
    

    float no = 0;
    int i = 0;
    
    for (i=([lgth count]-1); ((i>=0)&&((diff/[(NSNumber*)[lgth objectAtIndex:i] floatValue])<=1)); --i) {
        
    }
        
    if(i<0){i=0;}
    
    no = diff/[(NSNumber*)[lgth objectAtIndex:i] floatValue];

    NSString *phrasestr = nil;
    no = floor(no);

    
    phrasestr = [phrase objectAtIndex: i];
    
    if(no!=1){
        
        phrasestr = [phrasestr stringByAppendingString:@"s"];
    }
    
    NSNumber *no2 = [NSNumber numberWithFloat:no];
         
    NSString *value = [NSString stringWithFormat:@"%@ ",no2];
    value = [value stringByAppendingString: phrasestr];
    

    
        return [value stringByAppendingString:@" ago"];
        //return value;
    }
    else
    {
        return @"?";
    }
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //return [dateFormatter stringFromDate:date];
    
}




+(void)registerObjectMappings{
    
    NSMutableIndexSet *datastatuscodes = [NSMutableIndexSet indexSetWithIndex:200];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    // Set it Globally
    [RKObjectMapping setPreferredDateFormatter:dateFormatter];
    
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    
    
    
    //pLPrayerRequestListItem ********************************************
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[pLPrayerRequestListItem class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"requestdate":@"requestdate",
     @"requestid": @"requestid",
     @"requestoremail": @"requestoremail",
     @"requesttext": @"requesttext",
     @"groupids": @"groupids",
     @"praycount": @"praycount",
     @"totalpraycount": @"totalpraycount",
     @"peopleprayed": @"peopleprayed",
     @"answer": @"answer",
     @"commentcount": @"commentcount",
     @"startplanon": @"startplanon",
     @"prayinterval": @"prayinterval",
     @"iprayed":@"iprayed",
     @"scheduleddate": @"scheduleddate",
     @"lastupdateddate": @"lastupdateddate",
     @"senttoemails": @"senttoemails",
     @"requesttype": @"requesttype",
     @"scheduleitemid": @"scheduleitemid",
     }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                       pathPattern:@"lists/myprayerlist/:email"
                                                                                           keyPath: nil
                                                                                       statusCodes:datastatuscodes];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                       pathPattern:@"schedule/:email"
                                                                                           keyPath: nil
                                                                                       statusCodes:datastatuscodes];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:@"lists/:email/:requestid"
                                                                                           keyPath: nil
                                                                                       statusCodes:datastatuscodes];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"prayerrequests/answer/:email/:requestid"
                                                                     keyPath: nil
                                                                 statusCodes:datastatuscodes];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"prayerrequests"
                                                                     keyPath: nil
                                                                 statusCodes:datastatuscodes];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"requestdate":@"requestdate",
     @"requestid": @"requestid",
     @"requestoremail": @"requestoremail",
     @"requesttext": @"requesttext",
     @"groupids": @"groupids",
     @"peopleprayed": @"peopleprayed",
     @"answer": @"answer",
     @"commentcount": @"commentcount",
     @"startplanon": @"startplanon",
     @"prayinterval": @"prayinterval",
     @"iprayed":@"iprayed",
     @"scheduleddate": @"scheduleddate",
     @"lastupdateddate": @"lastupdateddate",
     @"senttoemails": @"senttoemails",
     @"requesttype": @"requesttype",
     @"scheduleitemid": @"scheduleitemid",
     }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[pLPrayerRequestListItem class]
                                                                                   rootKeyPath: nil];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLPrayerRequestListItem class]
                                             pathPattern:@"prayerrequests/d/:requestoremail/:requestid"
                                             method:RKRequestMethodDELETE]] ;
    
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLPrayerRequestListItem class]
                                             pathPattern:@"prayerrequests"
                                             method:RKRequestMethodPUT]] ;
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLPrayerRequestListItem class]
                                             pathPattern:@"prayerrequests/:requestoremail/:requestid"
                                             method:RKRequestMethodPOST]] ;
    
    
    //******************************************************************
    
    
    
    
    
    
    //pLLoginRequest ******************************************************************
    
    requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"password": @"password",
     @"devicetoken": @"devicetoken",
     }];
    
    
    requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[pLLoginRequest class]
                                                                                   rootKeyPath: nil];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLLoginRequest class]
                                             pathPattern:@"tokens/getlogintoken"
                                             method:RKRequestMethodPOST]] ;
    
    
    //******************************************************************
    
    
    //pLPasswordUpdateRequest ******************************************************************
    
    requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"oldpassword": @"oldpassword",
     @"newpassword": @"newpassword",
     }];
    
    
    requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                              objectClass:[pLPasswordUpdateRequest class]
                                                              rootKeyPath: nil];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLPasswordUpdateRequest class]
                                             pathPattern:@"users/changepassword/:email"
                                             method:RKRequestMethodPOST]] ;
    
    
    //******************************************************************

    
    
    
    
    
    //pLLoginResponse ******************************************************************
    
    
    RKObjectMapping* securityTokenMapping = [RKObjectMapping mappingForClass:[pLSecurityToken class]];
    
    [securityTokenMapping addAttributeMappingsFromDictionary:@{
     @"tokenId": @"tokenId",
     @"dateCode": @"dateCode",
     @"email": @"email",
     @"orgid": @"orgid",
     }];
    
    RKObjectMapping* loginResponseMapping = [RKObjectMapping mappingForClass:[pLLoginResponse class]];
    
    [loginResponseMapping addAttributeMappingsFromDictionary:@{
     @"errordescription": @"errordescription",
     @"errorcode": @"errorcode",
     }];
    
    
    [loginResponseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"securitytoken"
                                                                                   toKeyPath:@"securitytoken"
                                                                                 withMapping:securityTokenMapping]];
    
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:loginResponseMapping
                                                                 pathPattern:@"tokens/getlogintoken"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    // ******************************************************************

    
    //pLGroup ********************************************
    responseMapping = [RKObjectMapping mappingForClass:[pLGroup class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"owneremail": @"owneremail",
     @"groupname": @"groupname",
     @"groupdescription": @"groupdescription",
     @"groupmembers": @"groupmembers",
     @"grouptype": @"grouptype",
     @"orgid": @"orgid",
     @"groupid": @"groupid",
     @"invitees": @"invitees",
     @"requestors": @"requestors",
     @"notifyall": @"notifyall",
     @"notifyurgent": @"notifyurgent",
     }];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"groups/p/:owneremail/:groupname"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"groups/org/:orgid/:groupname"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"groups/:owneremail"
                                                                     keyPath: nil
                                                                 statusCodes:datastatuscodes];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"groups/org/:orgid"
                                                                     keyPath: nil
                                                                 statusCodes:datastatuscodes];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"groups"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    
    requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"owneremail": @"owneremail",
     @"groupname": @"groupname",
     @"groupdescription": @"groupdescription",
     @"groupmembers": @"groupmembers",
     @"grouptype": @"grouptype",
     @"orgid": @"orgid",
     @"groupid": @"groupid",
     @"invitees": @"invitees",
     @"requestors": @"requestors",
     }];
    
    
    requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                              objectClass:[pLGroup class]
                                                              rootKeyPath: nil];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLGroup class]
                                             pathPattern:@"groups"
                                             method:RKRequestMethodPUT]] ;
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLGroup class]
                                             pathPattern:@"groups"
                                             method:RKRequestMethodPOST]] ;
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLGroup class]
                                             pathPattern:@"groups/:orgid/:groupid"
                                             method:RKRequestMethodDELETE]] ;
    
    
    //******************************************************************
    

    //pLPerson ********************************************
    responseMapping = [RKObjectMapping mappingForClass:[pLPerson class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"fullname": @"fullname",
     @"orgid": @"orgid",
     @"description": @"description",
     }];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"lists/mycontacts/:owneremail"
                                                                     keyPath: nil
                                                                 statusCodes:datastatuscodes];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    //*****************************************************
    
    //pLUser ********************************************
    responseMapping = [RKObjectMapping mappingForClass:[pLUser class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"fullname": @"fullname",
     @"orgid": @"orgid",
     @"description": @"description",
     @"emailaddress": @"emailaddress",
     }];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"users/:email"
                                                                     keyPath: nil
                                                                 statusCodes:datastatuscodes];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"fullname": @"fullname",
     @"orgid": @"orgid",
     @"description": @"description",
     @"emailaddress": @"emailaddress",
     }];
    
    
    requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                              objectClass:[pLUser class]
                                                              rootKeyPath: nil];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLUser class]
                                             pathPattern:@"users/:email"
                                             method:RKRequestMethodPOST]];
    
    
    //*****************************************************
    
    
    //pLResponse ********************************************
    responseMapping = [RKObjectMapping mappingForClass:[pLResponse class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"status": @"status",
     @"description": @"description",
     }];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"prayerrequests/prayfor/:email/:requestid"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"prayerrequests/unprayfor/:email/:requestid"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"users/changepassword/:email"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    responseMapping = [[RKObjectMapping alloc]init];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"prayerrequests/d/:email/:requestid"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:204]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    //*****************************************************
    
    
    
    
    //pLComment ********************************************
    responseMapping = [RKObjectMapping mappingForClass:[pLComment class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"requestemail": @"requestemail",
     @"requestid": @"requestid",
     @"commentid": @"commentid",
     @"commenttext": @"commenttext",
     @"commentdate": @"commentdate",
     }];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"prayerrequests/:requestemail/:requestid/comments"
                                                                     keyPath: nil
                                                                 statusCodes:datastatuscodes];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    
    requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"requestemail": @"requestemail",
     @"requestid": @"requestid",
     @"commentid": @"commentid",
     @"commenttext": @"commenttext",
     @"commentdate": @"commentdate",
     }];
    
    
    requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                              objectClass:[pLComment class]
                                                              rootKeyPath: nil];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLComment class]
                                             pathPattern:@"prayerrequests/:requestemail/:requestid/comments"
                                             method:RKRequestMethodPUT]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLComment class]
                                             pathPattern:@"prayerrequests/:requestemail/:requestid/comments/:commentid"
                                             method:RKRequestMethodDELETE]];
    
    
    
    
    //******************************************************************
    
    
    //pLNotification ********************************************
    responseMapping = [RKObjectMapping mappingForClass:[pLNotification class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"notificationdate": @"notificationdate",
     @"notiftext": @"notiftext",
     @"entityid": @"entityid",
     @"requestoremail": @"requestoremail",
     @"openedflag": @"openedflag",
     @"fromemail": @"fromemail",
     @"notiftype": @"notiftype",
     }];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"notifications/:email"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    //*************************************************************
    
    
    
    //pLNotificationCount ********************************************
    responseMapping = [RKObjectMapping mappingForClass:[pLNotificationCount class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"count": @"count",
     }];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"notifications/:email/count"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    //*************************************************************
    
    
    
    
    
}


+(void)performloginwithEmail:(NSString*)email password:(NSString*)password savelogin:(BOOL)savelogin fromauto:(BOOL)fromauto{
    
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"PrayListLogin" accessGroup:nil];
    
    pLAppDelegate *appDelegate = (pLAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    [pLAppUtils showActivityIndicatorWithMessage:@"Logging In"];
    pLLoginRequest *lr = [[pLLoginRequest alloc] init];
    
    lr.email = email;
    lr.password = password;
    lr.devicetoken = [pLAppUtils devicetoken];
    
    [[RKObjectManager sharedManager] postObject:lr path: nil parameters: nil success:^( RKObjectRequestOperation *operation , RKMappingResult *mappingResult){
        
        if(mappingResult.array.count>0){
            
            pLLoginResponse *lr = (pLLoginResponse*)mappingResult.firstObject;
            if([lr.errordescription isEqualToString:@"Login Succeeded"]){
                [pLAppUtils setSecurityToken: lr.securitytoken];
                NSDictionary *headers = [RKObjectManager sharedManager].defaultHeaders;
                [headers setValue:[pLAppUtils securitytoken].tokenId forKey:@"securitytoken"];
                [headers setValue:[pLAppUtils securitytoken].email forKey:@"securityemail"];
                
                if(savelogin){
                    [keychainItem setObject:password forKey:(__bridge id)kSecValueData];
                    [keychainItem setObject:email forKey:(__bridge id)kSecAttrAccount];
                }
                
                [self loadmycontactsWithLogin:YES];
                [self loadnotifcount];
                [self loadgroupsWithLogin:YES];
                
                
            }
            else{
                [keychainItem resetKeychainItem];
                [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                if(fromauto){
                    pLDrawerController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"logincontroller"];
                    
                    appDelegate.window.rootViewController = mainViewController;
                }
            }
        }
        
    }
                                        failure:^( RKObjectRequestOperation *operation , NSError *error ){
                                            [keychainItem resetKeychainItem];
                                            [pLAppUtils hideActivityIndicatorWithMessage:@"Failed"];
                                            if(fromauto){
                                                pLDrawerController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"logincontroller"];
                                                
                                                appDelegate.window.rootViewController = mainViewController;
                                            };
                                            
                                        }];

    
}

+(void)trycompletelogin{
    
    if(peopleloaded&&groupsloaded){
        
        [pLAppUtils hideActivityIndicator];
        pLAppDelegate *appDelegate = (pLAppDelegate *)[[UIApplication sharedApplication] delegate];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
        pLDrawerController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"drawercontroller"];
    
        appDelegate.window.rootViewController = mainViewController;
    
    }
}

+(void)performautologin{
    
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"PrayListLogin" accessGroup:nil];
    
    NSString*email = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    NSString*password = [keychainItem objectForKey:(__bridge id)kSecValueData];
    
    [self performloginwithEmail:email password:password savelogin:YES fromauto:YES];

}

+(void)setuserimgforEmail:(NSString*)email image:(UIImage*)image{
    [userImages setObject:image forKey:email];
}

+(UIImage*)userimgFromEmail:(NSString*)email{
    
    if(userImages==nil){userImages = [[NSMutableDictionary alloc] init];}
    
    if([userImages objectForKey:email]==NULL){
    
        NSString *basepath = [RKObjectManager sharedManager].baseURL.absoluteString;
    
        NSString *imagepath = [basepath stringByAppendingString:[@"pictures/userimage/" stringByAppendingString: email]];

        //NSURL *url = [NSURL URLWithString:imagepath];
        //NSData *data = [NSData dataWithContentsOfURL:url];
        
        //[userImages setObject:[UIImage imageWithData:data] forKey:email];
        
        
        NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                         requestWithURL:[NSURL URLWithString:imagepath]
                                         cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [theRequest setHTTPMethod:@"GET"];
        [theRequest setValue:[pLAppUtils securitytoken].tokenId forHTTPHeaderField:@"securitytoken"];
        [theRequest setValue:[pLAppUtils securitytoken].email forHTTPHeaderField:@"securityemail"];
        
        
        NSData*serverData = [NSURLConnection sendSynchronousRequest:theRequest
                                           returningResponse:nil error:nil];
        
        if([UIImage imageWithData:serverData]){
            [userImages setObject:[UIImage imageWithData:serverData] forKey:email];
        }
        else
        {
            [userImages setObject:[UIImage imageNamed:@"nouserimage.png"] forKey:email];
        }
        
        
        
    }

    return [userImages objectForKey:email];
    
}

+(void)setpersonforEmail:(NSString*)email person:(pLPerson*)person{
    
    [contacts setObject:person forKey:email];
    
}

+(NSString*)fullnamefromEmail:(NSString*)email{
    
    pLPerson*person=[contacts objectForKey:email];
    
    if(person){
        return person.fullname;
    }
    else{
        return email;
    }
}

+(NSString*)groupnamefromID:(NSString*)id{
    
    pLGroup*g=[groups objectForKey:id];
    
    if(g){
        return g.groupname;
    }
    else{
        return @"";
    }
}

+(NSDictionary*)getgroupdictionary{
    return groups;
}

+(void)loadmycontactsWithLogin:(BOOL)withlogin{
    
    contacts = [[NSMutableDictionary alloc] init];
    
    NSString *objectpath = @"lists/mycontacts/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSMutableArray *personarray = [[NSMutableArray alloc] initWithArray:mappingResult.array];
                                                  
                                                  if(personarray.count>0){
                                                      for(pLPerson *u in personarray){
                                                            [contacts setObject:u forKey:u.email];
                                                      }
                                                      
                                                  }
                                                  
                                                  peopleloaded=YES;
                                                  
                                                  if(withlogin){
                                                      
                                                      [pLAppUtils trycompletelogin];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
}

+(void)loadgroupsWithLogin:(BOOL)withlogin{
    
    groups = [[NSMutableDictionary alloc] init];
    
    NSString *objectpath = @"groups/";
    NSString *path = [objectpath stringByAppendingString: [pLAppUtils securitytoken].email];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSMutableArray*grouparray = [[NSMutableArray alloc] initWithArray:mappingResult.array];
                                                  
                                                  if(grouparray.count>0){
                                                      for(pLGroup*g in grouparray){
                                                          [groups setObject:g forKey:g.groupid];
                                                      }
                                                  }
                                                  
                                                  groupsloaded=YES;
                                                  
                                                  if(withlogin){
                                                      
                                                      [self trycompletelogin];
                                                  }
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
    
    
}

+(void)loadnotifcount{

    
    NSString *objectpath = @"notifications/";
    NSString *path = [[objectpath stringByAppendingString: [pLAppUtils securitytoken].email] stringByAppendingString:@"/count"];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  pLNotificationCount*cnt = mappingResult.firstObject;
                                                  
                                                  if(cnt){
                                                      notifcount=cnt.count;
                                                  }
                                                  
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
}



+(void)clearnotifs{

    
    NSString *objectpath = @"notifications/";
    NSString *path = [[objectpath stringByAppendingString: [pLAppUtils securitytoken].email] stringByAppendingString:@"/clearcount"];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  notifcount = [NSNumber numberWithInt:0];
                                                  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                                                  
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationUpdate"
                                                                                                      object:nil
                                                                                                    userInfo:nil];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Encountered an error: %@", error);
                                              }];
    
}

+(UIActivityIndicatorView*)addspinnertoview:(UIView*)view{
    
    UIActivityIndicatorView *spinner;
    
    spinner = [[UIActivityIndicatorView alloc]
               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [view addSubview:spinner];
    [spinner startAnimating];
    
    return spinner;
    
}

+(NSString*)calculaterequeststats:(NSNumber*)praycount commentcount:(NSNumber*)commentcount totalpraycount:(NSNumber*)totalpraycount{
    
    NSString *retval = @"";
    
    if([totalpraycount compare:[NSNumber numberWithInt:0]]==NSOrderedDescending){
        if([totalpraycount compare:[NSNumber numberWithInt:1]]==NSOrderedSame){
            retval = [@"Prayed for " stringByAppendingString:[[totalpraycount stringValue] stringByAppendingString:@" time. "]];
        }
        else
        {
            retval = [@"Prayed for " stringByAppendingString:[[totalpraycount stringValue] stringByAppendingString:@" times. "]];
        }
    }
    
    if([praycount compare:[NSNumber numberWithInt:0]]==NSOrderedDescending){
        if([praycount compare:[NSNumber numberWithInt:1]]==NSOrderedSame){
            retval = [retval stringByAppendingString:[[praycount stringValue] stringByAppendingString:@" person prayed. "]];
        }
        else
        {
            retval = [retval stringByAppendingString:[[praycount stringValue] stringByAppendingString:@" people prayed. "]];
        }
    }
    
    if([commentcount compare:[NSNumber numberWithInt:0]]==NSOrderedDescending){
        if([commentcount compare:[NSNumber numberWithInt:1]]==NSOrderedSame){
            retval = [retval stringByAppendingString:[[commentcount stringValue] stringByAppendingString:@" comment."]];
        }
        else
        {
            retval = [retval stringByAppendingString:[[commentcount stringValue] stringByAppendingString:@" comments."]];
        }
    }
    
    return retval;
    
}



+(void) showActivityIndicatorWithMessage:(NSString*)message{
    
    pLAppDelegate *appDelegate = (pLAppDelegate *)[[UIApplication sharedApplication] delegate];
        hud = [[MBProgressHUD alloc] initWithWindow:appDelegate.window];
        [appDelegate.window addSubview:hud];
    

        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = message;
    
        [hud show:YES];

}

+(void) hideActivityIndicator{
    [hud hide:YES];
}

+(void) showCheckboxIndicatorWithMessage:(NSString*)message{
    
    
        pLAppDelegate *appDelegate = (pLAppDelegate *)[[UIApplication sharedApplication] delegate];
        hud = [[MBProgressHUD alloc] initWithWindow:appDelegate.window];
        [appDelegate.window addSubview:hud];
    

        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = message;
    
        [hud show:YES];
        [hud hide:YES afterDelay:0.5];

}

+(void) hideActivityIndicatorWithMessage:(NSString*)message{
    
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
	hud.mode = MBProgressHUDModeCustomView;
    
	hud.labelText = message;
    
	[hud show:YES];
	[hud hide:YES afterDelay:0.5];
}


+(void) shownotifsfromview:(UIView*)view{
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationsPopupView" owner:self options:nil];
    pLNotificationsPopupViewController*controller;
    
    for (id oneObject in nib)
        if ([oneObject isKindOfClass:[pLNotificationsPopupViewController class]])
            
            controller = (pLNotificationsPopupViewController *)oneObject;
    
    controller.title = @"Notifications";
    //our popover
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    popover.contentSizeForViewInPopover = CGSizeMake(280,350);
    popover.contentSize = CGSizeMake(280,350);
    
    //the popover will be presented from the okButton view
    [popover presentPopoverFromView:view];
    
    
}

+(void)dismissnotifs{
    
    [popover dismissPopoverAnimated:YES];
}

@end
