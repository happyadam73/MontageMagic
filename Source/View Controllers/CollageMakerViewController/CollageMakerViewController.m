//
//  CollageMakerViewController.m
//  CollageMaker
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController.h"
#import "CollageMakerViewController+Gestures.h"
#import "CollageMakerViewController+UI.h"
#import "FileHelpers.h"
#import "Collage.h"
#import "UIColor+SignColors.h"
#import "CollageMakerViewController+Toolbar.h"
#import "CollageDescriptor.h"
#import "CollageStore.h"
#import "CollageTheme.h"
#import "CollageMakerViewController+Edit.h"
#import "CollageMakerViewController+LuckyDip.h"
#import "AWBTransformableArrowView.h"
#import "UIColor+Texture.h"
#import "AWBMemoryWarningViewController.h"

@implementation CollageMakerViewController

@synthesize rotationGestureRecognizer, panGestureRecognizer, pinchGestureRecognizer, singleTapGestureRecognizer, doubleTapGestureRecognizer, swipeGestureRecognizer;
@synthesize isCollageInEditMode, cameraButton, addressBookButton, actionButton, progressView, progressViewHolder, textButton, luckyDipButton, addSymbolButton;
@synthesize cancelButton, editButton, deleteButton, editTextButton, selectNoneOrAllButton, settingsButton, memoryWarningButton, importingLabel, importingLabelHolder, toolbarSpacing, fixedToolbarSpacing;
@synthesize imagePickerPopover, addressBookPopover, luckyDipPopover, memoryWarningPopover, deleteConfirmationSheet, choosePhotoSourceSheet, addSymbolPopover, chooseActionTypeSheet;
@synthesize lowMemoryCount, isImporting, exportSize, addImageShadows, addTextBorders, addImageBorders, addTextShadows, imageRoundedBorders, textRoundedBorders, addTextBackground, imageShadowColor, textShadowColor, imageBorderColor, textBorderColor, textBackgroundColor;
@synthesize labelTextFont, labelTextColor, labelTextLine1, labelTextLine2, labelTextLine3, symbolColor, symbolShape;
@synthesize collageSaveDocumentsSubdirectory, totalCollageSubviews, totalCollageSubviewsWithShadows, isLevel1AnimationsEnabled, isLevel2AnimationsEnabled, excessiveSubviewCount, totalImageSubviews, totalLabelSubviews, totalSymbolSubviews;
@synthesize collageDescriptor, requestThemeChangeOnNextLoad, assetGroups, selectedAssetsGroup, selectedAssetsGroupName, luckyDipSourceIndex, luckyDipAmountIndex, luckyDipContactTypeIndex, luckyDipContactIncludePhoneNumber, createMagicCollage;
@synthesize addCollageBorder, collageBorderColor, useBackgroundTexture, collageBackgroundTexture, collageBackgroundColor;
@synthesize busyView, assetsLibrary;
@synthesize collageObjectLocator;
@synthesize useMyFonts, labelMyFont, labelTextAlignment;
@synthesize canvasView;
@synthesize exportFormatSelectedIndex, pngExportTransparentBackground, jpgExportQualityValue;
@synthesize imageRoundedCornerSize;

- (id)init
{
    CollageDescriptor *collage = [[CollageStore defaultStore] createCollage];
    return [self initWithCollageDescriptor:collage];
}

- (id)initWithCollageDescriptor:(CollageDescriptor *)collage
{
    self = [super init];
    if (self) {  
        AWBCollageObjectLocator *locator = [[AWBCollageObjectLocator alloc] initWithLocationType:kAWBCollageObjectLocatorTypeScatter];
        self.collageObjectLocator = locator;
        self.lowMemoryCount = 0;
        symbolShape = kAWBArrowLineShapeTypeNotSpecified;
        requestThemeChangeOnNextLoad = NO;
        luckyDipInProgress = NO;
        self.luckyDipSourceIndex = kAWBLuckyDipSourceIndexPhotos;
        self.luckyDipAmountIndex = kAWBLuckyDipAmountIndexAutoFill;
        self.luckyDipContactTypeIndex = kAWBLuckyDipContactTypeIndexTextAndPhoto;
        self.luckyDipContactIncludePhoneNumber = NO;
        self.collageDescriptor = collage;
        [self setCollageSaveDocumentsSubdirectory:collage.collageSaveDocumentsSubdirectory];
        if (collage.collageName && ([collage.collageName length] > 0)) {
            self.navigationItem.title = [NSString stringWithFormat:@"%@", collage.collageName];
        } else {
            self.navigationItem.title = [NSString stringWithFormat:@"%@", collage.collageSaveDocumentsSubdirectory];
        }
        self.exportSize = 2.0;
        self.exportFormatSelectedIndex = kAWBExportFormatIndexJPEG;
        self.pngExportTransparentBackground = NO;
        self.jpgExportQualityValue = 0.7;

        CollageTheme *theme = [collage theme];
        [self updateCollageWithTheme:theme];
        [self setLabelTextLine1:nil];
        [self setLabelTextLine2:nil];    
        [self setLabelTextLine3:nil];    
        [self setIsCollageInEditMode:NO];
        [self setIsImporting:NO]; 
        displayMemoryWarningIndicator = NO;
        animateMemoryWarningIndicator = YES;
        viewDidUnload = NO;
        imageCountWhenMemoryWarningOccurred = 0;
        [locator release];
    }
    return self;
}

