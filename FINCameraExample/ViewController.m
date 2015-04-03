//
//  ViewController.m
//  FINCamera
//
//  Created by 黄丰 on 15/4/1.
//  Copyright (c) 2015年 com.FIN.FINCamera. All rights reserved.
//

#import "ViewController.h"
#import "FINCamera.h"

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    FINCamera * camera =[FINCamera createWithBuilder:^(FINCamera *builder) {
        // input
        [builder useFrontCamera];
        // output
        [builder useVideoDataOutputWithDelegate:weakSelf];
        // setting
        [builder setPreset:AVCaptureSessionPresetPhoto];
    }];
    [camera startSession];
    [self.view addSubview:[camera previewWithFrame:self.view.frame]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (YES) {
            sleep(3);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [camera toggleCamera];
                [camera toggleTorchMode];
            });
        }
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"TEST");
}
@end
