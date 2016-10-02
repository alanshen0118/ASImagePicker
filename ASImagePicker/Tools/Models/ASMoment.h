//
//  ASMoment.h
//  ASImagePickerDemo
//
//  Created by alan on 9/20/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ASMomentGroupType) {
    ASMomentGroupTypeDay = 0,
    ASMomentGroupTypeMonth,
    ASMomentGroupTypeYear,
};

@interface ASMoment : NSObject

@property (strong, nonatomic) NSDateComponents *dateComponents;

@property (nonatomic) ASMomentGroupType momentGroupType;

@property (copy, nonatomic) NSMutableArray *assets;

@end
