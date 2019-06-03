//
//  SCVideoModel.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/18.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SCVideoModel : NSObject

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) AVURLAsset *asset;

@end
