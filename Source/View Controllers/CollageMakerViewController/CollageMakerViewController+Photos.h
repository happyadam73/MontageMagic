//
//  CollageMakerViewController+Photos.h
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "AWBTransformableImageView.h"

@interface CollageMakerViewController (Photos) <UIImagePickerControllerDelegate, ELCImagePickerControllerDelegate>

- (void)addPhoto:(id)sender;
- (void)initialiseImagePickerPopoverWithViewController:(UIViewController *)viewController andBarButtonItem:(UIBarButtonItem *)button;
- (void)addPhotosWithInfo:(id)info;
- (void)addImageView:(id)info;
- (void)addImageViewsCompleted:(id)info;
- (void)choosePhotoSourceActionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)applySettingsToImageView:(AWBTransformableImageView *)imageView;
- (NSUInteger)recommendedMaxResolutionForImageSize:(CGSize)imageSize;


@end
