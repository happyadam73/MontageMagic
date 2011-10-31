//
//  CollageMakerViewController+LuckyDip.h
//  Collage Maker
//
//  Created by Adam Buckley on 23/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController.h"
#import "AWBCollageSettingsTableViewController.h"
#import "CollageTheme.h"

enum {
    kAWBLuckyDipAmountIndex5Or6Objects = 0,
    kAWBLuckyDipAmountIndex10Or12Objects = 1,
    kAWBLuckyDipAmountIndex15Or18Objects = 2,
    kAWBLuckyDipAmountIndex20Or24Objects = 3,
    kAWBLuckyDipAmountIndexAutoFill = 4
};

enum {
    kAWBLuckyDipSourceIndexPhotos = 0,
    kAWBLuckyDipSourceIndexContacts = 1
};

enum {
    kAWBLuckyDipContactTypeIndexTextOnly = 0,
    kAWBLuckyDipContactTypeIndexPhotoOnly = 1,
    kAWBLuckyDipContactTypeIndexTextAndPhoto = 2
};

@interface CollageMakerViewController (LuckyDip)

- (void)initialiseLuckyDipPopoverWithViewController:(UIViewController *)viewController andBarButtonItem:(UIBarButtonItem *)button;
- (void)performLuckyDip:(id)sender;
- (void)presentLuckyDipController;
- (void)luckyDipTableViewController:(AWBCollageSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info;
- (void)luckyDipAddPhotos;
- (void)luckyDipAddContacts;
- (NSIndexSet *)randomUniqueNumbersFromLow:(NSUInteger)low toHigh:(NSUInteger)high totalRequired:(NSUInteger)count;
- (NSUInteger)luckyDipAmountFromIndex:(NSInteger)amountIndex;
- (ALAssetsGroup *)assetsGroupFromAssetsGroups:(NSArray *)assetsGroups withName:(NSString *)groupName;
- (void)addPhotosFromWholeLibrary;
- (void)assetGroupEnumerationFailedWithError:(NSError *)error;
- (void)autoStartWithLuckyDip;
- (void)autoStartLuckyDipWithSourceIndex:(NSNumber *)index;
- (NSUInteger)bestAmountIndexForDevice;
- (NSUInteger)bestLuckyDipSourceForCollageTheme:(CollageThemeType)themeType;

@end
