//
//  FINCamera.h
//  FINCamera
//
//  Created by 黄丰 on 15/4/1.
//  Copyright (c) 2015年 com.FIN.FINCamera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import<QuartzCore/QuartzCore.h>


@class FINCamera ;
@protocol FINCameraDelagate <NSObject>
@optional
- (void)camera:(FINCamera *)camera adjustingFocus:(BOOL)adjustingFocus;
@end


@interface FINCamera : NSObject
@property (nonatomic,strong, readonly) AVCaptureSession * CaptureSession;

@property(nonatomic,assign,readonly)BOOL BackCameraAvailable;
@property(nonatomic,assign,readonly)BOOL FrontCameraAvailable;

@property(nonatomic,assign,readonly)BOOL UsingBackCamera;
@property(nonatomic,assign,readonly)BOOL UsingFrontCamera;

@property(nonatomic,readonly)AVCaptureDevice * BackCameraDevice;
@property(nonatomic,readonly)AVCaptureDevice * FrontCameraDevice;

@property(nonatomic,strong,readonly)UIView * Preview;

@property(nonatomic,weak)id<FINCameraDelagate> delegate;

+(id)createWithBuilder:(void (^)(FINCamera * builder))block;

#pragma mark input
-(void)useBackCamera;
-(void)useFrontCamera;
-(void)toggleCamera;
-(AVCaptureDevice *)currentDevice;

#pragma mark output
-(void)useMetaDataOutputWithDelegate:(id<AVCaptureMetadataOutputObjectsDelegate>)delegate NS_AVAILABLE_IOS(7_0);
-(void)useVideoDataOutputWithDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate;
-(void)useStillImageOutput;

- (void)captureStillImageWithCompletionHandler:(void (^)(UIImage * image)) block;

#pragma mark preset
-(void)setPreset:(NSString *)preset;

#pragma mark focus
-(BOOL)pointFocusAvailable;
-(void)focusAtPoint:(CGPoint)touchPoint;

#pragma mark Torch
- (BOOL) supportsTorchMode;
- (BOOL) isTorchModeOn;
- (void) toggleTorchMode;

#pragma mark flash
- (BOOL) supportsFlashMode;
- (void) SwitchFlashMode:(AVCaptureFlashMode)flashModel;

-(void)setVideoZoomFactor:(CGFloat)videoZoomFactor NS_AVAILABLE_IOS(7_0);
-(CGFloat)getVideoZoomFactor NS_AVAILABLE_IOS(7_0);

-(UIView *)previewWithFrame:(CGRect)frame;

-(void)startSession;
-(void)endSession;

@end


