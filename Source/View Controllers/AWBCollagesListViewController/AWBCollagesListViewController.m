//
//  AWBCollagesListViewController.m
//  Collage Maker
//
//  Created by Adam Buckley on 12/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBCollagesListViewController.h"
#import "FileHelpers.h"
#import "CollageMakerViewController.h"
#import "CollageDescriptor.h"
#import "CollageStore.h"
#import "AWBSettingsGroup.h"
#import "AWBMyFontsListViewController.h"

@implementation AWBCollagesListViewController

@synthesize isLowMemory, busyView, myFontsButton;

- (id)init
{    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        scrollToRow = -1;
        self.navigationItem.title = @"Saved Collages";
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCollageDescriptor:)];
        [[self navigationItem] setRightBarButtonItem:addButton];
        [addButton release];
        [self.navigationController setToolbarHidden:NO animated:NO];
        self.toolbarItems = [self myCollagesToolbarButtons];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)dealloc
{
    [busyView release];
    [myFontsButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    self.isLowMemory = YES;
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (DEVICE_IS_IPAD) {
        [self tableView].rowHeight = 212;
    } else {
        [self tableView].rowHeight = 100;    
    } 
}

- (void)viewDidUnload
{
    self.busyView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    self.toolbarItems = [self myCollagesToolbarButtons];
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAWBInfoKeyCollageStoreCollageIndex];
    [[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    haveCreatedMagicCollage = NO;
    motionEnabled = YES;
    [self becomeFirstResponder];
    
    scrollToRow = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyScrollToCollageStoreCollageIndex];
    if (scrollToRow >= 0) {
        @try {
            [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollToRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        @catch (NSException *e) {
            NSLog(@"%@", [e reason]);
        }
        @finally {
            scrollToRow = -1;
        }
    } 
}

- (void)viewWillDisappear:(BOOL)animated
{
    motionEnabled = NO;
    [[CollageStore defaultStore] saveAllCollages];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[CollageStore defaultStore] allCollages] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CollageDescriptorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        UILongPressGestureRecognizer *longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)] autorelease];
        longPressGesture.minimumPressDuration = 1.2; //seconds
        longPressGesture.delegate = self;
		[cell addGestureRecognizer:longPressGesture];
    }
    
    CollageDescriptor *collage = [[[CollageStore defaultStore] allCollages] objectAtIndex:[indexPath row]];
    NSString *subDir = collage.collageSaveDocumentsSubdirectory;

    if (collage.collageName && ([collage.collageName length] > 0)) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", collage.collageName];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", subDir];
    }

    UIImage *thumbnail = [UIImage imageWithContentsOfFile:AWBPathInDocumentSubdirectory(subDir, @"thumbnail.jpg")];
    
    if (!thumbnail) {
        if (DEVICE_IS_IPAD) {
            thumbnail = [UIImage imageNamed:@"defaultthumbnail.jpg"];
        } else {
            thumbnail = [UIImage imageNamed:@"defaultthumbnailsmall.jpg"];
        }    
    }
    cell.imageView.image = thumbnail;
    cell.imageView.layer.borderWidth = [self borderThickness];
    cell.imageView.layer.cornerRadius = [self borderThickness] * 4.0; 
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.borderColor = [[UIColor blackColor] CGColor];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created: %@\r\nUpdated: %@", AWBDateStringForCurrentLocale(collage.createdDate), AWBDocumentSubdirectoryModifiedDate(subDir)];        
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        CollageStore *cs = [CollageStore defaultStore];
        NSUInteger collageCountBeforeDelete = [[cs allCollages] count];
        NSArray *collages = [cs allCollages];
        CollageDescriptor *collage = [collages objectAtIndex:[indexPath row]];
        [cs removeCollage:collage];
        [[CollageStore defaultStore] saveAllCollages];
        NSUInteger collageCountAfterDelete = [[[CollageStore defaultStore] allCollages] count];
        
        // We also remove that row from the table view with an animation
        if ((collageCountBeforeDelete - collageCountAfterDelete) == 1) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:YES];
        }
        
        if (collageCountAfterDelete == 0) {
            [self.tableView reloadData];
        }        
    }
}

