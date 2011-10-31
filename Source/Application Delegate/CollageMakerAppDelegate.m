//
//  CollageMakerAppDelegate.m
//  CollageMaker
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerAppDelegate.h"
#import "CollageMakerViewController.h"
#import "AWBSettings.h"
#import "AWBCollagesListViewController.h"
#import "CollageStore.h"
#import "CollageDescriptor.h"

@implementation CollageMakerAppDelegate

@synthesize window=_window;
@synthesize mainNavigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    CollageDescriptor *collage = nil;
    NSUInteger totalSavedCollages = [[[CollageStore defaultStore] allCollages] count];
    NSInteger collageIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyCollageStoreCollageIndex];
    if (totalSavedCollages==0) {
        //no collages
        //if user default index is -1 then this was by choice - user deleted them all so collage is nil otherwise this
        //is the first ever start so create one for the user automatically
        if (collageIndex != -1) {
            collage = [[CollageStore defaultStore] createCollage];
            //first collage - set theme
            collage.themeType = kAWBCollageThemeTypePhotoModernBlack;
            collage.collageName = @"Magic Moments";
        }
    } else {
        //check what the last selected collage was
        //if it's -1 (last used the list view) or it's outside array bounds, then collage not set
        if ((collageIndex >= 0) && (collageIndex < totalSavedCollages)) {
            collage = [[[CollageStore defaultStore] allCollages] objectAtIndex:collageIndex];
            if (collage.totalObjects >= [CollageMakerViewController excessiveSubviewCountThreshold]) {
                NSLog(@"Collage Total Objects: %d - exceed threshold (%d), so don't load", collage.totalObjects, [CollageMakerViewController excessiveSubviewCountThreshold]);
                collage = nil;
            }
        }
    }
    
    AWBCollagesListViewController *listController = [[AWBCollagesListViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:listController];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navController.navigationBar.translucent = YES;
    navController.toolbar.barStyle = UIBarStyleBlack;
    navController.toolbar.translucent = YES;
    
    //navigate to collage if one was previously selected, or this is the first collage
    if (collage) {
        CollageMakerViewController *collageController = [[CollageMakerViewController alloc] initWithCollageDescriptor:collage];
        [navController pushViewController:collageController animated:NO];
        [collageController release];        
    }
    
    self.mainNavigationController = navController;
    self.window.rootViewController = self.mainNavigationController;
    [navController release];
    [listController release];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [self.mainNavigationController.topViewController viewWillDisappear:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [self.mainNavigationController.topViewController viewDidAppear:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [mainNavigationController release];
    [super dealloc];
}

@end
