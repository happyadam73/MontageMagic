//
//  AWBZFontTableCell.m
//  Montage Magic
//
//  Created by Buckley Adam on 19/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBZFontTableCell.h"

@implementation AWBZFontTableCell

- (id)initWithFontType:(AWBCollageFontType)fontType reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        AWBCollageFont *font = [[AWBCollageFont alloc] initWithFontType:fontType];
        fontLabel = [[FontLabel alloc] initWithFrame:CGRectZero zFont:[font zFontWithSize:24.0]];
        fontLabel.backgroundColor = [UIColor clearColor];
        fontLabel.text = [font fontDescription];
        [[self contentView] addSubview:fontLabel];
        [font release];
        [fontLabel release];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithFontType:AWBCollageFontTypeHelvetica reuseIdentifier:reuseIdentifier];
}

- (void)updateCellWithSetting:(AWBSetting *)aSetting
{
    AWBCollageFontType fontType = [aSetting.settingValue integerValue];
    AWBCollageFont *font = [[AWBCollageFont alloc] initWithFontType:fontType];
    fontLabel.zFont = [font zFontWithSize:24.0];
    fontLabel.text = [font fontDescription];
    [font release];    
}

- (void)layoutSubviews  
{
    [super layoutSubviews];
    fontLabel.frame = CGRectMake(10.0, 0.0, (self.contentView.bounds.size.width - 20.0), self.contentView.bounds.size.height);
}

@end
