//
//  CollageMakerViewController+LuckyDip.m
//  Collage Maker
//
//  Created by Adam Buckley on 23/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+LuckyDip.h"
#import "CollageMakerViewController+UI.h"
#import "CollageMakerViewController+Edit.h"
#import "AWBTransforms.h"
#import "CollageMakerViewController+Toolbar.h"
#import "AWBPersonContact.h"
#import "NSMutableArray+Shuffle.h"
#import "CollageDescriptor.h"

@implementation CollageMakerViewController (LuckyDip)

- (void)performLuckyDip:(id)sender
{
    if (!self.isImporting) {
        [self resetEditMode:sender];
        
        if (DEVICE_IS_IPAD) {
            BOOL wasPopoverVisible = [self.luckyDipPopover isPopoverVisible];
            [self dismissAllActionSheetsAndPopovers];
            if (wasPopoverVisible) {
                return;
            }
        }

        [sender setEnabled:NO];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.assetGroups = tempArray;
        [tempArray release];
        
        //add the All Photos group (use NSNULL)
        [self.assetGroups addObject:[NSNull null]];
        
        totalAssets = 0;
        
        dismissAssetsLibrary = YES;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        self.assetsLibrary = library;
        [library release];
        
        dispatch_async(dispatch_get_main_queue(), ^
           {
               NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

               // Group enumerator Block
               void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
               {
                   if (group == nil) 
                   {
                       [sender setEnabled:YES];
                       if (totalAssets == 0) {
                           //no groups added so remove the all photos group
                           self.assetGroups = nil;
                       }
                       [self performSelectorOnMainThread:@selector(presentLuckyDipController) withObject:nil waitUntilDone:YES];
                       return;
                   }
                   
                   //pre-fetch poster images and asset counts
                   totalAssets += [group numberOfAssets];
                   [self.assetGroups addObject:group];
               };
               
               // Group Enumerator Failure Block
               void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                   [self assetGroupEnumerationFailedWithError:error];
                   [sender setEnabled:YES];
               };	
               
               // Enumerate Albums  
               if (self.assetsLibrary) {
                   [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                                     usingBlock:assetGroupEnumerator 
                                                   failureBlock:assetGroupEnumberatorFailure];
                   
               } else {
                   [sender setEnabled:YES];
               }
               
               [pool release];
           });        
    }
}

- (void)assetGroupEnumerationFailedWithError:(NSError *)error
{
    if (self.busyView) {
        [self.busyView removeFromParentView];
        self.busyView = nil;        
    }
    
    NSString *errorDescription;
    switch ([error code]) {
        case ALAssetsLibraryDataUnavailableError:
            errorDescription = @"Access to your Photo Library is unavailable.  Use iTunes to syncronise photos to your device.";
            break;
        case ALAssetsLibraryAccessUserDeniedError:
            errorDescription = @"Photo Library access requires granting Montage Magic access to Location Services.  To enable this please go to the Location Services Menu in Settings.";
            break;
        case ALAssetsLibraryAccessGloballyDeniedError:
            errorDescription = @"Photo Library access requires Location Services to be switched on.  To enable this please go to the Location Services Menu in Settings.";
            break;
        default:
            errorDescription = [NSString stringWithFormat:@"An error occurred. %@", [error localizedDescription]];
            break;
    }
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Photos Unavailable" message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    self.assetsLibrary = nil;
    NSLog(@"A problem occured %@", [error description]);	    
}

- (void)initialiseLuckyDipPopoverWithViewController:(UIViewController *)viewController andBarButtonItem:(UIBarButtonItem *)button    
{
    if (DEVICE_IS_IPAD) {
        
        BOOL wasPopoverVisible = [self.luckyDipPopover isPopoverVisible];
        [self dismissAllActionSheetsAndPopovers];
        if (wasPopoverVisible) {
            return;
        }
        
        UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:viewController];
        self.luckyDipPopover = popOver;
        [popOver release];
        self.luckyDipPopover.delegate = self;
        [self.luckyDipPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];        
    } else {
        [self presentModalViewController:viewController animated:self.isLevel1AnimationsEnabled];       
    }
}

