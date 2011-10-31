//
//  AlbumPickerController.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ELCAlbumPickerController : UITableViewController {
	
	NSMutableArray *assetGroups;
	NSOperationQueue *queue;
	id parent;
    NSUInteger currentGroupIndex;
    NSUInteger currentRun;
    
    ALAssetsLibrary *assetsLibrary;
}

@property (nonatomic, assign) id parent;
@property (nonatomic, retain) NSMutableArray *assetGroups;
@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;

-(void)selectedAssets:(NSArray*)_assets;
-(void)prepareGroups;
- (void)reloadTableView;

@end

