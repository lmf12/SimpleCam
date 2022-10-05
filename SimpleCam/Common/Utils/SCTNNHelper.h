//
//  SCTNNHelper.h
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/7.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <tnn/tnn.h>
#import <Metal/Metal.h>

using namespace std;
using namespace TNN_NS;

@interface SCTNNHelper : NSObject

// 构建网络实例
+ (shared_ptr<Instance>)createInstanceWithProtoPath:(NSString *)protoPath
                                          modelPath:(NSString *)modelPath;

// 执行网络，输入纹理大小需要和模型匹配
+ (void)processInstance:(shared_ptr<Instance>)instance
         withInputParam:(MatConvertParam)inputParam
            outputParam:(MatConvertParam)outputParam
                  input:(id<MTLTexture>)input
                 output:(id<MTLTexture>)output;

+ (map<string, shared_ptr<Mat>>)processInstance:(shared_ptr<Instance>)instance
                                 withInputParam:(MatConvertParam)inputParam
                                    outputParam:(MatConvertParam)outputParam
                                          input:(id<MTLTexture>)input;

// 获取渲染结果纹理，会将输入纹理转成符合模型大小，输出纹理与输入纹理大小相同
+ (id<MTLTexture>)processTextureWithInstance:(shared_ptr<Instance>)instance
                              withInputParam:(MatConvertParam)inputParam
                                 outputParam:(MatConvertParam)outputParam
                                       input:(id<MTLTexture>)input;

+ (map<string, shared_ptr<Mat>>)processWithInstance:(shared_ptr<Instance>)instance
                                     withInputParam:(MatConvertParam)inputParam
                                        outputParam:(MatConvertParam)outputParam
                                              input:(id<MTLTexture>)input;

// 输入尺寸
+ (CGSize)inputSize:(shared_ptr<Instance>)instance;

// 输出尺寸
+ (CGSize)outputSize:(shared_ptr<Instance>)instance;

+ (CGSize)outputSize:(shared_ptr<Instance>)instance name:(string)name;

// 获取实例的commandQueue
+ (id<MTLCommandQueue>)commandQueue:(shared_ptr<Instance>)instance;

@end
