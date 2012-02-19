//
//  UIImage+NonCached.h
//  Collage Maker
//
//  Created by Adam Buckley on 09/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (NonCached)

//+ (UIImage *)imageFromFile:(NSString*)aFileName;

+ (UIImage *)imageFromFile:(NSString *)fileName;
+ (UIImage *)imageFromFile:(NSString *)fileName withNoUpscaleForNonRetina:(BOOL)noUpscaleForNonRetina;
- (id)initFromFile:(NSString *)filename withNoUpscaleForNonRetina:(BOOL)noUpscaleForNonRetina;

@end
