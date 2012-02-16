//
//  AWBZFontTableCell.h
//  Roadsign Magic
//
//  Created by Buckley Adam on 19/12/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "AWBCollageFont.h"
#import "AWBSettingTableCell.h"

@interface AWBZFontTableCell : UITableViewCell {
    FontLabel *fontLabel;
}

- (id)initWithFontType:(AWBCollageFontType)fontType reuseIdentifier:(NSString *)reuseIdentifier;

@end
