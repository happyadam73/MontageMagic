//
//  CollageMakerViewController+Action.m
//  Collage Maker
//
//  Created by Adam Buckley on 26/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+Action.h"
#import "CollageMakerViewController+Delete.h"
#import "CollageMakerViewController+UI.h"
#import "CollageMakerViewController+Edit.h"
#import "CollageMakerViewController+Toolbar.h"
#import "UIImage+Scale.h"
#import "AWBTransforms.h"
#import "CollageTheme.h"
#import "CollageDescriptor.h"
#import "AWBDeviceHelper.h"
#import <Twitter/Twitter.h>
#import "UIColor+Texture.h"
#import "UIImage+NonCached.h"

@implementation CollageMakerViewController (Action)

- (void)performAction:(id)sender
{
    if (!self.isImporting) {
        [self resetEditMode:sender];
        
        BOOL wasActionSheetVisible = self.chooseActionTypeSheet.visible;
        [self dismissAllActionSheetsAndPopovers];
        if (wasActionSheetVisible) {
            return;
        }
                
        UIActionSheet *actionSheet = nil;
        if ([UIPrintInteractionController isPrintingAvailable]) {
            if ([self canUseTwitter]) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                 cancelButtonTitle:@"Cancel" 
                                            destructiveButtonTitle:nil 
                                                 otherButtonTitles:@"Save Collage as Photo", @"Email Collage", @"Print (4x6, A6)", @"Print (Letter, A4)", @"Twitter", nil];                
            } else {                
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                 cancelButtonTitle:@"Cancel" 
                                            destructiveButtonTitle:nil 
                                                 otherButtonTitles:@"Save Collage as Photo", @"Email Collage", @"Print (4x6, A6)", @"Print (Letter, A4)", nil];
            }
        } else {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                             cancelButtonTitle:@"Cancel" 
                                        destructiveButtonTitle:nil 
                                             otherButtonTitles:@"Save Collage as Photo", @"Email Collage", nil];
        }
        self.chooseActionTypeSheet = actionSheet;
        [actionSheet release];
        
        [self.chooseActionTypeSheet showFromBarButtonItem:self.actionButton animated:YES];
    }
}

- (void)chooseActionTypeActionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        
        if (self.exportQuality == 0.0) {
            self.exportQuality = 1.0;
        }
        
        SEL methodSelector;
        id methodObject = nil;
        NSString *busyText = nil;
        NSString *busyTextDetail = nil;
        
        if (buttonIndex == [actionSheet firstOtherButtonIndex]) {
            //Save Image
            busyText = @"Exporting Image";
            busyTextDetail = [NSString stringWithFormat:@"(Size: %@)", AWBScreenSizeFromQualityValue(self.exportQuality)];
            methodSelector = @selector(saveCollageAsPhoto);
        } else if (buttonIndex == ([actionSheet firstOtherButtonIndex]+1)) {
            //Email Image
            busyText = @"Preparing for Email";
            busyTextDetail = [NSString stringWithFormat:@"(Size: %@)", AWBScreenSizeFromQualityValue(self.exportQuality)];
            methodSelector = @selector(emailCollageAsPhoto);
        } else if (buttonIndex == ([actionSheet firstOtherButtonIndex]+2)) {
            // Print Image (4x6, A6)
            busyText = @"Preparing for Print";
            busyTextDetail = @"(4x6, A6)";
            methodSelector = @selector(printItemWithSize:);
            methodObject = [NSNumber numberWithInteger:0];
        } else if (buttonIndex == ([actionSheet firstOtherButtonIndex]+3)) {
            // Print Image
            busyText = @"Preparing for Print";
            busyTextDetail = @"(Letter, A4)";
            methodSelector = @selector(printItemWithSize:);
            methodObject = [NSNumber numberWithInteger:1];
        } else if (buttonIndex == ([actionSheet firstOtherButtonIndex]+4)) {
            // Twitter Image
            busyText = @"Preparing for Twitter";
            CGFloat quality = (DEVICE_IS_IPAD? 1.0 : 2.0);
            busyTextDetail = [NSString stringWithFormat:@"(Size: %@)", AWBScreenSizeFromQualityValue(quality)];
            methodSelector = @selector(twitterCollageAsPhoto);
        }
        
        if (busyText) {
            AWBBusyView *busyIndicatorView = [[AWBBusyView alloc] initWithText:busyText detailText:busyTextDetail parentView:self.view centerAtPoint:self.view.center];
            self.busyView = busyIndicatorView;
            [busyIndicatorView release];
            [self performSelector:methodSelector withObject:methodObject afterDelay:0.0];	
        }	
    }
}

