//
//  ASAlbumListController.h
//  ASImagePickerDemo
//
//  Created by alan on 8/25/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPhotoGridController.h"

@interface ASAlbumListController : UIViewController

@property (nonatomic, strong, nullable) ASImagePickerCompletionBlock completionBlock;

@property (nonatomic, strong, nullable) PHFetchOptions *fetchAlbumsOptions;///相册抓取配置，包括排序、筛选

@property (nonatomic, strong, nullable) PHFetchOptions *fetchPhotosOptions;///图片抓取配置，包括排序、筛选

@property (nonatomic) BOOL allowsMoments;//default value is YES.

@property (nonatomic) BOOL showsEmptyAlbum;//default value is NO.

@property (nonatomic) BOOL showsAlbumNumber;//if showsEmptyAlbum is YES,this property will work.default is YES.

@property (nonatomic) BOOL showsAlbumThumbImage;//if showsEmptyAlbum is YES,this property will work.default is YES.

@property (nonatomic) BOOL showsAlbumCategory;//default value is YES.

@end