- (void)updateCollageWithTheme:(CollageTheme *)theme
{
    [self setAddImageShadows:theme.addImageShadows];
    [self setAddTextShadows:theme.addTextShadows];
    [self setAddImageBorders:theme.addImageBorders];
    [self setAddTextBorders:theme.addTextBorders];
    [self setImageRoundedBorders:theme.imageRoundedBorders];
    [self setImageRoundedCornerSize:theme.imageRoundedCornerSize];
    [self setTextRoundedBorders:theme.textRoundedBorders];
    [self setAddTextBackground:theme.addTextBackground];
    [self setImageShadowColor:theme.imageShadowColor];
    [self setTextShadowColor:theme.textShadowColor];
    [self setImageBorderColor:theme.imageBorderColor];
    [self setTextBorderColor:theme.textBorderColor];
    [self setTextBackgroundColor:theme.textBackgroundColor];
    [self setLabelTextColor:theme.labelTextColor];
    [self setLabelTextFont:theme.labelTextFont];
    [self setSymbolColor:theme.symbolColor];
    [self setAddCollageBorder:theme.addCollageBorder];
    [self setUseBackgroundTexture:theme.useBackgroundTexture];
    [self setCollageBackgroundColor:theme.collageBackgroundColor];
    [self setCollageBorderColor:theme.collageBorderColor];
    [self setCollageBackgroundTexture:theme.backgroundTexture];  
    [self setUseMyFonts:theme.useMyFonts];
    [self setLabelMyFont:theme.labelMyFont];
    [self setLabelTextAlignment:theme.labelTextAlignment];
    self.collageObjectLocator.snapToGrid = theme.snapToGrid;
    self.collageObjectLocator.objectLocatorType = theme.objectLocatorType;
    self.collageObjectLocator.autoMemoryReduction = theme.autoMemoryReduction;
    
    if (self.useBackgroundTexture && self.collageBackgroundTexture) {
        //[[self view] setBackgroundColor:[UIColor textureColorWithDescription:self.collageBackgroundTexture]];
        [self.view setBackgroundColor:[UIColor textureColorWithDescription:self.collageBackgroundTexture]];
    } else {
        if (self.collageBackgroundColor) {
            //[[self view] setBackgroundColor:self.collageBackgroundColor];
            [self.view setBackgroundColor:self.collageBackgroundColor];
        }            
    }
    
    if (self.addCollageBorder && self.collageBorderColor) {
        //[self view].layer.borderColor = [self.collageBorderColor CGColor];
        self.canvasView.layer.borderColor = [self.collageBorderColor CGColor];
        CGFloat borderThickness = 4.0;
        if (DEVICE_IS_IPAD) {
            borderThickness = 6.0;
        }
        //[self view].layer.borderWidth = borderThickness;
        self.canvasView.layer.borderWidth = borderThickness;
    } else {
        //[self view].layer.borderColor = [[UIColor blackColor] CGColor];
        //[self view].layer.borderWidth = 0.0;            
        self.canvasView.layer.borderColor = [[UIColor blackColor] CGColor];
        self.canvasView.layer.borderWidth = 0.0;            
    }
    //[self view].layer.masksToBounds = YES;
    self.canvasView.layer.masksToBounds = YES;
}

