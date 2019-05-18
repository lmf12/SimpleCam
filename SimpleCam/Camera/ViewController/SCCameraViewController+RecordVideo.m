//
//  SCCameraViewController+RecordVideo.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/18.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCameraManager.h"

#import "SCCameraViewController+Private.h"
#import "SCCameraViewController+RecordVideo.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (RecordVideo)

- (void)startRecordVideo {
    if (self.isRecordingVideo) {
        return;
    }
    self.isRecordingVideo = YES;
    [[SCCameraManager shareManager] recordVideoWithFilters:self.currentFilters];
}

- (void)stopRecordVideo {
    if (!self.isRecordingVideo) {
        return;
    }
    @weakify(self);
    [[SCCameraManager shareManager] stopRecordVideoWithCompletion:^(NSString *videoPath) {
        @strongify(self);
        
        self.isRecordingVideo = NO;
        
        SCVideoModel *videoModel = [[SCVideoModel alloc] init];
        videoModel.filePath = videoPath;
        [self.videos addObject:videoModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SCVideoResultViewController *vc = [[SCVideoResultViewController alloc] init];
            vc.videos = self.videos;
            [self.navigationController pushViewController:vc animated:NO];
        });
    }];
}

@end

#pragma clang diagnostic pop
