//
//  ASCameraPreviewView.h
//  ASImagePickerDemo
//
//  Created by alan on 9/6/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

@import UIKit;

@class AVCaptureSession;

@interface ASCameraPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
