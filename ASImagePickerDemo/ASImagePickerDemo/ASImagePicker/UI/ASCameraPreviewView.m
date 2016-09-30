//
//  ASCameraPreviewView.m
//  ASImagePickerDemo
//
//  Created by alan on 9/6/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

@import AVFoundation;

#import "ASCameraPreviewView.h"

@implementation ASCameraPreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
}

@end
