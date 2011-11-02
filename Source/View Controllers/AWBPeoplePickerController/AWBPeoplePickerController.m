//
//  AWBPeoplePickerController.m
//  Collage Maker
//
//  Created by Adam Buckley on 20/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBPeoplePickerController.h"
#import "AWBPersonContact.h"

@implementation AWBPeoplePickerController

@synthesize addressBookContactsBySection, sortedAddressBookContacts, filteredAddressBookContacts, firstInitialSections, peoplePickerDelegate, thumbnailsEnabled;

- (id)init
{
    return [self initWithStyle:UITableViewStylePlain thumbnailsEnabled:YES];
}

- (id)initWithThumbnailsEnabled:(BOOL)thumbnails
{
    return [self initWithStyle:UITableViewStylePlain thumbnailsEnabled:thumbnails];
}

- (id)initWithStyle:(UITableViewStyle)style thumbnailsEnabled:(BOOL)thumbnails
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        thumbnailsEnabled = thumbnails;
        totalContactsSelected = 0;
        includePhoneNumbers = [[NSUserDefaults standardUserDefaults] boolForKey:kAWBInfoKeyIncludeNumbersOnPeoplePicker];
        toolbarButtonSelectsAll = YES;
    }
    return self;
}

- (void)dealloc
{
    if (addressBook != NULL) {
        CFRelease(addressBook);
        addressBook = NULL;
    }
    [sortedAddressBookContacts release];
    [addressBookContactsBySection release];
    [filteredAddressBookContacts release];
    [firstInitialSections release];
    [searchDisplayController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    if (self.thumbnailsEnabled) {
        self.thumbnailsEnabled = NO;
        [self clearContactsThumbnailCache];
        [self.tableView reloadData];
    }
}

- (void)populatePeopleArray
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (addressBook != NULL) {
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        if (people != NULL) {
            NSMutableArray *peopleArray = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
            
            totalContactsSelected = 0;
            for (NSUInteger index = 0; index < CFArrayGetCount(people); index++) {
                ABRecordRef person = CFArrayGetValueAtIndex(people, index);
                if (person != NULL) {
                    AWBPersonContact *contact = [[AWBPersonContact alloc] initWithABRecordRef:person];                    
                    if (contact) {
                        [peopleArray addObject:contact];                    
                    }
                    [contact release];
                }
            }
            
            CFRelease(people);
            
            NSArray *sortedPeopleArray = [peopleArray sortedArrayUsingDescriptors:[AWBPersonContact contactSortDescriptors]];
            [peopleArray release];
            [self setSortedAddressBookContacts:sortedPeopleArray];
            
            self.filteredAddressBookContacts = [NSMutableArray arrayWithCapacity:[self.sortedAddressBookContacts count]];
            
            NSMutableArray *firstCharacters = [[NSMutableArray alloc] initWithCapacity:30];
            NSMutableDictionary *contactsBySection = [[NSMutableDictionary alloc] initWithCapacity:30];
            
            for (AWBPersonContact *contact in sortedPeopleArray) {
                NSString *firstCharacter = [contact firstCharacter];
                if (![firstCharacters containsObject:firstCharacter]) {
                    if (firstCharacter) {
                        [firstCharacters addObject:firstCharacter];
                    }
                }
                
                NSMutableArray *sectionContacts = [contactsBySection objectForKey:firstCharacter];
                if (!sectionContacts) {
                    sectionContacts = [[[NSMutableArray alloc] init] autorelease];
                    if (sectionContacts && firstCharacter) {
                        [contactsBySection setObject:sectionContacts forKey:firstCharacter];
                    }
                }
                if (contact) {
                    [sectionContacts addObject:contact];                    
                }
            }
            
            NSMutableArray *sortedSections = [NSMutableArray arrayWithArray:[firstCharacters sortedArrayUsingSelector:@selector(localizedCompare:)]];
            NSUInteger findHashSection = [sortedSections indexOfObject:@"#"];
            if (findHashSection != NSNotFound) {
                [sortedSections removeObjectAtIndex:findHashSection];
                [sortedSections addObject:@"#"];
            }
            
            [self setFirstInitialSections:sortedSections];
            [self setAddressBookContactsBySection:contactsBySection];
            [firstCharacters release];
            [contactsBySection release];              
        }
    }

    [pool drain];
}

