//
//  CollageMakerViewController+Toolbar.m
//  Collage Maker
//
//  Created by Adam Buckley on 11/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+Toolbar.h"
#import "CollageMakerViewController+Action.h"
#import "CollageMakerViewController+Photos.h"
#import "CollageMakerViewController+Text.h"
#import "CollageMakerViewController+Delete.h"
#import "CollageMakerViewController+AddressBook.h"
#import "CollageMakerViewController+UI.h"
#import "UIColor+SignColors.h"
#import "CollageMakerViewController+Edit.h"
#import "AWBTransformableArrowView.h"
#import "CollageMakerViewController+Action.h"
#import "CollageMakerViewController+Symbol.h"
#import "CollageMakerViewController.h"

@implementation CollageMakerViewController (Toolbar)

- (void)setToolbarForImporting  
{
    [self.navigationController setNavigationBarHidden:YES animated:self.isLevel1AnimationsEnabled];
    self.toolbarItems = [self importingToolbarButtons];
    self.progressView.progress = 0.0;
    [self.settingsButton setImage:nil];
    [self.settingsButton setTitle:@"Stop Importing"];    
}

- (void)resetToNormalToolbar
{
    [self.navigationController setNavigationBarHidden:NO animated:self.isLevel1AnimationsEnabled];
    self.toolbarItems = [self normalToolbarButtons];
    [self.settingsButton setImage:[UIImage imageNamed:@"settings.png"]];
    [self.settingsButton setTitle:nil];  
    
    if (displayMemoryWarningIndicator && animateMemoryWarningIndicator) {
        animateMemoryWarningIndicator = NO;
        [UIView animateWithDuration:0.35 delay:0.5 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAutoreverse) animations: ^ {
            [UIView setAnimationRepeatCount:3.0];
            [self.memoryWarningButton.customView setAlpha:0.0]; } 
                         completion: ^ (BOOL finished) {self.memoryWarningButton.customView.alpha = 1.0;}];

    }
}

- (void)setToolbarForEditMode  
{
    self.toolbarItems = [self editModeButtons];
}

- (NSArray *)normalToolbarButtons
{
    NSArray *toolbarButtons = nil;
    if (displayMemoryWarningIndicator) {
        toolbarButtons = [NSArray arrayWithObjects:self.actionButton, self.cameraButton, self.textButton, self.addressBookButton, self.luckyDipButton, self.addSymbolButton, self.toolbarSpacing, self.memoryWarningButton, self.fixedToolbarSpacing, self.settingsButton, nil];
    } else {
        toolbarButtons = [NSArray arrayWithObjects:self.actionButton, self.cameraButton, self.textButton, self.addressBookButton, self.luckyDipButton, self.addSymbolButton, self.toolbarSpacing, self.settingsButton, nil];        
    }
    return toolbarButtons;
}

- (NSArray *)importingToolbarButtons
{
    return [NSArray arrayWithObjects:self.importingLabelHolder, self.progressViewHolder, self.toolbarSpacing, self.settingsButton, nil];
}

- (NSArray *)editModeButtons
{
    return [NSArray arrayWithObjects:self.selectNoneOrAllButton, self.editTextButton, self.deleteButton, nil];    
}

- (UIProgressView *)progressView
{
    if (!progressView) {
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    }
    return progressView;
}

- (UIBarButtonItem *)progressViewHolder 
{
    if (!progressViewHolder) {
        progressViewHolder = [[UIBarButtonItem alloc] initWithCustomView:self.progressView];
    }
    return progressViewHolder;
}

- (UILabel *)importingLabel
{
    if (!importingLabel) {
        NSString *label = @"Importing:";
        UIFont *font = [UIFont systemFontOfSize:14.0];
        CGSize textSize = [label sizeWithFont:font];
        importingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, textSize.width+10, textSize.height)]; 
        [importingLabel setBackgroundColor:[UIColor clearColor]];
        [importingLabel setTextColor:[UIColor whiteColor]];
        [importingLabel setFont:font];
        [importingLabel setText:label];
    }
    return importingLabel;    
}

- (UIBarButtonItem *)importingLabelHolder
{
    if (!importingLabelHolder) {
        importingLabelHolder = [[UIBarButtonItem alloc] initWithCustomView:self.importingLabel];
    }
    return importingLabelHolder;    
}

- (UIBarButtonItem *)actionButton
{
    if (!actionButton) {
        actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(performAction:)];
        actionButton.style = UIBarButtonItemStyleBordered;
    }
    return actionButton;
}

- (UIBarButtonItem *)cameraButton
{
    if (!cameraButton) {
        cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addPhoto:)];
        cameraButton.style = UIBarButtonItemStyleBordered;
    }
    return cameraButton;    
}

- (UIBarButtonItem *)textButton
{
    if (!textButton) {
        textButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textbutton24"] style:UIBarButtonItemStyleBordered target:self action:@selector(addTextView:)];
    }
    return textButton;    
}

- (UIBarButtonItem *)luckyDipButton
{
    if (!luckyDipButton) {
        luckyDipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star"] style:UIBarButtonItemStyleBordered target:self action:@selector(performLuckyDip:)];
    }
    return luckyDipButton;    
}

