//
//  AWBSettingsGroup.m
//  Collage Maker
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBSettingsGroup.h"
#import "AWBSetting.h"
#import "AWBSettings.h"
#import "AWBCollageFont.h"
#import "CollageTheme.h"
#import "CollageDescriptor.h"
#import "FileHelpers.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIColor+Texture.h"
#import "UIImage+NonCached.h"
#import "AWBCollageObjectLocator.h"
#import "AWBCollageLayout.h"

@implementation AWBSettingsGroup

@synthesize header, footer, settings, parentSettings, visible, dependentVisibleSettingsGroup, dependentHiddenSettingsGroup, masterSwitchIsOn;
@synthesize isMutuallyExclusive, selectedIndex, settingKeyForMutuallyExclusiveObjects, mutuallyExclusiveObjects;
@synthesize iPhoneRowHeight, iPadRowHeight;

- (id)initWithSettings:(NSMutableArray *)aSettings header:(NSString *)aHeader footer:(NSString *)aFooter    
{
    self = [super init];
    if (self) {
        [self setSettings:aSettings];
        [self setHeader:aHeader];
        [self setFooter:aFooter];
        [self setVisible:YES];
        isMutuallyExclusive = NO;
        selectedIndex = 0;
        iPhoneRowHeight = 0.0;    //default - means no row height override
        iPadRowHeight = 0.0;      //default - means no row height override
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\r  Header: %@\r  Footer: %@\r  Settings: %@", header, footer, [settings description]];
}

- (NSMutableArray *)visibleSettings
{
    if (visibleSettings) {
        return visibleSettings;
    } else {
        visibleSettings = [[NSMutableArray alloc] init];
        if (self.settings && ([self.settings count] > 0)) {
            for (AWBSetting *setting in self.settings) {
                if (setting.visible) {
                    if (setting) {
                        [visibleSettings addObject:setting];
                    }
                }
            }
        }
        return visibleSettings;       
    }
}

- (void)masterSwitchSettingHasChangedValue:(id)setting
{
    if (self.parentSettings) {
        masterSwitchIsOn = [(AWBSetting *)setting isSwitchedOn];
        [self.parentSettings masterSwitchSettingHasChangedValue:setting forSettingsGroup:self];
    }
}

- (void)notifySlaveSettingsOfMasterSwitchSettingValue:(BOOL)masterSwitchValue
{
    [visibleSettings release];
    visibleSettings = nil;
    for (AWBSetting *setting in self.settings) {
        if (setting.masterSlaveType == AWBSettingMasterSlaveTypeSlaveCell) {
            setting.visible = (masterSwitchValue == YES);
        } else if (setting.masterSlaveType == AWBSettingMasterSlaveTypeSlaveCellNegative) {
            setting.visible = (masterSwitchValue == NO);
        }
    }
    
    if (dependentVisibleSettingsGroup && parentSettings) {
        dependentVisibleSettingsGroup.visible = (masterSwitchValue == YES);
        [parentSettings visibleSettingsGroupsHaveChanged];
    }

    if (dependentHiddenSettingsGroup && parentSettings) {
        dependentHiddenSettingsGroup.visible = (masterSwitchValue == NO);
        [parentSettings visibleSettingsGroupsHaveChanged];
    }
}

+ (AWBSettingsGroup *)textColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyTextColor] andKey:kAWBInfoKeyTextColor]] header:@"Text Colour" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)backgroundColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyCollageBackgroundColor] andKey:kAWBInfoKeyCollageBackgroundColor]] header:@"Background Colour" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)imageShadowColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyImageShadowColor] andKey:kAWBInfoKeyImageShadowColor]] header:@"Photo Shadow Colour" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)textShadowColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyTextShadowColor] andKey:kAWBInfoKeyTextShadowColor]] header:@"Text Shadow Colour" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)imageBorderColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyImageBorderColor] andKey:kAWBInfoKeyImageBorderColor]] header:@"Photo Border Colour" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)textBorderColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyTextBorderColor] andKey:kAWBInfoKeyTextBorderColor]] header:@"Text Border Colour" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)collageBorderColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyCollageBorderColor] andKey:kAWBInfoKeyCollageBorderColor]] header:@"Collage Border Colour" footer:@"Collage borders will not appear on small and large prints."] autorelease];
}

