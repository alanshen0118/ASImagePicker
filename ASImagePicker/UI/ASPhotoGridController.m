//
//  ASPhotoGridController.m
//  ASImagePickerDemo
//
//  Created by alan on 8/26/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASPhotoGridController.h"
#import "NSIndexSet+Convenience.h"
#import "UICollectionView+Convenience.h"
#import "PHFetchResult+Convenience.h"
#import "ASPhotoGridCell.h"
#import "ASPhotoGridSectionHeaderView.h"
#import "ASMoment.h"

@import PhotosUI;

@interface ASPhotoGridController () <PHPhotoLibraryChangeObserver, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, copy) NSMutableArray *moments;
@property CGRect previousPreheatRect;

@end

@implementation ASPhotoGridController
static NSString * const CellReuseIdentifier = @"Cell";
static NSString * const SectionHeaderReuseIdentifier = @"SectionHeader";
static CGSize AssetGridThumbnailSize;

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.collectionView.allowsMultipleSelection = YES;
        if (self.rowLimit == 0) self.rowLimit = 4;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self customPageViews];
    [self setupData];
    
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 可见区域刷新缓存
    [self updateCachedAssets];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - system delegate
- (id)copyWithZone:(NSZone *)zone {
    
    ASPhotoGridController *photoGridController = [[ASPhotoGridController alloc] init];
    photoGridController.allowsMultiSelected = self.allowsMultiSelected;
    photoGridController.allowsMoments = self.allowsMoments;
    photoGridController.momentGroupType = self.momentGroupType;
    photoGridController.allowsMomentsAnimation = self.allowsMomentsAnimation;
    photoGridController.allowsEditing = self.allowsEditing;
    photoGridController.allowsImageEditing = self.allowsImageEditing;
    photoGridController.showsLivePhotoBadge = self.showsLivePhotoBadge;
    photoGridController.imageLimit = self.imageLimit;
    photoGridController.rowLimit = self.rowLimit;
    photoGridController.completionBlock = self.completionBlock;
    return photoGridController;

}
#pragma mark -- PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // 检测是否有资源变化
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    

    // 通知在后台队列，重定位到主队列进行界面更新
    dispatch_async(dispatch_get_main_queue(), ^{

        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        
        UICollectionView *collectionView = self.collectionView;
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            [collectionView reloadData];
            
        } else {
            // 如果相册有变化，collectionview动画增删改
            [collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
            } completion:NULL];
        }
        
        
        
    });
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.allowsMoments) {
        ASMoment *moment = self.moments[section];
        return [moment.assets count];
    }
    return [self.assetsFetchResults count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    if (self.allowsMoments && self.moments) {
        ASMoment *moment = self.moments[indexPath.section];
        asset = moment.assets[indexPath.row];
    }
    
    ASPhotoGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.representedAssetIdentifier = asset.localIdentifier;
    cell.allowsMultiSelected = self.allowsMultiSelected;
    
    // 如果是Live图片增加一个标记
    if (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
        UIImage *badge = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
        cell.livePhotoBadgeImage = badge;
    }
    
    // 请求图片
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeDefault
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
                                  if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      cell.thumbnailImage = result;
                                  }
                              }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.allowsMoments) {
        return self.moments.count;
    }
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ASPhotoGridSectionHeaderView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderReuseIdentifier forIndexPath:indexPath];
    ASMoment *moment = self.moments[indexPath.section];
    switch (self.momentGroupType) {
        case ASMomentGroupTypeDay:
            reusableView.textLabel.text = [NSString stringWithFormat:@"%zi年%zi月%zi日", moment.dateComponents.year, moment.dateComponents.month, moment.dateComponents.day];
            break;
        case ASMomentGroupTypeMonth:
            reusableView.textLabel.text = [NSString stringWithFormat:@"%zi年%zi月", moment.dateComponents.year, moment.dateComponents.month];
            break;
        case ASMomentGroupTypeYear:
            reusableView.textLabel.text = [NSString stringWithFormat:@"%zi年", moment.dateComponents.year];
            break;
        default:
            break;
    }
    return reusableView;
}

#pragma mark -- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ASMoment *moment = self.moments[indexPath.section];
    PHAsset *asset = moment.assets[indexPath.item];
    NSLog(@"%@", asset.creationDate);
    return self.allowsMultiSelected && self.imageLimit > 0 ? [collectionView indexPathsForSelectedItems].count < self.imageLimit : YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allowsMultiSelected) return;
    PHAsset *asset;
    if (self.allowsMoments) {
        ASMoment *moment = self.moments[indexPath.section];
//        NSLog(@"%@", moment.dateComponents);
        asset = moment.assets[indexPath.item];
    } else {
        asset = self.assetsFetchResults[indexPath.item];
    }
    if (self.allowsImageEditing) {
        [self.imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (self.completionBlock && imageData) {
                self.completionBlock(@[imageData], nil);
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        return;
    }
    
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCachedAssets];
}

