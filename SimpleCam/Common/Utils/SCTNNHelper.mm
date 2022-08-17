//
//  SCTNNHelper.m
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/7.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <MetalKit/MetalKit.h>

#import "SCMetalHelper.h"

#import "SCTNNHelper.h"

@implementation SCTNNHelper

#pragma mark - Public

+ (shared_ptr<Instance>)createInstanceWithProtoPath:(NSString *)protoPath
                                          modelPath:(NSString *)modelPath {
    TNN *tnn = [self decodeModelWithProtoPath:protoPath modelPath:modelPath];
    shared_ptr<Instance> instance = [self bulidNetworkWithTNN:tnn];
    delete tnn;
    return instance;
}

+ (void)processInstance:(shared_ptr<Instance>)instance
         withInputParam:(MatConvertParam)inputParam
            outputParam:(MatConvertParam)outputParam
                  input:(id<MTLTexture>)input
                 output:(id<MTLTexture>)output {
    [self defaultPreprocessWithInstance:instance
                              withInput:input
                                  param:inputParam];
    [self processInstance:instance];
    [self defaultPostprocessWithInstance:instance
                              withOutput:output
                                   param:outputParam];
}

+ (void)processInstance:(shared_ptr<Instance>)instance
            withLibrary:(id<MTLLibrary>)library
     preprocessFunction:(NSString *)preprocessFunction
    postprocessFunction:(NSString *)postprocessFunction
                  input:(id<MTLTexture>)input
                 output:(id<MTLTexture>)output {
    if (!library || !preprocessFunction || !postprocessFunction) {
        return;
    }
    [self customPreprocessWithInstance:instance
                               library:library
                          functionName:preprocessFunction
                             withInput:input];
    [self processInstance:instance];
    [self customPostprocessWithInstance:instance
                                library:library
                           functionName:postprocessFunction
                             withOutput:output];
}

+ (id<MTLTexture>)processTextureWithInstance:(shared_ptr<Instance>)instance
                              withInputParam:(MatConvertParam)inputParam
                                 outputParam:(MatConvertParam)outputParam
                                       input:(id<MTLTexture>)input {
    id<MTLCommandQueue> commandQueue = [self fetchCommandQueueWithInstance:instance];
    id<MTLTexture> inputTexture = input;
    // resize 输入纹理
    CGSize inputSize = [self inputSize:instance];
    if (input.width != (int)inputSize.width || input.height != (int)inputSize.height) {
        inputTexture = [SCMetalHelper resizeTexture:inputTexture
                                       commandQueue:commandQueue
                                           dstWidth:inputSize.width
                                          dstHeight:inputSize.height];
    }
    
    // 创建输出纹理
    CGSize outputSize = [self outputSize:instance];
    id<MTLTexture> resultTexture = [SCMetalHelper createTextureWithWidth:outputSize.width
                                                                  height:outputSize.height];
    
    [self processInstance:instance
           withInputParam:inputParam
              outputParam:outputParam
                    input:inputTexture
                   output:resultTexture];
    
    // resize 输入纹理
    if (input.width != (int)outputSize.width || input.height != (int)outputSize.height) {
        resultTexture = [SCMetalHelper resizeTexture:resultTexture
                                        commandQueue:commandQueue
                                            dstWidth:input.width
                                           dstHeight:input.height];
    }
    
    return resultTexture;
}

+ (id<MTLTexture>)processTextureWithInstance:(shared_ptr<Instance>)instance
                                 withLibrary:(id<MTLLibrary>)library
                          preprocessFunction:(NSString *)preprocessFunction
                         postprocessFunction:(NSString *)postprocessFunction
                                       input:(id<MTLTexture>)input {
    id<MTLCommandQueue> commandQueue = [self fetchCommandQueueWithInstance:instance];
    id<MTLTexture> inputTexture = input;
    // resize 输入纹理
    CGSize inputSize = [self inputSize:instance];
    if (input.width != (int)inputSize.width || input.height != (int)inputSize.height) {
        inputTexture = [SCMetalHelper resizeTexture:inputTexture
                                       commandQueue:commandQueue
                                           dstWidth:inputSize.width
                                          dstHeight:inputSize.height];
    }
    
    // 创建输出纹理
    CGSize outputSize = [self outputSize:instance];
    id<MTLTexture> resultTexture = [SCMetalHelper createTextureWithWidth:outputSize.width
                                                                  height:outputSize.height];
    
    [self processInstance:instance
              withLibrary:library
       preprocessFunction:preprocessFunction
      postprocessFunction:postprocessFunction
                    input:inputTexture
                   output:resultTexture];
    
    // resize 输入纹理
    if (input.width != (int)outputSize.width || input.height != (int)outputSize.height) {
        resultTexture = [SCMetalHelper resizeTexture:resultTexture
                                        commandQueue:commandQueue
                                            dstWidth:input.width
                                           dstHeight:input.height];
    }
    
    return resultTexture;
}

