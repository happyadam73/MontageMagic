//
//  CollageMakerViewController+Photos.m
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+Photos.h"
#import "CollageMakerViewController+UI.h"
#import "CollageMakerViewController+Toolbar.h"
#import "UIImage+Scale.h"
#import "CollageMakerViewController+Delete.h"
#import "UIView+Animation.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CollageMakerViewController+Edit.h"

@implementation CollageMakerViewController (Photos)

- (void)addPhoto:(id)sender
{   
    if (!self.isImporting) {
        [self resetEditMode:sender];
        
        BOOL wasActionSheetVisible = self.choosePhotoSourceSheet.visible;
        BOOL wasImagePickerPopoverVisible = [self.imagePickerPopover isPopoverVisible];
        [self dismissAllActionSheetsAndPopovers];
        if (wasActionSheetVisible || wasImagePickerPopoverVisible) {
            return;
        }
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                        cancelButtonTitle:@"Cancel" 
                                                   destructiveButtonTitle:nil 
                                                        otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
        self.choosePhotoSourceSheet = actionSheet;
        [actionSheet release];        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //present the action sheet 
            [self.choosePhotoSourceSheet showFromBarButtonItem:self.cameraButton animated:YES];
        } else {
            [self actionSheet:self.choosePhotoSourceSheet willDismissWithButtonIndex:[self.choosePhotoSourceSheet firstOtherButtonIndex]+1];
        }
    }
}

- (void)choosePhotoSourceActionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        UIViewController *imagePicker;
        
        if (buttonIndex == [actionSheet firstOtherButtonIndex]) {
            imagePicker = [[UIImagePickerController alloc] init];
            [(UIImagePickerController *)imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera]; 
            [(UIImagePickerController *)imagePicker setDelegate:self];
        } else {
            
            dismissAssetsLibrary = YES;
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            self.assetsLibrary = library;
            [library release];
            
            ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];  
            albumController.assetsLibrary = self.assetsLibrary;
            imagePicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
            [albumController setParent:imagePicker];
            [(ELCImagePickerController *)imagePicker setDelegate:self];
            [albumController release];           
        }
        [self initialiseImagePickerPopoverWithViewController:imagePicker andBarButtonItem:self.cameraButton];
        
        [imagePicker release];            
    }     
}

- (void)initialiseImagePickerPopoverWithViewController:(UIViewController *)viewController andBarButtonItem:(UIBarButtonItem *)button;
{
    if (DEVICE_IS_IPAD) {
        BOOL wasPopoverVisible = [self.imagePickerPopover isPopoverVisible];
        [self dismissAllActionSheetsAndPopovers];
        if (wasPopoverVisible) {
            return;
        }
        UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:viewController] ;
        self.imagePickerPopover = popOver;
        [popOver release];        
        self.imagePickerPopover.delegate = self;
        [self.imagePickerPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];        
    } else {
        [self presentModalViewController:viewController animated:YES];       
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info  
{
    if ([self totalCollageSubviews] == 0) {
        [self.collageObjectLocator resetLocator];
    }
    
    UIImage *cameraImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (cameraImage) {
        NSUInteger recommendedResolution = [self recommendedMaxResolutionForImageSize:cameraImage.size];
        UIImage *image = [cameraImage imageScaledToMaxResolution:recommendedResolution withTransparentBorderThickness:0.0];   
        if (image) {
            [self.collageObjectLocator pushPhotoObject:image isContactPhoto:NO];
            AWBTransformableImageView *imageView = [[AWBTransformableImageView alloc] initWithImage:image rotation:self.collageObjectLocator.objectRotation scale:self.collageObjectLocator.objectScale horizontalFlip:NO imageKey:nil imageDocsSubDir:self.collageSaveDocumentsSubdirectory];
            [self applySettingsToImageView:imageView];
            
            if (self.isLevel2AnimationsEnabled) {
                [[self view] addSubviewWithAnimation:imageView duration:0.5 moveToPoint:self.collageObjectLocator.objectPosition];        
            } else {
                [[self view] addSubview:imageView];
                imageView.center = self.collageObjectLocator.objectPosition;
            }
            
            totalImageSubviews += 1;
            [imageView release];
            [self saveChanges:YES];        
        }        
    }
    
    [self dismissToolbarAndPopover:imagePickerPopover];
    self.imagePickerPopover = nil;
    
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info   
{
    [self setToolbarForImporting];
    [self setIsImporting:YES];
    luckyDipInProgress = NO;
    [self performSelectorInBackground:@selector(addPhotosWithInfo:) withObject:info];
    [self dismissToolbarAndPopover:self.imagePickerPopover];
    self.imagePickerPopover = nil;
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissToolbarAndPopover:self.imagePickerPopover];
    self.imagePickerPopover = nil;
    self.selectedAssetsGroup = nil;
    self.assetsLibrary = nil;
}

-(void)addPhotosWithInfo:(id)info
{
    [info retain];
    NSUInteger processingAssetCount = [info count];
    NSUInteger currentAsset = 0;
    self.lowMemory = NO;
    
    if ([self totalCollageSubviews] == 0) {
        [self.collageObjectLocator resetLocator];
    }
    
    for(ALAsset *asset in info) { 
        if ((!self.lowMemory) && self.isImporting && (!self.luckyDipImportCollageIsFull)) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            NSMutableDictionary *assetInfo = [[NSMutableDictionary alloc] init];
            CGImageRef assetImageRef = [[asset defaultRepresentation] fullScreenImage];
            
            if (assetImageRef != NULL) {
                UIImage *assetImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1.0 orientation:[[asset valueForProperty:@"ALAssetPropertyOrientation"] intValue]];
                if (assetImage) {
                    NSUInteger recommendedResolution = [self recommendedMaxResolutionForImageSize:assetImage.size];
                    UIImage *image = [assetImage imageScaledToMaxResolution:recommendedResolution withTransparentBorderThickness:0.0];
                    if (image) {
                        [assetInfo setObject:image forKey:@"Image"];
                    }
                    currentAsset += 1;
                    [assetInfo setObject:[NSNumber numberWithInt:currentAsset] forKey:@"CurrentAssetIndex"];
                    [assetInfo setObject:[NSNumber numberWithInt:processingAssetCount] forKey:@"AssetCount"];   
                    
                    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.1];
                    [[NSRunLoop currentRunLoop] runUntilDate:date];
                    
                    [self performSelectorOnMainThread:@selector(addImageView:) withObject:assetInfo waitUntilDone:YES];                     
                }
            }
            
            [assetInfo release];
            [pool drain];
        }
    }
    [info release];
    [self performSelectorOnMainThread:@selector(addImageViewsCompleted:) withObject:nil waitUntilDone:YES];
    self.lowMemory = NO;
}