- (void)presentLuckyDipController
{
    if ([self.assetGroups count] > 0) {
        self.selectedAssetsGroup = [self assetsGroupFromAssetsGroups:self.assetGroups withName:self.selectedAssetsGroupName];
        if (!self.selectedAssetsGroup) {
            self.selectedAssetsGroup = [self.assetGroups objectAtIndex:0];        
        }
    }
    NSMutableDictionary *settingsInfo = [self settingsInfo]; 
    self.assetGroups = nil;
    AWBCollageSettingsTableViewController *settingsController = [[AWBCollageSettingsTableViewController alloc] initWithSettings:[AWBSettings luckyDipSettingsWithInfo:settingsInfo] settingsInfo:settingsInfo rootController:nil]; 
    settingsController.delegate = self;
    settingsController.controllerType = AWBSettingsControllerTypeLuckyDipSettings;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    [self initialiseLuckyDipPopoverWithViewController:navController andBarButtonItem:self.luckyDipButton];
    
    [settingsController release];   
    [navController release];    
}

- (void)luckyDipTableViewController:(AWBCollageSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info
{
    dismissAssetsLibrary = NO;
    [self dismissToolbarAndPopover:self.luckyDipPopover];
    self.luckyDipPopover = nil;

    if (self.busyView) {
        [self.busyView removeFromParentView];
        self.busyView = nil;        
    }

    self.selectedAssetsGroup = [info objectForKey:kAWBInfoKeySelectedAssetGroup];
    if (self.selectedAssetsGroup) {
        if ([self.selectedAssetsGroup isEqual:[NSNull null]]) {
            self.selectedAssetsGroupName = kAWBAllPhotosGroupPersistentID;
        } else {
            [self.selectedAssetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
            self.selectedAssetsGroupName = [self.selectedAssetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];                    
        }
    }
    self.luckyDipSourceIndex = [[info objectForKey:kAWBInfoKeyLuckyDipSourceSelectedIndex] intValue];
    self.luckyDipAmountIndex = [[info objectForKey:kAWBInfoKeyLuckyDipAmountSelectedIndex] intValue];
    self.luckyDipContactTypeIndex = [[info objectForKey:kAWBInfoKeyLuckyDipContactTypeSelectedIndex] intValue];
    self.luckyDipContactIncludePhoneNumber = [[info objectForKey:kAWBInfoKeyLuckyDipContactIncludePhoneNumber] boolValue];
    
    if (self.luckyDipSourceIndex == kAWBLuckyDipSourceIndexPhotos) {
        [self luckyDipAddPhotos];
    } else {
        self.assetsLibrary = nil;
        self.selectedAssetsGroup = nil;
        [self luckyDipAddContacts];
    }
}

- (void)luckyDipAddPhotos
{    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (self.selectedAssetsGroup) {
        if ([self.selectedAssetsGroup isEqual:[NSNull null]]) {
            [self addPhotosFromWholeLibrary];
        } else {
            NSUInteger assetGroupCount = [self.selectedAssetsGroup numberOfAssets];
            if (assetGroupCount > 0) {
                [self setToolbarForImporting];
                [self setIsImporting:YES];            
                NSUInteger requestedAmount = [self luckyDipAmountFromIndex:self.luckyDipAmountIndex];
                NSIndexSet *randomIndices = [self randomUniqueNumbersFromLow:0 toHigh:(assetGroupCount-1) totalRequired:requestedAmount];
                
                NSMutableArray *randomAssets = [[[NSMutableArray alloc] initWithCapacity:[randomIndices count]] autorelease];
                [self.selectedAssetsGroup enumerateAssetsAtIndexes:randomIndices options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
                 {      
                     if(result == nil) {
                         [randomAssets randomShuffle];
                         luckyDipInProgress = YES;
                         [self performSelectorInBackground:@selector(addPhotosWithInfo:) withObject:randomAssets];
                         return;
                     } else {
                         [randomAssets addObject:result];
                     }
                 }];
            }            
        }
    }
    [pool drain];
}

- (void)addPhotosFromWholeLibrary
{
    if (totalAssets > 0 && self.assetsLibrary) {
        [self setToolbarForImporting];
        [self setIsImporting:YES];            
        luckyDipInProgress = YES;
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

        NSUInteger requestedAmount = [self luckyDipAmountFromIndex:self.luckyDipAmountIndex];
        NSIndexSet *randomIndices = [self randomUniqueNumbersFromLow:0 toHigh:(totalAssets-1) totalRequired:requestedAmount];
        NSMutableArray *randomAssets = [[[NSMutableArray alloc] initWithCapacity:[randomIndices count]] autorelease];
        __block NSUInteger currentAssetIndex = 0;
        
        void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result != NULL) {
                if ([randomIndices containsIndex:currentAssetIndex]) {
                    [randomAssets addObject:result];
                }
                currentAssetIndex += 1;
            }
        };
        
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            if(group != nil) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                [group enumerateAssetsUsingBlock:assetEnumerator];
                [pool drain];
            } else {
                [randomAssets randomShuffle];
                [self performSelectorInBackground:@selector(addPhotosWithInfo:) withObject:randomAssets];
                return;
            }
        };
        
        // Group Enumerator Failure Block
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            [self assetGroupEnumerationFailedWithError:error];
        };	
        
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:assetGroupEnumerator
                             failureBlock:assetGroupEnumberatorFailure];  
        [pool release];
    }
}

