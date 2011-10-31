//
//  AWBSymbolGroupPickerController.m
//  Collage Maker
//
//  Created by Adam Buckley on 01/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBSymbolGroupPickerController.h"
#import "AWBSymbolPickerController.h"
#import "UIImage+Scale.h"
#import "AWBSymbolAndTextCell.h"
#import "AWBSymbolGroupCell.h"
#import "AWBTransformableArrowView.h"
#import "UIColor+SignColors.h"
#import "AWBColorPickerTableCell.h"

@implementation AWBSymbolGroupPickerController

@synthesize symbolGroupTypes, symbolPickerDelegate, arrowColor, shapeType;

#pragma mark -
#pragma mark View lifecycle

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.arrowColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Select Line Shape";
    self.shapeType = kAWBArrowLineShapeTypeNotSpecified;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.title = @"Select Line Shape";
    if (DEVICE_IS_IPHONE) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissPicker:)];
        [self.navigationItem setRightBarButtonItem:cancelButton];
        [cancelButton release];
    } else {
        [self setContentSizeForViewInPopover:CGSizeMake(480, 550)];
    }
    
	self.symbolGroupTypes = [NSArray arrayWithObjects:[NSNumber numberWithInteger:kAWBArrowLineShapeTypeStraightLine], [NSNumber numberWithInteger:kAWBArrowLineShapeTypeQuarterCircle], [NSNumber numberWithInteger:kAWBArrowLineShapeTypeHalfCircle], [NSNumber numberWithInteger:kAWBArrowLineShapeTypeBezierCurve], nil];
    
    if (self.shapeType != kAWBArrowLineShapeTypeNotSpecified) {
        NSNumber *lineShapeType = [self.symbolGroupTypes objectAtIndex:self.shapeType];
        AWBSymbolPickerController * picker = [[AWBSymbolPickerController alloc] initWithArrowLineShape:[lineShapeType integerValue] arrowColor:self.arrowColor];
        picker.parent = self;
        [self.navigationController pushViewController:picker animated:YES];
        [picker release];        
    }
}

- (void)viewDidUnload
{
    self.symbolGroupTypes = nil;
    self.arrowColor = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == 0) {
        return 1;
    } else {
        return [symbolGroupTypes count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section == 0) {
        return @"Lines & Arrow Colour";
    } else {
        return @"Lines & Arrow Shape";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    static NSString *CellIdentifier0 = @"SymbolColorCell";
    static NSString *CellIdentifier1 = @"SymbolGroupCell";
    if ([indexPath section] == 0) {
        AWBColorPickerTableCell *cell = (AWBColorPickerTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
        if (cell == nil) {
            cell = [[[AWBColorPickerTableCell alloc] initWithSelectedColor:self.arrowColor reuseIdentifier:CellIdentifier0] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[(AWBColorPickerTableCell *)cell picker] addTarget:self action:@selector(colorPickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;         
        
    } else {
        AWBSymbolAndTextCell *cell = (AWBSymbolAndTextCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[AWBSymbolAndTextCell alloc] initWithReuseIdentifier:CellIdentifier1] autorelease];
        }
        
        NSNumber *arrowShapeType = [self.symbolGroupTypes objectAtIndex:[indexPath row]];
        [cell setArrowLineShapeType:[arrowShapeType integerValue]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        return cell;        
    }
}

- (void)colorPickerValueChanged:(id)sender
{
    self.arrowColor = [(AWBColorPickerSegmentedControl *)sender selectedColor];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if ([indexPath section] == 1) {
        NSNumber *lineShapeType = [self.symbolGroupTypes objectAtIndex:[indexPath row]];
        AWBSymbolPickerController * picker = [[AWBSymbolPickerController alloc] initWithArrowLineShape:[lineShapeType integerValue] arrowColor:self.arrowColor];
        picker.parent = self;
        self.shapeType = [lineShapeType integerValue];
        [self.navigationController pushViewController:picker animated:YES];
        [picker release];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if ([indexPath section] == 0) {
        return tableView.rowHeight;
    } else {
        return 74;        
    }
}

- (void)dismissPicker:(id)sender 
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES]; 
    if([symbolPickerDelegate respondsToSelector:@selector(awbSymbolGroupPickerControllerDidCancel:)]) {
		[symbolPickerDelegate performSelector:@selector(awbSymbolGroupPickerControllerDidCancel:) withObject:self withObject:nil];
	} 
}

- (void)finishPickingSymbol:(AWBTransformableArrowView *)symbol 
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES]; 
    if([symbolPickerDelegate respondsToSelector:@selector(awbSymbolGroupPickerController:didFinishPickingSymbol:)]) {
		[symbolPickerDelegate performSelector:@selector(awbSymbolGroupPickerController:didFinishPickingSymbol:) withObject:self withObject:symbol];
	}    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    NSLog(@"AWBSymbolPickerController received memory warning!");
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc 
{	
    [arrowColor release];
	[symbolGroupTypes release];
    [super dealloc];
}

@end
