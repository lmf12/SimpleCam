//
//  SCMetalTextureConverter.m
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/8.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <MetalKit/MetalKit.h>

#import "SCMetalTextureConverter.h"

typedef struct {
    vector_float4 position;
    vector_float4 texCoords;
} SCVertex;

@interface SCMetalTextureConverter ()

@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLBuffer> vertixBuffer;
@property (nonatomic, strong) id<MTLTexture> targetTexture;
@property (nonatomic, strong) MTLRenderPassDescriptor *renderPassDescriptor;

@property (nonatomic, assign) CVPixelBufferRef renderTarget;
@property (nonatomic, assign) CVMetalTextureCacheRef textureCache;

@end

@implementation SCMetalTextureConverter

- (void)dealloc {
    if (_renderTarget) {
        CVPixelBufferRelease(_renderTarget);
    }
    if (_textureCache) {
        CFRelease(_textureCache);
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCommandQueue:(id<MTLCommandQueue>)queue {
    self = [super init];
    if (self) {
        self.commandQueue = queue;
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

- (CVPixelBufferRef)pixelBufferWithTexture:(id<MTLTexture>)texture {
    if (!texture) {
        return nil;
    }
    [self setupTargetTextureWithSize:CGSizeMake(texture.width, texture.height)];
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = self.renderPassDescriptor;
    
    renderPassDescriptor.colorAttachments[0].texture = self.targetTexture;
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    MTLViewport viewport = (MTLViewport){0.0, 0.0, texture.width, texture.height, -1.0, 1.0};
    [renderEncoder setViewport:viewport];
    [renderEncoder setRenderPipelineState:self.pipelineState];
    [renderEncoder setVertexBuffer:self.vertixBuffer
                            offset:0
                           atIndex:0];
    [renderEncoder setFragmentTexture:texture
                              atIndex:0];
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip
                      vertexStart:0
                      vertexCount:4];
    
    [renderEncoder endEncoding];
    [commandBuffer commit];
    [commandBuffer waitUntilScheduled];
    
    CVPixelBufferRef resultPixelBuffer = self.renderTarget;
    self.renderTarget = nil;
    return resultPixelBuffer;
}

- (void)drawSrcTexture:(id<MTLTexture>)srcTexture toDstTexture:(id<MTLTexture>)dstTexture {
    if (!srcTexture || !dstTexture) {
        return;
    }
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = self.renderPassDescriptor;
    
    renderPassDescriptor.colorAttachments[0].texture = dstTexture;
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    MTLViewport viewport = (MTLViewport){0.0, 0.0, dstTexture.width, dstTexture.height, -1.0, 1.0};
    [renderEncoder setViewport:viewport];
    [renderEncoder setRenderPipelineState:self.pipelineState];
    [renderEncoder setVertexBuffer:self.vertixBuffer
                            offset:0
                           atIndex:0];
    [renderEncoder setFragmentTexture:srcTexture
                              atIndex:0];
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip
                      vertexStart:0
                      vertexCount:4];
    
    [renderEncoder endEncoding];
    [commandBuffer commit];
    [commandBuffer waitUntilScheduled];
}

- (id<MTLTexture>)textureWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    if (!pixelBuffer) {
        return nil;
    }
    CVPixelBufferRetain(pixelBuffer);
    CVMetalTextureRef texture = nil;
    CVReturn status = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                self.textureCache,
                                                                pixelBuffer,
                                                                nil,
                                                                MTLPixelFormatBGRA8Unorm,
                                                                CVPixelBufferGetWidth(pixelBuffer),
                                                                CVPixelBufferGetHeight(pixelBuffer),
                                                                0,
                                                                &texture);
    if (status != kCVReturnSuccess) {
        NSLog(@"texture create fail");
        CVPixelBufferRelease(pixelBuffer);
        return nil;
    }
    id<MTLTexture> result = CVMetalTextureGetTexture(texture);
    
    CFRelease(texture);
    CVPixelBufferRelease(pixelBuffer);
    
    return result;
}

#pragma mark - Private

- (void)commonInit {
    [self setupDevice];
    [self setupPipeline];
    [self setupVertex];
    [self setupRenderPassDescriptor];
}

- (void)setupDevice {
    self.device = MTLCreateSystemDefaultDevice();
}

- (void)setupPipeline {
    id<MTLLibrary> library = [self.device newDefaultLibrary];
    
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"defaultVertexShader"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"defaultFragmentShader"];
    
    MTLRenderPipelineDescriptor *descriptor = [[MTLRenderPipelineDescriptor alloc] init];
    descriptor.vertexFunction = vertexFunction;
    descriptor.fragmentFunction = fragmentFunction;
    descriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    self.pipelineState = [self.device newRenderPipelineStateWithDescriptor:descriptor
                                                                     error:NULL];
    if (!self.commandQueue) {
        self.commandQueue = [self.device newCommandQueue];
    }
}

- (void)setupVertex {
    static const SCVertex vertices[] = {
        {{-1.0, -1.0, 0.0, 1.0}, {0.0, 1.0}},
        {{-1.0, 1.0, 0.0, 1.0}, {0.0, 0.0}},
        {{1.0, -1.0, 0.0, 1.0}, {1.0, 1.0}},
        {{1.0, 1.0, 0.0, 1.0}, {1.0, 0.0}}
    };
    self.vertixBuffer = [self.device newBufferWithBytes:vertices
                                                 length:sizeof(vertices)
                                                options:MTLResourceStorageModeShared];
}

- (void)setupRenderPassDescriptor {
    self.renderPassDescriptor = [MTLRenderPassDescriptor new];
    self.renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0);
    self.renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    self.renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
}

- (void)setupTargetTextureWithSize:(CGSize)size {
    CFDictionaryRef dictionary;
    CFMutableDictionaryRef attrs;
    dictionary = CFDictionaryCreate(kCFAllocatorDefault,
                                    nil,
                                    nil,
                                    0,
                                    &kCFTypeDictionaryKeyCallBacks,
                                    &kCFTypeDictionaryValueCallBacks);
    attrs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                      1,
                                      &kCFTypeDictionaryKeyCallBacks,
                                      &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(attrs,
                         kCVPixelBufferIOSurfacePropertiesKey,
                         dictionary);
    
    if (self.renderTarget) {
        CVPixelBufferRelease(self.renderTarget);
    }
    CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height,
                        kCVPixelFormatType_32BGRA,
                        attrs,
                        &_renderTarget);
    
    size_t width = CVPixelBufferGetWidthOfPlane(self.renderTarget, 0);
    size_t height = CVPixelBufferGetHeightOfPlane(self.renderTarget, 0);
    MTLPixelFormat pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    CVMetalTextureRef texture = nil;
    CVReturn status = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                self.textureCache,
                                                                self.renderTarget,
                                                                nil,
                                                                pixelFormat,
                                                                width,
                                                                height,
                                                                0,
                                                                &texture);
    if (status == kCVReturnSuccess) {
        self.targetTexture = CVMetalTextureGetTexture(texture);
        CFRelease(texture);
    } else {
        NSLog(@"render target create fail");
    }
    CFRelease(attrs);
    CFRelease(dictionary);
}

#pragma mark - Accessor

- (CVMetalTextureCacheRef)textureCache {
    if (!_textureCache) {
        CVReturn status = CVMetalTextureCacheCreate(kCFAllocatorDefault,
                                                    nil,
                                                    self.device,
                                                    nil,
                                                    &_textureCache);
        if (status != kCVReturnSuccess) {
            NSLog(@"texture cache create fail");
        }
    }
    return _textureCache;
}

@end
