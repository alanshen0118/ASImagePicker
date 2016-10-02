//
//  ASPhotoGridSectionHeaderView.m
//  ASImagePickerDemo
//
//  Created by alan on 9/5/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASPhotoGridSectionHeaderView.h"

@interface ASPhotoGridSectionHeaderView ()

@end

@implementation ASPhotoGridSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor clearColor];
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView * effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        [self addSubview:effectview];
        [self addSubview:self.textLabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeLeft multiplier:1.f constant:-8.f]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15.f];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

@end
