//
//  NSMutableArray+Shuffle.m
//  Collage Maker
//
//  Created by Adam Buckley on 20/10/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

- (void)randomShuffle
{
//    To shuffle an array a of n elements (indexes 0..n-1):
//    for i from n − 1 downto 1 do
//        j ← random integer with 0 ≤ j ≤ i
//        exchange a[j] and a[i]
    NSUInteger n = [self count];
    
    if (n > 0) {
        for (NSUInteger i = (n-1); i >= 1; i--) {
            NSUInteger j = AWBRandomIntInRange(0, i);
            [self exchangeObjectAtIndex:j withObjectAtIndex:i];
        }
    }        
}

@end
