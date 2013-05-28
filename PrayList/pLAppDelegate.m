//
//  pLAppDelegate.m
//  PrayList
//
//  Created by Peter Opheim on 11/14/12.
//  Copyright (c) 2012 Peter Opheim. All rights reserved.
//


#import "pLAppDelegate.h"
#import "pLPrayerRequestListItem.h"
#import "pLLoginRequest.h"
#import "pLSecurityToken.h"
#import "pLAppUtils.h"

@implementation pLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    

    //RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://praylistws.elasticbeanstalk.com/rest/"]];
    
    //RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://127.0.0.1:8080/praylistws/rest/"]];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://mbpro.local:8080/praylistws/rest/"]];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
                                
    
    [pLAppUtils registerObjectMappings];
    
    
    //self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
    
	// Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			[self addMessageFromRemoteNotification:dictionary updateUI:NO];
		}
	}

    return YES;
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
	NSLog(@"Received notification: %@", userInfo);
	[self addMessageFromRemoteNotification:userInfo updateUI:YES];
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
	//Refresh notification array so push notif can find it, so that it can mark it as viewed
    
	NSNumber* alertCount = [[userInfo valueForKey:@"aps"] valueForKey:@"badge"];
    
    [pLAppUtils setNotifCount:alertCount];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationUpdate"
                                                        object:nil
                                                      userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GroupsChanged"
                                                        object:nil
                                                      userInfo:nil];
    
	
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[alertCount unsignedIntegerValue]];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [pLAppUtils setDeviceToken:[deviceToken description]];
	NSLog(@"My token is: %@", deviceToken);
    NSLog(@"AppUtils token is: %@", [pLAppUtils devicetoken]);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
