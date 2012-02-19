//
//  AWBCollageLayout.m
//  Collage Maker
//
//  Created by Adam Buckley on 20/10/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBCollageLayout.h"
#import "UIImage+NonCached.h"

@implementation AWBCollageLayout

+ (NSArray *)allLayouts
{
    if (DEVICE_IS_IPAD) {
        return [NSArray arrayWithObjects:[NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeScatter], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeGrid2x3iPad], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeGrid2x3], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeGrid4x6], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicLargeImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicMediumImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicSmallImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicTinyImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicMicroImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicNanoImages], nil];
        
    } else {
        return [NSArray arrayWithObjects:[NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeScatter], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeGrid2x3], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeGrid4x6], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicLargeImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicMediumImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicSmallImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicTinyImages], nil];
        
    }
    
}

+ (NSArray *)allLayoutDescriptions
{
    if (DEVICE_IS_IPAD) {
        return [NSArray arrayWithObjects:@"Scattered Grid", @"Grid (3 x 2)", @"Grid (5 x 4)", @"Grid (10 x 8)", @"Mosaic (4 Rows)", @"Mosaic (5 Rows)", @"Mosaic (6 Rows)", @"Mosaic (7 Rows)", @"Mosaic (9 Rows)", @"Mosaic (13 Rows)", nil];
    } else {
        return [NSArray arrayWithObjects:@"Scattered Grid", @"Grid (3 x 2)", @"Grid (6 x 4)", @"Mosaic (3 Rows)", @"Mosaic (4 Rows)", @"Mosaic (5 Rows)", @"Mosaic (6 Rows)", nil];        
    }
}

+ (NSArray *)allLayoutImages
{
    if (DEVICE_IS_IPAD) {
        return [NSArray arrayWithObjects:[UIImage imageFromFile:@"scattergrid100.jpg"], [UIImage imageFromFile:@"grid2x3100.jpg"], [UIImage imageFromFile:@"grid4x5100.jpg"], [UIImage imageFromFile:@"grid8x10100.jpg"], [UIImage imageFromFile:@"mosaic4row100.jpg"], [UIImage imageFromFile:@"mosaic5row100.jpg"], [UIImage imageFromFile:@"mosaic6row100.jpg"], [UIImage imageFromFile:@"mosaic7row100.jpg"], [UIImage imageFromFile:@"mosaic9row100.jpg"], [UIImage imageFromFile:@"mosaic13row100.jpg"], nil];        
    } else {
        return [NSArray arrayWithObjects:[UIImage imageFromFile:@"scattergrid50.jpg"], [UIImage imageFromFile:@"grid2x350.jpg"], [UIImage imageFromFile:@"grid4x650.jpg"], [UIImage imageFromFile:@"mosaic3row50.jpg"], [UIImage imageFromFile:@"mosaic4row50.jpg"], [UIImage imageFromFile:@"mosaic5row50.jpg"], [UIImage imageFromFile:@"mosaic6row50.jpg"], nil]; 
    }
}

@end
