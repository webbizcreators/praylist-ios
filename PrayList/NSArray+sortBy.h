//
//  NSArray+sortBy.h
//  PrayList
//
//  Created by Peter Opheim on 6/5/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (sortBy)

- (NSArray*) sortByObjectTag;
- (NSArray*) sortByUIViewOriginX;
- (NSArray*) sortByUIViewOriginY;

@end
