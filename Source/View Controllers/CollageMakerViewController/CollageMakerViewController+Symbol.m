//
//  CollageMakerViewController+Symbol.m
//  Collage Maker
//
//  Created by Adam Buckley on 01/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+Symbol.h"
#import "CollageMakerViewController+UI.h"
#import "CollageMakerViewController+Edit.h"
#import "UIView+Animation.h"

@implementation CollageMakerViewController (Symbol)

- (void)addSymbol:(id)sender
{
    if (!self.isImporting) {
        [self resetEditMode:sender];
        AWBSymbolGroupPickerController *symbolPicker = [[AWBSymbolGroupPickerController alloc] init]; 
        symbolPicker.symbolPickerDelegate = self;
        symbolPicker.arrowColor = self.symbolColor;
        symbolPicker.shapeType = self.symbolShape;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:symbolPicker];
        [self initialiseAddSymbolPopoverWithViewController:navController andBarButtonItem:self.addSymbolButton];
        [symbolPicker release];   
        [navController release];    
    }          
}

- (void)initialiseAddSymbolPopoverWithViewController:(UIViewController *)viewController andBarButtonItem:(UIBarButtonItem *)button    
{
    if (DEVICE_IS_IPAD) {
        
        BOOL wasPopoverVisible = [self.addSymbolPopover isPopoverVisible];
        [self dismissAllActionSheetsAndPopovers];
        if (wasPopoverVisible) {
            return;
        }
        
        UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:viewController];
        self.addSymbolPopover = popOver;
        [popOver release];
        self.addSymbolPopover.delegate = self;
        [self.addSymbolPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];        
    } else {
        [self presentModalViewController:viewController animated:YES];       
    }
}

- (void)awbSymbolGroupPickerControllerDidCancel:(AWBSymbolGroupPickerController *)picker
{
    self.symbolShape = picker.shapeType;
    [self dismissToolbarAndPopover:addSymbolPopover];    
}

- (void)awbSymbolGroupPickerController:(AWBSymbolGroupPickerController *)picker didFinishPickingSymbol:(AWBTransformableArrowView *)symbol 
{
    if ([self totalCollageSubviews] == 0) {
        [self.collageObjectLocator resetLocator];
    }
    
    self.symbolColor = picker.arrowColor;
    self.symbolShape = picker.shapeType;
    
    CGFloat arrowLength = 100.0;
    if (DEVICE_IS_IPAD) {
        arrowLength = 150.0;
    }
    
    if (symbol.arrowLineShapeType == kAWBArrowLineShapeTypeHalfCircle) {
        arrowLength *= 1.2;
    }
    
    [self.collageObjectLocator pushSymbol];
    AWBTransformableArrowView *arrow = [[AWBTransformableArrowView alloc] initWithLength:arrowLength color:symbol.arrowColor type:symbol.arrowType thickness:symbol.arrowThicknessType arrowHead:symbol.arrowHeadType arrowLineShape:symbol.arrowLineShapeType arrowLineStroke:symbol.arrowLineStrokeType];
    arrow.center = self.collageObjectLocator.objectPosition;
    [[self view] addSubview:arrow];
    [arrow release];

    totalSymbolSubviews += 1;
    [self saveChanges:YES];
    [self dismissToolbarAndPopover:addSymbolPopover];    

}

@end
