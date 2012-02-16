//
//  CollageMakerViewController+AddressBook.m
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+AddressBook.h"
#import "AWBTransformableImageView.h"
#import "AWBTransformableLabel.h"
#import "CollageMakerViewController+UI.h"
#import "CollageMakerViewController+Delete.h"
#import "UIImage+Scale.h"
#import "UIView+Animation.h"
#import "CollageMakerViewController+Photos.h"
#import "CollageMakerViewController+Text.h"
#import "CollageMakerViewController+Edit.h"
#import "AWBPersonContact.h"
#import "CollageMakerViewController+Toolbar.h"
#import "CollageMakerViewController+LuckyDip.h"

@implementation CollageMakerViewController (AddressBook)

- (void)initialiseAddressBookPopoverWithViewController:(UIViewController *)viewController andBarButtonItem:(UIBarButtonItem *)button    
{
    if (DEVICE_IS_IPAD) {

        BOOL wasPopoverVisible = [self.addressBookPopover isPopoverVisible];
        [self dismissAllActionSheetsAndPopovers];
        if (wasPopoverVisible) {
            return;
        }
        
        UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:viewController];
        self.addressBookPopover = popOver;
        [popOver release];
        self.addressBookPopover.delegate = self;
        [self.addressBookPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];        
    } else {
        [self presentModalViewController:viewController animated:YES];       
    }
}

- (void)addContact:(id)sender
{
    if (!self.isImporting) {
        [self resetEditMode:sender];
    
        AWBPeoplePickerController *peoplePicker = [[AWBPeoplePickerController alloc] init];
        [peoplePicker setPeoplePickerDelegate:self];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:peoplePicker];
        [self initialiseAddressBookPopoverWithViewController:navController andBarButtonItem:self.addressBookButton];
        [peoplePicker release];
        [navController release];
    
    }        
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker    
{
    [self dismissToolbarAndPopover:addressBookPopover];
}

- (void)awbPeoplePickerControllerDidCancel:(AWBPeoplePickerController *)picker
{
    [self dismissToolbarAndPopover:addressBookPopover];    
}

- (void)awbPeoplePickerController:(AWBPeoplePickerController *)picker didFinishPickingContacts:(NSArray *)contacts
{
    [self setToolbarForImporting];
    [self setIsImporting:YES];
    luckyDipInProgress = NO;
    [self performSelectorInBackground:@selector(addContactViewsWithContacts:) withObject:contacts];
    [self dismissToolbarAndPopover:self.addressBookPopover];
    self.addressBookPopover = nil;
}

- (void)addContactViewsWithContacts:(NSArray *)contacts
{
    [contacts retain];
    NSUInteger processingContactCount = [contacts count];
    NSUInteger currentContactIndex = 0;
    self.lowMemory = NO;
    
    if ([self totalCollageSubviews] == 0) {
        [self.collageObjectLocator resetLocator];
    }
    
    for (AWBPersonContact *contact in contacts) { 
        if (!self.lowMemory && self.isImporting && (!self.luckyDipImportCollageIsFull)) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            currentContactIndex += 1;
            NSMutableDictionary *contactInfo = [[NSMutableDictionary alloc] init];
            
            UIImage *contactImage = [contact fullSizeImage];
            UIImage *resizedImage = nil;
            if (contactImage) {
                NSUInteger recommendedResolution = [self recommendedMaxResolutionForImageSize:contactImage.size];
                resizedImage = [contactImage imageScaledToMaxResolution:recommendedResolution withTransparentBorderThickness:0.0];
                if (resizedImage) {
                    [contactInfo setObject:resizedImage forKey:@"ContactImage"];
                }
            }
            [contactInfo setObject:[NSNumber numberWithInt:currentContactIndex] forKey:@"CurrentContactIndex"];
            [contactInfo setObject:[NSNumber numberWithInt:processingContactCount] forKey:@"ContactCount"]; 
            NSString *phoneNumber = contact.displayPhoneNumber;
            NSString *firstName = nil;
            NSString *lastName = nil;
            
            if (phoneNumber && resizedImage) {
                firstName = contact.displayName;
                
            } else {
                firstName = contact.firstName;
                lastName = contact.lastName;
            }

            if (firstName) {
                [contactInfo setObject:firstName forKey:@"ContactFirstName"];
            }
            if (lastName) {
                [contactInfo setObject:lastName forKey:@"ContactLastName"];
            }
            if (phoneNumber) {
                [contactInfo setObject:phoneNumber forKey:@"ContactPhoneNumber"];
            }
            
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.1];
            [[NSRunLoop currentRunLoop] runUntilDate:date];
            
            [self performSelectorOnMainThread:@selector(addContactImageAndLabelView:) withObject:contactInfo waitUntilDone:YES];
            [contactInfo release];
            [pool drain];
        }
    }
    [contacts release];
    [self performSelectorOnMainThread:@selector(addContactViewsCompleted:) withObject:nil waitUntilDone:YES];
    self.lowMemory = NO;
}

