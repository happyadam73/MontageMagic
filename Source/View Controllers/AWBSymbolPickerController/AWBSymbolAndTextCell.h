//
//  AWBSymbolGroupCell.h
//  Collage Maker
//
//  Created by Adam Buckley on 01/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBTransformableArrowView.h"

@interface AWBSymbolAndTextCell : UITableViewCell {
    AWBTransformableArrowView *arrowView;
    UILabel *arrowLabel;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setArrowLineShapeType:(AWBArrowLineShapeType)lineShapeType;
- (NSString *)descriptionOfLineShapeType:(AWBArrowLineShapeType)lineShapeType;

@end
