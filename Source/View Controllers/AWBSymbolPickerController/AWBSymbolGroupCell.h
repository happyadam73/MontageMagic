//
//  AWBSymbolGroupCell.h
//  Collage Maker
//
//  Created by Adam Buckley on 02/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWBSymbolGroupCell : UITableViewCell {
    NSArray *symbolViews;
    UIColor *symbolBackgroundColor;
}

@property (nonatomic, retain) NSArray *symbolViews;
@property (nonatomic, retain) UIColor *symbolBackgroundColor;

- (id)initWithSymbols:(NSArray *)symbols backgroundColor:(UIColor *)color reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setSymbols:(NSArray *)symbols;

@end