+ (AWBSettingsGroup *)shadowsSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:[AWBSetting switchSettingWithText:@"Photo Shadows" value:[info objectForKey:kAWBInfoKeyImageShadows] key:kAWBInfoKeyImageShadows], [AWBSetting switchSettingWithText:@"Text Shadows" value:[info objectForKey:kAWBInfoKeyTextShadows] key:kAWBInfoKeyTextShadows], nil];
    
    return [[[self alloc] initWithSettings:buttonSettings header:@"Shadows" footer:nil] autorelease];    
}

+ (AWBSettingsGroup *)imageShadowsSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *addPhotoShadowsSetting = [AWBSetting switchSettingWithText:@"Photo Shadows" value:[info objectForKey:kAWBInfoKeyImageShadows] key:kAWBInfoKeyImageShadows];
    addPhotoShadowsSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObject:addPhotoShadowsSetting];    
    AWBSettingsGroup *imageShadowSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:nil];
    imageShadowSettings.masterSwitchIsOn = addPhotoShadowsSetting.isSwitchedOn;
    addPhotoShadowsSetting.parentGroup = imageShadowSettings;
    return [imageShadowSettings autorelease];
}

+ (AWBSettingsGroup *)textShadowsSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *addTextShadowsSetting = [AWBSetting switchSettingWithText:@"Text Shadows" value:[info objectForKey:kAWBInfoKeyTextShadows] key:kAWBInfoKeyTextShadows];
    addTextShadowsSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObject:addTextShadowsSetting];
    AWBSettingsGroup *textShadowSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:@"Shadows can affect performance.  Try laying out photos and text before adding shadows."];
    textShadowSettings.masterSwitchIsOn = addTextShadowsSetting.isSwitchedOn;
    addTextShadowsSetting.parentGroup = textShadowSettings;
    return [textShadowSettings autorelease];    
}

+ (AWBSettingsGroup *)textBackgroundSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *addTextBackgroundSetting = [AWBSetting switchSettingWithText:@"Add Text Background" value:[info objectForKey:kAWBInfoKeyTextBackground] key:kAWBInfoKeyTextBackground];
    addTextBackgroundSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObject:addTextBackgroundSetting];
    AWBSettingsGroup *textBackgroundSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:nil];
    textBackgroundSettings.masterSwitchIsOn = addTextBackgroundSetting.isSwitchedOn;
    addTextBackgroundSetting.parentGroup = textBackgroundSettings;
    return [textBackgroundSettings autorelease];    
}

+ (AWBSettingsGroup *)textBackgroundColorPickerSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting colorSettingWithValue:[info objectForKey:kAWBInfoKeyTextBackgroundColor] andKey:kAWBInfoKeyTextBackgroundColor]] header:@"Text Background Colour" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)imageBordersSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *addPhotoBordersSetting = [AWBSetting switchSettingWithText:@"Add Photo Borders" value:[info objectForKey:kAWBInfoKeyImageBorders] key:kAWBInfoKeyImageBorders];
    addPhotoBordersSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    AWBSetting *roundedBordersSetting = [AWBSetting switchSettingWithText:@"Rounded Borders" value:[info objectForKey:kAWBInfoKeyImageRoundedBorders] key:kAWBInfoKeyImageRoundedBorders];
    roundedBordersSetting.masterSlaveType = AWBSettingMasterSlaveTypeSlaveCell;
    roundedBordersSetting.visible = addPhotoBordersSetting.isSwitchedOn;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:addPhotoBordersSetting, roundedBordersSetting, nil];    
    AWBSettingsGroup *imageBorderSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:nil];
    imageBorderSettings.masterSwitchIsOn = addPhotoBordersSetting.isSwitchedOn;
    addPhotoBordersSetting.parentGroup = imageBorderSettings;
    return [imageBorderSettings autorelease];
}