- (void)tableView:(UITableView *)tableView 
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
      toIndexPath:(NSIndexPath *)toIndexPath 
{
    [[CollageStore defaultStore] moveCollageAtIndex:[fromIndexPath row] toIndex:[toIndexPath row]];
}

- (CGFloat)borderThickness
{
    if (DEVICE_IS_IPAD) {
        return 6.0;
    } else {
        return 3.0;    
    }    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    NSUInteger totalCollageCount = [[[CollageStore defaultStore] allCollages] count];
    if (totalCollageCount > 0) {
        self.navigationItem.leftBarButtonItem = [self editButtonItem];
        return @"Click the + button to create a new collage. Or Shake Me and I'll make one for you!  Tap and Hold a collage to make a copy.";
    } else {
        [self setEditing:NO];
        self.navigationItem.leftBarButtonItem = nil;
        return @"There are no saved collages.  Click the + button to create a new collage or Shake Me to generate a random collage.";
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    motionEnabled = NO;
    [self loadCollageAtIndexPath:indexPath requestThemeChange:NO createMagicCollage:NO];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath    
{
    motionEnabled = NO;
    CollageDescriptor *collage = [[[CollageStore defaultStore] allCollages] objectAtIndex:[indexPath row]];
    NSUInteger totalDiskBytes = AWBDocumentSubdirectoryFolderSize(collage.collageSaveDocumentsSubdirectory);
    [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyScrollToCollageStoreCollageIndex]; 
    
    NSMutableDictionary *settingsInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:collage.collageName, kAWBInfoKeyCollageName, [CollageTheme themeWithThemeType:collage.themeType], kAWBInfoKeyCollageTheme, [NSNumber numberWithInt:collage.totalImageObjects], kAWBInfoKeyCollageTotalImageObjects, [NSNumber numberWithInt:collage.totalLabelObjects], kAWBInfoKeyCollageTotalLabelObjects, [NSNumber numberWithInt:[indexPath row]], kAWBInfoKeyCollageStoreCollageIndex, [NSNumber numberWithInt:collage.totalImageMemoryBytes], kAWBInfoKeyCollageTotalImageMemoryBytes, [NSNumber numberWithInt:totalDiskBytes], kAWBInfoKeyCollageTotalDiskBytes, nil];
    AWBCollageSettingsTableViewController *settingsController = [[AWBCollageSettingsTableViewController alloc] initWithSettings:[AWBSettings collageDescriptionSettingsWithInfo:settingsInfo header:[collage collageInfoHeaderView]] settingsInfo:settingsInfo rootController:nil]; 
    settingsController.delegate = self;
    settingsController.controllerType = AWBSettingsControllerTypeCollageInfoSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;  
    [self presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];
}

- (void)loadCollageAtIndexPath:(NSIndexPath *)indexPath requestThemeChange:(BOOL)themeChange createMagicCollage:(BOOL)createMagicCollage
{
    CollageDescriptor *collage = [[[CollageStore defaultStore] allCollages] objectAtIndex:[indexPath row]];
    CollageMakerViewController *collageController = [[[CollageMakerViewController alloc] initWithCollageDescriptor:collage] autorelease];  
    collageController.createMagicCollage = createMagicCollage;
    if (themeChange) {
        collageController.requestThemeChangeOnNextLoad = YES;
    }
    
    //first transition animation - if there's more than 10 images or 30 objects then don't animate the transition
    BOOL animated = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyScrollToCollageStoreCollageIndex]; 
    if ((collage.totalImageObjects > 10) || (collage.totalObjects > 30)) {
        animated = NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kAWBInfoKeyCollageStoreCollageIndex]; 
    }
        
    //secondly - load progress busy indicator.  Only enable if more than 10 images to be loaded   
    if (collage.totalImageObjects > 10) {
        NSString *busyTextDetail = [NSString stringWithFormat:@"(with %d photos)", collage.totalImageObjects];
        AWBBusyView *busyIndicatorView = [[AWBBusyView alloc] initWithText:@"Preparing Collage" detailText:busyTextDetail parentView:self.view centerAtPoint:[self centerOfVisibleRows]];
        [self performSelector:@selector(navigateToCollageController:) withObject:collageController afterDelay:0];
        self.busyView = busyIndicatorView;
        [busyIndicatorView release];
    } else {
        [self.navigationController pushViewController:collageController animated:animated];
    }
  
}

