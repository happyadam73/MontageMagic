//
//  AWBPeoplePickerController.h
//  Collage Maker
//
//  Created by Adam Buckley on 20/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

static NSString *const kAWBInfoKeyIncludeNumbersOnPeoplePicker = @"IncludeNumbersOnPeoplePicker";

@class AWBPeoplePickerController;

@protocol AWBPeoplePickerControllerDelegate

- (void)awbPeoplePickerController:(AWBPeoplePickerController *)picker didFinishPickingContacts:(NSArray *)contacts;
- (void)awbPeoplePickerControllerDidCancel:(AWBPeoplePickerController *)picker;

@end

@interface AWBPeoplePickerController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
    id peoplePickerDelegate;        
    NSDictionary *addressBookContactsBySection;
    NSArray *sortedAddressBookContacts;
    NSMutableArray *filteredAddressBookContacts;
    NSArray *firstInitialSections;
    UISearchDisplayController *searchDisplayController;
    ABAddressBookRef addressBook;
    BOOL thumbnailsEnabled;
    NSUInteger totalContactsSelected;
    BOOL toolbarButtonSelectsAll;
    BOOL includePhoneNumbers;
}

@property (nonatomic, assign) id peoplePickerDelegate;
@property (nonatomic, retain) NSDictionary *addressBookContactsBySection;
@property (nonatomic, retain) NSArray *sortedAddressBookContacts;
@property (nonatomic, retain) NSMutableArray *filteredAddressBookContacts;
@property (nonatomic, retain) NSArray *firstInitialSections;
@property (nonatomic, assign) BOOL thumbnailsEnabled;

- (id)initWithThumbnailsEnabled:(BOOL)thumbnails;
- (id)initWithStyle:(UITableViewStyle)style thumbnailsEnabled:(BOOL)thumbnails;
- (void)populatePeopleArray;
- (void)filterContentForSearchText:(NSString*)searchText;
- (void)finishPickerWithInfo:(id)sender;
- (void)dismissPicker:(id)sender;
- (NSArray *)selectedContacts;
- (void)clearContactsThumbnailCache;
- (UIView *)tableFooterViewWithTotalContacts:(NSUInteger)totalContacts;
- (void)updateNavBarTitle;
- (void)addToolbarButtons;
- (void)addOrExcludeNumbers:(id)sender;
- (void)selectAllContacts:(id)sender;

@end
