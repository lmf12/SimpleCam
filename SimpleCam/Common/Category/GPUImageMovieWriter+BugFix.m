//
//  GPUImageMovieWriter+BugFix.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/25.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCGPUImageMovieWriter.h"

#import "GPUImageMovieWriter+BugFix.h"

@implementation GPUImageMovieWriter (BugFix)

/**
 修复 GPUImageMovieWriter 保存黑屏问题，
 在不修改源码的基础上，在 SCGPUImageMovieWriter 上修改，
 然后将 GPUImageMovieWriter 的类型指为 SCGPUImageMovieWriter
 修改方式参考链接：https://www.jianshu.com/p/443e8ea7b0c5
 */
- (Class)class {
    return [SCGPUImageMovieWriter class];
}

@end
