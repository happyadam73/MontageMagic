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

@interface AWBCollagesListViewController : UITableViewController <AWBCollageSettingsTableViewControllerDelegate>
{
    NSInteger scrollToRow;
    BOOL isLowMemory;
    BOOL haveCreatedMagicCollage;
    AWBBusyView *busyView;
    BOOL motionEnabled;
}

@property (assign) BOOL isLowMemory;
@property (nonatomic, retain) AWBBusyView *busyView;

- (CGFloat)borderThickness;
- (void)addNewCollageDescriptor:(id)sender;
- (void)loadCollageAtIndexPath:(NSIndexPath *)indexPath requestThemeChange:(BOOL)themeChange createMagicCollage:(BOOL)createMagicCollage;
- (void)navigateToCollageController:(CollageMakerViewController *)collageController;
- (CGPoint)centerOfVisibleRows;

@end