- (void)luckyDipAddContacts
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    if (addressBook != NULL) {
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        if (people != NULL) {
            NSUInteger totalPeopleCount = CFArrayGetCount(people);
            
            if (totalPeopleCount > 0) {
                NSUInteger requestedAmount = [self luckyDipAmountFromIndex:self.luckyDipAmountIndex];
                NSMutableArray *peopleArray1 = [[NSMutableArray alloc] initWithCapacity:requestedAmount];
                NSMutableArray *peopleArray2 = [[NSMutableArray alloc] initWithCapacity:requestedAmount];
                
                //first determine two index sets - one for contacts with names and one for contacts with photos
                NSMutableArray *photoContactIndices = [[NSMutableArray alloc] initWithCapacity:totalPeopleCount];
                NSMutableArray *nameContactIndices = [[NSMutableArray alloc] initWithCapacity:totalPeopleCount];
                for (NSUInteger index = 0; index < totalPeopleCount; index++) {
                    ABRecordRef person = CFArrayGetValueAtIndex(people, index);
                    AWBPersonContact *contact = [[AWBPersonContact alloc] initWithABRecordRef:person];
                    if ([contact hasImageDataWithAddressBookRef:addressBook]) {
                        [photoContactIndices addObject:[NSNumber numberWithInteger:index]];
                    }
                    if (contact.hasNameData) {
                        [nameContactIndices addObject:[NSNumber numberWithInteger:index]];
                    }
                    [contact release];                    
                }
                
                if (self.luckyDipContactTypeIndex != kAWBLuckyDipContactTypeIndexTextOnly) {
                    //optional stage 1 - require just photos so try to fulfil as many as possible
                    //generate initial random sequence count for photo contacts (if any)
                    NSUInteger totalContactsWithPhotos = [photoContactIndices count];
                    if (totalContactsWithPhotos > 0) {
                        NSIndexSet *randomIndices = [self randomUniqueNumbersFromLow:0 toHigh:(totalContactsWithPhotos-1) totalRequired:requestedAmount];
                        [randomIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                            NSUInteger contactIndex = [[photoContactIndices objectAtIndex:idx] integerValue];
                            ABRecordRef person = CFArrayGetValueAtIndex(people, contactIndex);
                            AWBPersonContact *contact = [[AWBPersonContact alloc] initWithABRecordRef:person];
                            if (self.luckyDipContactTypeIndex == kAWBLuckyDipContactTypeIndexPhotoOnly) {
                                contact.hideName = YES;
                                contact.hideNumber = YES;
                            } else {
                                contact.hideNumber = (self.luckyDipContactIncludePhoneNumber == NO);
                            }
                            
                            [peopleArray1 addObject:contact];
                            [contact release];
                            [nameContactIndices removeObject:[NSNumber numberWithInteger:contactIndex]];
                        }];
                        requestedAmount -= [peopleArray1 count];
                        [peopleArray1 randomShuffle];
                    }
                }
                
                //stage 2 - go through all name contacts for any remaining amount (this will be the only stage for text only)
                NSUInteger totalContactsRemainingWithNames = [nameContactIndices count];
                if ((requestedAmount > 0) && (totalContactsRemainingWithNames > 0)) {
                    NSIndexSet *randomIndices = [self randomUniqueNumbersFromLow:0 toHigh:(totalContactsRemainingWithNames-1) totalRequired:requestedAmount];
                    [randomIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                        NSUInteger contactIndex = [[nameContactIndices objectAtIndex:idx] integerValue];
                        ABRecordRef person = CFArrayGetValueAtIndex(people, contactIndex);
                        AWBPersonContact *contact = [[AWBPersonContact alloc] initWithABRecordRef:person];
                        contact.hideImage = YES;
                        contact.hideNumber = (self.luckyDipContactIncludePhoneNumber == NO);
                        [peopleArray2 addObject:contact];
                        [contact release];
                    }];
                }
                
                if ([peopleArray2 count] > 0) {
                    [peopleArray2 randomShuffle];
                    [peopleArray1 addObjectsFromArray:peopleArray2];
                }
                
                [photoContactIndices release];
                [nameContactIndices release];
                if ([peopleArray1 count]>0) {
                    [self setToolbarForImporting];
                    [self setIsImporting:YES];
                    luckyDipInProgress = YES;
                    [self performSelectorInBackground:@selector(addContactViewsWithContacts:) withObject:peopleArray1];
                }
                [peopleArray1 release];                
                [peopleArray2 release];                
            }
            CFRelease(people);
        }
        CFRelease(addressBook);
    }
    [pool drain];
}

