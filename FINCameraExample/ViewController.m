//
//  ViewController.m
//  FINCamera
//
//  Created by 黄丰 on 15/4/1.
//  Copyright (c) 2015年 com.FIN.FINCamera. All rights reserved.
//

#import "ViewController.h"
#import "FINCamera.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    
    FINCamera * camera =[FINCamera createWithBuilder:^(FINCamera *builder) {
        [builder useBackCamera];
        [builder useVideoDataOutput];
        [builder setPreset:AVCaptureSessionPresetPhoto];
    }];
    [camera startSession];
    [self.view addSubview:[camera previewWithFrame:self.view.frame]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
