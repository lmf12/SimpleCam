//
//  SCHairSegmentationFilter.m
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/13.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import "SCAIManager.h"
#import "SCMetalTextureConverter.h"

#import "SCHairSegmentationFilter.h"

@interface SCHairSegmentationFilter ()

@property (nonatomic, strong) SCMetalTextureConverter *textureConverter;
@property (nonatomic, strong) GPUImageFramebuffer *hairFramebuffer;
@property (nonatomic, strong) id<MTLTexture> hairTexture;

@end

@implementation SCHairSegmentationFilter

- (void)dealloc {
    if (_hairFramebuffer) {
        [_hairFramebuffer unlock];
    }
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex {
    CVPixelBufferRef inputPixelBuffer = firstInputFramebuffer.renderTarget;
    if (inputPixelBuffer) {
        [[SCAIManager shareManager] hairSegmentationWithSrcPixelBuffer:inputPixelBuffer dstTexture:self.hairTexture];
    }
    [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates {
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
    
    CVPixelBufferRef inputPixelBuffer = firstInputFramebuffer.renderTarget;
    if (inputPixelBuffer) {
        GLint maskUniform = [filterProgram uniformIndex:@"hairMask"];
        glActiveTexture(GL_TEXTURE3);
        glBindTexture(GL_TEXTURE_2D, self.hairFramebuffer.texture);
        glUniform1i(maskUniform, 3);
    }
    
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

#pragma mark - getter

- (GPUImageFramebuffer *)hairFramebuffer {
    if (!_hairFramebuffer) {
        _hairFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:CGSizeMake(firstInputFramebuffer.size.width, firstInputFramebuffer.size.height) onlyTexture:NO];
    }
    return _hairFramebuffer;
}

- (id<MTLTexture>)hairTexture {
    if (!_hairTexture) {
        _hairTexture = [self.textureConverter textureWithPixelBuffer:self.hairFramebuffer.renderTarget];
    }
    return _hairTexture;
}

- (SCMetalTextureConverter *)textureConverter {
    if (!_textureConverter) {
        _textureConverter = [[SCMetalTextureConverter alloc] init];
    }
    return _textureConverter;
}

@end
