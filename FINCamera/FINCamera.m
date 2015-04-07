//
//  FINCamera.m
//  FINCamera
//
//  Created by 黄丰 on 15/4/1.
//  Copyright (c) 2015年 com.FIN.FINCamera. All rights reserved.
//

#import "FINCamera.h"

@implementation FINCamera{
    AVCaptureVideoPreviewLayer * _perviewLayer;
}


-(BOOL)BackCameraAvailable{
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]){
        if (device.position == AVCaptureDevicePositionBack)
            return YES;
    }
    return NO;
}
-(BOOL)FrontCameraAvailable{
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]){
        if (device.position == AVCaptureDevicePositionFront)
            return YES;
    }
    return NO;
}


-(BOOL)UsingBackCamera{
    for (AVCaptureDeviceInput *input in self.CaptureSession.inputs){
        if ([input.device.uniqueID isEqual:self.BackCameraDevice.uniqueID])
            return YES;
    }
    return NO;
}
-(BOOL)UsingFrontCamera{
    for (AVCaptureDeviceInput *input in self.CaptureSession.inputs){
        if ([input.device.uniqueID isEqual:self.FrontCameraDevice.uniqueID])
            return YES;
    }
    return NO;
}


-(AVCaptureDevice *)BackCameraDevice{
    for (AVCaptureDevice * device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if(device.position == AVCaptureDevicePositionBack)
            return device;
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}
-(AVCaptureDevice *)FrontCameraDevice{
    for (AVCaptureDevice * device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if(device.position == AVCaptureDevicePositionFront)
            return device;
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}


-(id)init{
    self=[super init];
    if(self){
        _CaptureSession=[[AVCaptureSession alloc]init];
        _CaptureSession.sessionPreset=AVCaptureSessionPresetPhoto;
    }
    return self;
}
+(id)createWithBuilder:(void (^)(FINCamera *))block{
    FINCamera * camera  =[[FINCamera alloc]init];
    if(camera){
        if(block){
            block(camera);
        }
    }
    return camera;
}


-(void)useDevice:(AVCaptureDevice *)device{
    
    [self.CaptureSession beginConfiguration];
    
    for (AVCaptureInput *input in self.CaptureSession.inputs)
        [self.CaptureSession removeInput:input];
    
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [self.CaptureSession addInput:captureInput];
    
    [self.CaptureSession commitConfiguration];
}
-(void)useBackCamera{
    [self useDevice:self.BackCameraDevice];
}
-(void)useFrontCamera{
    [self useDevice:self.FrontCameraDevice];
}
-(void)toggleCamera{
    if(self.UsingFrontCamera){
        [self useBackCamera];
    }
    else if(self.BackCameraDevice){
        [self useFrontCamera];
    }
    else{
        return;
    }
}
-(AVCaptureDevice *)currentDevice{
    return self.UsingBackCamera?self.BackCameraDevice:
    (self.UsingFrontCamera?self.FrontCameraDevice:nil);
}

-(void)removeOutputs{
    for (AVCaptureOutput * output in self.CaptureSession.outputs) {
        [self.CaptureSession removeOutput:output];
    }
}
-(void)useMetaDataOutputWithDelegate:(id<AVCaptureMetadataOutputObjectsDelegate>)delegate{
    [self.CaptureSession beginConfiguration];
    
    [self removeOutputs];
    AVCaptureMetadataOutput * output =[AVCaptureMetadataOutput new];
    [output setMetadataObjectsDelegate:delegate queue:dispatch_get_main_queue()];
    output.metadataObjectTypes=output.availableMetadataObjectTypes;
    [self.CaptureSession addOutput:output];
    
    [self.CaptureSession commitConfiguration];
}
-(void)useVideoDataOutputWithDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate{
    [self.CaptureSession beginConfiguration];
    
    [self removeOutputs];
    
    AVCaptureVideoDataOutput * output =[AVCaptureVideoDataOutput new];
    output.videoSettings =[NSDictionary dictionaryWithObject:
                           [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [output setSampleBufferDelegate:delegate queue:dispatch_queue_create("SampleBufferQueue", NULL)];
    [self.CaptureSession addOutput:output];
    
    [self.CaptureSession commitConfiguration];
}
-(void)setPreset:(NSString *)preset{
    if([self.CaptureSession canSetSessionPreset:preset])
        self.CaptureSession.sessionPreset=preset;
    else{
        NSAssert(NO, @"set sessionPreset error");
    }
}

-(BOOL)pointFocusAvailable{
    AVCaptureDevice * device = [self currentDevice];
    if(device && device.focusPointOfInterestSupported && device.exposurePointOfInterestSupported){
        return YES;
    }
    return NO;
}
-(BOOL)supportsTorchMode{
    AVCaptureDevice * device =[self currentDevice];
    if(device && [device hasTorch] && [device isTorchModeSupported:AVCaptureTorchModeOn]){
        return YES;
    }
    return NO;
}
-(BOOL)isTorchModeOn{
    if([self supportsTorchMode]){
        return [self currentDevice].torchMode==AVCaptureTorchModeOn;
    }
    return NO;
}
-(void)toggleTorchMode{
    if([self supportsTorchMode]){
        AVCaptureDevice * device =[self currentDevice];
        if([device lockForConfiguration:nil]){
            device.torchMode=device.torchMode==AVCaptureTorchModeOn?AVCaptureTorchModeOff:AVCaptureTorchModeOn;
        }
        [device unlockForConfiguration];
    }
    else{
        NSAssert(NO, @"device can't toggle Torch Mode");
    }
}
-(void)focusAtPoint:(CGPoint)touchPoint{
    CGPoint pointOfInterest =[_perviewLayer captureDevicePointOfInterestForPoint:touchPoint];
    AVCaptureDevice * device =[self currentDevice];
    if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.focusPointOfInterest = pointOfInterest;
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            
            if(device.isExposurePointOfInterestSupported && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]){
                device.exposurePointOfInterest=pointOfInterest;
                device.exposureMode=AVCaptureExposureModeContinuousAutoExposure;
            }
            
            [device unlockForConfiguration];
        }
    }
}
-(void)setVideoZoomFactor:(CGFloat)videoZoomFactor{
    if(videoZoomFactor<1){
        NSAssert(NO, @"Must be greater than zero");
    }
    AVCaptureDevice * device =[self currentDevice];
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        [device setVideoZoomFactor:videoZoomFactor];
        [device unlockForConfiguration];
    }
}
-(CGFloat)getVideoZoomFactor{
    AVCaptureDevice * device =[self currentDevice];
    return device.videoZoomFactor;
}
-(UIView *)previewWithFrame:(CGRect)frame{
    if(!_Preview){
        AVCaptureVideoPreviewLayer * perviewLayer=[AVCaptureVideoPreviewLayer layerWithSession:self.CaptureSession];
        _perviewLayer=perviewLayer;
        if(perviewLayer){
            perviewLayer.frame=frame;
            perviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
            _Preview=[[UIView alloc]initWithFrame:frame];
            [_Preview.layer addSublayer:perviewLayer];
        }
    }
    return _Preview;
}
-(void)startSession{
    if(!self.CaptureSession.running)
        [self.CaptureSession startRunning];
}
-(void)endSession{
    [self.CaptureSession stopRunning];
}
@end
