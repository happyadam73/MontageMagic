//
//  AlbumPickerController.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"

@implementation ELCAlbumPickerController

@synthesize parent, assetGroups, assetsLibrary;

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated    
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

	[self.navigationItem setTitle:@"Loading..."];
    if (DEVICE_IS_IPHONE) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
        [self.navigationItem setRightBarButtonItem:cancelButton];
        [cancelButton release];
    } else {
        [self setContentSizeForViewInPopover:CGSizeMake(480, 550)];
    }

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    [tempArray release];
    
    [self prepareGroups];    
}

-(void)prepareGroups 
{   
    dispatch_async(dispatch_get_main_queue(), ^
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        // Group enumerator Block
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
        {
            if (group == nil) 
            {
                if (self.navigationController) {
                    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];                
                }
                return;
            }
            
            if (!self.navigationController) {
                *stop = YES;
            } else {
                //pre-fetch poster images and asset counts
                [UIImage imageWithCGImage:[group posterImage]];
                [group numberOfAssets];
                [self.assetGroups addObject:group];
            }        
        };
        
        // Group Enumerator Failure Block
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            NSString *errorDescription;
            switch ([error code]) {
                case ALAssetsLibraryDataUnavailableError:
                    errorDescription = @"Your Photo library is unavailable.  You can sync photos onto your device using iTunes.";
                    break;
                case ALAssetsLibraryAccessUserDeniedError:
                    errorDescription = @"Photo library access requires granting Montage Magic access to Location Services.  To enable this please go to the Location Services Menu in Settings.";
                    break;
                case ALAssetsLibraryAccessGloballyDeniedError:
                    errorDescription = @"Photo library access requires Location Services to be switched on.  To enable this please go to the Location Services Menu in Settings.";
                    break;
                default:
                    errorDescription = [NSString stringWithFormat:@"An error occurred. %@", [error localizedDescription]];
                    break;
            }
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Photos" message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            NSLog(@"A problem occured %@", [error description]);
            [self.parent performSelectorOnMainThread:@selector(cancelImagePicker) withObject:nil waitUntilDone:NO];
        };	
        
        // Enumerate Albums
        [self.assetsLibrary  enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:assetGroupEnumerator 
                             failureBlock:assetGroupEnumberatorFailure];        
        [pool release];        
    });
                
}

-(void)reloadTableView 
{
	[self.tableView reloadData];
	[self.navigationItem setTitle:@"Select an Album"];
}

-(void)selectedAssets:(NSArray*)_assets 
{	
	[(ELCImagePickerController*)parent selectedAssets:_assets];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return [assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[g valueForProperty:ALAssetsGroupPropertyName]];
    NSString *photoDesc = nil;
    if (gCount == 1) {
        photoDesc = @"Photo";
    } else {
        photoDesc = @"Photos";
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@",gCount, photoDesc];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	ELCAssetTablePicker *picker = [[ELCAssetTablePicker alloc] initWithNibName:@"ELCAssetTablePicker" bundle:[NSBundle mainBundle]];
	picker.parent = self;

    // Move me    
    picker.assetGroup = [assetGroups objectAtIndex:indexPath.row];
    [picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];

	[self.navigationController pushViewController:picker animated:YES];
	[picker release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	return 57;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{	
    [assetsLibrary release];
	[assetGroups release];
    [super dealloc];
}

@end

