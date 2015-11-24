# Usage
```objc
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
```
