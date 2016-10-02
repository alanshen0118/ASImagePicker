//
//  ASCameraViewController.h
//  ASImagePickerDemo
//
//  Created by alan on 9/6/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

@import UIKit;

@interface ASCameraViewController : UIViewController

- (void)resumeInterruptedSession;

- (void)toggleMovieRecording;

- (void)changeCamera;

- (void)snapStillImage;

@end
