//
//  AWBRoadsignsListViewController.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBMyFontsListViewController.h"
#import "FileHelpers.h"
#import "AWBMyFontStore.h"
#import "AWBSettingsGroup.h"
#import "SSZipArchive.h"

@implementation AWBMyFontsListViewController

@synthesize theTableView, pendingMyFontInstall, pendingMyFontInstallURL, installMyFontAlertView, installExtractedFontsAlertView, helpButton, toolbarSpacing;
@synthesize pendingMyFont, extractedFontFiles;

- (void)loadView {
	
	// create a new table using the full application frame
	// we'll ask the datasource which type of table to use (plain or grouped)
	UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
														  style:UITableViewStyleGrouped];
	
	// set the autoresizing mask so that the table will always fill the view
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    tableView.allowsSelection = NO;
    tableView.allowsSelectionDuringEditing = NO;
    
	// set the tableview delegate to this object and the datasource to the datasource which has already been set
	tableView.delegate = self;
	tableView.dataSource = self;
	
	// set the tableview as the controller view
    self.theTableView = tableView;
	self.view = tableView;
	[tableView release];    
}

- (void)dealloc 
{
	theTableView.delegate = nil;
	theTableView.dataSource = nil;
	[theTableView release];
    [pendingMyFontInstallURL release];
    [pendingMyFont release];
    [installMyFontAlertView release];
    [installExtractedFontsAlertView release];
    [helpButton release];
    [toolbarSpacing release];
    [extractedFontFiles release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.theTableView.rowHeight = 70;    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    theTableView.delegate = nil;
	theTableView.dataSource = nil;
    self.theTableView = nil;
    self.helpButton = nil;
    self.toolbarSpacing = nil;
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.toolbarItems = [self myFontsToolbarButtons];
    [self.navigationController setToolbarHidden:NO animated:YES];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myfonts"]];
    self.navigationItem.titleView = titleView;
    [titleView release];
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];    
    [self.theTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (pendingMyFontInstall) {
        pendingMyFontInstall = NO;
        [self attemptMyFontInstall];
    } 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[AWBMyFontStore defaultStore] saveAllMyFonts];
    
    //dismiss alert views if neccessary
    if (self.installMyFontAlertView) {
        self.installMyFontAlertView.delegate = nil;
        [self.installMyFontAlertView dismissWithClickedButtonIndex:self.installMyFontAlertView.cancelButtonIndex animated:NO];
        [self alertView:self.installMyFontAlertView didDismissWithButtonIndex:self.installMyFontAlertView.cancelButtonIndex];
    }
    
    if (self.installExtractedFontsAlertView) {
        self.installExtractedFontsAlertView.delegate = nil;
        [self.installExtractedFontsAlertView dismissWithClickedButtonIndex:self.installExtractedFontsAlertView.cancelButtonIndex animated:NO];
        [self alertView:self.installExtractedFontsAlertView didDismissWithButtonIndex:self.installExtractedFontsAlertView.cancelButtonIndex];
    }    
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    //return YES;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated    
{
    [super setEditing:editing animated:animated];
    [theTableView setEditing:editing animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[AWBMyFontStore defaultStore] allMyFonts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyFontCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AWBMyFont *myFont = [[[AWBMyFontStore defaultStore] allMyFonts] objectAtIndex:[indexPath row]];
    cell.textLabel.text = myFont.fontName;
    cell.detailTextLabel.numberOfLines = 2;
    
    NSString *familyName;
    if (myFont.familyName) {
        familyName = myFont.familyName;
    } else {
        familyName = @"N/A";
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Family: %@\r\nInstalled: %@ (%@)", familyName, AWBDateStringForCurrentLocale(myFont.createdDate), AWBFileSizeIntToString(myFont.fileSizeBytes)];        
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
       
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        AWBMyFontStore *fs = [AWBMyFontStore defaultStore];
        NSUInteger myFontCountBeforeDelete = [[fs allMyFonts] count];
        NSArray *myFonts = [fs allMyFonts];
        AWBMyFont *myFont = [myFonts objectAtIndex:[indexPath row]];
        [fs removeMyFont:myFont];
        [fs saveAllMyFonts];
        NSUInteger myFontCountAfterDelete = [[fs allMyFonts] count];
        
        // We also remove that row from the table view with an animation
        if ((myFontCountBeforeDelete - myFontCountAfterDelete) == 1) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:YES];
        }
        
        if (myFontCountAfterDelete == 0) {
            [self.theTableView reloadData];
        }        
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    [[AWBMyFontStore defaultStore] moveMyFontAtIndex:[fromIndexPath row] toIndex:[toIndexPath row]];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    NSUInteger totalMyFontCount = [[[AWBMyFontStore defaultStore] allMyFonts] count];
    if (totalMyFontCount > 0) {
        self.navigationItem.rightBarButtonItem = [self editButtonItem];
        return @"Tap the Blue Disclosure button to see a preview of each font.  You can also edit the font name.";
    } else {
        [self setEditing:NO];
        self.navigationItem.rightBarButtonItem = nil;
        return @"There are no MyFonts installed.  You can install TrueType and OpenType fonts by opening them from apps such as Mail and Safari.  Tap on the Help button for more information.";
    }        
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath  
{
    [self setEditing:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [self setEditing:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath    
{
    AWBMyFont *myFont = [[[AWBMyFontStore defaultStore] allMyFonts] objectAtIndex:[indexPath row]];
    
    NSMutableDictionary *settingsInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:myFont.fontName, kAWBInfoKeyMyFontFontName, myFont.fileUrl, kAWBInfoKeyMyFontFileUrl, myFont.filename, kAWBInfoKeyMyFontFilename, myFont.createdDate, kAWBInfoKeyMyFontCreatedDate, [NSNumber numberWithInteger:myFont.fileSizeBytes], kAWBInfoKeyMyFontFileSizeBytes, [NSNumber numberWithInt:[indexPath row]], kAWBInfoKeyMyFontStoreMyFontIndex, nil];
    
    if (myFont.familyName) {
        [settingsInfo setObject:myFont.familyName forKey:kAWBInfoKeyMyFontFamilyName];
    }

    if (myFont.postScriptName) {
        [settingsInfo setObject:myFont.postScriptName forKey:kAWBInfoKeyMyFontPostscriptName];
    }
        
    AWBCollageSettingsTableViewController *settingsController = [[AWBCollageSettingsTableViewController alloc] initWithSettings:[AWBSettings myFontDescriptionSettingsWithInfo:settingsInfo header:nil] settingsInfo:settingsInfo rootController:nil]; 
    settingsController.delegate = self;
    settingsController.controllerType = AWBSettingsControllerTypeMyFontInfoSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;  
    [self presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];
}

- (void)awbCollageSettingsTableViewController:(AWBCollageSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info
{
    if (settingsController.controllerType == AWBSettingsControllerTypeMyFontInfoSettings) {
        NSUInteger myFontStoreIndex = [[info objectForKey:kAWBInfoKeyMyFontStoreMyFontIndex] intValue];
        if (myFontStoreIndex < [[[AWBMyFontStore defaultStore] allMyFonts] count]) {
            AWBMyFont *myFont = [[[AWBMyFontStore defaultStore] allMyFonts] objectAtIndex:myFontStoreIndex]; 
            myFont.fontName = [info objectForKey:kAWBInfoKeyMyFontFontName];
            [[AWBMyFontStore defaultStore] saveAllMyFonts];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:myFontStoreIndex inSection:0];
            [self.theTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone]; 
        }
    }
}

- (void)attemptMyFontInstall
{
    //need a URL
    if (self.pendingMyFontInstallURL) {
        
        BOOL isZipFile = [[[self.pendingMyFontInstallURL pathExtension] uppercaseString] isEqualToString:@"ZIP"];
        if (isZipFile) {
            [self handleMyFontZipFileInstall];
        } else {
            AWBMyFont *font = [[AWBMyFont alloc] initWithUrl:self.pendingMyFontInstallURL];
            self.pendingMyFont = font;
            [font release];
            if (self.pendingMyFont) {
                [self confirmMyFontInstall:self.pendingMyFont.fontName];
            } else {
                NSString *path = [self.pendingMyFontInstallURL path];
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                [self showFontInstallError:path.lastPathComponent];
            }            
        }
    }
}

- (void)handleMyFontZipFileInstall
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *path = [self.pendingMyFontInstallURL path];
    NSString *extractFolder = AWBPathInMyFontsExtractionSubdirectory();
    
    BOOL success = [SSZipArchive unzipFontFilesAtPath:path toDestination:extractFolder];
    if (success) {
        NSArray *fontFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:extractFolder error:nil];
        if (fontFiles && ([fontFiles count] > 0)) {
            self.extractedFontFiles = fontFiles;
            [self confirmExtractedFontsInstall];
        } else {
            [self showFontZipNoFilesError:path.lastPathComponent];
            [self myFontZipFileCleanup];            
        }
    } else {
        [self showFontZipFileInstallError:path.lastPathComponent];
        [self myFontZipFileCleanup];
    }
    
    [pool drain];
}

- (void)myFontZipFileCleanup
{
    NSString *path = [self.pendingMyFontInstallURL path];
    NSString *extractFolder = AWBPathInMyFontsExtractionSubdirectory();
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];  
    [[NSFileManager defaultManager] removeItemAtPath:extractFolder error:nil];  
    self.pendingMyFontInstallURL = nil;
    self.extractedFontFiles = nil;
    self.installExtractedFontsAlertView = nil;
}

- (void)showFontZipFileInstallError:(NSString *)filename
{
    NSString *message = [NSString stringWithFormat:@"%@ is either an invalid Zip file or could not be opened and extracted.", filename];
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Zip Extraction Failed" 
                              message:message 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];       
}

