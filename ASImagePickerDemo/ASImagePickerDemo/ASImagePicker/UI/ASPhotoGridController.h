//
//  ASPhotoGridController.h
//  ASImagePickerDemo
//
//  Created by alan on 8/26/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AVFoundation;
@import Photos;

typedef void(^ASImagePickerCompletionBlock)(NSArray<id> *datas, NSError *error);

@interface ASPhotoGridController : UIViewController

@property (strong, nonatomic) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (strong, nonatomic) ASImagePickerCompletionBlock completionBlock;

@end