+ (CGSize)inputSize:(shared_ptr<Instance>)instance {
    BlobMap inputBlobs;
    Status status = instance->GetAllInputBlobs(inputBlobs);
    if (status != TNN_OK) {
        NSLog(@"Error: get input blobs failed");
        return CGSizeZero;
    }
    Blob *networkInput = inputBlobs.begin()->second;
    
    auto dims = networkInput->GetBlobDesc().dims;
    int width = dims[3];
    int height = dims[2];

    return CGSizeMake(width, height);
}

+ (CGSize)outputSize:(shared_ptr<Instance>)instance {
    BlobMap outputBlobs;
    Status status = instance->GetAllOutputBlobs(outputBlobs);
    if (status != TNN_OK) {
        NSLog(@"Error: get output blobs failed");
        return CGSizeZero;
    }
    Blob *networkOutput = outputBlobs.begin()->second;
    
    auto dims = networkOutput->GetBlobDesc().dims;
    int width = dims[3];
    int height = dims[2];
    
    return CGSizeMake(width, height);
}

+ (id<MTLCommandQueue>)commandQueue:(shared_ptr<Instance>)instance {
    return [self fetchCommandQueueWithInstance:instance];
}

#pragma mark - Private

// 解析模型
+ (TNN *)decodeModelWithProtoPath:(NSString *)protoPath
                        modelPath:(NSString *)modelPath {
    TNN *tnn = new TNN();
    string protoContent = [NSString stringWithContentsOfFile:protoPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil].UTF8String;
    NSData *modelData = [NSData dataWithContentsOfFile:modelPath];
    string modelContent = [modelData length] > 0 ? string((const char *)[modelData bytes], [modelData length]) : "";
    
    if (protoContent.size() <= 0 || modelContent.size() <= 0) {
        NSLog(@"Error: proto or model path is invalid");
        return nullptr;
    }
    
    ModelConfig modelConfig;
    modelConfig.model_type = MODEL_TYPE_TNN; // 指定模型类型
    modelConfig.params = {protoContent, modelContent};
    
    Status status = tnn->Init(modelConfig);
    
    if (status != TNN_OK) {
        NSLog(@"Error: tnn init failed");
        return nullptr;
    }
    
    return tnn;
}

// 构建网络实例
+ (shared_ptr<Instance>)bulidNetworkWithTNN:(TNN *)tnn {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"tnn" ofType:@"bundle"];
    NSString *libPath = [bundlePath stringByAppendingPathComponent:@"tnn.metallib"];
    
    Status status;
    NetworkConfig networkConfig;
    networkConfig.device_type = DEVICE_METAL;  // 使用 metal
    networkConfig.library_path = {libPath.UTF8String};
    shared_ptr<Instance> instance = tnn->CreateInst(networkConfig, status);
    
    if (status != TNN_OK) {
        NSLog(@"Error: create instance failed");
        return nullptr;
    }
    return instance;
}

// 获取 commondQueue
+ (id<MTLCommandQueue>)fetchCommandQueueWithInstance:(shared_ptr<Instance>)instance {
    void *command_queue_ptr = nullptr;
    Status status = instance->GetCommandQueue(&command_queue_ptr);
    if (status != TNN_OK || !command_queue_ptr) {
        NSLog(@"Error: get command queue failed");
        return nil;
    }
    
    return (__bridge id<MTLCommandQueue>)command_queue_ptr;
}

// 默认预处理
+ (void)defaultPreprocessWithInstance:(shared_ptr<Instance>)instance
                            withInput:(id<MTLTexture>)input
                                param:(MatConvertParam)param {
    BlobMap inputBlobs;
    Status status = instance->GetAllInputBlobs(inputBlobs);
    if (status != TNN_OK) {
        NSLog(@"Error: get input blobs failed");
        return;
    }
    Blob *networkInput = inputBlobs.begin()->second;
    
    id<MTLCommandQueue> commandQueue = [self fetchCommandQueueWithInstance:instance];
    
    Mat inputMat = {DEVICE_METAL, tnn::N8UC4, {1, 3, (int)input.height, (int)input.width}, (__bridge void*)input};
    shared_ptr<BlobConverter> preprocessor = make_shared<BlobConverter>(networkInput);
    preprocessor->ConvertFromMatAsync(inputMat, param, (__bridge void*)commandQueue);
}

