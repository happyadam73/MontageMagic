//
//  CollageMakerAppDelegate.h
//  CollageMaker
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollageMakerViewController;

@interface CollageMakerAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *mainNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *mainNavigationController;

- (BOOL)handleOpenURL:(NSURL *)url;

@end
