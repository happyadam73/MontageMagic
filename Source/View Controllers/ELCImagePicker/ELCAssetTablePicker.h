//
//  AssetTablePicker.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define CELLS_PER_ROW 6

@interface ELCAssetTablePicker : UITableViewController
{
	ALAssetsGroup *assetGroup;
	
	NSMutableArray *elcAssets;
//	int selectedAssets;
	NSUInteger totalSelectedAssets;
	id parent;
	
	NSOperationQueue *queue;
    
    IBOutlet UIView *headerView;
    
    BOOL toolbarButtonSelectsAll;
    BOOL lowMemory;
}

@property (nonatomic, assign) id parent;
@property (nonatomic, assign) ALAssetsGroup *assetGroup;
@property (nonatomic, retain) NSMutableArray *elcAssets;
@property (nonatomic, retain) IBOutlet UILabel *selectedAssetsLabel;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (assign) BOOL lowMemory;
@property (assign) NSUInteger totalSelectedAssets;

//-(int)totalSelectedAssets;
- (void)preparePhotos;
- (void)assetToggled:(BOOL)selected;
- (void)doneAction:(id)sender;
- (void)selectAllAssets:(id)sender;
- (void)addSelectAllButton;
- (void)reloadTableData;

@end