+ (AWBSettingsGroup *)textBordersSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *addTextBordersSetting = [AWBSetting switchSettingWithText:@"Add Text Borders" value:[info objectForKey:kAWBInfoKeyTextBorders] key:kAWBInfoKeyTextBorders];
    addTextBordersSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    AWBSetting *roundedBordersSetting = [AWBSetting switchSettingWithText:@"Rounded Borders" value:[info objectForKey:kAWBInfoKeyTextRoundedBorders] key:kAWBInfoKeyTextRoundedBorders];
    roundedBordersSetting.masterSlaveType = AWBSettingMasterSlaveTypeSlaveCell;
    roundedBordersSetting.visible = addTextBordersSetting.isSwitchedOn;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:addTextBordersSetting, roundedBordersSetting, nil];
    AWBSettingsGroup *textBorderSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:nil];    
    textBorderSettings.masterSwitchIsOn = addTextBordersSetting.isSwitchedOn;
    addTextBordersSetting.parentGroup = textBorderSettings; 
    return [textBorderSettings autorelease];    
}

+ (AWBSettingsGroup *)collageBorderSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *addCollageBorderSetting = [AWBSetting switchSettingWithText:@"Add Collage Border" value:[info objectForKey:kAWBInfoKeyCollageBorder] key:kAWBInfoKeyCollageBorder];
    addCollageBorderSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObject:addCollageBorderSetting];
    AWBSettingsGroup *collageBorderSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:nil];
    collageBorderSettings.masterSwitchIsOn = addCollageBorderSetting.isSwitchedOn;
    addCollageBorderSetting.parentGroup = collageBorderSettings;
    return [collageBorderSettings autorelease];
}

+ (AWBSettingsGroup *)qualitySliderSettingsGroupWithInfo:(NSDictionary *)info
{
    return [[[self alloc] initWithSettings:[NSMutableArray arrayWithObject:[AWBSetting qualitySliderSettingWithValue:[info objectForKey:kAWBInfoKeyExportQualityValue] andKey:kAWBInfoKeyExportQualityValue]] header:@"Export Quality" footer:@"Applies only to saving & emailing the collage as a photo."] autorelease];
}

+ (AWBSettingsGroup *)textEditSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *textEditSettings = [NSMutableArray arrayWithObjects:[AWBSetting textEditSettingWithText:@"Line 1" value:[info objectForKey:kAWBInfoKeyLabelTextLine1] key:kAWBInfoKeyLabelTextLine1], [AWBSetting textEditSettingWithText:@"Line 2" value:[info objectForKey:kAWBInfoKeyLabelTextLine2] key:kAWBInfoKeyLabelTextLine2], [AWBSetting textEditSettingWithText:@"Line 3" value:[info objectForKey:kAWBInfoKeyLabelTextLine3] key:kAWBInfoKeyLabelTextLine3], nil];
    
    return [[[self alloc] initWithSettings:textEditSettings header:@"Label Text" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)fontSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *fontSettings = nil;
    if (DEVICE_IS_IPAD) {
        fontSettings = [NSMutableArray arrayWithObjects:[AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeArialRoundedMTBold]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeChalkduster]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeAcademyEngravedLetPlain]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeBradleyHandITCTTBold]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeHelvetica]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeMarkerFeltThin]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypePapyrus]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypePartyLetPlain]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeSnellRoundhand]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeTrebuchetMSItalic]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeAmericanTypewriter]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeZapfino]], nil];
    } else {
        fontSettings = [NSMutableArray arrayWithObjects:[AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeArialRoundedMTBold]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeHelvetica]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeMarkerFeltThin]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeSnellRoundhand]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeTrebuchetMSItalic]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeAmericanTypewriter]], [AWBSetting fontSettingWithValue:[NSNumber numberWithInteger:AWBCollageFontTypeZapfino]], nil];
    }
    
    AWBSettingsGroup *fontGroup = [[self alloc] initWithSettings:fontSettings header:@"Font" footer:nil];
    fontGroup.isMutuallyExclusive = YES;
    fontGroup.settingKeyForMutuallyExclusiveObjects = kAWBInfoKeyTextFontName;
    
    if (DEVICE_IS_IPAD) {
        fontGroup.mutuallyExclusiveObjects = [NSMutableArray arrayWithObjects:@"ArialRoundedMTBold", @"Chalkduster", @"AcademyEngravedLetPlain", @"BradleyHandITCTT-Bold", @"Helvetica", @"MarkerFelt-Thin", @"Papyrus", @"PartyLetPlain", @"SnellRoundhand", @"TrebuchetMS-Italic", @"AmericanTypewriter", @"Zapfino", nil];
    } else {
        fontGroup.mutuallyExclusiveObjects = [NSMutableArray arrayWithObjects:@"ArialRoundedMTBold", @"Helvetica", @"MarkerFelt-Thin", @"SnellRoundhand", @"TrebuchetMS-Italic", @"AmericanTypewriter", @"Zapfino", nil];        
    }
        
    fontGroup.selectedIndex = [fontGroup.mutuallyExclusiveObjects indexOfObject:[info objectForKey:kAWBInfoKeyTextFontName]];
    
    return [fontGroup autorelease];
}

