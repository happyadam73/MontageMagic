//
//  AWBSymbolGroupCell.m
//  Collage Maker
//
//  Created by Adam Buckley on 02/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBSymbolGroupCell.h"
#import "AWBTransformableArrowView.h"
#import "UIColor+SignColors.h"
#import "AWBSymbolPickerController.h"

@implementation AWBSymbolGroupCell

@synthesize symbolViews, symbolBackgroundColor;

- (id)initWithSymbols:(NSArray *)symbols backgroundColor:(UIColor *)color reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.symbolViews = symbols;
        self.symbolBackgroundColor = color;
    }
    return self;    
}

-(void)setSymbols:(NSArray *)symbols
{
    for(UIView *view in [self subviews]) 
    {		
		[view removeFromSuperview];
	}
	self.symbolViews = symbols;
}

-(void)layoutSubviews {
    CGPoint centerPoint = CGPointMake(36.0, 34.0);
    UIColor *borderColor;
    if ([self.symbolBackgroundColor isEqual:[UIColor blackColor]]) {
        borderColor = [UIColor whiteColor];
    } else {
        borderColor = [UIColor blackColor];            
    }
    
	for(AWBTransformableArrowView *arrow in self.symbolViews) {
        
        CGRect frame = CGRectMake(centerPoint.x - 34.0, 0.0, 68.0, 68.0);
        UIView *border = [[UIView alloc] initWithFrame:frame];
        border.backgroundColor = self.symbolBackgroundColor;
        border.layer.borderColor = [borderColor CGColor];
        border.layer.borderWidth = 0.5;
        UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:arrow action:@selector(arrowViewClicked:)] autorelease];
		[border addGestureRecognizer:tapRecognizer];
        [self addSubview:border];
        [border release];
        [arrow setUserInteractionEnabled:NO];
        [self addSubview:arrow];
        arrow.center = centerPoint;
        centerPoint.x += 68.0;
	}
}

- (void)dealloc
{
    [symbolBackgroundColor release];
    [symbolViews release];
    [super dealloc];
}

@end
