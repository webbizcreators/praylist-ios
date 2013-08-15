//
//  pLAppUtils.h
//  PrayList
//
//  Created by Peter Opheim on 2/7/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pLSecurityToken.h"
#import <RestKit/RestKit.h>
#import "pLPerson.h"

@interface pLAppUtils : NSObject

+ (pLSecurityToken *) securitytoken;
+ (void)setSecurityToken:(pLSecurityToken *)stt;
+ (void)registerObjectMappings;
+ (void)loadmycontactsWithLogin:(BOOL)withlogin;
+(UIImage*)userimgFromEmail:(NSString*)email;
+(NSString*)formatPostDate:(NSDate*)date;
+(UIActivityIndicatorView*)addspinnertoview:(UIView*)view;
+(NSString*)calculaterequeststats:(NSNumber*)praycount commentcount:(NSNumber*)commentcount totalpraycount:(NSNumber*)totalpraycount;
+(NSString*)fullnamefromEmail:(NSString*)email;
+(NSArray*)getcontacts;
+(NSString*)devicetoken;
+(void)setDeviceToken:(NSString *)dtt;
+(void)setNotifCount:(NSNumber *)dtt;
+(NSNumber*)notifcount;
+(void)clearnotifs;
+(void)loadnotifcount;
+(void) showActivityIndicatorWithMessage:(NSString*)message;
+(void) hideActivityIndicator;
+(void) showCheckboxIndicatorWithMessage:(NSString*)message;
+(void) hideActivityIndicatorWithMessage:(NSString*)message;
+(void) shownotifsfromview:(UIView*)view;
+(void)dismissnotifs;
+(void)loadgroupsWithLogin:(BOOL)withlogin;
+(NSString*)groupnamefromID:(NSString*)id;
+(void)setuserimgforEmail:(NSString*)email image:(UIImage*)image;
+(void)setpersonforEmail:(NSString*)email person:(pLPerson*)person;
+(void)performautologin;
+(void)performloginwithEmail:(NSString*)email password:(NSString*)password savelogin:(BOOL)savelogin fromauto:(BOOL)fromauto;
+(NSDictionary*)getgroupdictionary;


@end
