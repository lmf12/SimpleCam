//
//  SCFaceDetectorHandler.m
//  SimpleCam
//
//  Created by Lyman Li on 2022/10/3.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#include <fstream>

#import "SCFaceInfoModel.h"
#import "SCTNNHelper.h"
#import "SCFaceDetectorHandler.h"
#import "SCMetalTextureConverter.h"

static int const kNumAnchors = 896;
static int const kDetectDims = 16;
static int const kNumKeypoints = 6;

@interface SCFaceDetectorHandler ()

@property (nonatomic, assign) shared_ptr<Instance> faceDetector;
@property (nonatomic, copy) NSArray<NSNumber *> *faceDetectorAnchors;
@property (nonatomic, strong) SCMetalTextureConverter *textureConverter;

@end

@implementation SCFaceDetectorHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}


#pragma mark - Public

- (void)detectFaceWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    id<MTLTexture> texture = [self.textureConverter textureWithPixelBuffer:pixelBuffer];
    map<string, shared_ptr<Mat>> result = [SCTNNHelper processWithInstance:self.faceDetector
                                                            withInputParam:[self faceDetectorInputParam]
                                                               outputParam:[self faceDetectorOutputParam]
                                                                     input:texture];
    Mat scores = *result["546"].get();
    Mat boxes = *result["544"].get();
    
    CGSize inputSize = [SCTNNHelper inputSize:self.faceDetector];
    NSArray<SCFaceInfoModel *> *infos = [self generateBBoxWithScores:scores
                                                               boxes:boxes
                                                          imageWidth:(int)inputSize.width
                                                         imageHeight:(int)inputSize.height
                                                   minScoreThreshold:0.75];
    NSArray<SCFaceInfoModel *> *faceList = [self nmsWithInput:infos iouThreshold:0.3 type:1];
    for (SCFaceInfoModel *info in faceList) {
        int index = [faceList indexOfObject:info];
        NSLog(@"%d --- %f %f %f %f" , index, info.x1, info.y1, info.x2, info.y2);
    }
}

#pragma mark - Private

- (void)commonInit {
    [self setupFaceDetector];
    
    id<MTLCommandQueue> commandQueue = [SCTNNHelper commandQueue:self.faceDetector];
    self.textureConverter = [[SCMetalTextureConverter alloc] initWithCommandQueue:commandQueue];
}

- (void)setupFaceDetector {
    NSString *protoPath = [[NSBundle mainBundle] pathForResource:@"blazeface"
                                                          ofType:@"tnnproto"];
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"blazeface"
                                                          ofType:@"tnnmodel"];
    self.faceDetector = [SCTNNHelper createInstanceWithProtoPath:protoPath modelPath:modelPath];
    [self setupFaceDetectorAnchors];
}

- (void)setupFaceDetectorAnchors {
    NSString *anchorPath = [[NSBundle mainBundle] pathForResource:@"blazeface_anchors"
                                                           ofType:@"txt"];
    ifstream inFile(string(anchorPath.UTF8String));
    NSMutableArray *anchors = [[NSMutableArray alloc] initWithCapacity:kNumAnchors * 4];

    int index = 0;
    string line;
    while(std::getline(inFile, line, '\n')) {
        float val = std::stof(line);
        anchors[index++] = @(val);
    }
    self.faceDetectorAnchors = [anchors copy];
}