- (CGPoint)centerOfVisibleRows
{
    CGPoint center = CGPointZero;
    NSArray *rowPaths = [self.tableView indexPathsForVisibleRows];
    if (rowPaths && ([rowPaths count] > 0)) {
        CGRect topRect = [self.tableView rectForRowAtIndexPath:[rowPaths objectAtIndex:0]];
        CGRect bottomRect = [self.tableView rectForRowAtIndexPath:[rowPaths objectAtIndex:([rowPaths count]-1)]];
        CGPoint topLeft = topRect.origin;
        CGPoint bottomRight = CGPointMake(bottomRect.origin.x + bottomRect.size.width, bottomRect.origin.y + bottomRect.size.height);
        CGFloat totalWidth = bottomRight.x - topLeft.x;
        CGFloat totalHeight = bottomRight.y - topLeft.y;
        center = CGPointMake(topLeft.x + (totalWidth/2.0), topLeft.y + (totalHeight/2.0));
    } else {
        NSLog(@"No Visible Rows!");
    }
    return center;
}

- (void)navigateToCollageController:(CollageMakerViewController *)collageController
{
    [self.navigationController pushViewController:collageController animated:NO];
    [self.busyView removeFromParentView];
    self.busyView = nil;
}

- (void)addNewCollageDescriptor:(id)sender
{
    motionEnabled = NO;
    [self setEditing:NO animated:YES];
    NSString *nextDefaultCollageName = [[CollageStore defaultStore] nextDefaultCollageName];
    CollageThemeType lastUsedThemeType = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyCollageThemeType];
    NSMutableDictionary *settingsInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:nextDefaultCollageName, kAWBInfoKeyCollageName, [CollageTheme themeWithThemeType:lastUsedThemeType], kAWBInfoKeyCollageTheme, [NSNumber numberWithBool:NO], kAWBInfoKeyAddContentOnCreation, nil];
    AWBCollageSettingsTableViewController *settingsController = [[AWBCollageSettingsTableViewController alloc] initWithSettings:[AWBSettings themeSettingsWithInfo:settingsInfo] settingsInfo:settingsInfo rootController:nil]; 
    settingsController.delegate = self;
    settingsController.controllerType = AWBSettingsControllerTypeChooseThemeSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
    [self presentModalViewController:navController animated:YES];
    [settingsController release];   
    [navController release];
}

