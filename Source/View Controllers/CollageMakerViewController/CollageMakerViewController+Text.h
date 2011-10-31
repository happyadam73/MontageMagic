//
//  CollageMakerViewController+Text.h
//  Collage Maker
//
//  Created by Adam Buckley on 24/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController.h"
#import "AWBTransformableLabel.h"
#import "AWBCollageSettingsTableViewController.h"

@interface CollageMakerViewController (Text)

- (void)addTextView:(id)sender;
- (void)editSelectedTextViews:(id)sender;
- (NSMutableArray *)textLabelLines;

@end
