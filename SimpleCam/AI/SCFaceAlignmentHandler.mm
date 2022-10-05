//
//  SCFaceAlignmentHandler.m
//  SimpleCam
//
//  Created by Lyman Li on 2022/10/2.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#include <fstream>

#import "SCTNNHelper.h"

#import "SCFaceAlignmentHandler.h"

@interface SCFaceAlignmentHandler ()

@property (nonatomic, assign) shared_ptr<Instance> faceAlignment;
@property (nonatomic, copy) NSArray<NSNumber *> *meanPts;

@end

@implementation SCFaceAlignmentHandler

- (instancetype)initWithProtoName:(NSString *)protoName
                        modelName:(NSString *)modelName
                      meanPtsName:(NSString *)meanPtsName {
    self = [super init];
    if (self) {
        [self setupWithWithProtoName:protoName
                           modelName:modelName
                         meanPtsName:meanPtsName];
    }
    return self;
}

#pragma mark - Public

- (void)detectFaceWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
}

#pragma mark - Private

- (void)setupWithWithProtoName:(NSString *)protoName
                     modelName:(NSString *)modelName
                   meanPtsName:(NSString *)meanPtsName {
    NSString *protoPath = [[NSBundle mainBundle] pathForResource:protoName
                                                          ofType:@"tnnproto"];
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:modelName
                                                          ofType:@"tnnmodel"];
    self.faceAlignment = [SCTNNHelper createInstanceWithProtoPath:protoPath modelPath:modelPath];
    
    [self setupMeanPtsWithFileName:meanPtsName];
}

- (void)setupMeanPtsWithFileName:(NSString *)fileName {
    NSString *meanPtsPath = [[NSBundle mainBundle] pathForResource:fileName
                                                           ofType:@"txt"];
    ifstream inFile(string(meanPtsPath.UTF8String));
    NSMutableArray *meanPts = [[NSMutableArray alloc] init];

    string line;
    while(std::getline(inFile, line, '\n')) {
        float val = std::stof(line);
        [meanPts addObject:@(val)];
    }
    self.meanPts = [meanPts copy];
}

- (MatConvertParam)inputParam {
    return {
        {1.0 / 128.0, 1.0 / 128.0, 1.0 / 128.0, 0.0},
        {-1.0, -1.0, -1.0, 0.0},
        false
    };
}

- (MatConvertParam)outputParam {
    return MatConvertParam();
}

@end