- (UIBarButtonItem *)addSymbolButton
{
    if (!addSymbolButton) {
        addSymbolButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow2"] style:UIBarButtonItemStyleBordered target:self action:@selector(addSymbol:)];
    }
    return addSymbolButton;    
}

- (UIBarButtonItem *)addressBookButton
{
    if (!addressBookButton) {
        addressBookButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"person"] style:UIBarButtonItemStyleBordered target:self action:@selector(addContact:)];
    }
    return addressBookButton;    
}

- (UIBarButtonItem *)toolbarSpacing
{
    if (!toolbarSpacing) {
        toolbarSpacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return toolbarSpacing;    
}

- (UIBarButtonItem *)fixedToolbarSpacing
{
    if (!fixedToolbarSpacing) {
        fixedToolbarSpacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedToolbarSpacing.width = 20;
    }
    return fixedToolbarSpacing;
}

- (UIBarButtonItem *)settingsButton
{
    if (!settingsButton) {
        settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStyleBordered target:self action:@selector(settingsButtonAction:)];
    }
    return settingsButton;    
}

- (void)insertBarButtonItem:(UIBarButtonItem *)button atIndex:(NSUInteger)index 
{
    NSMutableArray *items = [self.toolbarItems mutableCopy];
    [items insertObject:button atIndex:index];
    self.toolbarItems = items;
    [items release];
}

- (void)removeBarButtonItem:(UIBarButtonItem *)button
{
    NSMutableArray *items = [self.toolbarItems mutableCopy];
    [items removeObject:button];
    self.toolbarItems = items;
    [items release];
}

- (UIBarButtonItem *)editButton
{
    if (!editButton) {
        editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enableEditMode:)];
        editButton.style = UIBarButtonItemStyleBordered;
    }
    return editButton;    
}

- (UIBarButtonItem *)cancelButton
{
    if (!cancelButton) {
        cancelButton = [[UIBarButtonItem alloc] initWithCustomView:[self tintedSegmentedControlButtonWithTitle:@"Cancel" color:[UIColor blueSignBackgroundColor] target:self action:@selector(resetEditMode:)]];
    }
    return cancelButton;    
}

- (UIBarButtonItem *)deleteButton
{
    if (!deleteButton) {
        deleteButton = [[UIBarButtonItem alloc] initWithCustomView:[self tintedSegmentedControlButtonWithTitle:@"Delete" color:[UIColor redSignBackgroundColor] target:self action:@selector(deleteSelectedViews:)]];
    }
    return deleteButton;    
}

- (UIBarButtonItem *)editTextButton
{
    if (!editTextButton) {
        editTextButton = [[UIBarButtonItem alloc] initWithCustomView:[self tintedSegmentedControlButtonWithTitle:@"Edit Text" color:[UIColor blueSignBackgroundColor] target:self action:@selector(editSelectedTextViews:)]];
    }
    return editTextButton;       
}

- (UIBarButtonItem *)selectNoneOrAllButton
{
    if (!selectNoneOrAllButton) {
        selectNoneOrAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStyleBordered target:self action:@selector(selectAllOrNoneInEditMode:)];
    }
    return selectNoneOrAllButton;    
}

- (UIBarButtonItem *)memoryWarningButton
{
    if (!memoryWarningButton) {
        memoryWarningButton = [[UIBarButtonItem alloc] initWithCustomView:[self memoryButtonControlWithColor:[UIColor yellowSignBackgroundColor] target:self action:@selector(showMemoryWarning:)]];
    }    
    return memoryWarningButton;          
}

- (UISegmentedControl *)memoryButtonControlWithColor:(UIColor *)color target:(id)target action:(SEL)action
{    
    UISegmentedControl *button = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10.0, 7.0, 40.0, 30.0)];
    [button setTintColor:color];
    [button addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [button setSegmentedControlStyle:UISegmentedControlStyleBar];
    [button insertSegmentWithImage:[UIImage imageNamed:@"warning"] atIndex:0 animated:NO];
    [button setMomentary:YES];  
    return [button autorelease];
}

- (UISegmentedControl *)tintedSegmentedControlButtonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action
{
    CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:12.0]].width;
    UISegmentedControl *button = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10,7,(width+30.0),30)];
    [button setTintColor:color];
    [button addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [button setSegmentedControlStyle:UISegmentedControlStyleBar];
    [button insertSegmentWithTitle:title atIndex:0 animated:NO];
    [button setMomentary:YES];  
    return [button autorelease];
}

- (void)updateTintedSegmentedControlButton:(UIBarButtonItem *)button withTitle:(NSString *)title
{
    CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:12.0]].width;
    UISegmentedControl *segmentedControl = (UISegmentedControl *)button.customView;
    [segmentedControl setTitle:title forSegmentAtIndex:0];
    CGRect newRect = segmentedControl.frame;
    newRect.size.width = width+30.0;
    segmentedControl.frame = newRect;
}

- (CGPoint)deleteButtonApproxPosition
{
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;    
    CGFloat maxLength = MAX(screenSize.width, screenSize.height);
    CGFloat minLength = MIN(screenSize.width, screenSize.height);
    CGFloat ratio = 2.0;
    if (DEVICE_IS_IPAD) {
        ratio = 4.0;
    }
    return CGPointMake(maxLength/ratio, minLength);
}

@end
