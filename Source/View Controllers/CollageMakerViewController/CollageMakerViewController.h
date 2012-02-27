//
//  CollageMakerViewController.h
//  CollageMaker
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"
#import "Collage.h"
#import "AWBTransformableArrowView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AWBBusyView.h"
#import "AWBCollageObjectLocator.h"

#define MAX_PIXELS 200000

@class CollageDescriptor;
@class CollageTheme;

@interface CollageMakerViewController : UIViewController <UINavigationControllerDelegate, UIActionSheetDelegate> {
    UIView *canvasView;
    
    UIRotationGestureRecognizer *rotationGestureRecognizer;
    UIPanGestureRecognizer *panGestureRecognizer;
    UIPinchGestureRecognizer *pinchGestureRecognizer;
    UITapGestureRecognizer *singleTapGestureRecognizer;
    UITapGestureRecognizer *doubleTapGestureRecognizer;
    UISwipeGestureRecognizer *swipeGestureRecognizer;
    
    UIView <AWBTransformableView> *capturedView;
    CGPoint capturedCenterOffset;
    BOOL currentlyPinching;
    BOOL currentlyRotating;

    UIBarButtonItem *editButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *editTextButton;
    UIBarButtonItem *selectNoneOrAllButton;    
    UIBarButtonItem *cameraButton;
    UIBarButtonItem *addressBookButton;
    UIProgressView *progressView;
    UIBarButtonItem *progressViewHolder;
    UIBarButtonItem *textButton;
    UIBarButtonItem *luckyDipButton;
    UIBarButtonItem *addSymbolButton;
    UIBarButtonItem *actionButton;
    UIBarButtonItem *memoryWarningButton;
    UIBarButtonItem *settingsButton;
    UILabel *importingLabel;
    UIBarButtonItem *importingLabelHolder;
    UIBarButtonItem *toolbarSpacing;
    UIBarButtonItem *fixedToolbarSpacing;
    
    UIPopoverController *imagePickerPopover;
    UIPopoverController *addressBookPopover;
    UIPopoverController *addSymbolPopover;
    UIPopoverController *luckyDipPopover;
    UIPopoverController *memoryWarningPopover;
    
    UIActionSheet *choosePhotoSourceSheet; 
    UIActionSheet *deleteConfirmationSheet;
    UIActionSheet *chooseActionTypeSheet;
    
    BOOL isCollageInEditMode;
    NSInteger lowMemoryCount;
    BOOL isImporting;
    BOOL addImageShadows;
    BOOL addTextShadows;
    BOOL addImageBorders;
    BOOL addTextBorders;
    BOOL imageRoundedBorders;
    AWBImageRoundedCornerSize imageRoundedCornerSize;
    AWBShadowOffsetSize imageShadowOffsetSize;
    AWBShadowOffsetSize textShadowOffsetSize;
    BOOL textRoundedBorders;
    BOOL addTextBackground;
    UIColor *imageShadowColor;
    UIColor *textShadowColor;
    UIColor *imageBorderColor;
    UIColor *textBorderColor;
    UIColor *textBackgroundColor;
    CGFloat exportSize;
    NSUInteger exportFormatSelectedIndex;
    BOOL pngExportTransparentBackground;
    CGFloat jpgExportQualityValue;
    
    NSString *labelTextLine1;
    NSString *labelTextLine2;
    NSString *labelTextLine3;
    UIColor *labelTextColor;
    NSString *labelTextFont;
    BOOL useMyFonts;
    NSString *labelMyFont;
    UITextAlignment labelTextAlignment;
    UIColor *symbolColor;
    AWBArrowLineShapeType symbolShape;
    
    BOOL addCollageBorder;
    UIColor *collageBorderColor;
    BOOL useBackgroundTexture;
    UIColor *collageBackgroundColor;
    NSString *collageBackgroundTexture;
    
    NSUInteger totalSelectedInEditMode;
    NSUInteger totalSelectedLabelsInEditMode; 
    NSUInteger totalLabelSubviews;
    NSUInteger totalSymbolSubviews;
    NSUInteger totalImageSubviews;
    
