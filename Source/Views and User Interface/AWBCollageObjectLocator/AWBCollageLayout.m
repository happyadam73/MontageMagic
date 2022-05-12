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
        return [NSArray arrayWithObjects:[NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeScatter], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeGrid2x3iPad], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeGrid2x3], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeGrid4x6], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicLargeImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicMediumImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicSmallImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicTinyImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicMicroImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicNanoImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicPicoImages], nil];
    } else {
        return [NSArray arrayWithObjects:[NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeScatter], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeGrid2x3], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeGrid4x6], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicLargeImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicMediumImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicSmallImages], [NSNumber numberWithInteger:kAWBCollageObjectLocatorTypeMosaicTinyImages], nil];
        
    }
    
}

+ (NSArray *)allLayoutDescriptions
{
    if (DEVICE_IS_IPAD) {
        return [NSArray arrayWithObjects:@"Scattered Grid", @"Grid (3 x 2)", @"Grid (5 x 4)", @"Grid (10 x 8)", @"Mosaic (4 Rows)", @"Mosaic (5 Rows)", @"Mosaic (6 Rows)", @"Mosaic (7 Rows)", @"Mosaic (9 Rows)", @"Mosaic (13 Rows)", @"Mosaic (24 Rows)", nil];
    } else {
        return [NSArray arrayWithObjects:@"Scattered Grid", @"Grid (3 x 2)", @"Grid (6 x 4)", @"Mosaic (3 Rows)", @"Mosaic (4 Rows)", @"Mosaic (5 Rows)", @"Mosaic (6 Rows)", nil];        
    }
}

+ (NSArray *)allLayoutImages
{
    if (DEVICE_IS_IPAD) {
        return [NSArray arrayWithObjects:[UIImage imageFromFile:@"scatteriPad.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"grid3x2iPad.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"grid5x4iPad.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"grid10x8iPad.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx4iPad.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx5iPad.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx6iPad.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx7iPad.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx9iPad.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx13iPad.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx13iPad.png" withNoUpscaleForNonRetina:YES], nil];        
    } else {
        return [NSArray arrayWithObjects:[UIImage imageFromFile:@"scatteriPhone.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"grid3x2iPhone.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"grid6x4iPhone.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx3iPhone.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx4iPhone.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx5iPhone.png" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"mosaicx6iPhone.png" withNoUpscaleForNonRetina:YES], nil]; 
    }
}

@end
