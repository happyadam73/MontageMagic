//
//  AssetTablePicker.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePicker.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"

@implementation ELCAssetTablePicker

@synthesize parent;
@synthesize selectedAssetsLabel;
@synthesize assetGroup, elcAssets;
@synthesize lowMemory;
@synthesize totalSelectedAssets;

- (void)viewDidAppear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:NO animated:YES];
}

-(void)viewDidLoad 
{
	[self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setAllowsSelection:NO];

    [self setContentSizeForViewInPopover:CGSizeMake(480, 550)];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
    [tempArray release];
	
	UIBarButtonItem *doneButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)] autorelease];
	[self.navigationItem setRightBarButtonItem:doneButtonItem];
	[self.navigationItem setTitle:@"Loading..."];
    self.totalSelectedAssets = 0;
	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)assetToggled:(BOOL)selected
{
    if (selected) {
        self.totalSelectedAssets += 1;
    } else {
        self.totalSelectedAssets -= 1;
    }
    
    if (self.totalSelectedAssets == 0) {
        [self.navigationItem setTitle:@"Select Photos"];        
    } else if (self.totalSelectedAssets == 1) {
        [self.navigationItem setTitle:@"1 Photo Selected"];        
    } else {
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%d Photos Selected", self.totalSelectedAssets]];                
    }
}

- (void)viewWillDisappear:(BOOL)animated    
{
    self.tableView = nil;
    self.assetGroup = nil;
    self.parent = nil;
}

-(void)preparePhotos 
{    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
     {      
         if(result == nil) 
         {
             if (!self.navigationController) {
                 NSLog(@"navigationController has disappeared!");
             } else {
                 [self performSelectorOnMainThread:@selector(addSelectAllButton) withObject:nil waitUntilDone:NO];
             }
                 return;
         }
         
         if (!self.navigationController) {
             *stop = YES;
         } else {
             ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
             [elcAsset setParent:self];
             
             @synchronized(self) {
                 if (elcAsset) {
                     [self.elcAssets addObject:elcAsset];                 
                 }
             }
        
             [elcAsset release];
             if ((index % 50)==49) {
                 [self performSelectorOnMainThread:@selector(reloadTableData) withObject:nil waitUntilDone:NO];
             }
         }         
     }];    
    
    [pool release];
}

- (void)reloadTableData
{
    if (self.navigationController) {
        [self.tableView reloadData];
    }
}

-(void)addSelectAllButton
{
    [self.tableView reloadData];
	[self.navigationItem setTitle:@"Select Photos"];
    
    //add select all bar button item
    UIBarButtonItem *selectAllButton = [[UIBarButtonItem alloc] initWithTitle:(toolbarButtonSelectsAll ? @"Select None" : @"Select All") style:UIBarButtonItemStyleBordered target:self action:@selector(selectAllAssets:)];
    [self setToolbarItems:[NSArray arrayWithObject:selectAllButton]];
    [selectAllButton release];
    toolbarButtonSelectsAll = YES;
}

- (void) doneAction:(id)sender 
{
	NSMutableArray *selectedAssetsImages = [[[NSMutableArray alloc] init] autorelease];
    
    @synchronized(self) {
        for(ELCAsset *elcAsset in self.elcAssets) 
        {		
            if([elcAsset selected]) {
                if ([elcAsset asset]) {
                    [selectedAssetsImages addObject:[elcAsset asset]];
                }
            }
        }        
    }
        
    [(ELCAlbumPickerController*)self.parent selectedAssets:selectedAssetsImages];
}

#pragma mark UITableViewDataSource Delegate Methods

-(void)selectAllAssets:(id)sender
{
    NSString *title = (toolbarButtonSelectsAll ? @"Select None" : @"Select All");
    [(UIBarButtonItem *)sender setTitle:title];
    for (ELCAsset *asset in self.elcAssets) {
        [asset setSelected:toolbarButtonSelectsAll];
    }
    toolbarButtonSelectsAll = !toolbarButtonSelectsAll;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return ((([self.assetGroup numberOfAssets]-1)/CELLS_PER_ROW)+1);
}

- (NSMutableArray *)assetsForIndexPath:(NSIndexPath*)_indexPath 
{    
    NSUInteger rowIndex = _indexPath.row;
    NSUInteger assetCount = [self.elcAssets count];
    NSUInteger minIndex = rowIndex * CELLS_PER_ROW;
    NSInteger maxIndex = -1;
    
    if (((rowIndex + 1) * CELLS_PER_ROW) <= assetCount) {
        maxIndex = minIndex + (CELLS_PER_ROW - 1);
    } else {
        if ((rowIndex * CELLS_PER_ROW) < assetCount) {
            maxIndex = (assetCount - 1);
        }
    }
    
    if (maxIndex >= 0) {
        NSMutableArray *assets = [[NSMutableArray alloc] initWithCapacity:CELLS_PER_ROW];
        for (int index = minIndex; index <= maxIndex; index++) {
            [assets addObject:[self.elcAssets objectAtIndex:index]];
        }
        return [assets autorelease];
    } else {
        return nil;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";   
    
    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) 
    {		        
        cell = [[[ELCAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier] autorelease];
    }	
	else 
    {		
        if (!self.lowMemory) {
            [cell setAssets:[self assetsForIndexPath:indexPath]];
        }
	}
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	return 79;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"ELCAssetTablePicker received memory warning!");
    self.lowMemory = YES;
    self.navigationItem.title = @"Not Enough Memory";
}

- (void)dealloc 
{
    [elcAssets release];
    [selectedAssetsLabel release];
    [super dealloc];    
}

@end