- (void)awbCollageSettingsTableViewController:(AWBCollageSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info
{
    if ((settingsController.controllerType == AWBSettingsControllerTypeChooseThemeSettings) || !settingsController) {
        CollageDescriptor *collage = [[CollageStore defaultStore] createCollage]; 
        collage.collageName = [info objectForKey:kAWBInfoKeyCollageName];
        collage.themeType = [[info objectForKey:kAWBInfoKeyCollageTheme] themeType];
        collage.addContentOnCreation = [[info objectForKey:kAWBInfoKeyAddContentOnCreation] boolValue];
        if (settingsController) {
            [[NSUserDefaults standardUserDefaults] setInteger:collage.themeType forKey:kAWBInfoKeyCollageThemeType];            
        }
        NSUInteger totalCollageCount = [[[CollageStore defaultStore] allCollages] count];
        if (totalCollageCount > 0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(totalCollageCount - 1) inSection:0];
            [self loadCollageAtIndexPath:scrollIndexPath requestThemeChange:NO createMagicCollage:collage.addContentOnCreation];            
        }
    } else if (settingsController.controllerType == AWBSettingsControllerTypeCollageInfoSettings) {
        NSUInteger collageStoreIndex = [[info objectForKey:kAWBInfoKeyCollageStoreCollageIndex] intValue];
        if (collageStoreIndex < [[[CollageStore defaultStore] allCollages] count]) {
            CollageDescriptor *collage = [[[CollageStore defaultStore] allCollages] objectAtIndex:collageStoreIndex]; 
            collage.collageName = [info objectForKey:kAWBInfoKeyCollageName];
            BOOL reloadCollage = NO;
            if (collage.themeType != [[info objectForKey:kAWBInfoKeyCollageTheme] themeType]) {
                //theme has changed so need to reload collage
                reloadCollage = YES;
                collage.themeType = [[info objectForKey:kAWBInfoKeyCollageTheme] themeType];
                [[NSUserDefaults standardUserDefaults] setInteger:collage.themeType forKey:kAWBInfoKeyCollageThemeType];             
            }
            [[CollageStore defaultStore] saveAllCollages];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:collageStoreIndex inSection:0];
            if (reloadCollage) {
                [self loadCollageAtIndexPath:indexPath requestThemeChange:YES createMagicCollage:NO];
            } else {
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone]; 
                motionEnabled = YES;
            }            
        }
    }
}

- (void)awbCollageSettingsTableViewControllerDidDissmiss:(AWBCollageSettingsTableViewController *)settingsController
{
    //cancelled creation or collage info
    motionEnabled = YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event   
{
    if ((motion == UIEventSubtypeMotionShake) && !haveCreatedMagicCollage && motionEnabled && !self.editing) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        haveCreatedMagicCollage = YES;
        NSString *nextDefaultCollageName = [[CollageStore defaultStore] nextDefaultCollageName];
        CollageTheme *randomTheme = [CollageTheme randomCollageTheme];
        NSDictionary *settingsInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:nextDefaultCollageName, kAWBInfoKeyCollageName, randomTheme, kAWBInfoKeyCollageTheme, [NSNumber numberWithBool:YES], kAWBInfoKeyAddContentOnCreation, nil];
        [self awbCollageSettingsTableViewController:nil didFinishSettingsWithInfo:settingsInfo];
        [pool drain];
    }
}

- (UIBarButtonItem *)myFontsButton
{
    if (!myFontsButton) {
        myFontsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myfonts"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMyFonts)];
    }
    return myFontsButton;    
}

- (void)showMyFonts
{
    AWBMyFontsListViewController *controller = [[AWBMyFontsListViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];                
}

- (NSArray *)myCollagesToolbarButtons
{
    return [NSArray arrayWithObjects:self.myFontsButton, nil];    
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
	// only when gesture was recognized, not when ended
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
        motionEnabled = NO;
		// get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
		// do something with this action
        pendingCopyIndexRow = [indexPath row];
        CollageDescriptor *collage = [[[CollageStore defaultStore] allCollages] objectAtIndex:pendingCopyIndexRow]; 
        [self confirmCopyCollage:collage.collageName];
	}
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) && (self.tableView.editing)) {
        return NO;
    } else {
        return YES;
    }
}

- (void)confirmCopyCollage:(NSString *)collageName
{
    NSString *msg = [NSString stringWithFormat:@"Make a copy of %@ ?", collageName];
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Copy Collage?" 
                              message:msg 
                              delegate:self 
                              cancelButtonTitle:@"No" 
                              otherButtonTitles:@"Yes", 
                              nil];
    
    [alertView show];
    [alertView release];   
}

- (void)copyCollageError
{
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Copy Failed!" 
                              message:@"An error occurred while copying the collage." 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        BOOL success = [[CollageStore defaultStore] copyCollageAtIndex:pendingCopyIndexRow]; 
        if (success) {
            [self.tableView reloadData];            
        } else {
            [self copyCollageError];
        }
    }
    motionEnabled = YES;
}

@end
