//
//  UIColor+Texture.m
//  Collage Maker
//
//  Created by Adam Buckley on 08/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "UIColor+Texture.h"
#import "UIImage+NonCached.h"

@implementation UIColor (Texture)

+ (id)brickTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"brick512.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)cardboardTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"cardboard512.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)corkTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"cork512.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)grassTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"grass512.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)paperTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"paper512.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)sandTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"sand512.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)blackboardTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"blackboard512.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)woodTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"wood250.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)concreteTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"concrete720.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)linedPaperTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"linedpaper121.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)redDamaskTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"reddamask148.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (NSArray *)allTextureColors
{
    return [NSArray arrayWithObjects:[UIColor corkTextureColor], [UIColor paperTextureColor], [UIColor blackboardTextureColor], [UIColor cardboardTextureColor], [UIColor brickTextureColor], [UIColor sandTextureColor], [UIColor grassTextureColor], [UIColor woodTextureColor], [UIColor concreteTextureColor], [UIColor linedPaperTextureColor], [UIColor redDamaskTextureColor], nil];
}

+ (NSArray *)allTextureColorDescriptions
{
    return [NSArray arrayWithObjects:@"Noticeboard", @"Paper", @"Blackboard", @"Cardboard", @"Brick", @"Sand", @"Grass", @"Wood", @"Concrete", @"Lined Paper", @"Red Damask", nil];
}

+ (NSArray *)allTextureColorImages
{
    return [NSArray arrayWithObjects:[UIImage imageFromFile:@"cork100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"paper100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"blackboard100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"cardboard100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"brick100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"sand100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"grass100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"wood100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"concrete100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"linedpaper100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"reddamask100.jpg" withNoUpscaleForNonRetina:YES], nil];
}

+ (id)textureColorWithDescription:(NSString *)colorDescription
{
    if ([colorDescription isEqualToString:@"Noticeboard"]) {
        return [UIColor corkTextureColor];
    } else if ([colorDescription isEqualToString:@"Paper"]) {
        return [UIColor paperTextureColor];
    } else if ([colorDescription isEqualToString:@"Blackboard"]) {
        return [UIColor blackboardTextureColor];
    } else if ([colorDescription isEqualToString:@"Cardboard"]) {
        return [UIColor cardboardTextureColor];
    } else if ([colorDescription isEqualToString:@"Brick"]) {
        return [UIColor brickTextureColor];
    } else if ([colorDescription isEqualToString:@"Sand"]) {
        return [UIColor sandTextureColor];
    } else if ([colorDescription isEqualToString:@"Grass"]) {
        return [UIColor grassTextureColor];
    } else if ([colorDescription isEqualToString:@"Wood"]) {
        return [UIColor woodTextureColor];
    } else if ([colorDescription isEqualToString:@"Concrete"]) {
        return [UIColor concreteTextureColor];
    } else if ([colorDescription isEqualToString:@"Lined Paper"]) {
        return [UIColor linedPaperTextureColor];
    } else if ([colorDescription isEqualToString:@"Red Damask"]) {
        return [UIColor redDamaskTextureColor];
    } else {
        return [UIColor corkTextureColor];
    } 
}

+ (UIImage *)textureImageWithDescription:(NSString *)colorDescription
{
    if ([colorDescription isEqualToString:@"Noticeboard"]) {
        return [UIImage imageFromFile:@"cork512.jpg"];
    } else if ([colorDescription isEqualToString:@"Paper"]) {
        return [UIImage imageFromFile:@"paper512.jpg"];
    } else if ([colorDescription isEqualToString:@"Blackboard"]) {
        return [UIImage imageFromFile:@"blackboard512.jpg"];
    } else if ([colorDescription isEqualToString:@"Cardboard"]) {
        return [UIImage imageFromFile:@"cardboard512.jpg"];
    } else if ([colorDescription isEqualToString:@"Brick"]) {
        return [UIImage imageFromFile:@"brick512.jpg"];
    } else if ([colorDescription isEqualToString:@"Sand"]) {
        return [UIImage imageFromFile:@"sand512.jpg"];
    } else if ([colorDescription isEqualToString:@"Grass"]) {
        return [UIImage imageFromFile:@"grass512.jpg"];
    } else if ([colorDescription isEqualToString:@"Wood"]) {
        return [UIImage imageFromFile:@"wood250.jpg"];
    } else if ([colorDescription isEqualToString:@"Concrete"]) {
        return [UIImage imageFromFile:@"concrete720.jpg"];
    } else if ([colorDescription isEqualToString:@"Lined Paper"]) {
        return [UIImage imageFromFile:@"linedpaper121.jpg"];
    } else if ([colorDescription isEqualToString:@"Red Damask"]) {
        return [UIImage imageFromFile:@"reddamask148.jpg"];
    } else {
        return [UIImage imageFromFile:@"cork512.jpg"];
    } 
}

@end