+ (AWBSettingsGroup *)shadowsAndBordersDrilldownSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:[AWBSetting drilldownSettingWithText:@"Background Colour & Texture" value:nil key:nil childSettings:[AWBSettings backgroundSettingsWithInfo:info]], [AWBSetting drilldownSettingWithText:@"Borders" value:nil key:nil childSettings:[AWBSettings borderSettingsWithInfo:info]], [AWBSetting drilldownSettingWithText:@"Shadows" value:nil key:nil childSettings:[AWBSettings shadowSettingsWithInfo:info]], [AWBSetting drilldownSettingWithText:@"Text Backgrounds" value:nil key:nil childSettings:[AWBSettings textBackgroundSettingsWithInfo:info]], nil];
    
    return [[[self alloc] initWithSettings:buttonSettings header:nil footer:nil] autorelease];    
}

+ (AWBSettingsGroup *)themesDrilldownSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *themeSettings = [NSMutableArray arrayWithObjects:[AWBSetting drilldownSettingWithText:@"Theme" value:info key:kAWBInfoKeyCollageTheme childSettings:[AWBSettings editThemeSettingsWithInfo:info]], nil];
    return [[[self alloc] initWithSettings:themeSettings header:@"Change Theme" footer:@"Warning! Changing theme will reload the collage and then reset all text objects to match the new theme."] autorelease];    
}

+ (AWBSettingsGroup *)themeListSettingsGroupWithInfo:(NSDictionary *)info header:(NSString *)header footer:(NSString *)footer   
{
    NSMutableArray *themes = [[NSMutableArray alloc] initWithCapacity:[[CollageTheme allCollageThemes] count]];
    for (CollageTheme *theme in [CollageTheme allCollageThemes]) {
        if (theme.isAvailableOnCurrentDevice) {
            if (theme) {
                [themes addObject:theme];
            }
        }
    }    
    
    NSMutableArray *themeSettings = [[NSMutableArray alloc] initWithCapacity:[themes count]];
    for (CollageTheme *theme in themes) {
        if (theme.isAvailableOnCurrentDevice) {
            AWBSetting *setting = [AWBSetting imageAndTextListSettingWithText:theme.themeName value:[UIImage imageFromFile:theme.thumbnailFilename]];
            if (setting) {
                [themeSettings addObject:setting];
            }
        }
    }

    AWBSettingsGroup *themeGroup = [[self alloc] initWithSettings:themeSettings header:header footer:footer];
    [themeSettings release];
    themeGroup.isMutuallyExclusive = YES;
    themeGroup.settingKeyForMutuallyExclusiveObjects = kAWBInfoKeyCollageTheme;
    themeGroup.mutuallyExclusiveObjects = themes;
    [themes release];
    themeGroup.selectedIndex = [themeGroup.mutuallyExclusiveObjects indexOfObject:[info objectForKey:kAWBInfoKeyCollageTheme]];
    if (themeGroup.selectedIndex >= [themeGroup.mutuallyExclusiveObjects count]) {
        themeGroup.selectedIndex = 0;
    }
    themeGroup.iPhoneRowHeight = 50.0;
    themeGroup.iPadRowHeight = 106.0;
    
    return [themeGroup autorelease];
}

+ (AWBSettingsGroup *)collageNameSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *themeNameSettings = [NSMutableArray arrayWithObjects:[AWBSetting textEditSettingWithText:@"Collage Name" value:[info objectForKey:kAWBInfoKeyCollageName] key:kAWBInfoKeyCollageName], nil];
    
    return [[[self alloc] initWithSettings:themeNameSettings header:nil footer:nil] autorelease];
}

