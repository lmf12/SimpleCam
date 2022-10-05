//
//  SCAIManager.m
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/7.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import "SCHairSegmentationHandler.h"
#import "SCFaceAlignmentHandler.h"

#import "SCAIManager.h"

static SCAIManager *_AIManager;

@interface SCAIManager ()

@property (nonatomic, strong) SCHairSegmentationHandler *hairSegmentationHandler;
@property (nonatomic, strong) SCFaceAlignmentHandler *faceAlignmentHandler;

@end

@implementation SCAIManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _AIManager = [[SCAIManager alloc] init];
    });
    return _AIManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

- (CVPixelBufferRef)hairSegmentationPixelBufferWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    return [self.hairSegmentationHandler hairSegmentationPixelBufferWithPixelBuffer:pixelBuffer];
}

- (void)hairSegmentationWithSrcPixelBuffer:(CVPixelBufferRef)srcPixelBuffer
                                dstTexture:(id<MTLTexture>)dstTexture {
    return [self.hairSegmentationHandler hairSegmentationWithSrcPixelBuffer:srcPixelBuffer
                                                                 dstTexture:dstTexture];
}

- (void)detectFaceWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    [self.faceAlignmentHandler detectFaceWithPixelBuffer:pixelBuffer];
}

#pragma mark - Private

- (void)commonInit {
    self.hairSegmentationHandler = [[SCHairSegmentationHandler alloc] init];
    self.faceAlignmentHandler = [[SCFaceAlignmentHandler alloc] init];
}

@end
