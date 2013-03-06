//
//  pLSecurityToken.h
//  PrayList
//
//  Created by Peter Opheim on 2/5/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pLSecurityToken : NSObject

@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* tokenId;
@property (nonatomic, retain) NSString* dateCode;

@end
