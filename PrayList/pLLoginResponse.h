//
//  pLLoginResponse.h
//  PrayList
//
//  Created by Peter Opheim on 3/23/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pLSecurityToken.h"

@interface pLLoginResponse : NSObject

@property (nonatomic, retain) pLSecurityToken* securitytoken;
@property (nonatomic, retain) NSString* errordescription;
@property (nonatomic, retain) NSString* errorcode;

@end
