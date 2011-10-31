//
//  CollageStore.h
//  Collage Maker
//
//  Created by Adam Buckley on 14/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kAWBInfoKeyCollageSequenceNumber = @"CollageSequenceNumber";
static NSString *const kAWBInfoKeyCollageStoreCollageIndex = @"CollageStoreCollageIndex";
static NSString *const kAWBInfoKeyScrollToCollageStoreCollageIndex = @"ScrollToCollageStoreCollageIndex";

@class CollageDescriptor;

@interface CollageStore : NSObject {
    NSMutableArray *allCollages;
}

+ (CollageStore *)defaultStore;

- (NSArray *)allCollages;
- (CollageDescriptor *)createCollage;
- (void)removeCollage:(CollageDescriptor *)collage;
- (void)moveCollageAtIndex:(int)from toIndex:(int)to;
- (NSString *)collageDescriptorArchivePath;
- (BOOL)saveAllCollages;
- (void)fetchCollagesIfNecessary;
- (NSString *)nextDefaultCollageName;

@end
