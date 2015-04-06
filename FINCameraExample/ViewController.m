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
@property(nonatomic,strong)FINCamera * camera;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
        self.camera =[FINCamera createWithBuilder:^(FINCamera *builder) {
        // input
        [builder useBackCamera];
        // output
//        [builder useVideoDataOutputWithDelegate:weakSelf];
        // setting
        [builder setPreset:AVCaptureSessionPresetPhoto];
    }];
    [self.camera startSession];
    [self.view addSubview:[self.camera previewWithFrame:self.view.frame]];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
}
-(void)tapClick:(UIGestureRecognizer *)sender{
    CGPoint touchPoint = [sender locationInView:self.view];
    [self.camera focusAtPoint:touchPoint];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"TEST");
}
@end