+ (AWBSettingsGroup *)collageNameWithHeaderSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *themeNameSettings = [NSMutableArray arrayWithObjects:[AWBSetting textEditSettingWithText:@"Name" value:[info objectForKey:kAWBInfoKeyCollageName] key:kAWBInfoKeyCollageName], nil];
    
    return [[[self alloc] initWithSettings:themeNameSettings header:@"Edit Collage Name" footer:nil] autorelease];
}

+ (AWBSettingsGroup *)collageInfoMetricsSettingsGroupWithInfo:(NSDictionary *)info
{
    NSString *imageObjectTotal = [NSString stringWithFormat:@"%d", [[info objectForKey:kAWBInfoKeyCollageTotalImageObjects] intValue]];
    NSString *labelObjectTotal = [NSString stringWithFormat:@"%d", [[info objectForKey:kAWBInfoKeyCollageTotalLabelObjects] intValue]];
    NSString *imageMemoryTotal = AWBFileSizeIntToString([[info objectForKey:kAWBInfoKeyCollageTotalImageMemoryBytes] intValue]);
    NSString *collageDiskTotal = AWBFileSizeIntToString([[info objectForKey:kAWBInfoKeyCollageTotalDiskBytes] intValue]);
    
    NSMutableArray *collageInfoSettings = [NSMutableArray arrayWithObjects:[AWBSetting textAndValueSettingWithText:@"Photos" value:imageObjectTotal], [AWBSetting textAndValueSettingWithText:@"Labels" value:labelObjectTotal], [AWBSetting textAndValueSettingWithText:@"Memory" value:imageMemoryTotal], [AWBSetting textAndValueSettingWithText:@"Disk" value:collageDiskTotal], nil];
    
    return [[[self alloc] initWithSettings:collageInfoSettings header:@"Info" footer:nil] autorelease];   
}

+ (AWBSettingsGroup *)luckyDipSourceSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *luckyDipTypeSetting = [AWBSetting segmentControlSettingWithText:@"Lucky Dip Type" items:[NSArray arrayWithObjects:@"Photos", @"Contacts", nil] value:[info objectForKey:kAWBInfoKeyLuckyDipSourceSelectedIndex] key:kAWBInfoKeyLuckyDipSourceSelectedIndex];
    
    NSArray *amountDescriptions = nil;
    if (DEVICE_IS_IPAD) {
        amountDescriptions = [NSArray arrayWithObjects:@"6", @"12", @"18", @"24", @"Auto", nil];
    } else {
        amountDescriptions = [NSArray arrayWithObjects:@"5", @"10", @"15", @"20", @"Auto", nil];        
    }
    
    AWBSetting *luckyDipAmountSetting = [AWBSetting segmentControlSettingWithText:@"Amount" items:amountDescriptions value:[info objectForKey:kAWBInfoKeyLuckyDipAmountSelectedIndex] key:kAWBInfoKeyLuckyDipAmountSelectedIndex];
    luckyDipTypeSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:luckyDipTypeSetting, luckyDipAmountSetting, nil];
        
    //AWBSettingsGroup *luckyDipSourceGroup = [[self alloc] initWithSettings:buttonSettings header:@"Selection Source" footer:nil];
    AWBSettingsGroup *luckyDipSourceGroup = [[self alloc] initWithSettings:buttonSettings header:nil footer:@"Auto Amount will attempt to fill the remaining collage according to its layout."];
    luckyDipSourceGroup.masterSwitchIsOn = luckyDipTypeSetting.isSwitchedOn;
    luckyDipTypeSetting.parentGroup = luckyDipSourceGroup; 

    return [luckyDipSourceGroup autorelease];    
}

+ (AWBSettingsGroup *)luckyDipContactSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:[AWBSetting segmentControlSettingWithText:@"Contacts Type" items:[NSArray arrayWithObjects:@"Text", @"Photo", @"Both", nil] value:[info objectForKey:kAWBInfoKeyLuckyDipContactTypeSelectedIndex] key:kAWBInfoKeyLuckyDipContactTypeSelectedIndex], [AWBSetting switchSettingWithText:@"Include Phone No." value:[info objectForKey:kAWBInfoKeyLuckyDipContactIncludePhoneNumber] key:kAWBInfoKeyLuckyDipContactIncludePhoneNumber], nil];
    
    AWBSettingsGroup *luckyDipContactGroup = [[self alloc] initWithSettings:buttonSettings header:@"Contacts" footer:@"If there are not enough contacts with photos, contact's names will be added instead."];
    
    return [luckyDipContactGroup autorelease];     
}

