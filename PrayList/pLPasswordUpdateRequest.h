//
//  pLPasswordUpdateRequest.h
//  PrayList
//
//  Created by Peter Opheim on 7/23/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pLPasswordUpdateRequest : NSObject

@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* oldpassword;
@property (nonatomic, retain) NSString* newpassword;

@end
