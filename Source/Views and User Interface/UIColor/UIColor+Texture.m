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

+ (id)cloudsTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"sky1024.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)nebulaTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"nebula1024.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)brightlightsTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"brightlights1024.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)metalTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"metal1024.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)darkWoodTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"darkwood1024.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)leatherTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"leather1024.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)denimTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"denim1024.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)basketWeaveTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"basketweave1024.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (id)graphPaperTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageFromFile:@"graphpaper1024.jpg" withNoUpscaleForNonRetina:YES]];
}

+ (NSArray *)allTextureColors
{
    return [NSArray arrayWithObjects:[UIColor corkTextureColor], [UIColor paperTextureColor], [UIColor blackboardTextureColor], [UIColor cardboardTextureColor], [UIColor brickTextureColor], [UIColor sandTextureColor], [UIColor grassTextureColor], [UIColor woodTextureColor], [UIColor concreteTextureColor], [UIColor linedPaperTextureColor], [UIColor redDamaskTextureColor], [UIColor cloudsTextureColor], [UIColor nebulaTextureColor], [UIColor brightlightsTextureColor], [UIColor metalTextureColor], [UIColor darkWoodTextureColor], [UIColor leatherTextureColor], [UIColor denimTextureColor], [UIColor basketWeaveTextureColor], [UIColor graphPaperTextureColor], nil];
}

+ (NSArray *)allTextureColorDescriptions
{
    return [NSArray arrayWithObjects:@"Noticeboard", @"Paper", @"Blackboard", @"Cardboard", @"Brick", @"Sand", @"Grass", @"Wood", @"Concrete", @"Lined Paper", @"Red Damask", @"Clouds", @"Nebula", @"Bright Lights", @"Metal", @"Dark Wood", @"Leather", @"Denim", @"Basket Weave", @"Graph Paper", nil];
}

+ (NSArray *)allTextureColorImages
{
    return [NSArray arrayWithObjects:[UIImage imageFromFile:@"cork100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"paper100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"blackboard100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"cardboard100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"brick100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"sand100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"grass100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"wood100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"concrete100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"linedpaper100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"reddamask100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"sky100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"nebula100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"brightlights100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"metal100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"darkwood100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"leather100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"denim100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"basketweave100.jpg" withNoUpscaleForNonRetina:YES], [UIImage imageFromFile:@"graphpaper100.jpg" withNoUpscaleForNonRetina:YES], nil];
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
    } else if ([colorDescription isEqualToString:@"Clouds"]) {
        return [UIColor cloudsTextureColor];
    } else if ([colorDescription isEqualToString:@"Nebula"]) {
        return [UIColor nebulaTextureColor];
    } else if ([colorDescription isEqualToString:@"Bright Lights"]) {
        return [UIColor brightlightsTextureColor];
    } else if ([colorDescription isEqualToString:@"Metal"]) {
        return [UIColor metalTextureColor];
    } else if ([colorDescription isEqualToString:@"Dark Wood"]) {
        return [UIColor darkWoodTextureColor];
    } else if ([colorDescription isEqualToString:@"Leather"]) {
        return [UIColor leatherTextureColor];
    } else if ([colorDescription isEqualToString:@"Denim"]) {
        return [UIColor denimTextureColor];
    } else if ([colorDescription isEqualToString:@"Basket Weave"]) {
        return [UIColor basketWeaveTextureColor];
    } else if ([colorDescription isEqualToString:@"Graph Paper"]) {
        return [UIColor graphPaperTextureColor];
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
    } else if ([colorDescription isEqualToString:@"Clouds"]) {
        return [UIImage imageFromFile:@"sky1024.jpg"];
    } else if ([colorDescription isEqualToString:@"Nebula"]) {
        return [UIImage imageFromFile:@"nebula1024.jpg"];
    } else if ([colorDescription isEqualToString:@"Bright Lights"]) {
        return [UIImage imageFromFile:@"brightlights1024.jpg"];
    } else if ([colorDescription isEqualToString:@"Metal"]) {
        return [UIImage imageFromFile:@"metal1024.jpg"];
    } else if ([colorDescription isEqualToString:@"Dark Wood"]) {
        return [UIImage imageFromFile:@"darkwood1024.jpg"];
    } else if ([colorDescription isEqualToString:@"Leather"]) {
        return [UIImage imageFromFile:@"leather1024.jpg"];
    } else if ([colorDescription isEqualToString:@"Denim"]) {
        return [UIImage imageFromFile:@"denim1024.jpg"];
    } else if ([colorDescription isEqualToString:@"Basket Weave"]) {
        return [UIImage imageFromFile:@"basketweave1024.jpg"];
    } else if ([colorDescription isEqualToString:@"Graph Paper"]) {
        return [UIImage imageFromFile:@"graphpaper1024.jpg"];
    } else {
        return [UIImage imageFromFile:@"cork512.jpg"];
    } 
}

@end

