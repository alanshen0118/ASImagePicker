//
//  PHFetchResult+Convenience.h
//  ASImagePickerDemo
//
//  Created by alan on 8/31/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <Photos/Photos.h>
#import "ASMoment.h"

@interface PHFetchResult (Convenience)

- (void)as_trimAlbumsWithFetchOption:(PHFetchOptions *)fetchOptions showsEmpty:(BOOL)showsEmpty completion:(void(^)(NSArray *results))completion;

- (NSMutableArray<ASMoment *> *)as_filterAssetsByMomentGroupType:(ASMomentGroupType)momentGroupType ascending:(BOOL)ascending;

@end
