//
//  SCFaceAlignmentHandler.h
//  SimpleCam
//
//  Created by Lyman Li on 2022/10/2.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFaceAlignmentHandler : NSObject

- (void)detectFaceWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

