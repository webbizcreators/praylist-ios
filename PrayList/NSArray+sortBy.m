//
//  NSArray+sortBy.m
//  PrayList
//
//  Created by Peter Opheim on 6/5/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import "NSArray+sortBy.h"

@implementation NSArray (sortBy)

- (NSArray*) sortByObjectTag
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(id objA, id objB){
        return(
               ([objA tag] < [objB tag]) ? NSOrderedAscending  :
               ([objA tag] > [objB tag]) ? NSOrderedDescending :
               NSOrderedSame);
    }];
}

- (NSArray*) sortByUIViewOriginX
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(id objA, id objB){
        return(
               ([objA frame].origin.x < [objB frame].origin.x) ? NSOrderedAscending  :
               ([objA frame].origin.x > [objB frame].origin.x) ? NSOrderedDescending :
               NSOrderedSame);
    }];
}

- (NSArray*) sortByUIViewOriginY
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(id objA, id objB){
        return(
               ([objA frame].origin.y < [objB frame].origin.y) ? NSOrderedAscending  :
               ([objA frame].origin.y > [objB frame].origin.y) ? NSOrderedDescending :
               NSOrderedSame);
    }];
}

@end