+ (AWBSettingsGroup *)backgroundTextureListSettingsGroupWithInfo:(NSDictionary *)info header:(NSString *)header footer:(NSString *)footer   
{
    NSArray *colorDescriptions = [UIColor allTextureColorDescriptions];
    NSArray *colorImages = [UIColor allTextureColorImages];
    NSUInteger colorCount = [colorDescriptions count];
    NSMutableArray *colorSettings = [[NSMutableArray alloc] initWithCapacity:colorCount];
    
    for (NSUInteger colorIndex = 0; colorIndex < colorCount; colorIndex++) {
        AWBSetting *setting = [AWBSetting imageAndTextListSettingWithText:[colorDescriptions objectAtIndex:colorIndex] value:[colorImages objectAtIndex:colorIndex]];
        if (setting) {
            [colorSettings addObject:setting];
        }
    }

    AWBSettingsGroup *colorSettingsGroup = [[self alloc] initWithSettings:colorSettings header:header footer:footer];
    [colorSettings release];
    colorSettingsGroup.isMutuallyExclusive = YES;
    colorSettingsGroup.settingKeyForMutuallyExclusiveObjects = kAWBInfoKeyCollageBackgroundTexture;
    colorSettingsGroup.mutuallyExclusiveObjects = [NSMutableArray arrayWithArray:colorDescriptions];
    colorSettingsGroup.selectedIndex = [colorSettingsGroup.mutuallyExclusiveObjects indexOfObject:[info objectForKey:kAWBInfoKeyCollageBackgroundTexture]];
    if (colorSettingsGroup.selectedIndex >= [colorSettingsGroup.mutuallyExclusiveObjects count]) {
        colorSettingsGroup.selectedIndex = 0;
    }
    colorSettingsGroup.iPhoneRowHeight = 50.0;
    colorSettingsGroup.iPadRowHeight = 106.0;
    
    return [colorSettingsGroup autorelease];
}

+ (AWBSettingsGroup *)backgroundTextureSwitchSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *backgroundTextureSwitchSetting = [AWBSetting switchSettingWithText:@"Use Textured Background" value:[info objectForKey:kAWBInfoKeyCollageUseBackgroundTexture] key:kAWBInfoKeyCollageUseBackgroundTexture];
    backgroundTextureSwitchSetting.masterSlaveType = AWBSettingMasterSlaveTypeMasterSwitch;
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObject:backgroundTextureSwitchSetting];
    AWBSettingsGroup *backgroundTextureSwitchSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:nil];
    backgroundTextureSwitchSettings.masterSwitchIsOn = backgroundTextureSwitchSetting.isSwitchedOn;
    backgroundTextureSwitchSetting.parentGroup = backgroundTextureSwitchSettings;
    return [backgroundTextureSwitchSettings autorelease];
}

+ (AWBSettingsGroup *)backgroundDrilldownSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:[AWBSetting drilldownSettingWithText:@"Colours & Textures" value:nil key:nil childSettings:[AWBSettings backgroundSettingsWithInfo:info]], nil];
    return [[[self alloc] initWithSettings:buttonSettings header:@"Background" footer:nil] autorelease];    
}

