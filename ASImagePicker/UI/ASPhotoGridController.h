//
//  ASPhotoGridController.h
//  ASImagePickerDemo
//
//  Created by alan on 8/26/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMoment.h"

@import AVFoundation;
@import Photos;

typedef void(^ASImagePickerCompletionBlock)(NSArray<id> *datas, NSError *error);

@interface ASPhotoGridController : UIViewController<NSCopying>

@property (strong, nonatomic) PHFetchResult *assetsFetchResults;

@property (strong, nonatomic) ASImagePickerCompletionBlock completionBlock;

@property (nonatomic) BOOL allowsMultiSelected;//default value is NO.

@property (nonatomic) BOOL allowsMoments;//default value is YES.

@property (nonatomic) ASMomentGroupType momentGroupType;//if allowsMoments is YES,this property will work.default value is ASMomentGroupTypeDay.

@property (nonatomic) BOOL allowsMomentsAnimation;//default value is NO.

@property (nonatomic) BOOL allowsEditing;//default value is NO.

@property (nonatomic) BOOL allowsImageEditing;//default value is NO.

@property (nonatomic) BOOL showsLivePhotoBadge;//default value is YES.

@property (nonatomic) NSInteger imageLimit;//default 0 represents no limit 选择图片数量上限

@property (nonatomic) NSInteger rowLimit;//default 4 minimum 1 每行显示个数

- (void)becomeEntrance;

@end