- (NSUInteger)luckyDipAmountFromIndex:(NSInteger)amountIndex
{
    NSUInteger amount = 0;
    
    switch (amountIndex) {
        case kAWBLuckyDipAmountIndex5Or6Objects:
            amount = (DEVICE_IS_IPHONE? 5 : 6);
            break;
        case kAWBLuckyDipAmountIndex10Or12Objects:
            amount = (DEVICE_IS_IPHONE? 10 : 12);
            break;
        case kAWBLuckyDipAmountIndex15Or18Objects:
            amount = (DEVICE_IS_IPHONE? 15 : 18);
            break;
        case kAWBLuckyDipAmountIndex20Or24Objects:
            amount = (DEVICE_IS_IPHONE? 20 : 24);
            break;
        case kAWBLuckyDipAmountIndexAutoFill:
            switch (self.collageObjectLocator.objectLocatorType) {
                case kAWBCollageObjectLocatorTypeScatter:
                    amount = (DEVICE_IS_IPHONE? 15 : 24);
                    break;
                case kAWBCollageObjectLocatorTypeMosaicLargeImages:
                    amount = (DEVICE_IS_IPHONE? 25 : 50);
                    break;
                case kAWBCollageObjectLocatorTypeMosaicMediumImages:
                    amount = (DEVICE_IS_IPHONE? 50 : 60);
                    break;
                case kAWBCollageObjectLocatorTypeMosaicSmallImages:
                    amount = (DEVICE_IS_IPHONE? 75 : 80);
                    break;
                case kAWBCollageObjectLocatorTypeMosaicTinyImages:
                    amount = (DEVICE_IS_IPHONE? 90 : 100);
                    break;
                case kAWBCollageObjectLocatorTypeMosaicMicroImages:
                    amount = (DEVICE_IS_IPHONE? 90 : 200);
                    break;
                case kAWBCollageObjectLocatorTypeMosaicNanoImages:
                    amount = (DEVICE_IS_IPHONE? 90 : 400);
                default:
                    break;
            }
            break;
        default:
            amount = (DEVICE_IS_IPHONE? 5 : 6);
            break;
    }
    return amount;
}

