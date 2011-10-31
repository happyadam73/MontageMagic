//
//  CollageDescriptor.h
//  Collage Maker
//
//  Created by Adam Buckley on 14/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollageTheme.h"

static NSString *const kAWBInfoKeyCollageName = @"CollageName";
static NSString *const kAWBInfoKeyCollageDocumentsSubdirectory = @"CollageDocumentsSubdirectory";
static NSString *const kAWBInfoKeyCollageCreatedDate = @"CollageCreatedDate";
static NSString *const kAWBInfoKeyCollageThemeType = @"CollageThemeType";
static NSString *const kAWBInfoKeyCollageTotalImageObjects = @"CollageTotalImageObjects";
static NSString *const kAWBInfoKeyCollageTotalLabelObjects = @"CollageTotalLabelObjects";
static NSString *const kAWBInfoKeyCollageTotalImageMemoryBytes = @"CollageTotalImageMemoryBytes";
static NSString *const kAWBInfoKeyCollageTotalDiskBytes = @"CollageTotalDiskBytes";

@interface CollageDescriptor : NSObject {
    NSString *collageSaveDocumentsSubdirectory; 
    NSString *collageName;
    NSDate *createdDate;
    CollageThemeType themeType;
    NSUInteger totalImageObjects;
    NSUInteger totalLabelObjects; 
    NSUInteger totalImageMemoryBytes;
    BOOL addContentOnCreation;
}

@property (nonatomic, retain) NSString *collageSaveDocumentsSubdirectory;
@property (nonatomic, retain) NSString *collageName;
@property (nonatomic, readonly) NSDate *createdDate;
@property (nonatomic, assign) CollageThemeType themeType;
@property (nonatomic, assign) NSUInteger totalImageObjects;
@property (nonatomic, assign) NSUInteger totalLabelObjects;
@property (nonatomic, readonly) NSUInteger totalObjects;
@property (nonatomic, assign) NSUInteger totalImageMemoryBytes; 
@property (nonatomic, assign) BOOL addContentOnCreation;

- (id)initWithCollageName:(NSString *)name documentsSubdirectory:(NSString *)subDirectory;
- (id)initWithCollageDocumentsSubdirectory:(NSString *)subDirectory;
- (CollageTheme *)theme;
- (UIImageView *)collageThumbnailImageView;
- (UIView *)collageInfoHeaderView;
- (UILabel *)collageNameLabel;
- (UILabel *)collageCreatedDateLabel;
- (UILabel *)collageUpdatedDateLabel;

@end
