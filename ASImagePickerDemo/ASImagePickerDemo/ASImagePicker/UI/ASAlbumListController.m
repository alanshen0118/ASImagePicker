//
//  ASAlbumListController.m
//  ASImagePickerDemo
//
//  Created by alan on 8/25/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASAlbumListController.h"
#import "ASAlbumCustomCell.h"
#import "PHFetchResult+Convenience.h"

@import Photos;

@interface ASAlbumListController ()<UITableViewDataSource, UITableViewDelegate, PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionFetchResults;

@property (nonatomic, strong) NSMutableArray *sectionResults;

@property (nonatomic, strong) NSArray *sectionLocalizedTitles;

@end

@implementation ASAlbumListController

static NSString * const AllPhotosReuseIdentifier = @"AS_AllPhotosCell";
static NSString * const CollectionCellReuseIdentifier = @"AS_CollectionCell";
static const float ListRowHeight = 89.f;

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self customPageViews];
    [self setupData];
    //注册观察相册变化的观察者
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)dealloc {
    //销毁观察相册变化的观察者
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - customPageViews
- (void)customPageViews {
    self.navigationItem.title = @"Photos";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(e__dismissImagePickerController)];
    [self.view addSubview:self.tableView];
}

#pragma mark - system delegate
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ASPhotoGridController *gridViewController = [[ASPhotoGridController alloc] init];
    gridViewController.completionBlock = self.completionBlock;
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    
    if (indexPath.section == 0) {
        gridViewController.assetsFetchResults = fetchResult;
    } else {
        // 获取选择行的PHAssetCollection
        NSArray *sections = self.sectionResults[indexPath.section];
        if (!sections || sections.count < indexPath.row) return;
        PHCollection *collection = sections[indexPath.row];
        if (![collection isKindOfClass:[PHAssetCollection class]]) return;
        
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:self.fetchPhotosOptions];
        
        gridViewController.assetsFetchResults = assetsFetchResult;
        gridViewController.assetCollection = assetCollection;
    }
    
    [self.navigationController pushViewController:gridViewController animated:YES];
}

#pragma mark -- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASAlbumCustomCell *cell = nil;
    PHFetchResult *fetchResult = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:AllPhotosReuseIdentifier forIndexPath:indexPath];
        fetchResult = self.sectionResults[indexPath.section];
        
        cell.textLabel.text = NSLocalizedString(@"All Photos", @"");
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CollectionCellReuseIdentifier forIndexPath:indexPath];
        if (!self.sectionResults || self.sectionResults.count <= indexPath.section) return nil;
        NSArray *collections = self.sectionResults[indexPath.section];
        if (!collections || collections.count <= indexPath.row) return nil;
        PHCollection *collection = collections[indexPath.row];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            fetchResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)collection options:self.fetchPhotosOptions];
            cell.textLabel.text = collection.localizedTitle;
        }
        //相册名
        
    }
    __block NSInteger fetchImageIndex = 0;
    NSMutableArray *thumbsImages = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < MIN(fetchResult.count, 3); i++) {
        fetchImageIndex++;
        [[PHCachingImageManager defaultManager] requestImageForAsset:fetchResult[i] targetSize:CGSizeMake(69, 69) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) [thumbsImages addObject:result];
            if (--fetchImageIndex == 0) {
                cell.thumbImages = thumbsImages;
                [cell layoutSubviews];
            }
        }];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zi", fetchResult.count];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        numberOfRows = 1;
    } else {
        if ([self.sectionResults[section] isKindOfClass:[NSArray class]]) {
            NSArray *results = self.sectionResults[section];
            numberOfRows = results.count;
        }
    }
    
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionResults.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionLocalizedTitles && self.sectionLocalizedTitles.count > section ? self.sectionLocalizedTitles[section] : @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ListRowHeight;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    //观察者，在后台队列执行，所以刷新界面需要在主队列中
    dispatch_async(dispatch_get_main_queue(), ^{
        //深拷贝，备份比较
        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        __block BOOL reloadRequired = NO;
        
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            //根据原先的相片集的数据创建变化对象
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            //判断变化对象是否为空，不为空则代表有相册有变化
            if (changeDetails != nil) {
                //变化后的数据替换变化前的数据
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        
        if (reloadRequired) {
            //刷新数据
            self.sectionFetchResults = updatedSectionFetchResults;
            [self.tableView reloadData];
        }
        
    });
}

