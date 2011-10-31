//
//  AWBSymbolPickerController.h
//  Collage Maker
//
//  Created by Adam Buckley on 02/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBTransformableArrowView.h"

@interface AWBSymbolPickerController : UITableViewController <AWBTransformableArrowViewDelegate> {
    NSMutableArray *symbols;
    AWBArrowLineShapeType arrowLineShapeType;
    UIColor *arrowColor;
    UIColor *arrowBackgroundColor;
    id parent;
}

@property (nonatomic, retain) NSArray *symbols;
@property (nonatomic, assign) AWBArrowLineShapeType arrowLineShapeType;
@property (nonatomic, retain) UIColor *arrowColor;
@property (nonatomic, retain) UIColor *arrowBackgroundColor;
@property (nonatomic, assign) id parent;

- (id)initWithArrowLineShape:(AWBArrowLineShapeType)lineShapeType arrowColor:(UIColor *)color;
- (NSMutableArray *)symbolsForIndexPath:(NSIndexPath*)indexPath;

@end
