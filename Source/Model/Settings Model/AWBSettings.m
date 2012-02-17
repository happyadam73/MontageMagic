//
//  AWBSettings.m
//  Collage Maker
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBSettings.h"
#import "AWBMyFontStore.h"

@implementation AWBSettings

@synthesize settingsGroups;
@synthesize settingsTitle;
@synthesize headerView;
@synthesize delegate;

- (id)initWithSettingsGroups:(NSMutableArray *)aSettingsGroups title:(NSString *)title
{
    self = [super init];
    if (self) {
        [self setSettingsTitle:title];
        [self setSettingsGroups:aSettingsGroups];
    }
    return self;
}

- (id)initWithSettingsGroups:(NSMutableArray *)aSettingsGroups
{
    return [self initWithSettingsGroups:aSettingsGroups title:@"Settings"];
}

- (void)dealloc
{
    [visibleSettingsGroups release];
    [settingsGroups release];
    [settingsTitle release];
    [headerView release];
    [super dealloc];
}

- (NSMutableArray *)visibleSettingsGroups
{
    if (visibleSettingsGroups) {
        return visibleSettingsGroups;
    } else {
        visibleSettingsGroups = [[NSMutableArray alloc] init];
        if (self.settingsGroups && ([self.settingsGroups count] > 0)) {
            for (AWBSettingsGroup *settingsGroup in self.settingsGroups) {
                if (settingsGroup.visible) {
                    [visibleSettingsGroups addObject:settingsGroup];
                }
            }
        }
        return visibleSettingsGroups;       
    }
}

- (void)visibleSettingsGroupsHaveChanged
{
    [visibleSettingsGroups release];
    visibleSettingsGroups = nil;
}

- (NSString *)description
{
    return [settingsGroups description];
}

- (void)masterSwitchSettingHasChangedValue:(AWBSetting *)setting forSettingsGroup:(AWBSettingsGroup *)settingsGroup
{
    if([delegate respondsToSelector:@selector(masterSwitchSettingHasChangedValue:forSettingsGroup:)]) {
		[delegate performSelector:@selector(masterSwitchSettingHasChangedValue:forSettingsGroup:) withObject:setting withObject:settingsGroup];
	}    
}

+ (AWBSettings *)mainSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup lockAndLayoutSettingsGroupWithInfo:info], [AWBSettingsGroup shadowsAndBordersDrilldownSettingsGroupWithInfo:info], [AWBSettingsGroup exportSizeSliderSettingsGroupWithInfo:info], nil];
    AWBSettings *mainSettings = [[self alloc] initWithSettingsGroups:settings title:@"Collage Settings"];
    
    return [mainSettings autorelease];
}

+ (AWBSettings *)borderSettingsWithInfo:(NSDictionary *)info    
{
    AWBSettingsGroup *imageBorderSettings = [AWBSettingsGroup imageBordersSettingsGroupWithInfo:info];
    AWBSettingsGroup *imageBorderColorPicker = [AWBSettingsGroup imageBorderColorPickerSettingsGroupWithInfo:info];
    AWBSettingsGroup *textBorderSettings = [AWBSettingsGroup textBordersSettingsGroupWithInfo:info];
    AWBSettingsGroup *textBorderColorPicker = [AWBSettingsGroup textBorderColorPickerSettingsGroupWithInfo:info];
    AWBSettingsGroup *collageBorderSettings = [AWBSettingsGroup collageBorderSettingsGroupWithInfo:info];
    AWBSettingsGroup *collageBorderColorPicker = [AWBSettingsGroup collageBorderColorPickerSettingsGroupWithInfo:info];
    
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:imageBorderSettings, imageBorderColorPicker, textBorderSettings, textBorderColorPicker, collageBorderSettings, collageBorderColorPicker, nil];
    AWBSettings *borderSettings = [[self alloc] initWithSettingsGroups:settings title:@"Borders"];
    imageBorderSettings.parentSettings = borderSettings;
    imageBorderSettings.dependentVisibleSettingsGroup = imageBorderColorPicker;
    imageBorderColorPicker.visible = imageBorderSettings.masterSwitchIsOn;
    textBorderSettings.parentSettings = borderSettings;
    textBorderSettings.dependentVisibleSettingsGroup = textBorderColorPicker;
    textBorderColorPicker.visible = textBorderSettings.masterSwitchIsOn;
    collageBorderSettings.parentSettings = borderSettings;
    collageBorderSettings.dependentVisibleSettingsGroup = collageBorderColorPicker;
    collageBorderColorPicker.visible = collageBorderSettings.masterSwitchIsOn;
    
    return [borderSettings autorelease];
}