#pragma mark - event response(e__method)
- (void)e__dismissImagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - public method

#pragma mark - private method(p__method)

#pragma mark - setup data
- (void)setupData {
    //reset
    self.sectionResults = nil;
    self.sectionLocalizedTitles = nil;
    self.sectionFetchResults = nil;
    
    //获取所有图片资源
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:self.fetchPhotosOptions];
    if (allPhotos) [self.sectionResults addObject:allPhotos];
    //获取智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:self.fetchAlbumsOptions];
    
    //获取用户自定义相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:self.fetchAlbumsOptions];
    NSMutableArray *sectionsLocalizedTitles = [NSMutableArray arrayWithObject:@""];
    [smartAlbums as_trimAlbumsWithFetchOption:self.fetchAlbumsOptions showsEmpty:self.showsEmptyAlbum completion:^(NSArray *results) {
        if (results) {
            [self.sectionResults addObject:results];
            NSString *sectionTitle = results.count > 0 && self.showsAlbumCategory ? NSLocalizedString(@"Smart Albums", @"") : @"";
            [sectionsLocalizedTitles addObject:sectionTitle];
        }
        [topLevelUserCollections as_trimAlbumsWithFetchOption:self.fetchAlbumsOptions showsEmpty:self.showsEmptyAlbum completion:^(NSArray *userResults) {
            if (userResults) {
                [self.sectionResults addObject:userResults];
                NSString *sectionTitle = userResults.count > 0 && self.showsAlbumCategory ? NSLocalizedString(@"Albums", @"") : @"";
                [sectionsLocalizedTitles addObject:sectionTitle];
            }
            // Store the PHFetchResult objects and localized titles for each section.
            self.sectionLocalizedTitles = sectionsLocalizedTitles;
            self.sectionFetchResults = @[allPhotos, smartAlbums, topLevelUserCollections];
        }];
    }];
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ASAlbumCustomCell class] forCellReuseIdentifier:AllPhotosReuseIdentifier];
        [_tableView registerClass:[ASAlbumCustomCell class] forCellReuseIdentifier:CollectionCellReuseIdentifier];
    }
    return _tableView;
}

- (PHFetchOptions *)getFetchAlbumsOptions {
    if (!_fetchAlbumsOptions) {
        
        _fetchAlbumsOptions = [[PHFetchOptions alloc] init];
        //图片配置设置排序规则
        _fetchAlbumsOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
    }
    return _fetchAlbumsOptions;
}

- (PHFetchOptions *)getFetchPhotosOptions {
    if (!_fetchPhotosOptions) {
        
        _fetchPhotosOptions = [[PHFetchOptions alloc] init];
        //图片配置设置排序规则
        _fetchPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    }
    return _fetchPhotosOptions;
}

- (NSMutableArray *)sectionResults {
    if (!_sectionResults) {
        _sectionResults = [NSMutableArray array];
    }
    return _sectionResults;
}

- (void)setFetchAlbumsOptions:(PHFetchOptions *)fetchAlbumsOptions {
    _fetchAlbumsOptions = fetchAlbumsOptions;
}

- (void)setFetchPhotosOptions:(PHFetchOptions *)fetchPhotosOptions {
    _fetchPhotosOptions = fetchPhotosOptions;
}

- (void)setAllowsMoments:(BOOL)allowsMoments {
    _allowsMoments = allowsMoments;
}

- (void)setShowsEmptyAlbum:(BOOL)showsEmptyAlbum {
    _showsEmptyAlbum = showsEmptyAlbum;
    [self setupData];
}

- (void)setShowsAlbumNumber:(BOOL)showsAlbumNumber {
    _showsAlbumNumber = showsAlbumNumber;
}

- (void)setShowsAlbumThumbImage:(BOOL)showsAlbumThumbImage {
    _showsAlbumThumbImage = showsAlbumThumbImage;
}

- (void)setShowsAlbumCategory:(BOOL)showsAlbumCategory {
    _showsAlbumCategory = showsAlbumCategory;
    [self setupData];
}

@end