- (void)clearContactsThumbnailCache
{
    for (AWBPersonContact *contact in sortedAddressBookContacts) {
        contact.thumbnail = nil;
    }
    if (addressBook != NULL) {
        CFRelease(addressBook);
        addressBook = NULL;
    }    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishPickerWithInfo:)];
    self.navigationItem.rightBarButtonItem = doneButton; 
    [doneButton release];
    
    if (DEVICE_IS_IPHONE) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissPicker:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        [cancelButton release];
    } else {
        [self setContentSizeForViewInPopover:CGSizeMake(480, 550)];
    }
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self updateNavBarTitle];

    if (addressBook == NULL) {
        addressBook = ABAddressBookCreate();
    }

    [self populatePeopleArray];
}

- (void)viewDidUnload
{
    [searchDisplayController release];
    searchDisplayController = nil;
    self.addressBookContactsBySection = nil;
    self.sortedAddressBookContacts = nil;
    self.filteredAddressBookContacts = nil;
    self.firstInitialSections = nil;
    self.thumbnailsEnabled = NO;
    [self clearContactsThumbnailCache];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.sortedAddressBookContacts count]>0) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];  
        [searchBar sizeToFit];
        searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];  
        [searchBar release]; 
        self.tableView.tableHeaderView = [searchDisplayController searchBar]; 
        self.tableView.tableFooterView = [self tableFooterViewWithTotalContacts:[self.sortedAddressBookContacts count]];
        [searchDisplayController setDelegate:self];  
        [searchDisplayController setSearchResultsDataSource:self];  
        [searchDisplayController setSearchResultsDelegate:self];        
    }
    
    [self.tableView reloadData];
    [self addToolbarButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)addToolbarButtons
{
    //add select all bar button item
    UIBarButtonItem *selectAllButton = [[UIBarButtonItem alloc] initWithTitle:(toolbarButtonSelectsAll ? @"Select All" : @"Select None") style:UIBarButtonItemStyleBordered target:self action:@selector(selectAllContacts:)];
    UIBarButtonItem *includeNumbersButton = [[UIBarButtonItem alloc] initWithTitle:(includePhoneNumbers ? @"Numbers Off" : @"Numbers On") style:UIBarButtonItemStyleBordered target:self action:@selector(addOrExcludeNumbers:)];    
    [self setToolbarItems:[NSArray arrayWithObjects:selectAllButton, includeNumbersButton, nil]];
    [selectAllButton release];
    [includeNumbersButton release];
}

- (void)addOrExcludeNumbers:(id)sender
{
    includePhoneNumbers = !includePhoneNumbers;
    [[NSUserDefaults standardUserDefaults] setBool:includePhoneNumbers forKey:kAWBInfoKeyIncludeNumbersOnPeoplePicker];
    NSString *title = (includePhoneNumbers ? @"Numbers Off" : @"Numbers On");
    [(UIBarButtonItem *)sender setTitle:title];
    if (searchDisplayController.active) {
        [searchDisplayController.searchResultsTableView reloadData];
    } else {
        [self.tableView reloadData];
    }
}

