//
//  SCFaceRecognitionHandler.m
//  SimpleCam
//
//  Created by Lyman Li on 2022/10/5.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#include <fstream>

#import "SCTNNHelper.h"

#import "SCFaceRecognitionHandler.h"
#import "SCFaceDetectorHandler.h"
#import "SCFaceAlignmentHandler.h"

@interface SCFaceRecognitionHandler ()

@property (nonatomic, strong) SCFaceDetectorHandler *faceDetectorHandler;

@property (nonatomic, assign) shared_ptr<Instance> faceAlignment1;
@property (nonatomic, assign) shared_ptr<Instance> faceAlignment2;

@end

@implementation SCFaceRecognitionHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

- (void)detectFaceWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    [self.faceDetectorHandler detectFaceWithPixelBuffer:pixelBuffer];
}

#pragma mark - Private

- (void)commonInit {
    self.faceDetectorHandler = [[SCFaceDetectorHandler alloc] init];
    
    [self setupFaceAlignment1];
    [self setupFaceAlignment2];
}

- (void)setupFaceAlignment1 {
    NSString *protoPath = [[NSBundle mainBundle] pathForResource:@"youtu_face_alignment_phase1"
                                                          ofType:@"tnnproto"];
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"youtu_face_alignment_phase1"
                                                          ofType:@"tnnmodel"];
    self.faceAlignment1 = [SCTNNHelper createInstanceWithProtoPath:protoPath modelPath:modelPath];
}

- (void)setupFaceAlignment2 {
    NSString *protoPath = [[NSBundle mainBundle] pathForResource:@"youtu_face_alignment_phase2"
                                                          ofType:@"tnnproto"];
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"youtu_face_alignment_phase2"
                                                          ofType:@"tnnmodel"];
    self.faceAlignment2 = [SCTNNHelper createInstanceWithProtoPath:protoPath modelPath:modelPath];
}

@end