- (UIImage *)generateCollageImageWithScaleFactor:(CGFloat)scaleFactor
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, scaleFactor);
    if (self.useBackgroundTexture && self.collageBackgroundTexture) {
        UIImage *image = [UIColor textureImageWithDescription:self.collageBackgroundTexture];
        CGContextDrawTiledImage(UIGraphicsGetCurrentContext(), CGRectMake(0.0, 0.0, (image.size.width/scaleFactor),  (image.size.height/scaleFactor)), [image CGImage]);
        self.view.backgroundColor = [UIColor clearColor];
    }
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *collageImage = UIGraphicsGetImageFromCurrentImageContext();
    if (self.useBackgroundTexture && self.collageBackgroundTexture) {
        self.view.backgroundColor = [UIColor textureColorWithDescription:self.collageBackgroundTexture];
    }
    UIGraphicsEndImageContext();
    return collageImage;
}

- (void)saveCollageAsPhoto
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbarHidden = YES;
    self.busyView.hidden = YES;
    UIImage *collageImage = [self generateCollageImageWithScaleFactor:self.exportQuality];    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.toolbarHidden = NO;
    self.busyView.hidden = NO;
    [self.busyView removeFromParentView];
    self.busyView = nil;
    [self saveImageToSavedPhotosAlbum:collageImage];    
}

- (void)saveImageToSavedPhotosAlbum:(UIImage *)image 
{
    [image retain];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo 
{
    if(error != nil) {
        NSLog(@"ERROR SAVING:%@",[error localizedDescription]);
    }
    [image release];
}

- (void)emailCollageAsPhoto
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbarHidden = YES;
    self.busyView.hidden = YES;
    UIImage *collageImage = [self generateCollageImageWithScaleFactor:self.exportQuality];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.toolbarHidden = NO;
    self.busyView.hidden = NO;
    [self.busyView removeFromParentView];
    self.busyView = nil;
    
    if ([MFMailComposeViewController canSendMail]) {
        [self displayCollageEmailCompositionSheet:collageImage];        
    }
}

- (void)displayCollageEmailCompositionSheet:(UIImage *)image 
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    NSString *subjectLine = [NSString stringWithFormat:@"Check Out My New %@!", [self typeOfMontageDescription]];
    [picker setSubject:subjectLine];
    
    // Attach an image to the email
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [picker addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"montage.jpg"];
    
    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat:@"This %@ was made on my %@ using Montage Magic", [self typeOfMontageDescription], machineFriendlyName()];
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:picker animated:YES];
    
    [picker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)printItemWithSize:(NSNumber *)sizeNumber
{
    BOOL print6x4 = ([sizeNumber integerValue] == 0);
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbarHidden = YES;
    self.busyView.hidden = YES;
    
    // calculate the scaling factor that will reduce the image size to maxPixels
    CGFloat actualHeight = self.view.bounds.size.height;
    CGFloat actualWidth = self.view.bounds.size.width;

    CGFloat leftMargin = 0.0;
    CGFloat rightMargin = 0.0;
    CGFloat topMargin = 0.0;
    CGFloat bottomMargin = 0.0;
    CGFloat offsetLeft = 0.0;
    CGFloat offsetTop = 0.0;
    CGFloat scaleFactor = 3.0;

    if (print6x4) {
        if (DEVICE_IS_IPAD) {
            leftMargin = 92.0;
            rightMargin = 92.0;
            topMargin = 69.0;
            bottomMargin = 69.0;
            offsetLeft = 112.0;
            offsetTop = 75.0;
            scaleFactor = 1.5;
        } else {
            leftMargin = 24.0;
            rightMargin = 24.0;
            topMargin = 16.0;
            bottomMargin = 16.0;
            offsetLeft = 30.0;
            offsetTop = 20.0;
            scaleFactor = 3.0;
        }
    } else {
        if (DEVICE_IS_IPAD) {
            scaleFactor = 2.0;
        } else {
            scaleFactor = 4.0;
        }
    }   
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth + leftMargin + rightMargin, actualHeight + topMargin + bottomMargin);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, scaleFactor);    

    if (self.addCollageBorder && self.collageBorderColor) {
        [self removeCollageBorderFromView];
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //for non mosaics, switch off mask to bounds
    CollageThemeType themeType = self.collageDescriptor.themeType;
    switch (themeType) {
        case kAWBCollageThemeTypePhotoMosaicSmallImagesBlack:
        case kAWBCollageThemeTypePhotoMosaicSmallImagesWhite:
        case kAWBCollageThemeTypePhotoMosaicLargeImagesBlack:
        case kAWBCollageThemeTypePhotoMosaicLargeImagesWhite:
        case kAWBCollageThemeTypePhotoMosaicMicroImagesBlack:
            [self view].layer.masksToBounds = YES;
            break;
        default:
            [self view].layer.masksToBounds = NO;        
    } 

    if (self.useBackgroundTexture) {
        UIImage *image = [UIColor textureImageWithDescription:self.collageBackgroundTexture];
        CGContextDrawTiledImage(UIGraphicsGetCurrentContext(), CGRectMake(0.0, 0.0, (image.size.width/scaleFactor),  (image.size.height/scaleFactor)), [image CGImage]);        
    } else {
        [self.collageBackgroundColor setFill];        
        UIRectFill(rect);
    }

    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext, offsetLeft, offsetTop);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *collageImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if (self.useBackgroundTexture) {
        self.view.backgroundColor = [UIColor textureColorWithDescription:self.collageBackgroundTexture];
    } else {
        self.view.backgroundColor = self.collageBackgroundColor;        
    }
    if (self.addCollageBorder && self.collageBorderColor) {
        [self addCollageBorderToView];
    }

    UIGraphicsEndImageContext();      

    [self view].layer.masksToBounds = YES;    
    self.busyView.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.toolbarHidden = NO;
            
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];

    NSData *myData = [NSData dataWithData:UIImagePNGRepresentation(collageImage)];
    
    [self.busyView removeFromParentView];
    self.busyView = nil;

    if(printController && [UIPrintInteractionController canPrintData:myData]) {
        
        printController.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        if (print6x4) {
            printInfo.outputType = UIPrintInfoOutputPhoto;
        } else {
            printInfo.outputType = UIPrintInfoOutputGeneral;            
        }
        printInfo.jobName = self.navigationItem.title;
        printController.printInfo = printInfo;
        printController.printingItem = myData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        
        if (DEVICE_IS_IPAD) {
            [printController presentFromBarButtonItem:self.actionButton animated:YES completionHandler:completionHandler];        
        } else {
            [printController presentAnimated:YES completionHandler:completionHandler];
        }
        
    }
}

