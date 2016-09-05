//
//  PHFetchResult+Convenience.m
//  ASImagePickerDemo
//
//  Created by alan on 8/31/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "PHFetchResult+Convenience.h"

@implementation PHFetchResult (Convenience)

- (void)as_trimAlbumsWithFetchOption:(PHFetchOptions *)fetchOptions showsEmpty:(BOOL)showsEmpty completion:(void(^)(NSArray *results))completion {
    
    if (self.count == 0) {
        completion([NSArray array]);
        return;
    }
    
    NSMutableArray *results = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[PHAssetCollection class]]) {
            
            PHAssetCollection *collection = (PHAssetCollection *)obj;
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
            if ((result && result.count > 0) || showsEmpty) {
                [results addObject:obj];
            }
            
        }
        if (idx >= self.count - 1) {
            
            completion(results);
            
        }
    }];
}

@end
