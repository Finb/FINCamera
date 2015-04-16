//
//  ViewController.m
//  FINCamera
//
//  Created by 黄丰 on 15/4/1.
//  Copyright (c) 2015年 com.FIN.FINCamera. All rights reserved.
//

#import "ViewController.h"
#import "FINCamera.h"

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,FINCameraDelagate>
@property(nonatomic,strong)FINCamera * camera;
@end

@implementation ViewController{
    CGFloat videoZoomFactor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    
    //Example
    __weak typeof(self) weakSelf = self;
    self.camera =[FINCamera createWithBuilder:^(FINCamera *builder) {
        // input
        [builder useBackCamera];
        // output
        [builder useVideoDataOutputWithDelegate:weakSelf];
        // delegate
        [builder setDelegate:weakSelf];
        // setting
        [builder setPreset:AVCaptureSessionPresetPhoto];
    }];
    [self.camera startSession];
    [self.view addSubview:[self.camera previewWithFrame:self.view.frame]];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
    
    UIPanGestureRecognizer * recognizer =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanFrom:)];
    [self.view addGestureRecognizer:recognizer];
}
-(void)handlePanFrom:(UIPanGestureRecognizer *)recognizer{
    CGPoint point = [recognizer translationInView:recognizer.view];
    videoZoomFactor -= point.y/self.view.frame.size.height/3;
    if(videoZoomFactor<0)
        videoZoomFactor=0;
    [self.camera setVideoZoomFactor:1+ videoZoomFactor];
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
-(void)camera:(FINCamera *)camera adjustingFocus:(BOOL)adjustingFocus{
    NSLog(@"%@",adjustingFocus?@"正在对焦":@"对焦完毕");
}
@end
