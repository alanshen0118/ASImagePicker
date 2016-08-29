//
//  ASImagePickerController.h
//  ASImagePickerDemo
//
//  Created by alan on 8/29/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASAlbumListController.h"

@interface ASImagePickerController : UINavigationController

- (instancetype)initWithCompletion:(ASImagePickerCompletionBlock)completion;

@end