-(void)addImageView:(NSMutableDictionary *)info
{
    CGFloat duration = 0.5;
    CGFloat assetCount = [[info valueForKey:@"AssetCount"] intValue];
    CGFloat assetIndex = [[info valueForKey:@"CurrentAssetIndex"] intValue];
    
    if (assetCount > 20) {
        duration = 0.1;
    } else if (assetCount > 10) {
        duration = 0.3;
    }
    
    self.progressView.progress = (assetIndex/assetCount);
    
    UIImage *image = [info valueForKey:@"Image"];
    if (image) {        
        [self.collageObjectLocator pushPhotoObject:image isContactPhoto:NO];
        AWBTransformableImageView *imageView = [[AWBTransformableImageView alloc] initWithImage:image rotation:self.collageObjectLocator.objectRotation scale:self.collageObjectLocator.objectScale horizontalFlip:NO imageKey:nil imageDocsSubDir:self.collageSaveDocumentsSubdirectory];
        [self applySettingsToImageView:imageView];
        if (self.isLevel2AnimationsEnabled) {
            [[self view] addSubviewWithAnimation:imageView duration:duration moveToPoint:self.collageObjectLocator.objectPosition];        
        } else {
            [[self view] addSubview:imageView];
            imageView.center = self.collageObjectLocator.objectPosition;
        }    
        totalImageSubviews += 1;
        [imageView release];        
    }
}

- (void)applySettingsToImageView:(AWBTransformableImageView *)imageView
{
    [imageView setRoundedBorder:self.imageRoundedBorders];
    [imageView setViewBorderColor:self.imageBorderColor];
    [imageView setViewShadowColor:self.imageShadowColor];
    imageView.addShadow = self.addImageShadows;
    imageView.addBorder = self.addImageBorders;
}

- (void)addImageViewsCompleted:(id)info
{
    self.selectedAssetsGroup = nil;
    self.assetsLibrary = nil;
    [self resetToNormalToolbar];
    [self saveChanges:YES];
    [self setIsImporting:NO];
}

- (NSUInteger)recommendedMaxResolutionForImageSize:(CGSize)imageSize
{
    if (self.collageObjectLocator.autoMemoryReduction) {
        if (self.collageObjectLocator.objectLocatorType == kAWBCollageObjectLocatorTypeScatter) {
            return MAX_PIXELS;
        } else {
            if (imageSize.height > 0.0) {
                CGFloat widthToHeightRatio = (imageSize.width/imageSize.height);
                CGFloat mosaicHeight = self.collageObjectLocator.currentMosaicRowHeight;
                CGFloat mosaicWidth = mosaicHeight * widthToHeightRatio;
                CGFloat deviceMultiplier = (DEVICE_IS_IPAD ? 8.0 : 16.0);
                CGFloat recommendedResolution = mosaicHeight * mosaicWidth * deviceMultiplier;
                if (recommendedResolution > (MAX_PIXELS * 1.5)) {
                    return (MAX_PIXELS * 1.5);
                } else {
                    return recommendedResolution;
                }
            } else {
                return MAX_PIXELS;
            }
        }
    } else {
        return MAX_PIXELS;
    }
}

@end
