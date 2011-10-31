//
//  AWBPersonContact.h
//  Collage Maker
//
//  Created by Adam Buckley on 20/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface AWBPersonContact : NSObject {
    ABRecordID recordID;
    NSString *firstName;
    NSString *lastName;
    UIImage *thumbnail;
    NSString *mainPhoneNumber;
    ABPersonSortOrdering sortOrder;
    BOOL selected;
    BOOL hasNameData;
    BOOL hideImage;
    BOOL hideName;
    BOOL hideNumber;
}

@property (nonatomic, readonly) ABRecordID recordID;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, retain) NSString *mainPhoneNumber;
@property (nonatomic, readonly) NSString *displayPhoneNumber;
@property (nonatomic, readonly) NSString *phoneNumberForAddressBook;
@property (nonatomic, readonly) NSString *sortKey1;
@property (nonatomic, readonly) NSString *sortKey2;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, readonly) BOOL hasNameData;
@property (nonatomic, assign) BOOL hideImage;
@property (nonatomic, assign) BOOL hideName;
@property (nonatomic, assign) BOOL hideNumber;

+ (NSArray *)contactSortDescriptors;
- (id)initWithABRecordRef:(ABRecordRef)person;
- (NSString *)firstCharacter;
- (UIImage *)fullSizeImage;
- (UIImage *)thumbnailImage;
- (UIImage *)thumbnailImageWithAddressBookRef:(ABAddressBookRef)addressBook;
- (BOOL)hasImageDataWithAddressBookRef:(ABAddressBookRef)addressBook;
- (NSUInteger)rankOfABPersonPhoneLabel:(NSString *)abPersonPhoneLabel;

@end
