//
//  SCCameraViewController+RecordVideo.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/18.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCameraViewController+Private.h"
#import "SCCameraViewController+RecordVideo.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (RecordVideo)

#pragma mark - Public

- (void)startRecordVideo {
    if (self.isRecordingVideo) {
        return;
    }
    self.isRecordingVideo = YES;
    
    [[SCCameraManager shareManager] recordVideo];
    [self startVideoTimer];
    
    [self refreshUIWhenRecordVideo];
}

- (void)stopRecordVideo {
    if (!self.isRecordingVideo) {
        return;
    }
    @weakify(self);
    [[SCCameraManager shareManager] stopRecordVideoWithCompletion:^(NSString *videoPath) {
        @strongify(self);
        
        self.isRecordingVideo = NO;
        
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
        SCVideoModel *videoModel = [[SCVideoModel alloc] init];
        videoModel.filePath = videoPath;
        videoModel.asset = asset;
        [self.videos addObject:videoModel];
        
        [self endVideoTimer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshUIWhenRecordVideo];
        });
    }];
}

- (void)startVideoTimer {
    self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(videoTimerAction) userInfo:nil repeats:YES];
    [self.videoTimer fire];
}

- (void)endVideoTimer {
    [self.videoTimer invalidate];
    self.videoTimer = nil;
}

#pragma mark - Action

- (void)videoTimerAction {
    CMTime savedTime = kCMTimeZero;
    for (SCVideoModel *model in self.videos) {
        savedTime = CMTimeAdd(savedTime, model.asset.duration);
    }
    NSInteger timestamp = round(CMTimeGetSeconds(savedTime) + [SCCameraManager shareManager].currentDuration);
    self.videoTimeLabel.timestamp = timestamp;
}

@end

#pragma clang diagnostic pop
