//
//  pLGroup.h
//  PrayList
//
//  Created by Peter Opheim on 2/26/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pLGroup : NSObject

@property (nonatomic, retain) NSString* orgid;
@property (nonatomic, retain) NSString* grouptype;
@property (nonatomic, retain) NSString* owneremail;
@property (nonatomic, retain) NSString* groupname;
@property (nonatomic, retain) NSString* groupdescription;
@property (nonatomic, retain) NSString* groupid;
@property (nonatomic, retain) NSMutableArray* groupmembers;
@property (nonatomic, retain) NSMutableArray* invitees;
@property (nonatomic, retain) NSMutableArray* requestors;

@end