- (void)updateAllLabels
{
//    self.labelMyFont = nil;
//    self.useMyFonts = NO;
//    self.labelTextAlignment = UITextAlignmentCenter;
    NSString *fontName = nil;
    if (self.useMyFonts) {
        fontName = self.labelMyFont;
    } else {
        fontName = self.labelTextFont;
    }
    
    //for(UIView <AWBTransformableView> *view in [[[self view] subviews] reverseObjectEnumerator]) {
    for(UIView <AWBTransformableView> *view in [[self.canvasView subviews] reverseObjectEnumerator]) {
        if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
            if ([view isKindOfClass:[AWBTransformableLabel class]]) {
                AWBTransformableLabel *label = (AWBTransformableLabel *)view;
                if (self.labelTextColor) {
                    [label.labelView setTextColor:self.labelTextColor];                       
                }
                [label updateLabelTextWithFontName:fontName fontSize:28.0];                                    
            }
        }            
    } 
}

- (void)dealloc
{
    [self deallocGestureRecognizers];
    [canvasView release];
    [cancelButton release];
    [editButton release];
    [deleteButton release];
    [editTextButton release];
    [selectNoneOrAllButton release];
    [cameraButton release];
    [addressBookButton release];
    [progressView release];
    [progressViewHolder release];
    [imagePickerPopover release];
    [addressBookPopover release];
    [addSymbolPopover release];
    [luckyDipPopover release];
    [memoryWarningPopover release];
    [deleteConfirmationSheet release];
    [choosePhotoSourceSheet release];
    [chooseActionTypeSheet release];
    [textButton release];
    [luckyDipButton release];
    [addSymbolButton release];
    [actionButton release];
    [memoryWarningButton release];
    [settingsButton release];
    [importingLabel release];
    [importingLabelHolder release];
    [toolbarSpacing release];
    [fixedToolbarSpacing release];
    [imageBorderColor release];
    [textBorderColor release];
    [imageShadowColor release];
    [textShadowColor release];
    [textBackgroundColor release];
    [labelTextFont release];
    [labelMyFont release];
    [labelTextColor release];
    [labelTextLine1 release];
    [labelTextLine2 release];
    [labelTextLine3 release];
    [symbolColor release];
    [collageBorderColor release];
    [collageBackgroundTexture release]; 
    [collageBackgroundColor release];
    [collageSaveDocumentsSubdirectory release];
    [assetGroups release];
    [selectedAssetsGroup release];
    [selectedAssetsGroupName release];
    [busyView release];
    [assetsLibrary release];
    [collageObjectLocator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"CollageMakerViewController Did receive memory warning!");
    self.lowMemoryCount += 1;
    imageCountWhenMemoryWarningOccurred = totalImageSubviews;
    displayMemoryWarningIndicator = YES;
    animateMemoryWarningIndicator = YES;
    
    if (!self.isCollageInEditMode && !self.isImporting) {
        [self resetToNormalToolbar];
    }
    [super didReceiveMemoryWarning];
}

- (BOOL)lowMemory
{
    BOOL lowMemoryThresholdExceeded = NO;
    
    if (self.lowMemoryCount > 5) {
        lowMemoryThresholdExceeded = YES;
    } else if (totalImageSubviews > 24) {
        lowMemoryThresholdExceeded = (self.lowMemoryCount > 0);
    } else {
        lowMemoryThresholdExceeded = (self.lowMemoryCount > ((int)(7.0 - (0.25 * totalImageSubviews))));
    }
    
    return lowMemoryThresholdExceeded;
}

- (void)showMemoryWarning:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (DEVICE_IS_IPAD) {
        BOOL wasPopoverVisible = [self.memoryWarningPopover isPopoverVisible];
        [self dismissAllActionSheetsAndPopovers];
        if (wasPopoverVisible) {
            return;
        }
    }
    
    AWBMemoryWarningViewController *warningController = [[AWBMemoryWarningViewController alloc] init]; 
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:warningController];
    
    if (DEVICE_IS_IPAD) {
        UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:navController];
        self.memoryWarningPopover = popOver;
        [popOver release];
        self.memoryWarningPopover.delegate = self;
        [self.memoryWarningPopover presentPopoverFromBarButtonItem:self.memoryWarningButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];        
    } else {
        [self presentModalViewController:navController animated:self.isLevel2AnimationsEnabled];
    }
    
    [warningController release];   
    [navController release];   
    [pool drain];
}

- (void)setLowMemory:(BOOL)lowMemory
{
    if (lowMemory == NO) {
        self.lowMemoryCount = 0;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialiseGestureRecognizers];
    collageLoadRequired = YES;
}