#pragma mark - event response(e__method)
- (void)e__confirmImagePickerAction {
    NSMutableArray *imageDatas = [NSMutableArray array];
    NSArray *selectedAssets = [self assetsAtIndexPaths:[self.collectionView indexPathsForSelectedItems]];
    __block NSInteger requestCompletedIndex = 0;
    for (PHAsset *asset in selectedAssets) {
        [self.imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData) [imageDatas addObject:imageData];
            requestCompletedIndex++;
            if (requestCompletedIndex > selectedAssets.count - 1) {
                if (self.completionBlock) self.completionBlock(imageDatas, nil);
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    
}

- (void)e__dismissImagePicker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - public method
- (void)customPageViews {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(e__confirmImagePickerAction)];
    [self.view addSubview:self.collectionView];
}

- (void)becomeEntrance {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(e__dismissImagePicker)];
}

#pragma mark - private method(__method)
#pragma mark - Asset Caching
- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // 预加载区域是可显示区域的两倍
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
//     比较是否显示的区域与之前预加载的区域有不同
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // 区分资源分别操作
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // 更新缓存
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // 存储预加载矩形已供比较
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];

    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset;
        if (self.allowsMoments) {
            ASMoment *moment = self.moments[indexPath.section];
            asset = moment.assets[indexPath.item];
        } else {
            asset = self.assetsFetchResults[indexPath.item];
        }
        
        [assets addObject:asset];
    }
    
    return assets;
}



#pragma mark - setup data
- (void)setupData {
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self resetCachedAssets];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

#pragma mark - getters and setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ASPhotoGridCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
        _collectionView.allowsMultipleSelection = self.allowsMultiSelected;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ASPhotoGridSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderReuseIdentifier];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 1;
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.sectionHeadersPinToVisibleBounds = YES;
        _flowLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 44);
        CGFloat row = self.rowLimit <= 0 ? 4 : self.rowLimit;
        CGFloat itemWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - row + 1) / row;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    }
    return _flowLayout;
}

- (void)setCompletionBlock:(ASImagePickerCompletionBlock)completionBlock {
    _completionBlock = completionBlock;
}

- (NSMutableArray *)moments {
    if (!_moments) {
        _moments = _assetsFetchResults ? [_assetsFetchResults as_filterAssetsByMomentGroupType:self.momentGroupType ascending:YES] : [NSMutableArray array];
    }
    return _moments;
}

//- (void)setAssetsFetchResults:(PHFetchResult *)assetsFetchResults {
//    _assetsFetchResults = assetsFetchResults;
//    NSMutableArray *moments = [allPhotos as_filterAssetsByMomentGroupType:ASMomentGroupTypeYear ascending:YES];
//}

- (void)setAllowsMultiSelected:(BOOL)allowsMultiSelected {
    _allowsMultiSelected = allowsMultiSelected;
}

- (void)setAllowsMoments:(BOOL)allowsMoments {
    _allowsMoments = allowsMoments;
    if (_allowsMoments) {
        self.flowLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 48);
    } else {
        self.flowLayout.headerReferenceSize = CGSizeZero;
    }
}

- (void)setAllowsMomentsAnimation:(BOOL)allowsMomentsAnimation {
    _allowsMomentsAnimation = allowsMomentsAnimation;
}

- (void)setEditing:(BOOL)editing {
    _allowsEditing = editing;
}

-(void)setAllowsImageEditing:(BOOL)allowsImageEditing {
    _allowsImageEditing = allowsImageEditing;
}

- (void)setShowsLivePhotoBadge:(BOOL)showsLivePhotoBadge {
    _showsLivePhotoBadge = showsLivePhotoBadge;
}

- (void)setImageLimit:(NSInteger)imageLimit {
    _imageLimit = imageLimit;
}

- (void)setRowLimit:(NSInteger)rowLimit {
    _rowLimit = rowLimit;
    CGFloat row = rowLimit <= 0 ? 4 : rowLimit;
    CGFloat itemWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - row + 1) / row;
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize = CGSizeMake(itemWidth, itemWidth);
    [self.collectionView reloadData];
}

//- (ASMomentGroupType)momentGroupType {
//    if (!_momentGroupType) {
//        _momentGroupType = ASMomentGroupTypeDay;
//    }
//    return _momentGroupType;
//}

@end
