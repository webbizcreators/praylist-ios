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
#import "pLCircle.h"


@implementation pLAppUtils

pLSecurityToken* st = nil;
NSMutableDictionary *userImages;

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
    }
    else
    {
        return @"Don't know.";
    }
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //return [dateFormatter stringFromDate:date];
    
}




+(void)registerObjectMappings{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    
    NSTimeZone *PST = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    [RKObjectMapping addDefaultDateFormatterForString:@"MM-dd-yyyy" inTimeZone:PST];
    
    
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    
    
    
    //pLPrayerRequestListItem ********************************************
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[pLPrayerRequestListItem class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"requestid": @"requestid",
     @"requestorEmail": @"requestoremail",
     @"requestText": @"requesttext",
     @"email": @"email",
     @"requestDateText":@"requestdate",
     }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                       pathPattern:@"lists/myprayerlist/:email"
                                                                                           keyPath: @"prayerRequestListItem"
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    //******************************************************************
    
    
    
    
    
    
    //pLLoginRequest ******************************************************************
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"email": @"email",
     @"password": @"password",
     }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[pLLoginRequest class]
                                                                                   rootKeyPath: nil];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLLoginRequest class]
                                             pathPattern:@"tokens/getlogintoken"
                                             method:RKRequestMethodPOST]] ;
    
    
    //******************************************************************
    
    
    
    
    
    //pLSecurityToken ******************************************************************
    responseMapping = [RKObjectMapping mappingForClass:[pLSecurityToken class]];
    
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"tokenId": @"tokenId",
     @"dateCode": @"dateCode",
     @"email": @"email",
     }];
    
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"tokens/getlogintoken"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    // ******************************************************************
    
    
    
    
    
    
    //pLPrayerRequest ********************************************
    responseMapping = [RKObjectMapping mappingForClass:[pLPrayerRequest class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"requestid": @"requestid",
     @"requestorEmail": @"requestoremail",
     @"requestText": @"requesttext",
     @"requestDate":@"requestdate",
     @"circleNames":@"circlenames",
     }];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                       pathPattern:@"prayerrequests/:requestoremail/:requestid"
                                                                                           keyPath: nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"prayerrequests/:requestoremail"
                                                                     keyPath: @"prayerRequest"
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"prayerrequests"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    
    requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"requestid": @"requestid",
     @"requestoremail": @"requestorEmail",
     @"requesttext": @"requestText",
     @"requestdate":@"requestDate",
     @"circlenames":@"circleNames",
     }];
    
    
    requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[pLPrayerRequest class]
                                                                                   rootKeyPath: nil];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLPrayerRequest class]
                                             pathPattern:@"prayerrequests"
                                             method:RKRequestMethodPUT]] ;
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLPrayerRequest class]
                                             pathPattern:@"prayerrequests/:requestoremail/:requestid"
                                             method:RKRequestMethodPOST]] ;
    
    
    
    
    //******************************************************************
    
    
    
    
    
    
    
    //pLCircle ********************************************
    responseMapping = [RKObjectMapping mappingForClass:[pLCircle class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"ownerEmail": @"owneremail",
     @"circleName": @"circlename",
     @"circleMembers": @"circlemembers",
     }];
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"circles/:owneremail/:circlename"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"circles/:owneremail"
                                                                     keyPath: @"circle"
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                 pathPattern:@"circles"
                                                                     keyPath: nil
                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor: responseDescriptor];
    
    
    
    requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"owneremail": @"ownerEmail",
     @"circlename": @"circleName",
     @"circlemembers": @"circleMembers",
     }];
    
    
    requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                              objectClass:[pLCircle class]
                                                              rootKeyPath: nil];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLCircle class]
                                             pathPattern:@"prayerrequests"
                                             method:RKRequestMethodPUT]] ;
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[pLCircle class]
                                             pathPattern:@"prayerrequests/:owneremail/:circlename"
                                             method:RKRequestMethodPOST]] ;
    
    
    
    
    //******************************************************************
    

    
    
    
    
}

+(UIImage*)userimgFromEmail:(NSString*)email{
    
    if(userImages==nil){userImages = [[NSMutableDictionary alloc] init];}
    
    if([userImages objectForKey:email]==NULL){
    
        NSString *basepath = [RKObjectManager sharedManager].baseURL.absoluteString;
    
        NSString *imagepath = [basepath stringByAppendingString:[@"pictures/userimage/" stringByAppendingString: email]];
        NSLog(@"Image Path: %@", imagepath);
        NSURL *url = [NSURL URLWithString:imagepath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [userImages setObject:[UIImage imageWithData:data] forKey:email];
        
    }

    return [userImages objectForKey:email];
    
}

@end
