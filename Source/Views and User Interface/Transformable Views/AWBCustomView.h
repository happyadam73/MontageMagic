//
//  AWBCustomView.h
//  Collage Maker
//
//  Created by Adam Buckley on 23/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"

@interface AWBCustomView : UIView <AWBTransformableView> {
    CGSize scaledSize;
}

@property (nonatomic, assign) CGSize scaledSize;

@end
