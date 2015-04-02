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

@interface FINCamera : NSObject
@property (nonatomic,strong, readonly) AVCaptureSession * CaptureSession;

@property(nonatomic,assign,readonly)BOOL BackCameraAvailable;
@property(nonatomic,assign,readonly)BOOL FrontCameraAvailable;

@property(nonatomic,assign,readonly)BOOL UsingBackCamera;
@property(nonatomic,assign,readonly)BOOL UsingFrontCamera;

@property(nonatomic,strong,readonly)AVCaptureDevice * BackCameraDevice;
@property(nonatomic,strong,readonly)AVCaptureDevice * FrontCameraDevice;

@property(nonatomic,strong,readonly)UIView * Preview;

+(id)createWithBuilder:(void (^)(FINCamera * builder))block;

#pragma mark input
-(void)useBackCamera;
-(void)useFrontCamera;
-(void)toggleCamera;

#pragma mark output
-(void)useMetaDataOutput NS_AVAILABLE_IOS(7_0);
-(void)useVideoDataOutput;

#pragma mark preset
-(void)setPreset:(NSString *)preset;

-(UIView *)previewWithFrame:(CGRect)frame;

-(void)startSession;
-(void)stopSession;

@end
