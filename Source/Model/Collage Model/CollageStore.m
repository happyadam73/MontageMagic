//
//  CollageStore.m
//  Collage Maker
//
//  Created by Adam Buckley on 14/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageStore.h"
#import "CollageDescriptor.h"
#import "FileHelpers.h"

static CollageStore *defaultStore = nil;

@implementation CollageStore

+ (CollageStore *)defaultStore
{
    if (!defaultStore) {
        // Create the singleton
        defaultStore = [[super allocWithZone:NULL] init];
    }
    return defaultStore;
}

// Prevent creation of additional instances
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self defaultStore] retain];
}

- (id)init
{
    // If we already have an instance of CollageStoreStore...
    if (defaultStore) {
        
        // Return the old one
        return defaultStore;
    }
    
    self = [super init];
    return self;
}

- (id)retain
{
    // Do nothing
    return self;
}

- (oneway void)release
{
    // Do nothing
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (NSArray *)allCollages
{
    // This ensures allCollages is created
    [self fetchCollagesIfNecessary];
    
    return allCollages;
}

- (CollageDescriptor *)createCollage
{
    [self fetchCollagesIfNecessary];
    
    NSInteger sequenceId = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyCollageSequenceNumber];
    sequenceId += 1;
    [[NSUserDefaults standardUserDefaults] setInteger:sequenceId forKey:kAWBInfoKeyCollageSequenceNumber];
    CollageDescriptor *collage = [[[CollageDescriptor alloc] initWithCollageDocumentsSubdirectory:[NSString stringWithFormat:@"Collage %d", sequenceId]] autorelease];
    collage.themeType = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyCollageThemeType];
    if (collage) {
        [allCollages addObject:collage];
    }
    
    return collage;
}

- (NSString *)nextDefaultCollageName
{
    NSInteger sequenceId = [[NSUserDefaults standardUserDefaults] integerForKey:kAWBInfoKeyCollageSequenceNumber];
    sequenceId += 1;
    return [NSString stringWithFormat:@"Collage %d", sequenceId];
}

- (void)removeCollage:(CollageDescriptor *)collage
{
    NSError *error;
    NSString *path = AWBDocumentSubdirectory([collage collageSaveDocumentsSubdirectory]);
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    [allCollages removeObjectIdenticalTo:collage];
}

- (void)moveCollageAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // Get pointer to object being moved
    CollageDescriptor *collage = [allCollages objectAtIndex:from];
    
    // Retain it... (retain count of p = 2)
    [collage retain];
    
    // Remove p from array, it is automatically sent release (retain count of p = 1)
    [allCollages removeObjectAtIndex:from];
    
    // Insert p in array at new location, retained by array (retain count of p = 2)
    [allCollages insertObject:collage atIndex:to];
    
    // Release p (retain count = 1, only owner is now array)
    [collage release];
}

- (NSString *)collageDescriptorArchivePath
{
    return AWBPathInDocumentDirectory(@"collageDescriptors.data");
}

- (BOOL)saveAllCollages
{
    // returns success or failure
    return [NSKeyedArchiver archiveRootObject:allCollages 
                                       toFile:[self collageDescriptorArchivePath]];
}

- (void)fetchCollagesIfNecessary
{
    if (!allCollages) {
        NSString *path = [self collageDescriptorArchivePath];
        allCollages = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
    }
    
    // If we tried to read one from disk but does not exist, then first try and copy the help collages from the bundle 
    if (!allCollages) {
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:kAWBInfoKeyCollageSequenceNumber];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAWBInfoKeyCollageStoreCollageIndex];
        BOOL success = AWBCopyCollageHelpFilesForDevice();  
        if (success) {
            NSString *path = [self collageDescriptorArchivePath];
            allCollages = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
        }
    }
    
    if (!allCollages) {
        //collage help files not copied so create empty collage store
        allCollages = [[NSMutableArray alloc] init];
    }
}

@end