    NSString *collageSaveDocumentsSubdirectory;
    
    BOOL collageLoadRequired;
    BOOL requestThemeChangeOnNextLoad;
    CollageDescriptor *collageDescriptor;
    
    NSMutableArray *assetGroups;
    ALAssetsGroup *selectedAssetsGroup;
    NSString *selectedAssetsGroupName;
    NSUInteger totalAssets;
    NSInteger luckyDipSourceIndex;
    NSInteger luckyDipAmountIndex;
    NSInteger luckyDipContactTypeIndex;
    BOOL luckyDipContactIncludePhoneNumber;
    BOOL createMagicCollage;
    BOOL luckyDipInProgress;
    
    AWBBusyView *busyView;
    
    ALAssetsLibrary *assetsLibrary; 
    BOOL dismissAssetsLibrary;
    
    NSUInteger imageCountWhenMemoryWarningOccurred;
    BOOL displayMemoryWarningIndicator;
    BOOL animateMemoryWarningIndicator;
    
    AWBCollageObjectLocator *collageObjectLocator;
    BOOL viewDidUnload;
    
    BOOL increasePhotoImportResolution;
}

@property (nonatomic, retain) UIView *canvasView;
@property (nonatomic, retain) UIRotationGestureRecognizer *rotationGestureRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, retain) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, retain) UIBarButtonItem *editButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *deleteButton;
@property (nonatomic, retain) UIBarButtonItem *editTextButton;
@property (nonatomic, retain) UIBarButtonItem *selectNoneOrAllButton;
@property (nonatomic, retain) UIBarButtonItem *cameraButton;
@property (nonatomic, retain) UIBarButtonItem *addressBookButton;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) UIBarButtonItem *progressViewHolder;
@property (nonatomic, retain) UIBarButtonItem *textButton;
@property (nonatomic, retain) UIBarButtonItem *luckyDipButton;
@property (nonatomic, retain) UIBarButtonItem *addSymbolButton;
@property (nonatomic, retain) UIBarButtonItem *actionButton;
@property (nonatomic, retain) UIBarButtonItem *memoryWarningButton;
@property (nonatomic, retain) UIBarButtonItem *settingsButton;
@property (nonatomic, retain) UILabel *importingLabel;
@property (nonatomic, retain) UIBarButtonItem *importingLabelHolder;
@property (nonatomic, retain) UIBarButtonItem *toolbarSpacing;
@property (nonatomic, retain) UIBarButtonItem *fixedToolbarSpacing;
@property (nonatomic, retain) UIPopoverController *imagePickerPopover;
@property (nonatomic, retain) UIPopoverController *addressBookPopover;
@property (nonatomic, retain) UIPopoverController *addSymbolPopover;
@property (nonatomic, retain) UIPopoverController *luckyDipPopover;
@property (nonatomic, retain) UIPopoverController *memoryWarningPopover;
@property (nonatomic, retain) UIActionSheet *deleteConfirmationSheet;
@property (nonatomic, retain) UIActionSheet *choosePhotoSourceSheet;
@property (nonatomic, retain) UIActionSheet *chooseActionTypeSheet;
@property (assign) BOOL isCollageInEditMode;
@property (assign) BOOL lowMemory;
@property (assign) BOOL isImporting;
@property (assign) NSInteger lowMemoryCount;
@property (nonatomic, assign) BOOL addImageShadows;
@property (nonatomic, assign) BOOL addTextShadows;
@property (nonatomic, assign) BOOL addImageBorders;
@property (nonatomic, assign) BOOL addTextBorders;
@property (nonatomic, assign) BOOL imageRoundedBorders;
@property (nonatomic, assign) AWBImageRoundedCornerSize imageRoundedCornerSize;
@property (nonatomic, assign) AWBShadowOffsetSize imageShadowOffsetSize;
@property (nonatomic, assign) AWBShadowOffsetSize textShadowOffsetSize;
@property (nonatomic, assign) BOOL textRoundedBorders;
@property (nonatomic, assign) BOOL addTextBackground;
@property (nonatomic, retain) UIColor *imageShadowColor;
@property (nonatomic, retain) UIColor *textShadowColor;
@property (nonatomic, retain) UIColor *imageBorderColor;
@property (nonatomic, retain) UIColor *textBorderColor;
@property (nonatomic, retain) UIColor *textBackgroundColor;
@property (nonatomic, assign) CGFloat exportSize;
@property (nonatomic, assign) NSUInteger exportFormatSelectedIndex;
@property (nonatomic, assign) BOOL pngExportTransparentBackground;
@property (nonatomic, assign) CGFloat jpgExportQualityValue;
@property (nonatomic, retain) NSString *labelTextLine1;
@property (nonatomic, retain) NSString *labelTextLine2;
@property (nonatomic, retain) NSString *labelTextLine3;
@property (nonatomic, retain) UIColor *labelTextColor;
@property (nonatomic, retain) NSString *labelTextFont;
@property (nonatomic, assign) BOOL useMyFonts;
@property (nonatomic, retain) NSString *labelMyFont;
@property (nonatomic, assign) UITextAlignment labelTextAlignment;
@property (nonatomic, retain) UIColor *symbolColor;
@property (nonatomic, assign) AWBArrowLineShapeType symbolShape;
@property (nonatomic, assign) BOOL addCollageBorder;
@property (nonatomic, retain) UIColor *collageBorderColor;
@property (nonatomic, assign) BOOL useBackgroundTexture;
@property (nonatomic, retain) NSString *collageBackgroundTexture;
@property (nonatomic, retain) UIColor *collageBackgroundColor;
@property (nonatomic, retain) NSString *collageSaveDocumentsSubdirectory;
@property (nonatomic, readonly) NSUInteger totalCollageSubviews;
@property (nonatomic, readonly) NSUInteger totalCollageSubviewsWithShadows;
@property (nonatomic, readonly) NSUInteger totalLabelSubviews;
@property (nonatomic, readonly) NSUInteger totalImageSubviews;
@property (nonatomic, readonly) NSUInteger totalSymbolSubviews;
@property (nonatomic, readonly) BOOL isLevel1AnimationsEnabled;
@property (nonatomic, readonly) BOOL isLevel2AnimationsEnabled;
@property (nonatomic, readonly) BOOL excessiveSubviewCount;
@property (nonatomic, assign) CollageDescriptor *collageDescriptor;
@property (nonatomic, assign) BOOL requestThemeChangeOnNextLoad;
@property (nonatomic, retain) NSMutableArray *assetGroups;
@property (nonatomic, retain) ALAssetsGroup *selectedAssetsGroup;
@property (nonatomic, retain) NSString *selectedAssetsGroupName;
@property (nonatomic, assign) NSInteger luckyDipSourceIndex;
@property (nonatomic, assign) NSInteger luckyDipAmountIndex;
@property (nonatomic, assign) NSInteger luckyDipContactTypeIndex;
@property (nonatomic, assign) BOOL luckyDipContactIncludePhoneNumber;
@property (nonatomic, assign) BOOL createMagicCollage;
@property (nonatomic, retain) AWBBusyView *busyView;
@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, retain) AWBCollageObjectLocator *collageObjectLocator;
@property (nonatomic, readonly) BOOL luckyDipImportCollageIsFull;
@property (nonatomic, assign) BOOL increasePhotoImportResolution;

- (id)initWithCollageDescriptor:(CollageDescriptor *)collage;
- (void)updateCollageWithTheme:(CollageTheme *)theme;
- (void)updateAllLabels;
- (NSString *)archivePath;
- (NSString *)thumbnailArchivePath;
- (BOOL)saveChanges:(BOOL)saveThumbnail;
- (void)loadChanges;
- (void)showMemoryWarning:(id)sender;

+ (NSUInteger)excessiveSubviewCountThreshold;

@end
