//
//  ASImagePickerController.m
//  ASImagePickerDemo
//
//  Created by alan on 8/29/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASImagePickerController.h"
#import "ASPhotoGridController.h"

@interface ASImagePickerController ()

@property (strong, nonatomic) ASAlbumListController *albumListController;

@property (strong, nonatomic) ASPhotoGridController *photoGridController;

@end

@implementation ASImagePickerController
@dynamic delegate;

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response(e__method)

#pragma mark - customPageViews
- (void)customPageViews {
    
}

#pragma mark - public method
#pragma mark -- class method
+ (BOOL)isSourceTypeAvailable:(ASImagePickerControllerSourceType)sourceType {
    //TODO:SourceTypeAvailable
    return YES;
}

+ (NSArray<NSString *> *)availableMediaTypesForSourceType:(ASImagePickerControllerSourceType)sourceType {
    //TODO:availableMediaTypes
    return nil;
}

+ (BOOL)isCameraDeviceAvailable:(ASImagePickerControllerCameraDevice)cameraDevice {
    //TODO:CameraDeviceAvailable
    return YES;
}

+ (BOOL)isFlashAvailableForCameraDevice:(ASImagePickerControllerCameraDevice)cameraDevice {
    //TODO:FlashAvailable
    return YES;
}

+ (NSArray<NSNumber *> *)availableCaptureModesForCameraDevice:(ASImagePickerControllerCameraDevice)cameraDevice {
    //TODO:availableCaptureModes
    return nil;
}

#pragma mark -- object method

#pragma mark - private method(__method)

#pragma mark - setup data
- (void)setupData {

}

#pragma mark - getters and setters

- (void)setAccess:(ASImagePickerControllerAccess)access {
    _access = access;
    switch (self.access) {
        case ASImagePickerControllerAccessAlbums:{
            self.viewControllers = @[self.albumListController];
            break;
        }
        case ASImagePickerControllerAccessPhotosWithAlbums:{
            //获取所有图片资源，图片配置设置排序规则
            PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:_fetchPhotosOptions];
            self.photoGridController.assetsFetchResults = allPhotos;
            self.viewControllers = @[self.albumListController, self.photoGridController];
            break;
        }
        case ASImagePickerControllerAccessPhotosWithoutAlbums:{
            //获取所有图片资源,图片配置设置排序规则
            PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:_fetchPhotosOptions];
            self.photoGridController.assetsFetchResults = allPhotos;
            self.viewControllers = @[self.photoGridController];
            break;
        }
            
        default:
            break;
    }
}

- (void)setSourceType:(ASImagePickerControllerSourceType)sourceType {
    _sourceType = sourceType;
}

- (void)setCameraCaptureMode:(ASImagePickerControllerCameraCaptureMode)cameraCaptureMode {
    _cameraCaptureMode = cameraCaptureMode;
}

- (void)setCameraDevice:(ASImagePickerControllerCameraDevice)cameraDevice {
    _cameraDevice = cameraDevice;
}

- (void)setCameraFlashMode:(ASImagePickerControllerCameraFlashMode)cameraFlashMode {
    _cameraFlashMode = cameraFlashMode;
}

- (void)setVideoQuality:(ASImagePickerControllerQualityType)videoQuality {
    _videoQuality = videoQuality;
}

- (void)setAllowsMultiSelected:(BOOL)allowsMultiSelected {
    _allowsMultiSelected = allowsMultiSelected;
}

- (void)setAllowsMoments:(BOOL)allowsMoments {
    _allowsMoments = allowsMoments;
    self.albumListController.allowsMoments = allowsMoments;
}

- (void)setAllowsMomentsAnimation:(BOOL)allowsMomentsAnimation {
    _allowsMomentsAnimation = allowsMomentsAnimation;
}

- (void)setAllowsEditing:(BOOL)allowsEditing {
    _allowsEditing = allowsEditing;
}

- (void)setAllowsImageEditing:(BOOL)allowsImageEditing {
    _allowsImageEditing = allowsImageEditing;
}

- (void)setShowsEmptyAlbum:(BOOL)showsEmptyAlbum {
    _showsEmptyAlbum = showsEmptyAlbum;
    self.albumListController.showsEmptyAlbum = showsEmptyAlbum;
}

- (void)setShowsAlbumNumber:(BOOL)showsAlbumNumber {
    _showsAlbumNumber = showsAlbumNumber;
    self.albumListController.showsAlbumNumber = showsAlbumNumber;
}

- (void)setShowsAlbumThumbImage:(BOOL)showsAlbumThumbImage {
    _showsAlbumThumbImage = showsAlbumThumbImage;
    self.albumListController.showsAlbumThumbImage = showsAlbumThumbImage;
}

- (void)setShowsAlbumCategory:(BOOL)showsAlbumCategory {
    _showsAlbumCategory = showsAlbumCategory;
    self.albumListController.showsAlbumCategory = showsAlbumCategory;
}

- (void)setShowsLivePhotoBadge:(BOOL)showsLivePhotoBadge {
    _showsLivePhotoBadge = showsLivePhotoBadge;
}

- (void)setImageLimit:(NSInteger)imageLimit {
    _imageLimit = imageLimit;
}

- (void)setRowLimit:(NSInteger)rowLimit {
    _rowLimit = rowLimit;
}

- (void)setCompletionBlock:(ASImagePickerCompletionBlock)completionBlock {
    _completionBlock = completionBlock;
}

- (ASAlbumListController *)albumListController {
    if (!_albumListController) {
        _albumListController = [[ASAlbumListController alloc] init];
    }
    return _albumListController;
}

- (ASPhotoGridController *)photoGridController {
    if (!_photoGridController) {
        _photoGridController = [[ASPhotoGridController alloc] init];
    }
    return _photoGridController;
}

@end