- (void)showFontZipNoFilesError:(NSString *)filename
{
    NSString *message = [NSString stringWithFormat:@"%@ contained no font files to install.", filename];
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"No Fonts Found" 
                              message:message 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];       
}

- (void)showFontZipOneOrMoreInstallErrors:(NSUInteger)errorCount
{
    NSString *message = [NSString stringWithFormat:@"%d font%@ either invalid or could not be installed.", errorCount, (errorCount > 1 ? @"s were" : @" was")];
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Install Error" 
                              message:message 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];       
}

- (void)showFontInstallError:(NSString *)filename
{
    NSString *message = [NSString stringWithFormat:@"%@ was invalid and could not be installed.", filename];
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Install Failed" 
                              message:message 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];       
}

- (void)confirmExtractedFontsInstall
{
    NSUInteger fontCount = [self.extractedFontFiles count];
    NSString *firstFontFilename = [self.extractedFontFiles objectAtIndex:0];
    NSString *message = nil;
    NSString *title = nil;
    
    if (fontCount > 1) {
        message = [NSString stringWithFormat:@"Do you want to install %@ and %d other font%@?", firstFontFilename, (fontCount - 1), (((fontCount - 1) > 1)? @"s" : @"")];
        title = [NSString stringWithFormat:@"Install %d fonts?", fontCount];
    } else {
        message = [NSString stringWithFormat:@"Do you want to install %@ ?", firstFontFilename];
        title = @"Install Font?";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:title 
                              message:message 
                              delegate:self 
                              cancelButtonTitle:@"No" 
                              otherButtonTitles:@"Yes", 
                              nil];
    self.installExtractedFontsAlertView = alertView;
    [self.installExtractedFontsAlertView show];
    [alertView release];   
}