- (NSString *)typeOfMontageDescription
{
    CollageThemeType themeType = self.collageDescriptor.themeType;
    
    switch (themeType) {
        case kAWBCollageThemeTypePhotoMosaicSmallImagesBlack:
        case kAWBCollageThemeTypePhotoMosaicSmallImagesWhite:
        case kAWBCollageThemeTypePhotoMosaicLargeImagesBlack:
        case kAWBCollageThemeTypePhotoMosaicLargeImagesWhite:
        case kAWBCollageThemeTypePhotoMosaicMicroImagesBlack:
            return @"Photo Mosaic";
        default:
            return @"Collage";
    } 
}

- (BOOL)canUseTwitter
{
    if ([TWTweetComposeViewController class] != nil) {
        return ([TWTweetComposeViewController canSendTweet]);
    } else {
        return NO;
    }
}

- (void)twitterCollageAsPhoto
{
    if ([TWTweetComposeViewController canSendTweet]) {
        self.navigationController.navigationBar.hidden = YES;
        self.navigationController.toolbarHidden = YES;
        self.busyView.hidden = YES;
        CGFloat quality = (DEVICE_IS_IPAD? 1.0 : 2.0);
        UIImage *collageImage = [self generateCollageImageWithScaleFactor:quality];
        self.navigationController.navigationBar.hidden = NO;
        self.navigationController.toolbarHidden = NO;
        self.busyView.hidden = NO;
        [self.busyView removeFromParentView];
        self.busyView = nil;
        
        [self displayTwitterControllerWithImage:collageImage];    
    } else {
        [self.busyView removeFromParentView];
        self.busyView = nil;        
    }
}

- (void)displayTwitterControllerWithImage:(UIImage *)image
{
    TWTweetComposeViewController *twitterController = [[TWTweetComposeViewController alloc] init];
    [twitterController setInitialText:[NSString stringWithFormat:@"Here's My New %@!", [self typeOfMontageDescription]]];
    [twitterController addImage:image];
    twitterController.completionHandler = ^(TWTweetComposeViewControllerResult res) {[self dismissModalViewControllerAnimated:YES];};
    [self presentViewController:twitterController animated:YES completion:nil];
    [twitterController release];
}

@end
