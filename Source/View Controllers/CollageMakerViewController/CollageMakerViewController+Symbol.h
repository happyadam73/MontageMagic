//
//  CollageMakerViewController+Symbol.h
//  Collage Maker
//
//  Created by Adam Buckley on 01/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController.h"
#import "AWBCollageSettingsTableViewController.h"
#import "AWBSymbolGroupPickerController.h"

@interface CollageMakerViewController (Symbol) <AWBSymbolGroupPickerControllerDelegate>

- (void)addSymbol:(id)sender;
- (void)initialiseAddSymbolPopoverWithViewController:(UIViewController *)viewController andBarButtonItem:(UIBarButtonItem *)button;

@end