-(void)selectAllContacts:(id)sender
{
    NSString *title = (toolbarButtonSelectsAll ? @"Select None" : @"Select All");
    [(UIBarButtonItem *)sender setTitle:title];
    totalContactsSelected = 0;
    if (searchDisplayController.active) {
        for (AWBPersonContact *contact in filteredAddressBookContacts) {
            contact.selected = toolbarButtonSelectsAll;

        }        
        if (toolbarButtonSelectsAll) {
            totalContactsSelected = [filteredAddressBookContacts count];
        }
        [searchDisplayController.searchResultsTableView reloadData];
    } else {
        for (AWBPersonContact *contact in sortedAddressBookContacts) {
            contact.selected = toolbarButtonSelectsAll;
        }  
        if (toolbarButtonSelectsAll) {
            totalContactsSelected = [sortedAddressBookContacts count];
        }
        [self.tableView reloadData];
    }
    toolbarButtonSelectsAll = !toolbarButtonSelectsAll;
    [self updateNavBarTitle];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == searchDisplayController.searchResultsTableView || ([self.sortedAddressBookContacts count] == 0)) {
        return 1;
    } else {
        return [firstInitialSections count];        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == searchDisplayController.searchResultsTableView) {
        return [filteredAddressBookContacts count];
    } else {
        if ([self.sortedAddressBookContacts count] == 0) {
            return 0;
        } else {
            NSString *firstCharacter = [firstInitialSections objectAtIndex:section];
            NSMutableArray *contactsForSection = [addressBookContactsBySection objectForKey:firstCharacter];
            return [contactsForSection count];            
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (tableView == searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        if ([self.sortedAddressBookContacts count] == 0) {
            return @"No Address Book Entries";
        } else {
            return [firstInitialSections objectAtIndex:section];        
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
        
    AWBPersonContact *contact = nil;
    if (tableView == searchDisplayController.searchResultsTableView) {
        contact = [filteredAddressBookContacts objectAtIndex:[indexPath row]];
    } else {
        NSString *firstCharacter = [firstInitialSections objectAtIndex:[indexPath section]];
        NSMutableArray *contactsForSection = [addressBookContactsBySection objectForKey:firstCharacter];
        contact = [contactsForSection objectAtIndex:[indexPath row]];
    }
    
    cell.textLabel.text = contact.displayName;
    if (includePhoneNumbers) {
        cell.detailTextLabel.text = contact.phoneNumberForAddressBook;        
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    if (thumbnailsEnabled) {
        if (addressBook != NULL) {
            cell.imageView.image = [contact thumbnailImageWithAddressBookRef:addressBook];                    
        } else {
            cell.imageView.image = [contact thumbnailImage];                                
        }
    } else {
        cell.imageView.image = nil;
    }
        
    if (contact.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == searchDisplayController.searchResultsTableView || ([self.sortedAddressBookContacts count] == 0)) {
        return nil;
    } else {
        return [NSArray arrayWithObjects:UITableViewIndexSearch, @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AWBPersonContact *contact = nil;
    if (tableView == searchDisplayController.searchResultsTableView) {
        contact = [filteredAddressBookContacts objectAtIndex:[indexPath row]];
    } else {
        NSString *firstCharacter = [firstInitialSections objectAtIndex:[indexPath section]];
        NSMutableArray *contactsForSection = [addressBookContactsBySection objectForKey:firstCharacter];
        contact = [contactsForSection objectAtIndex:[indexPath row]];
    }
    contact.selected = !contact.selected;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (contact.selected) {
        totalContactsSelected += 1;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        totalContactsSelected -= 1;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self updateNavBarTitle];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText
{
	[self.filteredAddressBookContacts removeAllObjects]; // First clear the filtered array.	
	for (AWBPersonContact *contact in sortedAddressBookContacts)
	{
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(SELF contains[cd] %@)", searchText];
        if ([predicate evaluateWithObject:contact.displayName]) {
            if (contact) {
                [self.filteredAddressBookContacts addObject:contact];                
            }
        }
 	}
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self addToolbarButtons];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller   
{
    self.toolbarItems = nil;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView   
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self addToolbarButtons];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView   
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.toolbarItems = nil;
}

- (void)dismissPicker:(id)sender 
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
    if([peoplePickerDelegate respondsToSelector:@selector(awbPeoplePickerControllerDidCancel:)]) {
		[peoplePickerDelegate performSelector:@selector(awbPeoplePickerControllerDidCancel:) withObject:self withObject:nil];
	}   
}

- (void)finishPickerWithInfo:(id)sender
{
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
    if([peoplePickerDelegate respondsToSelector:@selector(awbPeoplePickerController:didFinishPickingContacts:)]) {
		[peoplePickerDelegate performSelector:@selector(awbPeoplePickerController:didFinishPickingContacts:) withObject:self withObject:[self selectedContacts]];
	}    
}

- (NSArray *)selectedContacts
{
    NSMutableArray *selectedContacts = [NSMutableArray arrayWithCapacity:[sortedAddressBookContacts count]];
    for (AWBPersonContact *contact in sortedAddressBookContacts) {
        if (contact.selected) {
            contact.hideNumber = (includePhoneNumbers == NO);
            if (contact) {
                [selectedContacts addObject:contact];                
            }
        }
    }
    return selectedContacts;
}

- (UIView *)tableFooterViewWithTotalContacts:(NSUInteger)totalContacts    
{
    if (totalContacts == 0) {
        return nil;
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 60.0)];
        NSString *contactDesc = nil;
        if (totalContacts == 1) {
            contactDesc = @"Contact";
        } else {
            contactDesc = @"Contacts";
        }
        [label setText:[NSString stringWithFormat:@"%d %@", totalContacts, contactDesc]];
        [label setFont:[UIFont systemFontOfSize:22.0]];
        [label setTextColor:[UIColor darkGrayColor]];
        [label setTextAlignment:UITextAlignmentCenter];
        return [label autorelease];
    }
}

- (void)updateNavBarTitle
{
    if (totalContactsSelected == 0) {
        self.navigationItem.title = @"Select Contacts";
    } else {
        NSString *contactDesc = nil;
        if (totalContactsSelected == 1) {
            contactDesc = @"Contact";
        } else {
            contactDesc = @"Contacts";
        }
        self.navigationItem.title = [NSString stringWithFormat:@"%d %@ Selected", totalContactsSelected, contactDesc];
    }
}

@end
