//
//  ASPhotoGridCell.m
//  ASImagePickerDemo
//
//  Created by alan on 8/26/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASPhotoGridCell.h"

@interface ASPhotoGridCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *livePhotoBadgeImageView;
@property (strong, nonatomic) CALayer *maskLayer;

@end

@implementation ASPhotoGridCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.livePhotoBadgeImageView.image = nil;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self.contentView.layer addSublayer:self.maskLayer];
    } else {
        [self.maskLayer removeFromSuperlayer];
    }
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

- (void)setLivePhotoBadgeImage:(UIImage *)livePhotoBadgeImage {
    _livePhotoBadgeImage = livePhotoBadgeImage;
    self.livePhotoBadgeImageView.image = livePhotoBadgeImage;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIImageView *)livePhotoBadgeImageView {
    if (!_livePhotoBadgeImageView) {
        _livePhotoBadgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _livePhotoBadgeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _livePhotoBadgeImageView.clipsToBounds = YES;
        [self.contentView insertSubview:_livePhotoBadgeImageView aboveSubview:self.imageView];
    }
    return _livePhotoBadgeImageView;
}

- (CALayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CALayer layer];
        _maskLayer.frame = self.bounds;
        _maskLayer.contents = (id)[UIImage imageNamed:@"mask"].CGImage;
        _maskLayer.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.2f].CGColor;
    }
    return _maskLayer;
}

@end
