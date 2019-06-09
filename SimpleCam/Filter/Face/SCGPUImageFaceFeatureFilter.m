//
//  SCGPUImageFaceFeatureFilter.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/9.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFaceDetectorManager.h"

#import "SCGPUImageFaceFeatureFilter.h"

NSString *const kGPUImageFaceFeatureVertexShaderString = SHADER_STRING
(
 precision highp float;
 
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 varying vec2 textureCoordinate;
 
 uniform float pointSize;
 
 void main()
 {
     gl_Position = position;
     gl_PointSize = pointSize;
     textureCoordinate = inputTextureCoordinate.xy;
 }
);

NSString *const kGPUImageFaceFeatureFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform int isPoint;
 
 void main()
 {
     if (isPoint != 0) {
         gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
     } else {
         gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }
 }
);

@interface SCGPUImageFaceFeatureFilter ()

@property (nonatomic, assign) GLint isPointUniform;
@property (nonatomic, assign) GLint pointSizeUniform;

@end

@implementation SCGPUImageFaceFeatureFilter

- (instancetype)init {
    self = [super initWithVertexShaderFromString:kGPUImageFaceFeatureVertexShaderString
                        fragmentShaderFromString:kGPUImageFaceFeatureFragmentShaderString];
    if (self) {
        self.isPointUniform = [filterProgram uniformIndex:@"isPoint"];
        self.pointSizeUniform = [filterProgram uniformIndex:@"pointSize"];
    }
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices
                 textureCoordinates:(const GLfloat *)textureCoordinates {
    if (self.preventRendering)
    {
        [firstInputFramebuffer unlock];
        return;
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
    glUniform1i(self.isPointUniform, 0);    // 表示是绘制纹理
    
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
    glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    // 绘制点
    if (self.facesPoints) {
        glUniform1i(self.isPointUniform, 1);    // 表示是绘制点
        glUniform1f(self.pointSizeUniform, self.sizeOfFBO.width * 0.006);  // 设置点的大小
        glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, self.facesPoints);
        glDrawArrays(GL_POINTS, 0, [SCFaceDetectorManager facePointCount]);
    }
    
    [firstInputFramebuffer unlock];
    
    if (usingNextFrameForImageCapture)
    {
        dispatch_semaphore_signal(imageCaptureSemaphore);
    }
}

@end
