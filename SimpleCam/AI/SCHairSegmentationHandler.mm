//
//  SCHairSegmentationHandler.m
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/13.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <Metal/Metal.h>

#import "SCMetalTextureConverter.h"
#import "SCTNNHelper.h"

#import "SCHairSegmentationHandler.h"

MatConvertParam inputParam = {
    {1.0 / (255 * 0.229), 1.0 / (255 * 0.224), 1.0 / (255 * 0.225), 0.0},
    {-0.485 / 0.229, -0.456 / 0.224, -0.406 / 0.225, 0.0},
    true
};

MatConvertParam outputParam = {
    {255, 255, 255, 0},
    {0, 0, 0, 255},
    true
};

@interface SCHairSegmentationHandler ()

@property (nonatomic, strong) SCMetalTextureConverter *textureConverter;
@property (nonatomic, assign) shared_ptr<Instance> tnnInstance;
@property (nonatomic, strong) id<MTLLibrary> library;

@end

@implementation SCHairSegmentationHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

- (CVPixelBufferRef)hairSegmentationPixelBufferWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    id<MTLTexture> texture = [self.textureConverter textureWithPixelBuffer:pixelBuffer];
    id<MTLTexture> resultTexture = [SCTNNHelper processTextureWithInstance:self.tnnInstance withInputParam:inputParam outputParam:outputParam input:texture];
    CVPixelBufferRef resultPixelBuffer = [self.textureConverter pixelBufferWithTexture:resultTexture];
    return resultPixelBuffer;
}

- (void)hairSegmentationWithSrcPixelBuffer:(CVPixelBufferRef)srcPixelBuffer
                                dstTexture:(id<MTLTexture>)dstTexture {
    id<MTLTexture> texture = [self.textureConverter textureWithPixelBuffer:srcPixelBuffer];
    id<MTLTexture> resultTexture = [SCTNNHelper processTextureWithInstance:self.tnnInstance withInputParam:inputParam outputParam:outputParam input:texture];
    [self.textureConverter drawSrcTexture:resultTexture toDstTexture:dstTexture];
}

#pragma mark - Private

- (void)commonInit {
    NSString *protoPath = [[NSBundle mainBundle] pathForResource:@"hair_segmentation"
                                                          ofType:@"tnnproto"];
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"hair_segmentation"
                                                          ofType:@"tnnmodel"];
    self.tnnInstance = [SCTNNHelper createInstanceWithProtoPath:protoPath modelPath:modelPath];
    id<MTLCommandQueue> commandQueue = [SCTNNHelper commandQueue:self.tnnInstance];
    self.textureConverter = [[SCMetalTextureConverter alloc] initWithCommandQueue:commandQueue];
}

@end
