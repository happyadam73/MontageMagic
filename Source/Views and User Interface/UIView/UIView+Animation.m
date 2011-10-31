//
//  UIView+Animation.m
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "UIView+Animation.h"


@implementation UIView (Animation)

- (void)addSubviewWithAnimation:(UIView *)view duration:(NSTimeInterval)duration moveToPoint:(CGPoint)point
{
    [view retain];
        
    CGRect currentBounds = [view bounds];
    [view setBounds:CGRectZero];
    [view setAlpha:0.0];
    [view setCenter:[self randomViewPointWithMarginThickness:0.0]];
    
    [self addSubview:view];
    
    [UIView animateWithDuration:duration 
                          delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations: ^ {
                         [view setAlpha:1.0]; 
                         [view setBounds:currentBounds];
                         [view setCenter:point];
                     } 
                     completion: ^ (BOOL finished) {
                         [view release];
                     }];
}

- (CGPoint)randomViewPointWithMarginThickness:(CGFloat)margin
{
    CGFloat maxWidth = self.bounds.size.width - margin;
    CGFloat maxHeight = self.bounds.size.height - margin;

    return CGPointMake(AWBRandomIntInRange(margin, maxWidth), AWBRandomIntInRange(margin, maxHeight));   
}

- (CGPoint)randomViewPoint
{
    //set margin to 10% of longest screen length
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    
    //longest width should be height, but check just in case
    CGFloat screenLength = (screenSize.height > screenSize.width ? screenSize.height : screenSize.width);
    
    return [self randomViewPointWithMarginThickness:(0.1*screenLength)];
}
//
//- (CGPoint)randomPointInAreaWithIndex:(NSUInteger)areaIndex totalAreasWide:(NSUInteger)areasWide totalAreasHigh:(NSUInteger)areasHigh screenMarginPercentage:(CGFloat)screenMarginPerc areaMarginPercentage:(CGFloat)areaMarginPerc adjustMidPointsOnIndexOverflow:(BOOL)adjustMidPoints
//{
//    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
//    CGFloat screenWidth = (screenSize.height > screenSize.width ? screenSize.height : screenSize.width);
//    CGFloat screenHeight = (screenSize.height > screenSize.width ? screenSize.width : screenSize.height);
//    CGFloat screenOffsetX = screenWidth * screenMarginPerc;
//    CGFloat screenOffsetY = screenHeight * screenMarginPerc;
//    CGFloat areaWidth = ((1.0 - (2.0*screenMarginPerc))*screenWidth)/areasWide;
//    CGFloat areaHeight = ((1.0 - (2.0*screenMarginPerc))*screenHeight)/areasHigh;
//    CGFloat areaWidthRange = ((1.0 - (2.0*areaMarginPerc))*areaWidth);
//    CGFloat areaHeightRange = ((1.0 - (2.0*areaMarginPerc))*areaHeight);
//    CGFloat minAreaX = areaMarginPerc * areaWidth;
//    CGFloat maxAreaX = minAreaX + areaWidthRange;
//    CGFloat minAreaY = areaMarginPerc * areaHeight;
//    CGFloat maxAreaY = minAreaY + areaHeightRange;
//    
//    CGFloat randomX = (CGFloat)AWBRandomIntInRange((int)minAreaX, (int)maxAreaX);
//    CGFloat randomY = (CGFloat)AWBRandomIntInRange((int)minAreaY, (int)maxAreaY);
//    
//    //now work out from index, which box we are in
//    NSUInteger areaXIndex = ((areaIndex-1) % areasWide)+1;
//    NSUInteger areaYIndex = (((areaIndex-1)/areasWide) % areasHigh)+1;
//    
//    CGFloat pointX = screenOffsetX + ((areaXIndex-1)*areaWidth) + randomX;
//    CGFloat pointY = screenOffsetY + ((areaYIndex-1)*areaHeight) + randomY;
//    
//    if (adjustMidPoints) {
//        NSUInteger overflowIndex = (((areaIndex - 1) / (areasWide * areasHigh)) % 3);
//        if (overflowIndex == 1) {
//            pointX += (areaWidth/3.0);
//            pointY += (areaHeight/3.0);
//        } else if (overflowIndex == 2) {
//            pointX += ((2.0 * areaWidth)/3.0);
//            pointY += ((2.0 * areaHeight)/3.0);            
//        }
//    }
//    
//    if (pointX > (screenWidth - screenOffsetX)) {
//        pointX = (screenWidth - screenOffsetX);
//    } else if (pointX < screenOffsetX) {
//        pointX = screenOffsetX;
//    }
//    
//    if (pointY > (screenHeight - screenOffsetY)) {
//        pointY = (screenHeight - screenOffsetY);
//    } else if (pointY < screenOffsetY) {
//        pointY = screenOffsetY;
//    }    
//    
//    return CGPointMake(pointX, pointY);
//}

@end
