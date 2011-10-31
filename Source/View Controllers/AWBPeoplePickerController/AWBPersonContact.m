//
//  AWBPersonContact.m
//  Collage Maker
//
//  Created by Adam Buckley on 20/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBPersonContact.h"
#import "PhoneNumberFormatter.h"

@implementation AWBPersonContact

@synthesize firstName, lastName, thumbnail, displayName, mainPhoneNumber, sortKey1, sortKey2, selected, recordID, hasNameData, hideName, hideImage, displayPhoneNumber, phoneNumberForAddressBook, hideNumber;

- (id)initWithABRecordRef:(ABRecordRef)person
{
    self = [super init];
    if (self) {
        recordID = ABRecordGetRecordID(person);
        sortOrder = ABPersonGetSortOrdering();
        selected = NO;
        hasNameData = YES;
        hideName = NO;
        hideImage = NO;
        hideNumber = YES;
        
        CFStringRef firstNameRef = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef lastNameRef = ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        if (firstNameRef != NULL) {
            [self setFirstName:(NSString *)firstNameRef];
            CFRelease(firstNameRef);
        }
        
        if (lastNameRef != NULL) {
            [self setLastName:(NSString *)lastNameRef];
            CFRelease(lastNameRef);
        }  
        
        if (!firstName && !lastName) {
            CFStringRef companyRef = ABRecordCopyValue(person, kABPersonOrganizationProperty);
            if (companyRef != NULL) {
                [self setFirstName:(NSString *)companyRef];
                CFRelease(companyRef);
            } else {
                hasNameData = NO;
            }
        }
                
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if (phoneNumbers != NULL) 
        {
            NSUInteger totalPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
            if (totalPhoneNumbers > 0) {
                NSUInteger highestRank = 0;
                NSUInteger highestRankIndex = 0;
                for (NSUInteger index = 0; index < totalPhoneNumbers; index++) 
                {
                    CFStringRef number = ABMultiValueCopyValueAtIndex(phoneNumbers, index);
                    CFStringRef label = ABMultiValueCopyLabelAtIndex(phoneNumbers, index);
                    if ((number != NULL) && (label != NULL)) {
                        NSUInteger rank = [self rankOfABPersonPhoneLabel:(NSString *)label];
                        if (rank > highestRank) {
                            highestRank = rank;
                            highestRankIndex = index;
                        }
                    }
                    
                    if (number != NULL) {
                        CFRelease(number);
                    }
                    if (label != NULL) {
                        CFRelease(label);
                    }                    
                }
                               
                CFStringRef number = ABMultiValueCopyValueAtIndex(phoneNumbers, highestRankIndex);
                if (number != NULL) {
                    [self setMainPhoneNumber:(NSString *)number];
                    CFRelease(number);
                }
            }
            CFRelease(phoneNumbers);
        }
    }
    return self;
}

- (UIImage *)fullSizeImage
{
    UIImage *image = nil;
    if (!hideImage) {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        if (addressBook != NULL) {
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, self.recordID); 
            if (person != NULL) {
                CFDataRef imageData = ABPersonCopyImageData(person);
                if (imageData != NULL) {
                    image = [UIImage imageWithData:(NSData *)imageData];
                    CFRelease(imageData);
                }
            }
            CFRelease(addressBook);
        }         
    }
    return image;   
}

- (UIImage *)thumbnailImage
{
    UIImage *image = nil;
    ABAddressBookRef addressBook = ABAddressBookCreate();
    if (addressBook != NULL) {
        image = [self thumbnailImageWithAddressBookRef:addressBook];
        CFRelease(addressBook);
    }
    return image;
}

- (UIImage *)thumbnailImageWithAddressBookRef:(ABAddressBookRef)addressBook
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (!self.thumbnail) {
        UIImage *image = nil;
        
        if (addressBook != NULL) {
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, self.recordID); 
            if ((person != NULL) && (ABPersonCopyImageDataWithFormat != NULL)) {
                CFDataRef imageData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
                if (imageData!= NULL) {
                    image = [[UIImage alloc] initWithData:(NSData *)imageData];
                    CFRelease(imageData);
                }
            }
        }            
        
        if (image) {
            [self setThumbnail:image];
            [image release];
        } else {
            [self setThumbnail:[UIImage imageNamed:@"blank"]];
        }
    }
    [pool drain];
    return self.thumbnail;
}

- (BOOL)hasImageDataWithAddressBookRef:(ABAddressBookRef)addressBook
{
    if (!self.thumbnail) {
        BOOL hasImageData = NO;
        if (addressBook != NULL) {
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, self.recordID); 
            if (person != NULL) {
                if (ABPersonCopyImageDataWithFormat != NULL) {
                    CFDataRef imageData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
                    if (imageData != NULL) {
                        hasImageData = YES;
                        CFRelease(imageData);
                    }
                } else {
                    hasImageData = ABPersonHasImageData(person);                    
                }
            }
        }            
        return hasImageData;
    } else {
        return YES;
    }
}

- (NSString *)displayPhoneNumber
{
    if (!hideNumber) {
        return self.phoneNumberForAddressBook;
    } else {
        return nil;
    }
}

