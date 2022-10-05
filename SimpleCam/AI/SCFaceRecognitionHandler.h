//
//  SCFaceRecognitionHandler.h
//  SimpleCam
//
//  Created by Lyman Li on 2022/10/5.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFaceRecognitionHandler : NSObject

- (void)detectFaceWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end
