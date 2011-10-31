//
//  CollageMakerViewController+Delete.m
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+Delete.h"
#import "CollageMakerViewController+UI.h"
#import "AWBTransformableImageView.h"
#import "AWBTransformableArrowView.h"
#import "CollageMakerViewController+Toolbar.h"
#import "CollageMakerViewController+Edit.h"
#import "UIView+Animation.h"

@implementation CollageMakerViewController (Delete)

- (void)deleteSelectedViews:(id)sender
{
    BOOL wasActionSheetVisible = self.deleteConfirmationSheet.visible;
    [self dismissAllActionSheetsAndPopovers];
    if (wasActionSheetVisible || (totalSelectedInEditMode == 0)) {
        return;
    }
    
    NSString *deleteDescription;
    if (totalSelectedInEditMode == 1) {
        deleteDescription = @"Delete Object";
    } else {
        deleteDescription = @"Delete Selected Objects";
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                    cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle:deleteDescription 
                                                    otherButtonTitles:nil];
    self.deleteConfirmationSheet = actionSheet;
    [actionSheet release];
        
    [self.deleteConfirmationSheet showFromBarButtonItem:self.deleteButton animated:YES];    
}

- (void)deleteConfirmationActionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    CGFloat animationDelay = 0.0;
    
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        
        for(UIView <AWBTransformableView> *view in [[self view] subviews]) {
            if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                if (view.alpha == SELECTED_ALPHA) {
                    if ([view isMemberOfClass:[AWBTransformableImageView class]]) {
                        [(AWBTransformableImageView *)view removeImageFromFilesystem];
                        totalImageSubviews -= 1;
                    }                     
                    if ([view isKindOfClass:[AWBTransformableArrowView class]]) {
                        totalSymbolSubviews -= 1;
                    }
                    if ([view isKindOfClass:[AWBTransformableLabel class]]) {
                        totalLabelSubviews -= 1;
                    }
                    if (self.isLevel2AnimationsEnabled) {
                        animationDelay = 0.5;
                        [UIView animateWithDuration:animationDelay delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations: ^ {[view setCenter:[self deleteButtonApproxPosition]]; [view setAlpha:0.0]; view.transform = CGAffineTransformMakeScale(0.1, 0.1);} 
                                         completion: ^ (BOOL finished) {[view removeFromSuperview];}];
                    } else {
                        [view removeFromSuperview];
                    }
                }
            }            
        }
        
        //remove indicator if 4 or more images removed
        if (displayMemoryWarningIndicator && ((imageCountWhenMemoryWarningOccurred - totalImageSubviews)>= 5)) {
            displayMemoryWarningIndicator = NO;
            animateMemoryWarningIndicator = YES;
        }
        
        if (animationDelay > 0.0) {
            animationDelay += 0.1;
        }
        
        [self performSelector:@selector(resetEditMode:) withObject:actionSheet afterDelay:animationDelay];
    }
}

@end
