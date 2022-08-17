//
//  SCGPUImageDynamicSplitFilter.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/11/9.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "SCGPUImageDynamicSplitFilter.h"

static CGFloat const kCaptureTime = 2.0f;    // 自动捕获视频帧的间隔时间

NSString * const kSCGPUImageDynamicSplitFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 
 uniform sampler2D inputImageTexture1;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 uniform sampler2D inputImageTexture4;
 
 uniform int textureCount;
 
 varying vec2 textureCoordinate;
 
 void main (void) {
    vec2 position = mod(textureCoordinate * 2.0, 1.0);
    
    if (textureCoordinate.x <= 0.5 && textureCoordinate.y <= 0.5) {  // 左上
        gl_FragColor = texture2D(textureCount >= 1 ? inputImageTexture1 : inputImageTexture,
                                 position);
    } else if (textureCoordinate.x > 0.5 && textureCoordinate.y <= 0.5) {   // 右上
        gl_FragColor = texture2D(textureCount >= 2 ? inputImageTexture2 : inputImageTexture,
                                 position);
    } else if (textureCoordinate.x <= 0.5 && textureCoordinate.y > 0.5) {  // 左下
        gl_FragColor = texture2D(textureCount >= 3 ? inputImageTexture3 : inputImageTexture,
                                 position);
    } else {  // 右下
        gl_FragColor = texture2D(textureCount >= 4 ? inputImageTexture4 : inputImageTexture,
                                 position);
    }
 }
);

@interface SCGPUImageDynamicSplitFilter () {
    GLint firstTextureUniform;
    GLint secondTextureUniform;
    GLint thirdTextureUniform;
    GLint fourthTextureUniform;
    
    GLint textureCountUniform;
}

@property (nonatomic, strong) GPUImageFramebuffer *firstFramebuffer;
@property (nonatomic, strong) GPUImageFramebuffer *secondFramebuffer;
@property (nonatomic, strong) GPUImageFramebuffer *thirdFramebuffer;
@property (nonatomic, strong) GPUImageFramebuffer *fourthFramebuffer;

@property (nonatomic, assign) CGFloat lastCaptureTime;  // 上次补获视频帧的时间

@property (nonatomic, assign) NSInteger capturedCount;
@property (nonatomic, assign) BOOL needsCaptureFramebuffer;  // 是否需要捕获视频帧

@end

@implementation SCGPUImageDynamicSplitFilter

- (void)dealloc {
    [self releaseAllFramebuffer];
}

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageDynamicSplitFilterShaderString];
    if (self) {
        runSynchronouslyOnVideoProcessingQueue(^{
            firstTextureUniform = [filterProgram uniformIndex:@"inputImageTexture1"];
            secondTextureUniform = [filterProgram uniformIndex:@"inputImageTexture2"];
            thirdTextureUniform = [filterProgram uniformIndex:@"inputImageTexture3"];
            fourthTextureUniform = [filterProgram uniformIndex:@"inputImageTexture4"];
            
            textureCountUniform = [filterProgram uniformIndex:@"textureCount"];
        });
    }
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    if (self.preventRendering)
    {
        [firstInputFramebuffer unlock];
        return;
    }
    
    if (self.needsCaptureFramebuffer) {
        [self captureFramebuffer];
        self.needsCaptureFramebuffer = NO;
    }
    
    [GPUImageContext setActiveShaderProgram:filterProgram];

    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self sizeOfFBO] textureOptions:self.outputTextureOptions onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];
    if (usingNextFrameForImageCapture)
    {
        [outputFramebuffer lock];
    }

    [self setUniformsForProgramAtIndex:0];
    
    glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
    glClear(GL_COLOR_BUFFER_BIT);

    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, [firstInputFramebuffer texture]);
    glUniform1i(filterInputTextureUniform, 2);
    
    // 第一个纹理
    if (self.firstFramebuffer) {
        glActiveTexture(GL_TEXTURE3);
        glBindTexture(GL_TEXTURE_2D, [self.firstFramebuffer texture]);
        glUniform1i(firstTextureUniform, 3);
    }
    
    // 第二个纹理
    if (self.secondFramebuffer) {
        glActiveTexture(GL_TEXTURE4);
        glBindTexture(GL_TEXTURE_2D, [self.secondFramebuffer texture]);
        glUniform1i(secondTextureUniform, 4);
    }
    
    // 第三个纹理
    if (self.thirdFramebuffer) {
        glActiveTexture(GL_TEXTURE5);
        glBindTexture(GL_TEXTURE_2D, [self.thirdFramebuffer texture]);
        glUniform1i(thirdTextureUniform, 5);
    }
    
    // 第四个纹理
    if (self.fourthFramebuffer) {
        glActiveTexture(GL_TEXTURE6);
        glBindTexture(GL_TEXTURE_2D, [self.fourthFramebuffer texture]);
        glUniform1i(fourthTextureUniform, 6);
    }
    
    // 传递纹理的数量
    glUniform1i(textureCountUniform, (int)self.capturedCount);
    
    
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
    glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glFlush();
    
    [firstInputFramebuffer unlock];
    
    if (usingNextFrameForImageCapture)
    {
        dispatch_semaphore_signal(imageCaptureSemaphore);
    }
}

/// 捕获视频帧
- (void)captureFramebuffer {
    if (self.capturedCount >= 4) {
        return;
    }
    [firstInputFramebuffer lock];
    if (self.capturedCount == 0) {
        self.firstFramebuffer = firstInputFramebuffer;
    } else if (self.capturedCount == 1) {
        self.secondFramebuffer = firstInputFramebuffer;
    } else if (self.capturedCount == 2) {
        self.thirdFramebuffer = firstInputFramebuffer;
    } else if (self.capturedCount == 3) {
        self.fourthFramebuffer = firstInputFramebuffer;
    }
    self.capturedCount++;
}

/// 释放所有视频帧
- (void)releaseAllFramebuffer {
    runAsynchronouslyOnVideoProcessingQueue(^{
        if (self.firstFramebuffer) {
            [self.firstFramebuffer unlock];
            self.firstFramebuffer = nil;
        }
        if (self.secondFramebuffer) {
            [self.secondFramebuffer unlock];
            self.secondFramebuffer = nil;
        }
        if (self.thirdFramebuffer) {
            [self.thirdFramebuffer unlock];
            self.thirdFramebuffer = nil;
        }
        if (self.fourthFramebuffer) {
            [self.fourthFramebuffer unlock];
            self.fourthFramebuffer = nil;
        }
        self.capturedCount = 0;
    });
}

- (void)setTime:(CGFloat)time {
    [super setTime:time];
    
    if (time - self.lastCaptureTime >= kCaptureTime) {
        if (self.capturedCount >= 4) {  // 已经捕获 4 个视频帧
            [self releaseAllFramebuffer];
        } else {
            self.needsCaptureFramebuffer = YES;
        }
        self.lastCaptureTime = self.time;
    }
}

@end
