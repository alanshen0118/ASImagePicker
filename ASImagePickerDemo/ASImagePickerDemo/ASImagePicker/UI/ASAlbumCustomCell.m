//
//  ASAlbumCustomCell.m
//  ASImagePickerDemo
//
//  Created by alan on 8/25/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASAlbumCustomCell.h"
#import <PhotosUI/PhotosUI.h>

@interface ASAlbumCustomCell ()

@property (strong, nonatomic) UIImageView *frontImageView;

@property (strong, nonatomic) UIImageView *middleImageView;

@property (strong, nonatomic) UIImageView *lastImageView;

@property (strong, nonatomic) UILabel *albumNameLabel;

@property (strong, nonatomic) UILabel *photoCountLabel;

@end

@implementation ASAlbumCustomCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customPageViews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - public method
- (void)customPageViews {
    if (!self.showsThumbImage) {
        return;
    }
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    CGSize itemSize = CGSizeMake(65.f, 65.f);
    
    UIGraphicsBeginImageContext(itemSize);
    
    CGRect imageRect = CGRectMake(0.f, 0.f, itemSize.width, itemSize.height);
    
    [self.imageView.image drawInRect:imageRect];
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    for (int i = 0; i < self.thumbImages.count; i++) {
        switch (i) {
            case 0:{
//                self.frontImageView.image = self.placeholderImage;
                self.frontImageView.image = self.thumbImages[i];
                break;
            }
            case 1:{
//                self.middleImageView.image = self.placeholderImage;
                self.middleImageView.image = self.thumbImages[i];
                break;
            }
            case 2:{
//                self.lastImageView.image = self.placeholderImage;
                self.lastImageView.image = self.thumbImages[i];
                break;
            }
            default:
                break;
        }
    }
    
}

#pragma mark - lazy load
- (UIImageView *)frontImageView {
    if (!_frontImageView) {
        _frontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 69, 69)];
        _frontImageView.contentMode = UIViewContentModeScaleAspectFill;
        _frontImageView.clipsToBounds = YES;
        [self.contentView addSubview:_frontImageView];
    }
    return _frontImageView;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 65, 65)];
        _middleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _middleImageView.clipsToBounds = YES;
        [self.contentView insertSubview:_middleImageView belowSubview:self.frontImageView];
    }
    return _middleImageView;
}

- (UIImageView *)lastImageView {
    if (!_lastImageView) {
        _lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, 61, 61)];
        _lastImageView.contentMode = UIViewContentModeScaleAspectFill;
        _lastImageView.clipsToBounds = YES;
        [self.contentView insertSubview:_lastImageView belowSubview:self.middleImageView];
    }
    return _lastImageView;
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    [self customPageViews];
}

- (void)setThumbImages:(NSArray *)thumbImages {
    _thumbImages = thumbImages;
    [self customPageViews];
}

- (UILabel *)albumNameLabel {
    if (!_albumNameLabel) {
    }
    return _albumNameLabel;
}

- (void)setShowsThumbImage:(BOOL)showsThumbImage {
    _showsThumbImage = showsThumbImage;
    [self customPageViews];
}

@end
