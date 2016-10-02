//
//  ASMoment.m
//  ASImagePickerDemo
//
//  Created by alan on 9/20/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASMoment.h"

@implementation ASMoment

- (NSMutableArray *)assets {
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

@end
