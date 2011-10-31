//
//  AWBSymbolPickerController.m
//  Collage Maker
//
//  Created by Adam Buckley on 02/10/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBSymbolPickerController.h"
#import "UIImage+Scale.h"
#import "AWBSymbolAndTextCell.h"
#import "AWBSymbolGroupCell.h"
#import "UIColor+SignColors.h"
#import "AWBSymbolGroupPickerController.h"

@implementation AWBSymbolPickerController

@synthesize symbols, arrowLineShapeType, arrowColor, arrowBackgroundColor, parent;

- (id)initWithArrowLineShape:(AWBArrowLineShapeType)lineShapeType arrowColor:(UIColor *)color
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.arrowLineShapeType = lineShapeType;
        self.arrowColor = color;
        if (([self.arrowColor isEqual:[UIColor whiteColor]]) || ([self.arrowColor isEqual:[UIColor lightGrayColor]]) || ([self.arrowColor isEqual:[UIColor yellowSignBackgroundColor]]) || ([self.arrowColor isEqual:[UIColor orangeSignBackgroundColor]])) {
            self.arrowBackgroundColor = [UIColor blackColor];
        } else {
            self.arrowBackgroundColor = [UIColor whiteColor];            
        }
        self.tableView.allowsSelection = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Select Line or Arrow";
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setContentSizeForViewInPopover:CGSizeMake(480, 550)];
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:63];
    AWBTransformableArrowView *arrow;
    CGFloat arrowLength = 57;
    
    for (AWBArrowThicknessType thickness = kAWBArrowThicknessTypeThin; thickness <= kAWBArrowThicknessTypeThick; thickness++) {
        for (AWBArrowLineStrokeType lineStroke = kAWBArrowLineStrokeTypeSolid; lineStroke <= kAWBArrowLineStrokeTypeDotted; lineStroke++) {
            
            arrow = [[AWBTransformableArrowView alloc] initWithLength:arrowLength color:arrowColor type:kAWBArrowTypeNone thickness:thickness arrowHead:kAWBArrowHeadTypeFilledTriangle arrowLineShape:arrowLineShapeType arrowLineStroke:lineStroke];
            arrow.arrowViewDelegate = self;
            [temp addObject:arrow];
            [arrow release];
            
            arrow = [[AWBTransformableArrowView alloc] initWithLength:arrowLength color:arrowColor type:kAWBArrowTypeSingleHeaded thickness:thickness arrowHead:kAWBArrowHeadTypeFilledTriangle arrowLineShape:arrowLineShapeType arrowLineStroke:lineStroke];
            arrow.arrowViewDelegate = self;
            [temp addObject:arrow];
            [arrow release];    
            
            arrow = [[AWBTransformableArrowView alloc] initWithLength:arrowLength color:arrowColor type:kAWBArrowTypeSingleHeaded thickness:thickness arrowHead:kAWBArrowHeadTypeLined arrowLineShape:arrowLineShapeType arrowLineStroke:lineStroke];
            arrow.arrowViewDelegate = self;
            [temp addObject:arrow];
            [arrow release];  
            
            arrow = [[AWBTransformableArrowView alloc] initWithLength:arrowLength color:arrowColor type:kAWBArrowTypeSingleHeaded thickness:thickness arrowHead:kAWBArrowHeadTypeFilledArrow arrowLineShape:arrowLineShapeType arrowLineStroke:lineStroke];
            arrow.arrowViewDelegate = self;
            [temp addObject:arrow];
            [arrow release];  
            
            arrow = [[AWBTransformableArrowView alloc] initWithLength:arrowLength color:arrowColor type:kAWBArrowTypeDoubleHeaded thickness:thickness arrowHead:kAWBArrowHeadTypeFilledTriangle arrowLineShape:arrowLineShapeType arrowLineStroke:lineStroke];
            arrow.arrowViewDelegate = self;
            [temp addObject:arrow];
            [arrow release];
            
            arrow = [[AWBTransformableArrowView alloc] initWithLength:arrowLength color:arrowColor type:kAWBArrowTypeDoubleHeaded thickness:thickness arrowHead:kAWBArrowHeadTypeLined arrowLineShape:arrowLineShapeType arrowLineStroke:lineStroke];
            arrow.arrowViewDelegate = self;
            [temp addObject:arrow];
            [arrow release];
            
            arrow = [[AWBTransformableArrowView alloc] initWithLength:arrowLength color:arrowColor type:kAWBArrowTypeDoubleHeaded thickness:thickness arrowHead:kAWBArrowHeadTypeFilledArrow arrowLineShape:arrowLineShapeType arrowLineStroke:lineStroke];
            arrow.arrowViewDelegate = self;
            [temp addObject:arrow];
            [arrow release];
        }
    }
    
    self.symbols = temp;
    [temp release];
}

- (void)viewDidUnload
{
    self.symbols = nil;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self.symbols count]/7);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SymbolGroupCell";
    
    AWBSymbolGroupCell *cell = (AWBSymbolGroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AWBSymbolGroupCell alloc] initWithSymbols:nil backgroundColor:self.arrowBackgroundColor reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell setSymbols:[self symbolsForIndexPath:indexPath]];
    
    return cell;
}

- (NSMutableArray *)symbolsForIndexPath:(NSIndexPath*)indexPath {
    NSUInteger rowIndex = indexPath.row;
    NSUInteger minIndex = rowIndex * 7;
    NSInteger maxIndex = minIndex + 6;
    
    NSMutableArray *symbolsForRow = [[NSMutableArray alloc] initWithCapacity:7];
    for (int index = minIndex; index <= maxIndex; index++) {
        [symbolsForRow addObject:[self.symbols objectAtIndex:index]];
    }
    return [symbolsForRow autorelease];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 68;
}

- (void)awbTransformableArrowViewClicked:(AWBTransformableArrowView *)arrowView
{
    [(AWBSymbolGroupPickerController *)self.parent finishPickingSymbol:arrowView];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    NSLog(@"AWBSymbolPickerController received memory warning!");
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc 
{	
    [arrowBackgroundColor release];
    [arrowColor release];
	[symbols release];
    [super dealloc];
}

@end