- (NSArray<SCFaceInfoModel *> *)generateBBoxWithScores:(Mat &)scores
                                                 boxes:(Mat &)boxes
                                            imageWidth:(int)imageWidth
                                           imageHeight:(int)imageHeight
                                     minScoreThreshold:(float)minScoreThreshold {
    float *boxesData = static_cast<float*>(boxes.GetData());
    float *scoreData = static_cast<float*>(scores.GetData());
    NSArray<NSNumber *> *anchors = self.faceDetectorAnchors;
    NSMutableArray<SCFaceInfoModel *> *infos = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < kNumAnchors; ++i) {
        if (scoreData[i] < minScoreThreshold) {
            continue;
        }
        float xCenter = boxesData[i * kDetectDims + 0] / imageWidth * anchors[i * 4 + 2].floatValue + anchors[i * 4 + 0].floatValue;
        float yCenter = boxesData[i * kDetectDims + 1] / imageHeight * anchors[i * 4 + 3].floatValue + anchors[i * 4 + 1].floatValue;
        float width    = boxesData[i * kDetectDims + 2] / imageWidth * anchors[i * 4 + 2].floatValue;
        float height   = boxesData[i * kDetectDims + 3] / imageHeight * anchors[i * 4 + 3].floatValue;
        
        SCFaceInfoModel *faceInfo = [[SCFaceInfoModel alloc] init];
        faceInfo.imageWidth = imageWidth;
        faceInfo.imageHeight = imageHeight;
        faceInfo.score = scoreData[i];
        
        // bbox
        faceInfo.x1 = (xCenter - width / 2.0) * imageWidth;
        faceInfo.y1 = (yCenter - height / 2.0) * imageHeight;
        faceInfo.x2 = (xCenter + width / 2.0) * imageWidth;
        faceInfo.y2 = (yCenter + height / 2.0) * imageHeight;
        
        // key points
        NSMutableArray *keyPoints = [[NSMutableArray alloc] init];
        for(int j = 0; j < kNumKeypoints; ++j) {
            int offset = j * 2 + 4;
            float kpX = (boxesData[i * kDetectDims + offset + 0] / imageWidth * anchors[i * 4 + 2].floatValue + anchors[i * 4 + 0].floatValue) * imageWidth;
            float kpY = (boxesData[i * kDetectDims + offset + 1] / imageHeight * anchors[i * 4 + 3].floatValue + anchors[i * 4 + 1].floatValue) * imageHeight;
            [keyPoints addObject:@(CGPointMake(kpX, kpY))];
        }
        faceInfo.keyPoints = [keyPoints copy];
        [infos addObject:faceInfo];
    }
    return [infos copy];
}