+ (AWBSettingsGroup *)assetGroupSettingsGroupWithInfo:(NSDictionary *)info
{
    NSString *selectedGroupName = nil;
    ALAssetsGroup *selectedGroup = [info objectForKey:kAWBInfoKeySelectedAssetGroup];
    if (selectedGroup) {
        if ([selectedGroup isEqual:[NSNull null]]) {
            selectedGroupName = kAWBAllPhotosGroupPersistentID;                
        } else {
            selectedGroupName = [selectedGroup valueForProperty:ALAssetsGroupPropertyPersistentID];            
        }
    }
    NSUInteger assetGroupIndex = 0;
    NSUInteger selectedIndex = 0;
    NSMutableArray *assetGroups = [info objectForKey:kAWBInfoKeyAssetGroups];
    NSMutableArray *assetGroupSettings = [[NSMutableArray alloc] initWithCapacity:[assetGroups count]];
    for (ALAssetsGroup *assetGroup in assetGroups) {
        if ([assetGroup isEqual:[NSNull null]]) {
            if ([selectedGroupName isEqualToString:kAWBAllPhotosGroupPersistentID]) {
                selectedIndex = assetGroupIndex;                
            }
        } else {
            if ([[assetGroup valueForProperty:ALAssetsGroupPropertyPersistentID] isEqualToString:selectedGroupName]) {
                selectedIndex = assetGroupIndex;
            }
        }
        
        NSString *detailText = nil;
        NSString *assetGroupName = nil;
        UIImage *posterImage = nil;
        
        if (![assetGroup isEqual:[NSNull null]]) {
            posterImage = [UIImage imageWithCGImage:[assetGroup posterImage]];
            assetGroupName = [assetGroup valueForProperty:ALAssetsGroupPropertyName];
            NSInteger numberOfAssets = [assetGroup numberOfAssets];
            NSString *photoDesc = nil;
            if (numberOfAssets == 1) {
                photoDesc = @"Photo";
            } else {
                photoDesc = @"Photos";
            }
            detailText = [NSString stringWithFormat:@"%d %@",numberOfAssets, photoDesc]; 
        } else {
            posterImage = [UIImage imageNamed:@"blank"];
            assetGroupName = kAWBAllPhotosGroupName;
            
            NSInteger numberOfGroups = [assetGroups count] - 1; //subtract 1 for the artifically created all photos group
            NSString *albumDesc = nil;
            if (numberOfGroups == 1) {
                albumDesc = @"Album";
            } else {
                albumDesc = @"Albums";
            }
            detailText = [NSString stringWithFormat:@"%d %@",numberOfGroups, albumDesc]; 
        }

        AWBSetting *setting = [AWBSetting subtitleSettingWithText:assetGroupName detailText:detailText value:posterImage];
        if (setting) {
            [assetGroupSettings addObject:setting];            
        }
        assetGroupIndex += 1;
    }
        
    AWBSettingsGroup *assetGroupSettingsGroup = [[self alloc] initWithSettings:assetGroupSettings header:@"Photo Albums" footer:nil];
    [assetGroupSettings release];
    assetGroupSettingsGroup.isMutuallyExclusive = YES;
    assetGroupSettingsGroup.settingKeyForMutuallyExclusiveObjects = kAWBInfoKeySelectedAssetGroup;
    assetGroupSettingsGroup.mutuallyExclusiveObjects = assetGroups;
    assetGroupSettingsGroup.selectedIndex = selectedIndex;
    assetGroupSettingsGroup.iPhoneRowHeight = 60.0;
    assetGroupSettingsGroup.iPadRowHeight = 60.0;

    return [assetGroupSettingsGroup autorelease];
}

+ (AWBSettingsGroup *)assetsGroupDrilldownSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *assetsGroupSettings = [NSMutableArray arrayWithObjects:[AWBSetting drilldownSettingWithText:@"Album" value:info key:kAWBInfoKeySelectedAssetGroup childSettings:[AWBSettings assetGroupsSettingsWithInfo:info]], nil];
    return [[[self alloc] initWithSettings:assetsGroupSettings header:@"Photos" footer:nil] autorelease];    
}

+ (AWBSettingsGroup *)collageAddContentOnCreationSettingsGroupWithInfo:(NSDictionary *)info
{
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:[AWBSetting switchSettingWithText:@"Add Content" value:[info objectForKey:kAWBInfoKeyAddContentOnCreation] key:kAWBInfoKeyAddContentOnCreation], nil];
    AWBSettingsGroup *luckyDipContactGroup = [[self alloc] initWithSettings:buttonSettings header:@"Auto Content" footer:@"If enabled, a new collage is created with a random sample of photos or contacts"];
    
    return [luckyDipContactGroup autorelease];      
}

