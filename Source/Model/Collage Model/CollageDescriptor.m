//
//  CollageDescriptor.m
//  Collage Maker
//
//  Created by Adam Buckley on 14/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageDescriptor.h"
#import "CollageTheme.h"
#import "FileHelpers.h"

@implementation CollageDescriptor

@synthesize collageName, collageSaveDocumentsSubdirectory, createdDate, themeType, totalObjects, totalImageObjects, totalLabelObjects, totalImageMemoryBytes, addContentOnCreation;

- (id)initWithCollageName:(NSString *)name documentsSubdirectory:(NSString *)subDirectory
{
    self = [super init];
    if (self) {
        [self setCollageName:name];
        [self setCollageSaveDocumentsSubdirectory:subDirectory];
        createdDate = [[NSDate alloc] init];
        themeType = kAWBCollageThemeTypePlain;
        totalImageObjects = 0;
        totalLabelObjects = 0;
        totalImageMemoryBytes = 0;
        addContentOnCreation = NO;
    }
    return self;
}

- (id)initWithCollageDocumentsSubdirectory:(NSString *)subDirectory
{
    return [self initWithCollageName:subDirectory documentsSubdirectory:subDirectory];
}

- (id)init
{
    return [self initWithCollageName:@"Collage 1" documentsSubdirectory:@"Collage 1"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        [self setCollageName:[decoder decodeObjectForKey:kAWBInfoKeyCollageName]];
        [self setCollageSaveDocumentsSubdirectory:[decoder decodeObjectForKey:kAWBInfoKeyCollageDocumentsSubdirectory]];
        createdDate = [[decoder decodeObjectForKey:kAWBInfoKeyCollageCreatedDate] retain];
        [self setThemeType:[decoder decodeIntegerForKey:kAWBInfoKeyCollageThemeType]];
        [self setTotalImageObjects:[decoder decodeIntegerForKey:kAWBInfoKeyCollageTotalImageObjects]];
        [self setTotalLabelObjects:[decoder decodeIntegerForKey:kAWBInfoKeyCollageTotalLabelObjects]];
        [self setTotalImageMemoryBytes:[decoder decodeIntegerForKey:kAWBInfoKeyCollageTotalImageMemoryBytes]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:collageName forKey:kAWBInfoKeyCollageName];
    [encoder encodeObject:collageSaveDocumentsSubdirectory forKey:kAWBInfoKeyCollageDocumentsSubdirectory];
    [encoder encodeObject:createdDate forKey:kAWBInfoKeyCollageCreatedDate];
    [encoder encodeInteger:themeType forKey:kAWBInfoKeyCollageThemeType];
    [encoder encodeInteger:totalImageObjects forKey:kAWBInfoKeyCollageTotalImageObjects];    
    [encoder encodeInteger:totalLabelObjects forKey:kAWBInfoKeyCollageTotalLabelObjects]; 
    [encoder encodeInteger:totalImageMemoryBytes forKey:kAWBInfoKeyCollageTotalImageMemoryBytes];
}

- (CollageTheme *)theme
{
    return [CollageTheme themeWithThemeType:themeType];
}

- (UIImageView *)collageThumbnailImageView
{
    UIImage *thumbnail = [UIImage imageWithContentsOfFile:AWBPathInDocumentSubdirectory(self.collageSaveDocumentsSubdirectory, @"thumbnail.jpg")];
    
    if (!thumbnail) {
        if (DEVICE_IS_IPAD) {
            thumbnail = [UIImage imageNamed:@"defaultthumbnail.jpg"];
        } else {
            thumbnail = [UIImage imageNamed:@"defaultthumbnailsmall.jpg"];
        }    
    }
    
    CGFloat frameHeight = 92.0;
    CGFloat frameWidth = 138.0;
    CGFloat topMargin = 10.0;
    CGFloat leftMargin = 10.0;
    CGFloat shadowOffset = 5.0;
    
    if (DEVICE_IS_IPAD) {
        frameHeight = 184.0;
        frameWidth = 256.0;
        topMargin = 20.0;
        leftMargin = 44.0;
        shadowOffset = 10.0;
    }    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, frameWidth, frameHeight)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = thumbnail;    
    imageView.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    imageView.layer.shadowOpacity = 0.3;
    imageView.layer.shadowColor = [[UIColor blackColor] CGColor];

    imageView.autoresizingMask = UIViewAutoresizingNone;
    
    return [imageView autorelease];
}

- (UIView *)collageInfoHeaderView
{
    CGFloat frameHeight = 112.0;
    CGFloat frameWidth = 480.0;
    if (DEVICE_IS_IPAD) {
        frameHeight = 224.0;
        frameWidth = 768.0;
    }    
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frameWidth, frameHeight)];
    [infoView addSubview:[self collageThumbnailImageView]];
    [infoView addSubview:[self collageNameLabel]];
    [infoView addSubview:[self collageCreatedDateLabel]];
    [infoView addSubview:[self collageUpdatedDateLabel]];
    return [infoView autorelease];
}

- (UILabel *)collageNameLabel
{
    CGFloat leftMargin = 160;
    CGFloat topMargin = 25.0;
    CGFloat frameWidth = 310;
    CGFloat frameHeight = 30;
    CGFloat fontSize = 24.0;
    
    if (DEVICE_IS_IPAD) {
        leftMargin = 330.0;
        topMargin = 50.0;
        frameWidth = 400.0;
        frameHeight = 60.0;
        fontSize = 24.0;
    } 
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, frameWidth, frameHeight)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [nameLabel setText:self.collageName];
    return [nameLabel autorelease];
}

- (UILabel *)collageCreatedDateLabel
{
    CGFloat leftMargin = 160;
    CGFloat topMargin = 60.0;
    CGFloat frameWidth = 310;
    CGFloat frameHeight = 15;
    
    if (DEVICE_IS_IPAD) {
        leftMargin = 330.0;
        topMargin = 100.0;
        frameWidth = 400.0;
        frameHeight = 24.0;
    } 
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, frameWidth, frameHeight)];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setFont:[UIFont systemFontOfSize:16.0]];
    [dateLabel setTextColor:[UIColor darkGrayColor]];
    [dateLabel setText:[NSString stringWithFormat:@"Created:\t%@", AWBDateStringForCurrentLocale(self.createdDate)]];
    return [dateLabel autorelease];    
}

- (UILabel *)collageUpdatedDateLabel
{
    CGFloat leftMargin = 160;
    CGFloat topMargin = 80.0;
    CGFloat frameWidth = 310;
    CGFloat frameHeight = 15;
    
    if (DEVICE_IS_IPAD) {
        leftMargin = 330.0;
        topMargin = 124.0;
        frameWidth = 400.0;
        frameHeight = 24.0;
    } 
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, frameWidth, frameHeight)];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setFont:[UIFont systemFontOfSize:16.0]];
    [dateLabel setTextColor:[UIColor darkGrayColor]];
    [dateLabel setText:[NSString stringWithFormat:@"Updated:\t%@", AWBDocumentSubdirectoryModifiedDate(self.collageSaveDocumentsSubdirectory)]];
    return [dateLabel autorelease];    
}

- (NSUInteger)totalObjects
{
    return (totalImageObjects+totalLabelObjects);
}

- (void)dealloc
{
    [collageName release];
    [collageSaveDocumentsSubdirectory release];
    [createdDate release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (saved in %@), created %@", collageName, collageSaveDocumentsSubdirectory, createdDate];
}

@end
