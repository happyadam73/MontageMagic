//
//  UIColor+Texture.h
//  Collage Maker
//
//  Created by Adam Buckley on 08/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Texture) 

+ (id)brickTextureColor;
+ (id)cardboardTextureColor;
+ (id)corkTextureColor;
+ (id)grassTextureColor;
+ (id)paperTextureColor;
+ (id)sandTextureColor;
+ (id)blackboardTextureColor;
+ (id)woodTextureColor;
+ (id)concreteTextureColor;
+ (id)linedPaperTextureColor;
+ (id)redDamaskTextureColor;
+ (NSArray *)allTextureColors;
+ (NSArray *)allTextureColorDescriptions;
+ (NSArray *)allTextureColorImages;
+ (id)textureColorWithDescription:(NSString *)colorDescription;
+ (UIImage *)textureImageWithDescription:(NSString *)colorDescription;

@end
