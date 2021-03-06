//
//  CollageMakerViewController+Text.m
//  Collage Maker
//
//  Created by Adam Buckley on 24/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+Text.h"
#import "CollageMakerViewController+UI.h"
#import "CollageMakerViewController+Delete.h"
#import "UIView+Animation.h"
#import "CollageMakerViewController+Edit.h"
#import "AWBCollageFont.h"

@implementation CollageMakerViewController (Text) 

- (void)addTextView:(id)sender
{
    if (!self.isImporting) {
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        [self resetEditMode:sender];
        [self dismissAllActionSheetsAndPopovers];
        AWBCollageSettingsTableViewController *settingsController = [[AWBCollageSettingsTableViewController alloc] initWithSettings:[AWBSettings textSettingsWithInfo:[self settingsInfo]] settingsInfo:[self settingsInfo] rootController:nil]; 
        settingsController.delegate = self;
        settingsController.controllerType = AWBSettingsControllerTypeAddTextSettings;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
        navController.modalPresentationStyle = UIModalPresentationPageSheet;
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
        [self presentModalViewController:navController animated:self.isLevel1AnimationsEnabled];
        [settingsController release];   
        [navController release];
        
        [pool drain];
    }
}

- (void)editSelectedTextViews:(id)sender
{
    [self dismissAllActionSheetsAndPopovers];
    if (totalSelectedLabelsInEditMode == 0) {
        return;
    }
    
    AWBCollageSettingsTableViewController *settingsController = nil;
    
    UILabel *selectedLabelView = nil;
//    AWBTransformableLabel *selectedLabel = nil;
    BOOL isZFontLabel = NO;
    NSString *fontFilename = nil;
    
    //for(UIView <AWBTransformableView> *view in [[[self view] subviews] reverseObjectEnumerator]) {
    for(UIView <AWBTransformableView> *view in [[self.canvasView subviews] reverseObjectEnumerator]) {
        if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
            if ((view.alpha == SELECTED_ALPHA) && [view isKindOfClass:[AWBTransformableLabel class]]) {
//                selectedLabel = (AWBTransformableLabel *)view;
                selectedLabelView = [(AWBTransformableLabel *)view labelView];
                isZFontLabel = [(AWBTransformableLabel *)view isZFontLabel];
                fontFilename = [(AWBTransformableLabel *)view myFontFilename];
                break;
            }
        }            
    } 
    
    if (isZFontLabel) {
        if (fontFilename) {
            if ([AWBCollageFont myFontDoesExistWithFilename:fontFilename]) {
                self.useMyFonts = YES;
                self.labelMyFont = fontFilename;                
            } else {
                self.useMyFonts = NO;
                self.labelMyFont = @"Most Wasted";
            }
        } else {
            self.useMyFonts = NO;
            self.labelTextFont = ((FontLabel *)selectedLabelView).zFont.familyName;            
        }
    } else {
        self.useMyFonts = NO;
        self.labelTextFont = selectedLabelView.font.fontName;
    }
    
    self.labelTextColor = selectedLabelView.textColor;
    self.labelTextAlignment = selectedLabelView.textAlignment;
    
    if (totalSelectedLabelsInEditMode == 1) {
        //set info for selected label
        if (selectedLabelView) {
            NSArray *lines = [[selectedLabelView text] componentsSeparatedByString:@"\r\n"];
            NSUInteger lineCount = [lines count];
            if (lineCount > 0) {
                self.labelTextLine1 = [lines objectAtIndex:0];
            } else {
                self.labelTextLine1 = nil;
            }
            if (lineCount > 1) {
                self.labelTextLine2 = [lines objectAtIndex:1];
            } else {
                self.labelTextLine2 = nil;
            }
            if (lineCount > 2) {
                self.labelTextLine3 = [lines objectAtIndex:2];
            } else {
                self.labelTextLine3 = nil;
            }
        }
        settingsController = [[AWBCollageSettingsTableViewController alloc] initWithSettings:[AWBSettings editSingleTextSettingsWithInfo:[self settingsInfo]] settingsInfo:[self settingsInfo] rootController:nil];        
    } else {
        settingsController = [[AWBCollageSettingsTableViewController alloc] initWithSettings:[AWBSettings editTextSettingsWithInfo:[self settingsInfo]] settingsInfo:[self settingsInfo] rootController:nil];        
    }
    
    settingsController.delegate = self;
    settingsController.controllerType = AWBSettingsControllerTypeEditTextSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
    [self presentModalViewController:navController animated:self.isLevel1AnimationsEnabled];
    [settingsController release];   
    [navController release];
}

- (NSMutableArray *)textLabelLines
{
    NSMutableArray *lines = [[NSMutableArray alloc] initWithCapacity:3];
    if ([self.labelTextLine1 length] > 0) {
        [lines addObject:self.labelTextLine1];
    }
    if ([self.labelTextLine2 length] > 0) {
        [lines addObject:self.labelTextLine2];
    }  
    if ([self.labelTextLine3 length] > 0) {
        [lines addObject:self.labelTextLine3];
    }
    return [lines autorelease];
}

@end
