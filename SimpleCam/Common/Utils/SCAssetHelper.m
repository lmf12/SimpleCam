//
//  SCAssetHelper.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/25.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "SCAssetHelper.h"

@implementation SCAssetHelper

#pragma mark - Public

+ (UIImage *)videoPreviewImageWithURL:(NSURL *)url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time
                                                 actualTime:nil
                                                      error:&error];
    if (error) {
        NSAssert(NO, error.description);
    }
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return videoImage;
}

+ (void)mergeVideos:(NSArray *)videoPaths toExportPath:(NSString *)exportPath completion:(void (^)(void))completion {
    AVComposition *composition = [self compositionWithVideos:videoPaths];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = [NSURL fileURLWithPath:exportPath];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
}

#pragma mark - Private

+ (AVComposition *)compositionWithVideos:(NSArray *)videoPaths {
    return [self compositionWithVideos:videoPaths needsAudioTracks:YES];
}

/// 获取合并视频后的Composition
+ (AVComposition *)compositionWithVideos:(NSArray *)videoPaths
                        needsAudioTracks:(BOOL)needsAudioTracks {
    AVMutableComposition* mergeComposition = [AVMutableComposition composition];
    
    CMTime time = kCMTimeZero;
    
    // 视频轨道
    NSMutableArray *compositionVideoTracks = [NSMutableArray arrayWithCapacity:0];
    AVMutableCompositionTrack *compositionVideoTrack =
    [mergeComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                  preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTracks addObject:compositionVideoTrack];
    
    // 音频轨道
    NSMutableArray *compositionAudioTracks = nil;
    if (needsAudioTracks) {
        compositionAudioTracks = [NSMutableArray arrayWithCapacity:0];
        AVMutableCompositionTrack *compositionAudioTrack =
        [mergeComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                      preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTracks addObject:compositionAudioTrack];
    }
    
    for (NSInteger index = 0; index < videoPaths.count; index++) {
        NSString *videoPath = videoPaths[index];
        NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset* asset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:videoPath] options:inputOptions];
        
        // 视频轨道
        NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        NSInteger videoDelta = [videoTracks count] - [compositionVideoTracks count];
        if (videoDelta > 0) {
            for (int i = 0; i < videoDelta; i ++) {
                AVMutableCompositionTrack *insertCompositionVideoTrack =
                [mergeComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                              preferredTrackID:kCMPersistentTrackID_Invalid];
                [compositionVideoTracks addObject:insertCompositionVideoTrack];
            }
        }
        for (int i = 0; i < [videoTracks count]; i ++) {
            AVAssetTrack *videoTrack = [videoTracks objectAtIndex:i];
            AVMutableCompositionTrack *currentVideoCompositionTrack = [compositionVideoTracks objectAtIndex:i];
            [currentVideoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                                  ofTrack:videoTrack
                                                   atTime:time error:nil];
            if (index == 0) {
                [currentVideoCompositionTrack setPreferredTransform:videoTrack.preferredTransform];
            }
        }
        
        // 音频轨道
        if (needsAudioTracks) {
            NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
            NSInteger audioDelta = [audioTracks count] - [compositionAudioTracks count];
            if (audioDelta > 0) {
                for (int i = 0; i < audioDelta; i ++) {
                    AVMutableCompositionTrack *insertCompositionAudioTrack =
                    [mergeComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                  preferredTrackID:kCMPersistentTrackID_Invalid];
                    [compositionAudioTracks addObject:insertCompositionAudioTrack];
                }
            }
            
            for (int i = 0; i < [audioTracks count]; i ++) {
                AVAssetTrack *audioTrack = [audioTracks objectAtIndex:i];
                AVMutableCompositionTrack *currentAudioCompositionTrack = [compositionAudioTracks objectAtIndex:i];
                [currentAudioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                                      ofTrack:audioTrack
                                                       atTime:time error:nil];
            }
        }
        
        time = CMTimeAdd(time, asset.duration);
    }
    return mergeComposition;
}

@end