+ (AWBSettings *)shadowSettingsWithInfo:(NSDictionary *)info    
{
    AWBSettingsGroup *imageShadowsSettings = [AWBSettingsGroup imageShadowsSettingsGroupWithInfo:info];
    AWBSettingsGroup *imageShadowsColorPicker = [AWBSettingsGroup imageShadowColorPickerSettingsGroupWithInfo:info];
    AWBSettingsGroup *textShadowsSettings = [AWBSettingsGroup textShadowsSettingsGroupWithInfo:info];
    AWBSettingsGroup *textShadowsColorPicker = [AWBSettingsGroup textShadowColorPickerSettingsGroupWithInfo:info];
    
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:imageShadowsSettings, imageShadowsColorPicker, textShadowsSettings, textShadowsColorPicker, nil];
    AWBSettings *shadowSettings = [[self alloc] initWithSettingsGroups:settings title:@"Shadows"];
    imageShadowsSettings.parentSettings = shadowSettings;
    imageShadowsSettings.dependentVisibleSettingsGroup = imageShadowsColorPicker;
    imageShadowsColorPicker.visible = imageShadowsSettings.masterSwitchIsOn;
    textShadowsSettings.parentSettings = shadowSettings;
    textShadowsSettings.dependentVisibleSettingsGroup = textShadowsColorPicker;
    textShadowsColorPicker.visible = textShadowsSettings.masterSwitchIsOn;
    return [shadowSettings autorelease]; 
}

+ (AWBSettings *)textBackgroundSettingsWithInfo:(NSDictionary *)info    
{
    AWBSettingsGroup *textBackgroundSettings = [AWBSettingsGroup textBackgroundSettingsGroupWithInfo:info];
    AWBSettingsGroup *textBackgroundColorPicker = [AWBSettingsGroup textBackgroundColorPickerSettingsGroupWithInfo:info];
    
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:textBackgroundSettings, textBackgroundColorPicker, nil];
    AWBSettings *backgroundSettings = [[self alloc] initWithSettingsGroups:settings title:@"Text Backgrounds"];
    textBackgroundSettings.parentSettings = backgroundSettings;
    textBackgroundSettings.dependentVisibleSettingsGroup = textBackgroundColorPicker;
    textBackgroundColorPicker.visible = textBackgroundSettings.masterSwitchIsOn;
    return [backgroundSettings autorelease]; 
}

+ (AWBSettings *)textSettingsWithInfo:(NSDictionary *)info
{
    AWBSettings *textSettings = nil;
    NSString *settingsTitle = @"Add Text";

    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup textEditSettingsGroupWithInfo:info], [AWBSettingsGroup textAlignmentPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textColorPickerSettingsGroupWithInfo:info], nil];
    AWBSettingsGroup *fontTypeSettings = [AWBSettingsGroup myFontsSwitchSettingsGroupWithInfo:info];
    AWBSettingsGroup *builtInFontSettings = [AWBSettingsGroup fontSettingsGroupWithInfo:info];
    [settings addObject:fontTypeSettings];
    [settings addObject:builtInFontSettings];
    
    if ([[[AWBMyFontStore defaultStore] allMyFonts] count] > 0) {
        AWBSettingsGroup *myFontSettings = [AWBSettingsGroup myFontSettingsGroupWithInfo:info];
        [settings addObject:myFontSettings];
        textSettings = [[self alloc] initWithSettingsGroups:settings title:settingsTitle];
        fontTypeSettings.parentSettings = textSettings;
        fontTypeSettings.dependentVisibleSettingsGroup = myFontSettings;
        fontTypeSettings.dependentHiddenSettingsGroup = builtInFontSettings;
        myFontSettings.visible = fontTypeSettings.masterSwitchIsOn;
        builtInFontSettings.visible = !fontTypeSettings.masterSwitchIsOn;
    } else {
        //no my fonts installed
        textSettings = [[self alloc] initWithSettingsGroups:settings title:settingsTitle];
    }
    
    return [textSettings autorelease];
}

+ (AWBSettings *)editTextSettingsWithInfo:(NSDictionary *)info
{
    AWBSettings *textSettings = nil;
    NSString *settingsTitle = @"Edit Labels";
    
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup textAlignmentPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textColorPickerSettingsGroupWithInfo:info], nil];
    AWBSettingsGroup *fontTypeSettings = [AWBSettingsGroup myFontsSwitchSettingsGroupWithInfo:info];
    AWBSettingsGroup *builtInFontSettings = [AWBSettingsGroup fontSettingsGroupWithInfo:info];
    [settings addObject:fontTypeSettings];
    [settings addObject:builtInFontSettings];
    
    if ([[[AWBMyFontStore defaultStore] allMyFonts] count] > 0) {
        AWBSettingsGroup *myFontSettings = [AWBSettingsGroup myFontSettingsGroupWithInfo:info];
        [settings addObject:myFontSettings];
        textSettings = [[self alloc] initWithSettingsGroups:settings title:settingsTitle];
        fontTypeSettings.parentSettings = textSettings;
        fontTypeSettings.dependentVisibleSettingsGroup = myFontSettings;
        fontTypeSettings.dependentHiddenSettingsGroup = builtInFontSettings;
        myFontSettings.visible = fontTypeSettings.masterSwitchIsOn;
        builtInFontSettings.visible = !fontTypeSettings.masterSwitchIsOn;
    } else {
        //no my fonts installed
        textSettings = [[self alloc] initWithSettingsGroups:settings title:settingsTitle];
    }
    
    return [textSettings autorelease];
}