- (NSIndexSet *)randomUniqueNumbersFromLow:(NSUInteger)low toHigh:(NSUInteger)high totalRequired:(NSUInteger)count
{
    NSUInteger sourceCount = (high - low)+1;
    NSMutableArray *sourcePositions = [[NSMutableArray alloc] initWithCapacity:sourceCount];
    
    for (NSUInteger index=low; index <= high; index++) {
        [sourcePositions addObject:[NSNumber numberWithInteger:index]];
    }
    
    NSUInteger randomUniqueCount = count;
    if (randomUniqueCount > sourceCount) {
        randomUniqueCount = sourceCount;
    }
    
    NSMutableIndexSet *randomUniqueNumbers = [[NSMutableIndexSet alloc] init];
    
    for (NSUInteger index=0; index < randomUniqueCount; index++) {
        NSUInteger randomIndex = AWBRandomIntInRange(index, sourceCount-1);
        NSUInteger randomValue = [[sourcePositions objectAtIndex:randomIndex] integerValue];
        [sourcePositions replaceObjectAtIndex:randomIndex withObject:[sourcePositions objectAtIndex:index]];
        [randomUniqueNumbers addIndex:randomValue];
    }
    [sourcePositions release];
    return [randomUniqueNumbers autorelease];
}

- (ALAssetsGroup *)assetsGroupFromAssetsGroups:(NSArray *)assetsGroups withName:(NSString *)groupName
{
    ALAssetsGroup *selectedGroup = nil;
    if (groupName && assetsGroups) {
        for (ALAssetsGroup *group in assetsGroups) {
            if ([group isEqual:[NSNull null]]) {
                if ([groupName isEqualToString:kAWBAllPhotosGroupPersistentID]) {
                    selectedGroup = group;
                    break;
                }
            } else {
                NSString *name = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
                if ([name isEqualToString:groupName]) {
                    selectedGroup = group;
                    break;
                }                
            }
        }        
    }
    return selectedGroup;
}

- (void)autoStartWithLuckyDip
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    totalAssets = 0;
    
    //choose either photos or contacts
    NSUInteger sourceIndex = [self bestLuckyDipSourceForCollageTheme:self.collageDescriptor.themeType];
    if (sourceIndex == 2) {
        sourceIndex = 0;
    }
    
    if (sourceIndex == kAWBLuckyDipSourceIndexContacts) {
        [self autoStartLuckyDipWithSourceIndex:[NSNumber numberWithInteger:kAWBLuckyDipSourceIndexContacts]];
    } else {
        dismissAssetsLibrary = YES;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        self.assetsLibrary = library;
        [library release];
        
        void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result != NULL) {
                totalAssets += 1;
            }
        };
        
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            if(group != nil) {
                [group enumerateAssetsUsingBlock:assetEnumerator];
            } else {
                [self performSelectorOnMainThread:@selector(autoStartLuckyDipWithSourceIndex:) withObject:[NSNumber numberWithInteger:kAWBLuckyDipSourceIndexPhotos] waitUntilDone:YES];
                return;
            }
        };
        
        // Group Enumerator Failure Block
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            [self assetGroupEnumerationFailedWithError:error];
        };	
        
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:assetGroupEnumerator
                             failureBlock:assetGroupEnumberatorFailure];  
    }
    
    [pool drain];
}

