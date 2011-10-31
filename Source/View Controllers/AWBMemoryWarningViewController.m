//
//  AWBMemoryWarningViewController.m
//  Collage Maker
//
//  Created by Adam Buckley on 14/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBMemoryWarningViewController.h"


@implementation AWBMemoryWarningViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Low Memory Warning";
    
    if (DEVICE_IS_IPAD) {
        [self setContentSizeForViewInPopover:CGSizeMake(480, 320)]; 
        self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    }
    
    if (DEVICE_IS_IPHONE) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissWarning:)];
        self.navigationItem.rightBarButtonItem = doneButton; 
        [doneButton release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);   
}

- (void)dismissWarning:(id)sender 
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}

@end