+ (AWBSettings *)editSingleTextSettingsWithInfo:(NSDictionary *)info
{
    AWBSettings *textSettings = nil;
    NSString *settingsTitle = @"Edit Label";
    
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup textEditSettingsGroupWithInfo:info], [AWBSettingsGroup textAlignmentPickerSettingsGroupWithInfo:info], [AWBSettingsGroup textColorPickerSettingsGroupWithInfo:info], nil];
    AWBSettingsGroup *fontTypeSettings = [AWBSettingsGroup myFontsSwitchSettingsGroupWithInfo:info];
    AWBSettingsGroup *builtInFontSettings = [AWBSettingsGroup fontSettingsGroupWithInfo:info];
    [settings addObject:fontTypeSettings];
    [settings addObject:builtInFontSettings];
    
    if ([[[AWBMyFontStore defaultStore] allMyFonts] count] > 0) {
        AWBSettingsGroup *myFontSettings = [AWBSettingsGroup myFontSettingsGroupWithInfo:info];
        [settings addObject:myFontSettings];
        textSettings = [[self alloc] initWithSettingsGroups:settings title:settingsTitle];
        fontTypeSettings.parentSettings = textSettings;
        fontTypeSettings.dependentVisibleSettingsGroup = myFontSettings;
        fontTypeSettings.dependentHiddenSettingsGroup = builtInFontSettings;
        myFontSettings.visible = fontTypeSettings.masterSwitchIsOn;
        builtInFontSettings.visible = !fontTypeSettings.masterSwitchIsOn;
    } else {
        //no my fonts installed
        textSettings = [[self alloc] initWithSettingsGroups:settings title:settingsTitle];
    }
    
    return [textSettings autorelease];    
}

+ (AWBSettings *)themeSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup collageNameSettingsGroupWithInfo:info], [AWBSettingsGroup themeListSettingsGroupWithInfo:info header:@"Choose a Theme for the new Collage" footer:@"You can change theme and modify theme settings at any time."], [AWBSettingsGroup collageAddContentOnCreationSettingsGroupWithInfo:info], nil];
    return [[[self alloc] initWithSettingsGroups:settings title:@"New Collage"] autorelease];
}

+ (AWBSettings *)editThemeSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup themeListSettingsGroupWithInfo:info header:@"Change the Collage Theme" footer:nil], nil];
    return [[[self alloc] initWithSettingsGroups:settings title:@"Change Theme"] autorelease];
}

+ (AWBSettings *)collageDescriptionSettingsWithInfo:(NSDictionary *)info header:(UIView *)header
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup collageNameWithHeaderSettingsGroupWithInfo:info], [AWBSettingsGroup collageInfoMetricsSettingsGroupWithInfo:info], [AWBSettingsGroup themesDrilldownSettingsGroupWithInfo:info], nil];
    AWBSettings *collageDescriptionSettings = [[self alloc] initWithSettingsGroups:settings title:@"Collage Information"];
    collageDescriptionSettings.headerView = header;
    return [collageDescriptionSettings autorelease];
}

+ (AWBSettings *)luckyDipSettingsWithInfo:(NSDictionary *)info
{
    AWBSettingsGroup *luckyDipSourceSettings = [AWBSettingsGroup luckyDipSourceSettingsGroupWithInfo:info];
    AWBSettingsGroup *luckyDipAssetsDrilldownSettings = [AWBSettingsGroup assetsGroupDrilldownSettingsGroupWithInfo:info];
    AWBSettingsGroup *luckyDipContactSettings = [AWBSettingsGroup luckyDipContactSettingsGroupWithInfo:info];
    
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:luckyDipSourceSettings, luckyDipAssetsDrilldownSettings, luckyDipContactSettings, nil];
    AWBSettings *luckyDipSettings = [[self alloc] initWithSettingsGroups:settings title:@"Lucky Dip Settings"];
    
    luckyDipSourceSettings.parentSettings = luckyDipSettings;
    luckyDipSourceSettings.dependentVisibleSettingsGroup = luckyDipContactSettings;
    luckyDipSourceSettings.dependentHiddenSettingsGroup = luckyDipAssetsDrilldownSettings;
    luckyDipContactSettings.visible = luckyDipSourceSettings.masterSwitchIsOn;
    luckyDipAssetsDrilldownSettings.visible = !luckyDipSourceSettings.masterSwitchIsOn;
    
    return [luckyDipSettings autorelease];    
}