- (void)loadView
{
    [super loadView];
    
    CGSize currentBounds = self.view.bounds.size;
    CGFloat width = MAX(currentBounds.width, currentBounds.height);
    CGFloat height = MIN(currentBounds.width, currentBounds.height);
    
    UIView *backgroundCanvasView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height)];
    backgroundCanvasView.backgroundColor = [UIColor clearColor];
    backgroundCanvasView.userInteractionEnabled = YES;
    self.canvasView = backgroundCanvasView;
    [self.view addSubview:self.canvasView];
    [backgroundCanvasView release];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!self.modalViewController) {
        [self resetEditMode:nil];
        BOOL saveThumbnail = YES;
        if (self.excessiveSubviewCount) {
            saveThumbnail = NO;
        }
        [self saveChanges:saveThumbnail];
    }
    [super viewWillDisappear:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.isCollageInEditMode) {
        self.toolbarItems = [self normalToolbarButtons];
        self.navigationItem.rightBarButtonItem = self.editButton;
        [self setNavigationBarsHidden:NO animated:self.isLevel1AnimationsEnabled];        
    }
    
    if (!self.modalViewController || requestThemeChangeOnNextLoad || viewDidUnload) {
        viewDidUnload = NO;
        if (collageLoadRequired) {
            collageLoadRequired = NO;
            [self loadChanges];
        }        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (createMagicCollage) {
        createMagicCollage = NO;
        
//        AWBBusyView *busyIndicatorView = [[AWBBusyView alloc] initWithText:@"Looking for Photos" detailText:nil parentView:self.view centerAtPoint:self.view.center];
        AWBBusyView *busyIndicatorView = [[AWBBusyView alloc] initWithText:@"Looking for Photos" detailText:nil parentView:self.canvasView centerAtPoint:self.canvasView.center];
        self.busyView = busyIndicatorView;
        [busyIndicatorView release];
        [self performSelector:@selector(autoStartWithLuckyDip) withObject:nil afterDelay:0.0];	        
    }    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self dereferenceGestureRecognizers];
    self.cancelButton = nil;
    self.editButton = nil;
    self.deleteButton = nil;
    self.editTextButton = nil;
    self.selectNoneOrAllButton = nil;
    self.cameraButton = nil;
    self.addressBookButton = nil;
    self.imagePickerPopover = nil;
    self.addressBookPopover = nil;
    self.luckyDipPopover = nil;
    self.addSymbolPopover = nil;
    self.memoryWarningPopover = nil;
    self.actionButton = nil;
    self.progressView = nil;
    self.progressViewHolder = nil;
    self.deleteConfirmationSheet = nil;
    self.choosePhotoSourceSheet = nil;
    self.chooseActionTypeSheet = nil;
    self.textButton = nil;
    self.luckyDipButton = nil;
    self.addSymbolButton = nil;
    self.settingsButton = nil;
    self.memoryWarningButton = nil;
    self.importingLabelHolder = nil;
    self.importingLabel = nil;
    self.toolbarSpacing = nil;
    self.fixedToolbarSpacing = nil;
    self.assetGroups = nil;
    self.selectedAssetsGroup = nil;
    self.selectedAssetsGroupName = nil;
    self.busyView = nil;
    self.assetsLibrary = nil;
    self.canvasView = nil;
    viewDidUnload = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);   
    //return YES;
}

