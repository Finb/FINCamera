//
//  FINCameraTests.m
//  FINCamera
//
//  Created by 黄丰 on 15/4/1.
//  Copyright (c) 2015年 com.FIN.FINCamera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FINCamera.h"
@interface FINCameraTests :  XCTestCase

@end

@implementation FINCameraTests{
    FINCamera * _camera;
}

- (void)setUp {
    [super setUp];
    _camera =[FINCamera createWithBuilder:^(FINCamera *builder) {
    }];
}

- (void)tearDown {
    [super tearDown];
    _camera =nil;
}
-(void)testInit{
    XCTAssertNotNil(_camera);
}

-(void)testBackCamera{
    if(_camera.BackCameraAvailable)
        XCTAssertNotNil(_camera.BackCameraDevice);
}
-(void)testFrontCamera{
    if(_camera.FrontCameraAvailable)
        XCTAssertNotNil(_camera.FrontCameraDevice);
}

-(void)testUseBackAndFrontCamera{
    FINCamera * camera =[FINCamera createWithBuilder:^(FINCamera *builder) {
        [builder useBackCamera];
    }];
    XCTAssertTrue(camera.UsingBackCamera);
    XCTAssertFalse(camera.UsingFrontCamera);
 
    [camera useFrontCamera];
    XCTAssertFalse(camera.UsingBackCamera);
    XCTAssertTrue(camera.UsingFrontCamera);
}
-(void)testToggleCamera{
    FINCamera * camera =[FINCamera createWithBuilder:^(FINCamera *builder) {
        [builder useBackCamera];
    }];
    XCTAssertTrue(camera.UsingBackCamera);
    XCTAssertFalse(camera.UsingFrontCamera);
    
    [camera toggleCamera];
    XCTAssertFalse(camera.UsingBackCamera);
    XCTAssertTrue(camera.UsingFrontCamera);
    
    [camera toggleCamera];
    XCTAssertTrue(camera.UsingBackCamera);
    XCTAssertFalse(camera.UsingFrontCamera);
}
-(void)testPreviewNotNil{
    XCTAssertNotNil([_camera previewWithFrame:CGRectZero]);
    XCTAssertNotNil(_camera.Preview);
}
-(void)testUseMetaDataOutput{
    
}
-(void)testUseVideoDataOutput{
    
}
@end
