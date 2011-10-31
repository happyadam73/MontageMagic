//
//  CollageMakerViewController+AddressBook.h
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import "CollageMakerViewController.h"
#import "AWBPeoplePickerController.h"

@interface CollageMakerViewController (AddressBook) <AWBPeoplePickerControllerDelegate>

- (void)addContact:(id)sender;
- (void)initialiseAddressBookPopoverWithViewController:(UIViewController *)viewController andBarButtonItem:(UIBarButtonItem *)button;
- (void)addContactViewsWithContacts:(NSArray *)contacts;
- (void)addContactImageAndLabelView:(NSMutableDictionary *)info;
- (void)addContactViewsCompleted:(id)info;
- (BOOL)luckyDipImportCollageIsFullForContactImageOfSize:(CGSize)imageSize;
- (BOOL)luckyDipImportCollageIsFullForContactLabelBelowCurrentObject:(BOOL)belowCurrentObject;

@end
