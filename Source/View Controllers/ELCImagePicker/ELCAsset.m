//
//  Asset.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAsset.h"
#import "ELCAssetTablePicker.h"

@implementation ELCAsset

@synthesize asset;
@synthesize parent;

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(id)initWithAsset:(ALAsset*)_asset 
{	
	if ((self = [super initWithFrame:CGRectMake(0, 0, 0, 0)])) {
		self.asset = _asset;
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
		[self addSubview:assetImageView];
		[assetImageView release];
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
    }
    
	return self;	
}

-(void)toggleSelection 
{    
	overlayView.hidden = !overlayView.hidden; 
    [(ELCAssetTablePicker *)parent assetToggled:!overlayView.hidden];
}

-(BOOL)selected 
{	
	return !overlayView.hidden;
}

-(void)setSelected:(BOOL)_selected 
{
    if (overlayView.hidden == _selected) {
        [(ELCAssetTablePicker *)parent assetToggled:_selected];        
    }
	[overlayView setHidden:!_selected];
}

- (void)dealloc 
{    
    [asset release];
	[overlayView release];
    [super dealloc];
}

@end

