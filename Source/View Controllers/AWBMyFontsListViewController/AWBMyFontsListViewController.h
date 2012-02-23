//
//  AWBRoadsignsListViewController.h
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBCollageSettingsTableViewController.h"
#import "AWBBusyView.h"
#import "AWBMyFont.h"

@interface AWBMyFontsListViewController : UIViewController <UITableViewDataSource, 
                                                            UITableViewDelegate, 
                                                            UIAlertViewDelegate, 
                                                            UIActionSheetDelegate,
                                                            AWBCollageSettingsTableViewControllerDelegate>
{
	UITableView *theTableView;
    BOOL pendingMyFontInstall;
    AWBMyFont *pendingMyFont;
    NSURL *pendingMyFontInstallURL;
    UIAlertView *installMyFontAlertView;
    UIAlertView *installExtractedFontsAlertView;
    UIBarButtonItem *helpButton;
    UIBarButtonItem *freeFontsButton;    
    UIBarButtonItem *toolbarSpacing;
    BOOL showPurchaseWarning;
    NSArray *extractedFontFiles;
    UIActionSheet *freeFontsActionSheet; 
}

@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, assign) BOOL pendingMyFontInstall;
@property (nonatomic, retain) NSURL *pendingMyFontInstallURL;
@property (nonatomic, retain) AWBMyFont *pendingMyFont;
@property (nonatomic, retain) UIAlertView *installMyFontAlertView;
@property (nonatomic, retain) UIAlertView *installExtractedFontsAlertView;
@property (nonatomic, retain) UIBarButtonItem *helpButton;
@property (nonatomic, retain) UIBarButtonItem *freeFontsButton;
@property (nonatomic, retain) UIBarButtonItem *toolbarSpacing;
@property (nonatomic, retain) NSArray *extractedFontFiles;
@property (nonatomic, retain) UIActionSheet *freeFontsActionSheet; 

- (void)attemptMyFontInstall;
- (void)handleMyFontZipFileInstall;
- (void)myFontZipFileCleanup;
- (void)confirmMyFontInstall:(NSString *)fontName;
- (void)confirmExtractedFontsInstall;
- (void)installExtractedFonts;
- (void)showFontZipFileInstallError:(NSString *)filename;
- (void)showFontZipNoFilesError:(NSString *)filename;
- (void)showFontInstallError:(NSString *)filename;
- (void)showFontZipOneOrMoreInstallErrors:(NSUInteger)errorCount;
- (UIBarButtonItem *)helpButton;
- (void)showHelp;
- (NSArray *)myFontsToolbarButtons;
- (void)showFreeFontSites;

@end