+ (AWBSettingsGroup *)snapToGridSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *snapToGridSetting = [AWBSetting switchSettingWithText:@"Snap to Grid" value:[info objectForKey:kAWBInfoKeyObjectLocatorSnapToGrid] key:kAWBInfoKeyObjectLocatorSnapToGrid];    
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:snapToGridSetting, nil];
    AWBSettingsGroup *snapToGridSettings = [[self alloc] initWithSettings:buttonSettings header:@"Manual Layout" footer:nil];
    return [snapToGridSettings autorelease];
}

+ (AWBSettingsGroup *)layoutListSettingsGroupWithInfo:(NSDictionary *)info header:(NSString *)header footer:(NSString *)footer   
{
    NSArray *layoutDescriptions = [AWBCollageLayout allLayoutDescriptions];
    NSArray *layoutImages = [AWBCollageLayout allLayoutImages];
    NSUInteger layoutCount = [layoutDescriptions count];
    NSMutableArray *layoutSettings = [[NSMutableArray alloc] initWithCapacity:layoutCount];
    
    for (NSUInteger layoutIndex = 0; layoutIndex < layoutCount; layoutIndex++) {
        AWBSetting *setting = [AWBSetting imageAndTextListSettingWithText:[layoutDescriptions objectAtIndex:layoutIndex] value:[layoutImages objectAtIndex:layoutIndex]];
        if (setting) {
            [layoutSettings addObject:setting];            
        }
    }
    
    AWBSettingsGroup *layoutSettingsGroup = [[self alloc] initWithSettings:layoutSettings header:header footer:footer];
    [layoutSettings release];
    layoutSettingsGroup.isMutuallyExclusive = YES;
    layoutSettingsGroup.settingKeyForMutuallyExclusiveObjects = kAWBInfoKeyObjectLocatorType;
    layoutSettingsGroup.mutuallyExclusiveObjects = [NSMutableArray arrayWithArray:[AWBCollageLayout allLayouts]];
    layoutSettingsGroup.selectedIndex = [layoutSettingsGroup.mutuallyExclusiveObjects indexOfObject:[info objectForKey:kAWBInfoKeyObjectLocatorType]];
    if (layoutSettingsGroup.selectedIndex >= [layoutSettingsGroup.mutuallyExclusiveObjects count]) {
        layoutSettingsGroup.selectedIndex = 0;
    }
    layoutSettingsGroup.iPhoneRowHeight = 50.0;
    layoutSettingsGroup.iPadRowHeight = 106.0;
    
    return [layoutSettingsGroup autorelease];
}

+ (AWBSettingsGroup *)lockAndLayoutSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *lockCollageSetting = [AWBSetting switchSettingWithText:@"Lock Collage" value:[info objectForKey:kAWBInfoKeyObjectLocatorLockCollage] key:kAWBInfoKeyObjectLocatorLockCollage];
    AWBSetting *layoutDrilldownSetting = [AWBSetting drilldownSettingWithText:@"Layouts" value:nil key:nil childSettings:[AWBSettings layoutSettingsWithInfo:info]];    
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:lockCollageSetting, layoutDrilldownSetting, nil];
    AWBSettingsGroup *lockAndLayoutSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:nil];
    return [lockAndLayoutSettings autorelease];
}

+ (AWBSettingsGroup *)autoMemoryReductionSettingsGroupWithInfo:(NSDictionary *)info
{
    AWBSetting *autoMemoryReductionSetting = [AWBSetting switchSettingWithText:@"Reduce Memory" value:[info objectForKey:kAWBInfoKeyObjectLocatorAutoMemoryReduction] key:kAWBInfoKeyObjectLocatorAutoMemoryReduction];    
    NSMutableArray *buttonSettings = [NSMutableArray arrayWithObjects:autoMemoryReductionSetting, nil];
    AWBSettingsGroup *autoMemoryReductionSettings = [[self alloc] initWithSettings:buttonSettings header:nil footer:@"For mosaics with lots of smaller photos, images are further downsized to reduce memory usage.  A change to this setting does not affect existing photos."];
    return [autoMemoryReductionSettings autorelease];
}

- (void)dealloc
{
    [settings release];
    [header release];
    [footer release];
    [mutuallyExclusiveObjects release];
    [settingKeyForMutuallyExclusiveObjects release];
    [visibleSettings release];
    [super dealloc];
}

@end
