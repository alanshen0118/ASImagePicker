//
//  PHFetchResult+Convenience.m
//  ASImagePickerDemo
//
//  Created by alan on 8/31/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "PHFetchResult+Convenience.h"
@import Photos;

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

- (NSMutableArray<ASMoment *> *)as_filterAssetsByMomentGroupType:(ASMomentGroupType)momentGroupType ascending:(BOOL)ascending {
    
    if (!self.firstObject) {
        return nil;
    }
    
    PHFetchResult *result = nil;
    
    if ([self.firstObject isKindOfClass:[PHAssetCollection class]]) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:ascending]];
        result = [PHAsset fetchAssetsInAssetCollection:self.firstObject options:options];
    }
    
    if ([self.firstObject isKindOfClass:[PHAsset class]]) {
        result = self;
    }
    
    return [self sortMomentWithMomentGroupType:momentGroupType assets:result];
    
}

- (NSMutableArray<ASMoment *> *)sortMomentWithMomentGroupType:(ASMomentGroupType)momentGroupType assets:(PHFetchResult *)assets {
    
    ASMoment *lastGroup = nil;
    
    NSMutableArray *groups = [NSMutableArray array];
    
    
    for (PHAsset *asset in assets) {
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay   |
                                        NSCalendarUnitMonth |
                                        NSCalendarUnitYear
                                                                       fromDate:[asset creationDate]];
        NSUInteger month = [components month];
        NSUInteger year  = [components year];
        NSUInteger day   = [components day];
        
        switch (momentGroupType) {
            case ASMomentGroupTypeYear:
                
                if (lastGroup && lastGroup.dateComponents.year == year) break;
                
            case ASMomentGroupTypeMonth:
                
                if (lastGroup && lastGroup.dateComponents.year == year && lastGroup.dateComponents.month == month) break;
                
            case ASMomentGroupTypeDay:
                
                if (lastGroup && lastGroup.dateComponents.year == year && lastGroup.dateComponents.month == month &&lastGroup.dateComponents.day == day) break;
                
            default:
                
                lastGroup = [ASMoment new];
                lastGroup.dateComponents = components;
                [groups addObject:lastGroup];
                break;
                
        }
        
        [lastGroup.assets addObject:asset];
        
    }
    return groups;
    
}

@end
