//
//  pLUser.h
//  PrayList
//
//  Created by Peter Opheim on 7/22/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "pLPerson.h"

@interface pLUser : pLPerson

@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* emailaddress;

@end
