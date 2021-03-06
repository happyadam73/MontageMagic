/*
 *  FileHelpers.h
 *  Homepwner
 *
 *  Created by bhardy on 7/30/09.
 *  Copyright 2009 Big Nerd Ranch. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

NSString *AWBDocumentDirectory();
NSString *AWBDocumentSubdirectory(NSString *docsSubdirectory);
NSString *AWBPathInDocumentDirectory(NSString *fileName);
NSString *AWBPathInDocumentSubdirectory(NSString *docsSubdirectory, NSString *fileName);
void AWBSaveImageWithKey(UIImage *image, NSString *imageKey, BOOL saveAsPNG);
UIImage *AWBLoadImageWithKey(NSString *imageKey);
void AWBRemoveImageWithKey(NSString *imageKey);
NSUInteger AWBDocumentSubdirectoryFolderSize(NSString *docsSubdirectory);
NSString *AWBFileSizeIntToString(NSUInteger bytes);
NSString *AWBDocumentSubdirectoryModifiedDate(NSString *docsSubdirectory);
NSString *AWBDocumentSubdirectoryCreatedDate(NSString *docsSubdirectory);
NSString *AWBDateStringForCurrentLocale(NSDate *date);
NSString *AWBGetImageKeyFromDocumentSubdirectory(NSString *docsSubdirectory, NSString *fileName);
BOOL AWBCopyBundleItemAtPathToDocumentsFolder(NSString *bundleSubdirectory, NSString *filename);
BOOL AWBCopyCollageHelpFilesForDevice();
NSString *AWBPathInMyFontsDocumentsSubdirectory(NSString *filename);
NSString *AWBPathInMainBundleSubdirectory(NSString *bundleSubdirectory, NSString *filename);
BOOL AWBCopyDocsSubdirToSubdir(NSString *subdirFrom, NSString *subdirTo);
NSString *AWBReplaceSubdirInImageKey(NSString *imageKey, NSString *subDir);
NSString *AWBPathInMyFontsExtractionSubdirectory();
NSString *AWBPathWithFilenameInMyFontsExtractionSubdirectory(NSString *filename);