- (NSString *)phoneNumberForAddressBook
{
    if (mainPhoneNumber) {
        NSMutableString *phoneNumber = [NSMutableString stringWithString:mainPhoneNumber];
        if ([phoneNumber hasPrefix:@"+44"]) {
            [phoneNumber replaceOccurrencesOfString:@"+44" withString:@"0" options:NSAnchoredSearch range:NSMakeRange(0,3)];
        }        
        PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
        NSString *formattedPhoneNumber = [formatter format:phoneNumber];
        [formatter release];
        return formattedPhoneNumber;
    } else {
        return nil;
    }
}

- (NSString *)displayName
{
    NSMutableString *name = [NSMutableString stringWithString:@""];
    
    if (!hideName) {
        if (firstName) {
            [name appendString:firstName];
        }
        if (lastName) {
            if ([name length] > 0) {
                [name appendString:@" "];
            }
            [name appendString:lastName];
        }
        
        if ([name length] == 0) {
            [name appendString:@"No Name"];
        }        
    }
    
    return name;
}

- (NSString *)firstName
{
    if (hideName) {
        return nil;
    } else {
        return firstName;
    }
}

- (NSString *)lastName
{
    if (hideName) {
        return nil;
    } else {
        return lastName;
    }
}

- (NSString *)mainPhoneNumber
{
    if (hideNumber) {
        return nil;
    } else {
        return mainPhoneNumber;
    }
}

- (NSString *)sortKey1
{
    NSString *key = nil;
    if (sortOrder == kABPersonSortByLastName) {
        if (lastName) {
            key = lastName;
        } else {
            key = firstName;
        }
    } else {
        if (firstName) {
            key = firstName;
        } else {
            key = lastName;
        }    
    }
    
    if (key) {
        NSRange findLettersRange = [key rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
        if (findLettersRange.location == NSNotFound) {
            return [key uppercaseString];
        } else {
            return [[key substringFromIndex:findLettersRange.location] uppercaseString];        
        }   
    } else {
        return nil;
    }
}

- (NSString *)sortKey2
{
    NSString *key = nil;
    if (sortOrder == kABPersonSortByLastName) {
        if (lastName) {
            key = firstName;
        }
    } else {
        if (firstName) {
            key = lastName;
        }    
    }
    
    if (key) {
        NSRange findLettersRange = [key rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
        if (findLettersRange.location == NSNotFound) {
            return [key uppercaseString];
        } else {
            return [[key substringFromIndex:findLettersRange.location] uppercaseString];        
        }   
    } else {
        return nil;
    }
}

+ (NSArray *)contactSortDescriptors
{   
    NSSortDescriptor *sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:@"sortKey1" ascending:YES] autorelease];
    NSSortDescriptor *sortDescriptor2 = [[[NSSortDescriptor alloc] initWithKey:@"sortKey2" ascending:YES] autorelease];
    
    return [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
}

- (NSString *)firstCharacter
{
    NSString *keyName = nil;
    if (sortOrder == kABPersonSortByLastName) {
        if (lastName && ([lastName length]>0)) {
            keyName = lastName;
        } else {
            if (firstName && ([firstName length]>0)) {
                keyName = firstName;               
            }
        }
    } else {
        if (firstName && ([firstName length]>0)) {
            keyName = firstName;
        } else {
            if (lastName && ([lastName length]>0)) {
                keyName = lastName;                
            }
        }        
    }

    if (keyName) {
        NSRange findLettersRange = [keyName rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
        if (findLettersRange.location == NSNotFound) {
            return @"#";
        } else {
            return [[keyName substringWithRange:NSMakeRange(findLettersRange.location, 1)] uppercaseString];        
        }        
    } else {
        return @"#";
    }
}

- (NSUInteger)rankOfABPersonPhoneLabel:(NSString *)abPersonPhoneLabel
{
    NSUInteger rank = 4; //default
    
    if ([abPersonPhoneLabel isEqualToString:(NSString *)kABPersonPhoneMainLabel]) {
        rank = 10;
    } else if ([abPersonPhoneLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
        rank = 9;
    } else if ([abPersonPhoneLabel isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel]) {
        rank = 8;
    } else if ([abPersonPhoneLabel isEqualToString:(NSString *)kABHomeLabel]) {
        rank = 7;
    } else if ([abPersonPhoneLabel isEqualToString:(NSString *)kABWorkLabel]) {
        rank = 6;
    } else if ([abPersonPhoneLabel isEqualToString:(NSString *)kABOtherLabel]) {
        rank = 5;
    } else if ([abPersonPhoneLabel isEqualToString:(NSString *)kABPersonPhoneHomeFAXLabel]) {
        rank = 3;
    } else if ([abPersonPhoneLabel isEqualToString:(NSString *)kABPersonPhoneWorkFAXLabel]) {
        rank = 2;
    } else if ([abPersonPhoneLabel isEqualToString:(NSString *)kABPersonPhonePagerLabel]) {
        rank = 1;
    } 
    
    return rank;
}

- (void)dealloc
{
    [firstName release];
    [lastName release];
    [thumbnail release];
    [mainPhoneNumber release];
    [super dealloc];
}

@end