- (void)confirmMyFontInstall:(NSString *)fontName
{
    NSString *message = [NSString stringWithFormat:@"Do you want to install the font, %@ ?", fontName];
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Install Font?" 
                              message:message 
                              delegate:self 
                              cancelButtonTitle:@"No" 
                              otherButtonTitles:@"Yes", 
                              nil];
    self.installMyFontAlertView = alertView;
    [self.installMyFontAlertView show];
    [alertView release];   
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == self.installMyFontAlertView) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [[AWBMyFontStore defaultStore] installMyFont:self.pendingMyFont];
            [self.theTableView reloadData];
            NSUInteger scrollToRow = [theTableView numberOfRowsInSection:0] - 1;
            @try {
                [theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollToRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            @catch (NSException *e) {
                //                    NSLog(@"%@", [e reason]);
            }
        } else {
            [self.pendingMyFont removeFromInbox];
        }
        self.installMyFontAlertView = nil;
        self.pendingMyFontInstallURL = nil;
        self.pendingMyFont = nil;
    } else if (alertView == self.installExtractedFontsAlertView) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [self installExtractedFonts];
        } else {
            [self myFontZipFileCleanup];
        }        
    }
}

- (void)installExtractedFonts
{
    NSUInteger errorCount = 0;
    NSUInteger successCount = 0;
    for (NSString *fontFileName in self.extractedFontFiles) {
        NSString *fullPath = AWBPathWithFilenameInMyFontsExtractionSubdirectory(fontFileName);
        AWBMyFont *font = [[AWBMyFont alloc] initWithUrl:[NSURL fileURLWithPath:fullPath]];
        if (font) {
            [[AWBMyFontStore defaultStore] installMyFont:font];
            successCount += 1;
        } else {
            errorCount += 1;
        }
        [font release];
    }
    
    if (errorCount > 0) {
        [self showFontZipOneOrMoreInstallErrors:errorCount];
    }
    
    if (successCount > 0) {
        [self.theTableView reloadData];
        NSUInteger scrollToRow = [theTableView numberOfRowsInSection:0] - 1;
        @try {
            [theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollToRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        @catch (NSException *e) {
            //NSLog(@"%@", [e reason]);
        }
    }
    
    [self myFontZipFileCleanup];
}

- (UIBarButtonItem *)helpButton
{
    if (!helpButton) {
        helpButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"help"] style:UIBarButtonItemStyleBordered target:self action:@selector(showHelp)];
    }
    return helpButton;    
}

- (UIBarButtonItem *)toolbarSpacing
{
    if (!toolbarSpacing) {
        toolbarSpacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return toolbarSpacing;    
}

- (void)showHelp
{    
    AWBCollageSettingsTableViewController *settingsController = [[AWBCollageSettingsTableViewController alloc] initWithSettings:[AWBSettings helpSettingsWithFilename:@"MyFonts.rtfd.zip" title:@"MyFonts Help"] settingsInfo:nil rootController:nil]; 
    settingsController.delegate = nil;
    settingsController.controllerType = AWBSettingsControllerTypeHelpSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
    [self presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];                
}

- (NSArray *)myFontsToolbarButtons
{
    return [NSArray arrayWithObjects:self.toolbarSpacing, self.helpButton, nil];    
}

@end

