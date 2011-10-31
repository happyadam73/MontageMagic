//
//  AWBSymbolGroupPickerController.h
//  Collage Maker
//
//  Created by Adam Buckley on 01/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBTransformableArrowView.h"

@class AWBSymbolGroupPickerController;

@protocol AWBSymbolGroupPickerControllerDelegate

- (void)awbSymbolGroupPickerController:(AWBSymbolGroupPickerController *)picker didFinishPickingSymbol:(AWBTransformableArrowView *)symbol;
- (void)awbSymbolGroupPickerControllerDidCancel:(AWBSymbolGroupPickerController *)picker;

@end

@interface AWBSymbolGroupPickerController  : UITableViewController {
	NSArray *symbolGroupTypes;
    id symbolPickerDelegate;  
    UIColor *arrowColor;
    AWBArrowLineShapeType shapeType;
}

@property (nonatomic, retain) NSArray *symbolGroupTypes;
@property (nonatomic, assign) id symbolPickerDelegate;
@property (nonatomic, retain) UIColor *arrowColor;
@property (nonatomic, assign) AWBArrowLineShapeType shapeType;

- (void)dismissPicker:(id)sender;
- (void)colorPickerValueChanged:(id)sender;
- (void)dismissPicker:(id)sender;
- (void)finishPickingSymbol:(AWBTransformableArrowView *)symbol;

@end
