//
//  ASAlbumCustomCell.h
//  ASImagePickerDemo
//
//  Created by alan on 8/25/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASAlbumCustomCell : UITableViewCell

@property (strong, nonatomic) UIImage *placeholderImage;

@property (strong, nonatomic) NSArray *thumbImages;

//@property (strong, nonatomic) NSString *localIdentifier;

@property (nonatomic) BOOL showsThumbImage;

- (void)customPageViews;

@end
