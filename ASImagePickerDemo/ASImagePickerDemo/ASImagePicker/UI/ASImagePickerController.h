//
//  ASImagePickerController.h
//  ASImagePickerDemo
//
//  Created by alan on 8/29/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASAlbumListController.h"

typedef NS_ENUM(NSInteger, ASImagePickerControllerSourceType) {
    ASImagePickerControllerSourceTypePhotoLibrary,//图库
    ASImagePickerControllerSourceTypeCamera,//相机
    ASImagePickerControllerSourceTypeSavedPhotosAlbum//相册
};

typedef NS_ENUM(NSInteger, ASImagePickerControllerCameraDevice) {
    ASImagePickerControllerCameraDeviceRear,
    ASImagePickerControllerCameraDeviceFront
};

typedef NS_ENUM(NSInteger, ASImagePickerControllerAccess) {
    ASImagePickerControllerAccessAlbums,//入口为相册分类界面
    ASImagePickerControllerAccessPhotosWithoutAlbums,//入口为图片选择界面，不包含相册分类
    ASImagePickerControllerAccessPhotosWithAlbums//入口为图片选择界面，返回可回相册分类界面
};

// info dictionary keys
UIKIT_EXTERN NSString * _Nullable const ASImagePickerControllerMediaType;      // an NSString (UTI, i.e. kUTTypeImage)
UIKIT_EXTERN NSString * _Nullable const ASImagePickerControllerOriginalImage;  // a UIImage
UIKIT_EXTERN NSString * _Nullable const ASImagePickerControllerEditedImage;    // a UIImage
UIKIT_EXTERN NSString * _Nullable const ASImagePickerControllerCropRect;       // an NSValue (CGRect)
UIKIT_EXTERN NSString * _Nullable const ASImagePickerControllerMediaURL;       // an NSURL
UIKIT_EXTERN NSString * _Nullable const ASImagePickerControllerReferenceURL;  // an NSURL that references an asset in the AssetsLibrary framework
UIKIT_EXTERN NSString * _Nullable const ASImagePickerControllerMediaMetadata;  // an NSDictionary containing metadata from a captured photo
//CGImageSourceRef source = CGImageSourceCreateWithURL( (CFURLRef) aUrl, NULL);
//CGImageSourceRef source = CGImageSourceCreateWithData( (CFDataRef) theData, NULL);
//NSDictionary* metadata = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source,0,NULL);
UIKIT_EXTERN NSString * _Nullable const ASImagePickerControllerLivePhoto NS_AVAILABLE_IOS(9_1);  // a PHLivePhoto

@interface ASImagePickerController : UINavigationController

+ (BOOL)isSourceTypeAvailable:(ASImagePickerControllerSourceType)sourceType;                 // returns YES if source is available (i.e. camera present)
+ (nullable NSArray<NSString *> *)availableMediaTypesForSourceType:(ASImagePickerControllerSourceType)sourceType; // returns array of available media types (i.e. kUTTypeImage)
+ (BOOL)isCameraDeviceAvailable:(ASImagePickerControllerCameraDevice)cameraDevice; // returns YES if camera device is available
+ (BOOL)isFlashAvailableForCameraDevice:(ASImagePickerControllerCameraDevice)cameraDevice; // returns YES if camera device supports flash and torch.
+ (nullable NSArray<NSNumber *> *)availableCaptureModesForCameraDevice:(ASImagePickerControllerCameraDevice)cameraDevice; // returns array of NSNumbers (UIImagePickerControllerCameraCaptureMode)


- (nonnull instancetype)initWithCompletion:(nullable ASImagePickerCompletionBlock)completion;

@property (nonatomic) BOOL allowsMultiSelected;//default value is NO.

@property (nonatomic) BOOL allowsMoments;//default value is YES.

@property (nonatomic) BOOL allowsMomentsAnimation;//default value is NO.

@property (nonatomic) BOOL showsEmptyAlbum;//default value is NO.

//@property (nonatomic) BOOL showsAlbumName;//if showsEmptyAlbum is YES,this property will work.default is YES.

@property (nonatomic) BOOL showsAlbumNumber;//if showsEmptyAlbum is YES,this property will work.default is YES.

@property (nonatomic) BOOL showsAlbumThumbImage;//if showsEmptyAlbum is YES,this property will work.default is YES.

@property (nonatomic) BOOL allowsEditing;//default value is NO.

@property (nonatomic) BOOL allowsImageEditing;//default value is NO.

@property (nonatomic) BOOL showsLivePhotoBadge;//default value is YES.

@property (nonatomic) NSInteger imageLimit;//default 0 nolimit 选择图片数量上限

@property (nonatomic) NSInteger rowLimit;//default 4 minimum 1 每行显示个数


@end

@class ASImagePickerController;
@protocol ASImagePickerControllerDelegate<NSObject>
@optional
// The picker does not dismiss itself; the client dismisses it in these callbacks.
// The delegate will receive one or the other, but not both, depending whether the user
// confirms or cancels.
- (void)imagePickerController:(nullable ASImagePickerController *)picker didFinishPickingImages:(nullable NSArray<UIImage *> *)images editingInfos:(nullable NSDictionary<NSString *,id> *)editingInfos;
- (void)imagePickerController:(nullable ASImagePickerController *)picker didFinishPickingMediasWithInfos:(nullable NSArray<NSDictionary<NSString *,id> *> *)infos;
- (void)imagePickerControllerDidCancel:(nullable ASImagePickerController *)picker;

@end