//this must be run on the main thread
- (void)addContactImageAndLabelView:(NSMutableDictionary *)info
{
    CGFloat duration = 0.5;
    CGFloat contactCount = [[info valueForKey:@"ContactCount"] intValue];
    CGFloat contactIndex = [[info valueForKey:@"CurrentContactIndex"] intValue];
    UIImage *image = [info objectForKey:@"ContactImage"];
    NSString *firstName = [info objectForKey:@"ContactFirstName"];
    NSString *lastName = [info objectForKey:@"ContactLastName"];
    NSString *phoneNumber = [info objectForKey:@"ContactPhoneNumber"];
    BOOL labelBelowImage = NO;
    
    if (contactCount > 20) {
        duration = 0.1;
    } else if (contactCount > 10) {
        duration = 0.3;
    }
    
    self.progressView.progress = (contactIndex/contactCount);
    
    if (image) {
        if (![self luckyDipImportCollageIsFullForContactImageOfSize:image.size]) {
            [self.collageObjectLocator pushPhotoObject:image isContactPhoto:YES];
            AWBTransformableImageView *imageView = [[AWBTransformableImageView alloc] initWithImage:image rotation:self.collageObjectLocator.objectRotation scale:self.collageObjectLocator.objectScale horizontalFlip:NO imageKey:nil imageDocsSubDir:self.collageSaveDocumentsSubdirectory];
            [self applySettingsToImageView:imageView];
            
            if (self.isLevel2AnimationsEnabled) {
                [[self view] addSubviewWithAnimation:imageView duration:duration moveToPoint:self.collageObjectLocator.objectPosition];        
            } else {
                [[self view] addSubview:imageView];
                imageView.center = self.collageObjectLocator.objectPosition;
            }    
            totalImageSubviews += 1; 
            labelBelowImage = YES;
            [imageView release];            
        }
    }
    
    //Name Label
    if ((firstName || lastName) && (![self luckyDipImportCollageIsFullForContactLabelBelowCurrentObject:labelBelowImage])) {
        BOOL includePhoneNumber = NO;
        NSMutableArray *lines = [[NSMutableArray alloc] initWithCapacity:2];

        if ([firstName length] > 0) {
            [lines addObject:firstName];
        }
        if ([lastName length] > 0) {
            [lines addObject:lastName];
        }
        if ([phoneNumber length] > 0) {
            [lines addObject:phoneNumber];
            includePhoneNumber = YES;
        }

//        self.labelMyFont = nil;
//        self.useMyFonts = NO;
//        self.labelTextAlignment = UITextAlignmentCenter;
        NSString *fontName = nil;
        if (self.useMyFonts) {
            fontName = self.labelMyFont;
        } else {
            fontName = self.labelTextFont;
        }

        [collageObjectLocator pushContactLabelBelowCurrentObject:labelBelowImage includesPhoneNumber:includePhoneNumber];
        AWBTransformableLabel *label = [[AWBTransformableLabel alloc] initWithTextLines:lines fontName:fontName fontSize:28.0 offset:CGPointZero rotation:self.collageObjectLocator.objectRotation scale:self.collageObjectLocator.objectScale horizontalFlip:NO color:self.labelTextColor alignment:self.labelTextAlignment];

        CGPoint position = self.collageObjectLocator.objectPosition;
        
        if (self.collageObjectLocator.objectLocatorType == kAWBCollageObjectLocatorTypeScatter) {
            position.y += ((label.bounds.size.height * self.collageObjectLocator.objectScale) / 2.0);            
        } else {
            position.y -= ((label.bounds.size.height * self.collageObjectLocator.objectScale) / 2.0);                        
        }
        
        CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
        CGFloat screenHeight = MIN(screenSize.width, screenSize.height);
        if (position.y > (screenHeight * 0.97)) {
            position.y = (screenHeight * 0.97);
        }
        
        [label setCenter:position];
        [self applySettingsToLabel:label];
        [[self view] addSubview:label];
        totalLabelSubviews += 1;
        [label release];
        [lines release];
    }
}

- (void)addContactViewsCompleted:(id)info
{
    [self resetToNormalToolbar];
    [self saveChanges:YES];
    [self setIsImporting:NO];
}

- (BOOL)luckyDipImportCollageIsFullForContactImageOfSize:(CGSize)imageSize
{
    if (luckyDipInProgress && (self.luckyDipAmountIndex == kAWBLuckyDipAmountIndexAutoFill) && ([self.collageObjectLocator collageIsFullForContactImageOfSize:imageSize])) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)luckyDipImportCollageIsFullForContactLabelBelowCurrentObject:(BOOL)belowCurrentObject
{
    if (luckyDipInProgress && (self.luckyDipAmountIndex == kAWBLuckyDipAmountIndexAutoFill) && ([self.collageObjectLocator collageIsFullForContactLabelBelowCurrentObject:belowCurrentObject])) {
        return YES;
    } else {
        return NO;
    }
}

@end
