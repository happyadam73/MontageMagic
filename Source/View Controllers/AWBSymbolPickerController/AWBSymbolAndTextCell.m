//
//  AWBSymbolGroupCell.m
//  Collage Maker
//
//  Created by Adam Buckley on 01/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBSymbolAndTextCell.h"

@implementation AWBSymbolAndTextCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        arrowView = [[AWBTransformableArrowView alloc] initWithLength:70 color:[UIColor blackColor] type:kAWBArrowTypeSingleHeaded thickness:kAWBArrowThicknessTypeMedium arrowHead:kAWBArrowHeadTypeFilledTriangle arrowLineShape:kAWBArrowLineShapeTypeStraightLine arrowLineStroke:kAWBArrowLineStrokeTypeSolid];
        [[self contentView] addSubview:arrowView];
        [arrowView release];
        
        arrowLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [arrowLabel setBackgroundColor:[UIColor clearColor]];
        [arrowLabel setFont:[UIFont systemFontOfSize:18.0]];
        [[self contentView] addSubview:arrowLabel];
        [arrowLabel release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    arrowView.center = CGPointMake(45.0, self.contentView.center.y);
    
    CGRect bounds = [[self contentView] bounds];
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    CGFloat arrowLabelWidth = width - arrowView.bounds.size.width - 40.0;
    CGFloat arrowLabelHeight = height - 10.0;
    CGPoint startPoint = CGPointMake(arrowView.bounds.size.width + 30.0, 5.0);
    CGRect labelFrame = CGRectMake(startPoint.x, startPoint.y, arrowLabelWidth, arrowLabelHeight);
    [arrowLabel setFrame:labelFrame];
}

- (void)setArrowLineShapeType:(AWBArrowLineShapeType)lineShapeType  
{
    arrowView.arrowLineShapeType = lineShapeType;
    [arrowView adjustFrame];
    [arrowView setNeedsDisplay];
    [arrowLabel setText:[self descriptionOfLineShapeType:lineShapeType]];
}

- (NSString *)descriptionOfLineShapeType:(AWBArrowLineShapeType)lineShapeType
{
    switch (lineShapeType) {
        case kAWBArrowLineShapeTypeStraightLine:
            return @"Straight Lines";
            break;
        case kAWBArrowLineShapeTypeQuarterCircle:
            return @"Quarter Circles";
            break;
        case kAWBArrowLineShapeTypeHalfCircle:
            return @"Half Circles";
            break;
        case kAWBArrowLineShapeTypeBezierCurve:
            return @"Curved Lines";
            break;
        default:
            return nil;
            break;
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
