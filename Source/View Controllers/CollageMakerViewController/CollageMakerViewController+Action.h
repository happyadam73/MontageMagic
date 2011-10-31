//
//  CollageMakerViewController+Action.h
//  Collage Maker
//
//  Created by Adam Buckley on 26/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import "CollageMakerViewController.h"

@interface CollageMakerViewController (Action) <MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate> 

- (void)performAction:(id)sender;
- (void)chooseActionTypeActionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (UIImage *)generateCollageImageWithScaleFactor:(CGFloat)scaleFactor;
- (void)saveImageToSavedPhotosAlbum:(UIImage *)image; 
- (void)saveCollageAsPhoto;
- (void)emailCollageAsPhoto;
- (void)displayCollageEmailCompositionSheet:(UIImage *)image;
- (void)printItemWithSize:(NSNumber *)sizeNumber;
- (NSString *)typeOfMontageDescription;
- (BOOL)canUseTwitter;
- (void)twitterCollageAsPhoto;
- (void)displayTwitterControllerWithImage:(UIImage *)image;

@end
