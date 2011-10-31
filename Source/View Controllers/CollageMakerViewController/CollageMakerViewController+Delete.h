//
//  CollageMakerViewController+Delete.h
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController.h"

@interface CollageMakerViewController (Delete) 

- (void)deleteSelectedViews:(id)sender;
- (void)deleteConfirmationActionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;

@end