// 自定义预处理
+ (void)customPreprocessWithInstance:(shared_ptr<Instance>)instance
                             library:(id<MTLLibrary>)library
                        functionName:(NSString *)functionName
                           withInput:(id<MTLTexture>)input {
    BlobMap inputBlobs;
    Status status = instance->GetAllInputBlobs(inputBlobs);
    if (status != TNN_OK) {
        NSLog(@"Error: get input blobs failed");
        return;
    }
    Blob *networkInput = inputBlobs.begin()->second;
    
    id<MTLCommandQueue> commandQueue = [self fetchCommandQueueWithInstance:instance];
    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    [commandBuffer enqueue];
    
    id<MTLBuffer> blobBuffer = (__bridge id<MTLBuffer>)(void *)networkInput->GetHandle().base;
    NSUInteger blobOffset = (NSUInteger)networkInput->GetHandle().bytes_offset;
    
    id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];
    
    id<MTLComputePipelineState> pipelineState = [self computePipelineStateWithLibrary:library functionName:functionName];
    [encoder setComputePipelineState:pipelineState];
    [encoder setTexture:input atIndex:0];
    [encoder setBuffer:blobBuffer offset:blobOffset atIndex:0];
    
    CGSize inputSize = [self inputSize:instance];
    NSUInteger width = pipelineState.threadExecutionWidth;
    NSUInteger height = pipelineState.maxTotalThreadsPerThreadgroup / width;
    MTLSize groupThreads = {width, height, (NSUInteger)1};
    MTLSize groups = {(((int)inputSize.width + width - 1) / width),
                      (((int)inputSize.height + height - 1) / height), 1};
    [encoder dispatchThreadgroups:groups threadsPerThreadgroup:groupThreads];
    [encoder endEncoding];
    
    [commandBuffer commit];
    [commandBuffer waitUntilScheduled];
}

// 默认后处理
+ (void)defaultPostprocessWithInstance:(shared_ptr<Instance>)instance
                            withOutput:(id<MTLTexture>)output
                                 param:(MatConvertParam)param {
    BlobMap outputBlobs;
    Status status = instance->GetAllOutputBlobs(outputBlobs);
    if (status != TNN_OK) {
        NSLog(@"Error: get output blobs failed");
        return;
    }
    Blob *networkOutput = outputBlobs.begin()->second;
    
    Mat outputMat = {DEVICE_METAL, tnn::N8UC4, {1, 3, (int)output.height, (int)output.width}, (__bridge void*)output};
    shared_ptr<BlobConverter> postprocessor = make_shared<BlobConverter>(networkOutput);
    
    id<MTLCommandQueue> commandQueue = [self fetchCommandQueueWithInstance:instance];
    postprocessor->ConvertToMatAsync(outputMat, param, (__bridge void*)commandQueue);
}

// 自定义后处理
+ (void)customPostprocessWithInstance:(shared_ptr<Instance>)instance
                              library:(id<MTLLibrary>)library
                         functionName:(NSString *)functionName
                           withOutput:(id<MTLTexture>)output {
    BlobMap outputBlobs;
    Status status = instance->GetAllOutputBlobs(outputBlobs);
    if (status != TNN_OK) {
        NSLog(@"Error: get output blobs failed");
        return;
    }
    Blob *networkOutput = outputBlobs.begin()->second;
    
    id<MTLCommandQueue> commandQueue = [self fetchCommandQueueWithInstance:instance];
    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    [commandBuffer enqueue];
    
    id<MTLBuffer> blobBuffer = (__bridge id<MTLBuffer>)(void *)networkOutput->GetHandle().base;
    NSUInteger blobOffset = (NSUInteger)networkOutput->GetHandle().bytes_offset;
        
    id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];
    
    id<MTLComputePipelineState> pipelineState = [self computePipelineStateWithLibrary:library functionName:functionName];
    [encoder setComputePipelineState:pipelineState];
    [encoder setTexture:output atIndex:0];
    [encoder setBuffer:blobBuffer offset:blobOffset atIndex:0];
    
    NSUInteger width = pipelineState.threadExecutionWidth;
    NSUInteger height = pipelineState.maxTotalThreadsPerThreadgroup / width;
    MTLSize groupThreads = {width, height, (NSUInteger)1};
    MTLSize groups = {((output.width + width - 1) / width), ((output.height + height - 1) / height), 1};
    [encoder dispatchThreadgroups:groups threadsPerThreadgroup:groupThreads];
    [encoder endEncoding];
    
    [commandBuffer commit];
    [commandBuffer waitUntilScheduled];
}

// 模型执行
+ (void)processInstance:(shared_ptr<Instance>)instance {
    Status status = instance->ForwardAsync([]{});
    if (status != TNN_OK) {
        NSLog(@"Error: network process failed");
        return;
    }
}

// 根据 library 和 functionName 获取 pipelineState
+ (id<MTLComputePipelineState>)computePipelineStateWithLibrary:(id<MTLLibrary>)library functionName:(NSString *)functionName {
    id <MTLFunction> function = [library newFunctionWithName:functionName];
    return function ? [library.device newComputePipelineStateWithFunction:function error:nil] : nil;
}

@end
