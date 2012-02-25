//
//  AWBCollagesListViewController.h
//  Collage Maker
//
//  Created by Adam Buckley on 12/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBCollageSettingsTableViewController.h"
#import "AWBBusyView.h"

@class CollageMakerViewController;

@interface AWBCollagesListViewController : UITableViewController <AWBCollageSettingsTableViewControllerDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    NSInteger scrollToRow;
    BOOL isLowMemory;
    BOOL haveCreatedMagicCollage;
    AWBBusyView *busyView;
    BOOL motionEnabled;
    UIBarButtonItem *myFontsButton;
    UIBarButtonItem *helpButton;
    UIBarButtonItem *toolbarSpacing;
    NSUInteger pendingCopyIndexRow;
}

@property (assign) BOOL isLowMemory;
@property (nonatomic, retain) AWBBusyView *busyView;
@property (nonatomic, retain) UIBarButtonItem *myFontsButton;
@property (nonatomic, retain) UIBarButtonItem *helpButton;
@property (nonatomic, retain) UIBarButtonItem *toolbarSpacing;

- (CGFloat)borderThickness;
- (void)addNewCollageDescriptor:(id)sender;
- (void)loadCollageAtIndexPath:(NSIndexPath *)indexPath requestThemeChange:(BOOL)themeChange createMagicCollage:(BOOL)createMagicCollage;
- (void)navigateToCollageController:(CollageMakerViewController *)collageController;
- (CGPoint)centerOfVisibleRows;
- (void)showMyFonts;
- (NSArray *)myCollagesToolbarButtons;
- (void)confirmCopyCollage:(NSString *)collageName;
- (void)copyCollageError;
- (void)showHelp;

@end