- (BOOL)saveChanges:(BOOL)saveThumbnail
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BOOL success = NO;
    
    //if ([self view]) {
    if (self.canvasView) {
        
        //if excessive objects, then reset the selected collage index
        //trying to avoid memory crash when loading the app
        if (self.excessiveSubviewCount) {
            [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAWBInfoKeyCollageStoreCollageIndex];
        }
                
        Collage *collage = [[Collage alloc] init];
        collage.exportSize = exportSize;
        collage.exportFormatSelectedIndex = exportFormatSelectedIndex;
        collage.pngExportTransparentBackground = pngExportTransparentBackground;
        collage.jpgExportQualityValue = jpgExportQualityValue;
        collage.addImageShadows = addImageShadows;
        collage.addTextShadows = addTextShadows;
        collage.addImageBorders = addImageBorders;
        collage.addTextBorders  = addTextBorders;
        collage.imageRoundedBorders = imageRoundedBorders;
        collage.imageRoundedCornerSize = imageRoundedCornerSize;
        collage.textRoundedBorders = textRoundedBorders;
        collage.imageShadowColor = imageShadowColor;
        collage.textShadowColor = textShadowColor;
        collage.imageBorderColor = imageBorderColor;
        collage.textBorderColor = textBorderColor;
        collage.addTextBackground = addTextBackground;
        collage.textBackgroundColor = textBackgroundColor;
        collage.labelTextColor = labelTextColor;
        collage.symbolColor = symbolColor;
        collage.labelTextFont = labelTextFont;
        collage.labelTextLine1 = labelTextLine1;
        collage.labelTextLine2 = labelTextLine2;
        collage.labelTextLine3 = labelTextLine3;
        collage.luckyDipSourceIndex = luckyDipSourceIndex;
        collage.luckyDipAmountIndex = luckyDipAmountIndex;
        collage.luckyDipContactTypeIndex = luckyDipContactTypeIndex;
        collage.luckyDipContactIncludePhoneNumber = luckyDipContactIncludePhoneNumber;
        collage.selectedAssetsGroupName = selectedAssetsGroupName;
        collage.addCollageBorder = addCollageBorder;
        collage.collageBorderColor = collageBorderColor;
        collage.useBackgroundTexture = useBackgroundTexture;
        collage.backgroundTexture = collageBackgroundTexture;
        collage.collageBackgroundColor = collageBackgroundColor;
        collage.collageObjectLocator = collageObjectLocator;
        collage.labelTextAlignment = labelTextAlignment;
        collage.labelMyFont = labelMyFont;
        collage.useMyFonts = useMyFonts;
        
        //[collage initCollageFromView:[self view]];
        [collage initCollageFromView:self.canvasView];

        self.collageDescriptor.totalImageObjects = self.totalImageSubviews;
        self.collageDescriptor.totalLabelObjects = self.totalLabelSubviews;
        self.collageDescriptor.totalImageMemoryBytes = collage.totalImageMemoryBytes;
        [[CollageStore defaultStore] saveAllCollages];

        success = [NSKeyedArchiver archiveRootObject:collage toFile:[self archivePath]];
        [collage release];
        
        if (saveThumbnail) {
            CGFloat scale = 0.25;
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, scale);
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *collageImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData *imageData = UIImageJPEGRepresentation(collageImage, 0.7);
            [imageData writeToFile:[self thumbnailArchivePath] atomically:YES];
        }
    }
    [pool drain];
    return success;
}