- (NSArray<SCFaceInfoModel *> *)nmsWithInput:(NSArray<SCFaceInfoModel *> *)input iouThreshold:(float)iouThreshold type:(int)type {
    input = [input sortedArrayUsingComparator:^NSComparisonResult(SCFaceInfoModel *obj1, SCFaceInfoModel *obj2) {
        if (obj1.score > obj2.score) {
            return NSOrderedAscending;
        } else if (obj1.score < obj2.score) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    int boxNum = (int)[input count];
    vector<int> merged(boxNum, 0);

    NSMutableArray<SCFaceInfoModel *> *output = [[NSMutableArray alloc] init];
    for (int i = 0; i < boxNum; i++) {
        if (merged[i]) {
            continue;
        }
        NSMutableArray<SCFaceInfoModel *> *buf = [[NSMutableArray alloc] init];
        [buf addObject:input[i]];
        merged[i] = 1;

        float h0 = input[i].y2 - input[i].y1 + 1;
        float w0 = input[i].x2 - input[i].x1 + 1;

        float area0 = h0 * w0;

        for (int j = i + 1; j < boxNum; j++) {
            if (merged[j]) {
                continue;
            }

            float inner_x0 = input[i].x1 > input[j].x1 ? input[i].x1 : input[j].x1;
            float inner_y0 = input[i].y1 > input[j].y1 ? input[i].y1 : input[j].y1;

            float inner_x1 = input[i].x2 < input[j].x2 ? input[i].x2 : input[j].x2;
            float inner_y1 = input[i].y2 < input[j].y2 ? input[i].y2 : input[j].y2;

            float inner_h = inner_y1 - inner_y0 + 1;
            float inner_w = inner_x1 - inner_x0 + 1;

            if (inner_h <= 0 || inner_w <= 0)
                continue;

            float inner_area = inner_h * inner_w;

            float h1 = input[j].y2 - input[j].y1 + 1;
            float w1 = input[j].x2 - input[j].x1 + 1;

            float area1 = h1 * w1;

            float score;

            score = inner_area / (area0 + area1 - inner_area);

            if (score > iouThreshold) {
                merged[j] = 1;
                [buf addObject:input[j]];
            }
        }
        switch (type) {
            case 0: { // HardNMS
                [output addObject:buf[0]];
                break;
            }
            case 1: { // BlendingNMS
                float total = 0;
                for (int i = 0; i < [buf count]; i++) {
                    total += exp(buf[i].score);
                }
                SCFaceInfoModel *rects = [[SCFaceInfoModel alloc] init];
                NSMutableArray<NSValue *> *keyPoints = [[NSMutableArray alloc] init];
                for (int i = 0; i < [buf[0].keyPoints count]; ++i) {
                    [keyPoints addObject:@(CGPointZero)];
                }
                for (int i = 0; i < [buf count]; i++) {
                    float rate = exp(buf[i].score) / total;
                    rects.x1 += buf[i].x1 * rate;
                    rects.y1 += buf[i].y1 * rate;
                    rects.x2 += buf[i].x2 * rate;
                    rects.y2 += buf[i].y2 * rate;
                    rects.score += buf[i].score * rate;
                    for(int j = 0; j < [buf[i].keyPoints count]; ++j) {
                        CGFloat x = keyPoints[j].CGPointValue.x + buf[i].keyPoints[j].CGPointValue.x * rate;
                        CGFloat y = keyPoints[j].CGPointValue.y + buf[i].keyPoints[j].CGPointValue.y * rate;
                        keyPoints[j] = @(CGPointMake(x, y));
                    }
                    rects.imageHeight = buf[0].imageHeight;
                    rects.imageWidth  = buf[0].imageWidth;
                }
                rects.keyPoints = [keyPoints copy];
                [output addObject:rects];
                break;
            }
            case 2: { // WeightedNMS
                float total = 0;
                for (int i = 0; i < [buf count]; i++) {
                    total += buf[i].score;
                }
                SCFaceInfoModel *rects = [[SCFaceInfoModel alloc] init];
                NSMutableArray<NSValue *> *keyPoints = [[NSMutableArray alloc] init];
                for (int i = 0; i < [buf[0].keyPoints count]; ++i) {
                    [keyPoints addObject:@(CGPointZero)];
                }
                for (int i = 0; i < [buf count]; i++) {
                    float rate = buf[i].score / total;
                    rects.x1 += buf[i].x1 * rate;
                    rects.y1 += buf[i].y1 * rate;
                    rects.x2 += buf[i].x2 * rate;
                    rects.y2 += buf[i].y2 * rate;
                    rects.score += buf[i].score * rate;
                    for(int j = 0; j < [buf[i].keyPoints count]; ++j) {
                        CGFloat x = keyPoints[j].CGPointValue.x + buf[i].keyPoints[j].CGPointValue.x * rate;
                        CGFloat y = keyPoints[j].CGPointValue.y + buf[i].keyPoints[j].CGPointValue.y * rate;
                        keyPoints[j] = @(CGPointMake(x, y));
                    }
                    rects.imageHeight = buf[0].imageHeight;
                    rects.imageWidth  = buf[0].imageWidth;
                }
                rects.keyPoints = [keyPoints copy];
                [output addObject:rects];
                break;
            }
            default: {
            }
        }
    }
    return [output copy];
}

- (MatConvertParam)faceDetectorInputParam {
    return {
        {1.0 / 127.5, 1.0 / 127.5, 1.0 / 127.5, 0.0},
        {-1.0, -1.0, -1.0, 0.0},
        false
    };
}

- (MatConvertParam)faceDetectorOutputParam {
    return MatConvertParam();
}

@end
