//
//  ViewController.m
//  ASImagePickerDemo
//
//  Created by alan on 8/24/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ViewController.h"
#import "ASImagePickerController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)pickImages:(id)sender {
    __block CGFloat currentY = 0.f;
    [self presentViewController:[[ASImagePickerController alloc] initWithCompletion:^(NSArray<id> *datas, NSError *error) {
        for (UIImageView *imageView in self.scrollView.subviews) {
            [imageView removeFromSuperview];
        }
        for (NSData *data in datas) {
            UIImage *image = [UIImage imageWithData:data];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(0, currentY, 100, 100);
            currentY += CGRectGetHeight(imageView.frame) + 10.f;
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), currentY);
            [self.scrollView addSubview:imageView];
        }
    }] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
