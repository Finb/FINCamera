//
//  FINCamera.m
//  FINCamera
//
//  Created by 黄丰 on 15/4/1.
//  Copyright (c) 2015年 com.FIN.FINCamera. All rights reserved.
//

#import "FINCamera.h"

@implementation FINCamera


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

-(void)removeOutputs{
    for (AVCaptureOutput * output in self.CaptureSession.outputs) {
        [self.CaptureSession removeOutput:output];
    }
}
-(void)useMetaDataOutput{
    [self.CaptureSession beginConfiguration];
    
    [self removeOutputs];
    AVCaptureMetadataOutput * output =[AVCaptureMetadataOutput new];
//    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()]
    output.metadataObjectTypes=output.availableMetadataObjectTypes;
    [self.CaptureSession addOutput:output];
    
    [self.CaptureSession commitConfiguration];
}
-(void)useVideoDataOutput{
    
}
-(void)setPreset:(NSString *)preset{
    if([self.CaptureSession canSetSessionPreset:preset])
        self.CaptureSession.sessionPreset=preset;
    else{
        NSAssert(NO, @"set sessionPreset error");
    }
}

-(UIView *)previewWithFrame:(CGRect)frame{
    if(!_Preview){
        AVCaptureVideoPreviewLayer * perviewLayer=[AVCaptureVideoPreviewLayer layerWithSession:self.CaptureSession];
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
