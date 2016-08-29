//
//  ASImagePickerController.m
//  ASImagePickerDemo
//
//  Created by alan on 8/29/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASImagePickerController.h"

@interface ASImagePickerController ()

@end

@implementation ASImagePickerController

#pragma mark - life cycle
- (instancetype)initWithCompletion:(ASImagePickerCompletionBlock)completion {
    ASAlbumListController *albumListVC = [[ASAlbumListController alloc] init];
    albumListVC.completionBlock = completion;
    self = [super initWithRootViewController:albumListVC];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response(e__method)

#pragma mark - customPageViews
- (void)customPageViews {
    
}

#pragma mark - public method

#pragma mark - private method(__method)

#pragma mark - setup data
- (void)setupData {

}

#pragma mark - getters and setters

@end
