//
//  SCFaceDetectorHandler.h
//  SimpleCam
//
//  Created by Lyman Li on 2022/10/3.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <Metal/Metal.h>

@interface SCFaceDetectorHandler : NSObject

- (void)detectFaceWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end