- (void)autoStartLuckyDipWithSourceIndex:(NSNumber *)index
{
    id allPhotosAssetsGroup = [NSNull null];
    NSNumber *sourceIndex = index;
    NSNumber *amountIndex = [NSNumber numberWithInt:[self bestAmountIndexForDevice]];
    
    NSUInteger randomNumber = AWBRandomIntInRange(0, 9);
    NSUInteger contactType = kAWBLuckyDipContactTypeIndexTextAndPhoto;
    if (randomNumber >= 9) {
        contactType = kAWBLuckyDipContactTypeIndexTextOnly;
    } else if (randomNumber >= 7) {
        contactType = kAWBLuckyDipContactTypeIndexPhotoOnly;
    }
    NSNumber *contactTypeIndex = [NSNumber numberWithInt:contactType];
    NSNumber *includePhoneNumber = [NSNumber numberWithBool:(AWBRandomIntInRange(0, 1)==1)];
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:allPhotosAssetsGroup, kAWBInfoKeySelectedAssetGroup, sourceIndex, kAWBInfoKeyLuckyDipSourceSelectedIndex, amountIndex, kAWBInfoKeyLuckyDipAmountSelectedIndex, contactTypeIndex, kAWBInfoKeyLuckyDipContactTypeSelectedIndex, includePhoneNumber, kAWBInfoKeyLuckyDipContactIncludePhoneNumber, nil];
    
    [self luckyDipTableViewController:nil didFinishSettingsWithInfo:info];
}

- (NSUInteger)bestLuckyDipSourceForCollageTheme:(CollageThemeType)themeType
{
    //pick a number from 0 .. 9
    NSUInteger randomNumber = AWBRandomIntInRange(0, 9);
    
    NSUInteger sourceIndex = 0;
    
    switch (themeType) {
        case kAWBCollageThemeTypePlain:
            sourceIndex = (randomNumber >= 2 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeBlueAndGreenSign:
            sourceIndex = (randomNumber >= 3 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeBlueContrastItalic:
            sourceIndex = (randomNumber >= 8 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeChalkboard:
            sourceIndex = (randomNumber >= 3 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeElegant:
            sourceIndex = (randomNumber >= 3 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeGreenAndRedSign:
            sourceIndex = (randomNumber >= 4 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeYellowSign:
            sourceIndex = (randomNumber >= 4 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeHoliday:
            sourceIndex = (randomNumber >= 1 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeHolidayPhone:
            sourceIndex = (randomNumber >= 1 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeCardboard:
            sourceIndex = (randomNumber >= 3 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypePhotoModernBlack:
            sourceIndex = (randomNumber >= 2 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypePhotoModernWhite:
            sourceIndex = (randomNumber >= 2 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeRedAndBlackSign:
            sourceIndex = (randomNumber >= 4 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeHandwritten:
            sourceIndex = (randomNumber >= 3 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeBlackboard:
            sourceIndex = (randomNumber >= 3 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeTypewriter:
            sourceIndex = (randomNumber >= 3 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
        case kAWBCollageThemeTypeNoticeBoard:
            sourceIndex = kAWBLuckyDipSourceIndexContacts;
            break;
        case kAWBCollageThemeTypePhotoMosaicSmallImagesBlack:
            sourceIndex = kAWBLuckyDipSourceIndexPhotos;
            break;
        case kAWBCollageThemeTypePhotoMosaicSmallImagesWhite:
            sourceIndex = kAWBLuckyDipSourceIndexPhotos;
            break;
        case kAWBCollageThemeTypePhotoMosaicLargeImagesBlack:
            sourceIndex = kAWBLuckyDipSourceIndexPhotos;
            break;
        case kAWBCollageThemeTypePhotoMosaicLargeImagesWhite:
            sourceIndex = kAWBLuckyDipSourceIndexPhotos;
            break;
        case kAWBCollageThemeTypePhotoMosaicMicroImagesBlack:
            sourceIndex = kAWBLuckyDipSourceIndexPhotos;
            break;
        default:
            sourceIndex = (randomNumber >= 2 ? kAWBLuckyDipSourceIndexPhotos : kAWBLuckyDipSourceIndexContacts);
            break;
    }  
    
    return sourceIndex;
}

- (NSUInteger)bestAmountIndexForDevice
{
    return kAWBLuckyDipAmountIndexAutoFill;
}

@end