- (void)loadChanges
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *path = [self archivePath];
    Collage *collage = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
    if (collage) {
        if (requestThemeChangeOnNextLoad) {
            collage.collageBackgroundColor = self.collageBackgroundColor;
            collage.useBackgroundTexture = self.useBackgroundTexture;
            collage.addCollageBorder = self.addCollageBorder;
            collage.collageBorderColor = self.collageBorderColor;
            collage.backgroundTexture = self.collageBackgroundTexture;
            collage.collageObjectLocator = self.collageObjectLocator;
        } else {
            self.collageBackgroundColor = collage.collageBackgroundColor;
            self.addCollageBorder = collage.addCollageBorder;
            self.useBackgroundTexture = collage.useBackgroundTexture;
            if (collage.collageBorderColor) {
                self.collageBorderColor = collage.collageBorderColor;
            }
            if (collage.backgroundTexture) {
                self.collageBackgroundTexture = collage.backgroundTexture;
            }
            if (collage.collageObjectLocator) {
                //shouldn't happen but while there's no GUI for snap grid size, don't load a zero value
                CGFloat snapToGridSize = self.collageObjectLocator.snapToGridSize;
                self.collageObjectLocator = collage.collageObjectLocator;
                if (self.collageObjectLocator.snapToGridSize == 0.0) {
                    self.collageObjectLocator.snapToGridSize = snapToGridSize;
                }
            }
        }
        
        //[collage addCollageObjectsToView:[self view]];
        [collage applyCollageBackgroundToView:self.view];
        [collage addCollageObjectsToView:self.canvasView];
        
        if (requestThemeChangeOnNextLoad) {
            [self updateAllLabels];
        }       
        totalImageSubviews = collage.totalImageSubviews;
        totalLabelSubviews = collage.totalLabelSubviews;
        totalSymbolSubviews = collage.totalSymbolSubviews;
        self.exportSize = collage.exportSize;
        self.exportFormatSelectedIndex = collage.exportFormatSelectedIndex;
        self.pngExportTransparentBackground = collage.pngExportTransparentBackground;
        self.jpgExportQualityValue = collage.jpgExportQualityValue;            

        if (!requestThemeChangeOnNextLoad) {
            self.addImageShadows = collage.addImageShadows;
            self.addTextShadows = collage.addTextShadows;
            self.addImageBorders = collage.addImageBorders;
            self.addTextBorders = collage.addTextBorders;
            self.imageRoundedBorders = collage.imageRoundedBorders;
            self.imageRoundedCornerSize = collage.imageRoundedCornerSize;
            self.textRoundedBorders = collage.textRoundedBorders;
            self.addTextBackground = collage.addTextBackground;
            self.labelTextAlignment = collage.labelTextAlignment;
            self.useMyFonts = collage.useMyFonts;
            
            if (collage.imageBorderColor) {
                self.imageBorderColor = collage.imageBorderColor;
            }
            if (collage.textBorderColor) {
                self.textBorderColor = collage.textBorderColor;
            }
            if (collage.imageShadowColor) {
                self.imageShadowColor = collage.imageShadowColor;
            }
            if (collage.textShadowColor) {
                self.textShadowColor = collage.textShadowColor;
            }        
            if (collage.textBackgroundColor) {
                self.textBackgroundColor = collage.textBackgroundColor;
            }
            if (collage.labelTextColor) {
                self.labelTextColor = collage.labelTextColor;
            }
            if (collage.labelTextFont) {
                self.labelTextFont = collage.labelTextFont;
            }   
            if (collage.symbolColor) {
                self.symbolColor = collage.symbolColor;
            }
            if (collage.labelMyFont) {
                self.labelMyFont = collage.labelMyFont;
            }
        }

        if (collage.labelTextLine1) {
            self.labelTextLine1 = collage.labelTextLine1;
        } 
        if (collage.labelTextLine2) {
            self.labelTextLine2 = collage.labelTextLine2;
        }         
        if (collage.labelTextLine3) {
            self.labelTextLine3 = collage.labelTextLine3;
        }  
        if (collage.selectedAssetsGroupName) {
            self.selectedAssetsGroupName = collage.selectedAssetsGroupName;
        } 
        
        self.luckyDipSourceIndex = collage.luckyDipSourceIndex;
        self.luckyDipAmountIndex = collage.luckyDipAmountIndex;
        self.luckyDipContactTypeIndex = collage.luckyDipContactTypeIndex;
        self.luckyDipContactIncludePhoneNumber = collage.luckyDipContactIncludePhoneNumber;
        [self updateTextViewBackgrounds];
        [self updateViewBorders];
        [self updateViewShadows];
    }
    
    requestThemeChangeOnNextLoad = NO;
    [pool drain];
}

- (NSString *)archivePath
{
    return AWBPathInDocumentSubdirectory(collageSaveDocumentsSubdirectory, @"collage.data");
}

- (NSString *)thumbnailArchivePath
{
    return AWBPathInDocumentSubdirectory(collageSaveDocumentsSubdirectory, @"thumbnail.jpg");
}

- (NSUInteger)totalCollageSubviews
{
    return (totalImageSubviews + totalLabelSubviews + totalSymbolSubviews);
}

- (NSUInteger)totalCollageSubviewsWithShadows
{
    NSUInteger totalShadowObjects = 0;
    
    if (self.addImageShadows) {
        totalShadowObjects+=totalImageSubviews;
    }
    
    if (self.addTextShadows) {
        totalShadowObjects+=totalLabelSubviews;
    }
    
    return totalShadowObjects;
}

- (BOOL)isLevel1AnimationsEnabled
{
    if (self.totalCollageSubviewsWithShadows > 10 || self.totalCollageSubviews > 15) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isLevel2AnimationsEnabled
{
    if (self.totalCollageSubviewsWithShadows > 20 || self.totalCollageSubviews > 30) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)excessiveSubviewCount
{
    return (self.totalCollageSubviews >= [CollageMakerViewController excessiveSubviewCountThreshold]);
}

+ (NSUInteger)excessiveSubviewCountThreshold
{
    NSUInteger threshold;
    if (DEVICE_IS_IPAD) {
        //iPad 1 and 2 only have 256MB RAM
        threshold = 50;     // approx. 40MB
    } else {
        //iPhone has 512MB
        threshold = 100;    // approx. 80MB
    }
    return threshold;
}

- (BOOL)luckyDipImportCollageIsFull
{
    if (luckyDipInProgress && (self.luckyDipAmountIndex == kAWBLuckyDipAmountIndexAutoFill) && (self.collageObjectLocator.collageFull)) {
        return YES;
    } else {
        return NO;
    }
}

@end