+ (AWBSettings *)assetGroupsSettingsWithInfo:(NSDictionary *)info
{
    NSMutableArray *settings = [NSMutableArray arrayWithObject:[AWBSettingsGroup assetGroupSettingsGroupWithInfo:info]];
    return [[[self alloc] initWithSettingsGroups:settings title:@"Select Photo Album"] autorelease];
}

+ (AWBSettings *)backgroundSettingsWithInfo:(NSDictionary *)info
{
    AWBSettingsGroup *backgroundTypeSettings = [AWBSettingsGroup backgroundTextureSwitchSettingsGroupWithInfo:info];
    AWBSettingsGroup *backgroundColorSettings = [AWBSettingsGroup backgroundColorPickerSettingsGroupWithInfo:info];
    AWBSettingsGroup *backgroundTextureSettings = [AWBSettingsGroup backgroundTextureListSettingsGroupWithInfo:info header:@"Choose a Background Texture" footer:nil];
    
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:backgroundTypeSettings, backgroundColorSettings, backgroundTextureSettings, nil];
    AWBSettings *backgroundSettings = [[self alloc] initWithSettingsGroups:settings title:@"Background Settings"];
    
    backgroundTypeSettings.parentSettings = backgroundSettings;
    backgroundTypeSettings.dependentVisibleSettingsGroup = backgroundTextureSettings;
    backgroundTypeSettings.dependentHiddenSettingsGroup = backgroundColorSettings;
    backgroundTextureSettings.visible = backgroundTypeSettings.masterSwitchIsOn;
    backgroundColorSettings.visible = !backgroundTypeSettings.masterSwitchIsOn;
    
    return [backgroundSettings autorelease];    
}

+ (AWBSettings *)layoutSettingsWithInfo:(NSDictionary *)info
{
    AWBSettingsGroup *snapToGridSettings = [AWBSettingsGroup snapToGridSettingsGroupWithInfo:info];
    AWBSettingsGroup *layoutListSettings = [AWBSettingsGroup layoutListSettingsGroupWithInfo:info header:@"Automatic Layout" footer:@"Adding new photos and contacts automatically places them according to the chosen layout - you can still manually place all objects after they are added.  Removing all objects resets the layout."];
    AWBSettingsGroup *autoMemoryReductionSettings = [AWBSettingsGroup autoMemoryReductionSettingsGroupWithInfo:info];
    
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:snapToGridSettings, layoutListSettings, autoMemoryReductionSettings, nil];
    AWBSettings *layoutSettings = [[self alloc] initWithSettingsGroups:settings title:@"Layout Settings"];
    
    return [layoutSettings autorelease];    
}

+ (AWBSettings *)myFontDescriptionSettingsWithInfo:(NSDictionary *)info header:(UIView *)header
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup myFontNameWithHeaderSettingsGroupWithInfo:info], [AWBSettingsGroup myFontPreviewSettingsGroupWithInfo:info], [AWBSettingsGroup myFontInfoMetricsSettingsGroupWithInfo:info], nil];
    AWBSettings *myFontDescriptionSettings = [[self alloc] initWithSettingsGroups:settings title:@"MyFont Preview"];
    myFontDescriptionSettings.headerView = header;
    return [myFontDescriptionSettings autorelease];
}

+ (AWBSettings *)helpSettingsWithFilename:(NSString *)filename title:(NSString *)title
{
    NSMutableArray *settings = [NSMutableArray arrayWithObjects:[AWBSettingsGroup helpTextSettingsGroupWithFilename:filename], nil];
    AWBSettings *helpSettings = [[self alloc] initWithSettingsGroups:settings title:title];
    
    return [helpSettings autorelease];    
}

- (NSMutableDictionary *)infoFromSettings
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    
    for (AWBSettingsGroup *settingsGroup in self.settingsGroups) {
        for (AWBSetting *setting in settingsGroup.settings) {
            if (setting.settingKey && setting.settingValue) {
                if (!setting.readonly) {
                    [info setObject:setting.settingValue forKey:setting.settingKey];                    
                }
            }
        }
        
        if (settingsGroup.isMutuallyExclusive) {
            if (settingsGroup.settingKeyForMutuallyExclusiveObjects && settingsGroup.mutuallyExclusiveObjects && (settingsGroup.selectedIndex != NSNotFound)) {
                [info setObject:[settingsGroup.mutuallyExclusiveObjects objectAtIndex:settingsGroup.selectedIndex] forKey:settingsGroup.settingKeyForMutuallyExclusiveObjects];
            }
        }
    }
    
    return [info autorelease];
}

@end
