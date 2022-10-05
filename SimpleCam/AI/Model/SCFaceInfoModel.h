//
//  SCFaceInfoModel.h
//  SimpleCam
//
//  Created by Lyman Li on 2022/10/3.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFaceInfoModel : NSObject

@property (nonatomic, assign) CGFloat x1;
@property (nonatomic, assign) CGFloat y1;
@property (nonatomic, assign) CGFloat x2;
@property (nonatomic, assign) CGFloat y2;

@property (nonatomic, assign) NSInteger imageWidth;
@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) CGFloat score;

@property (nonatomic, copy) NSArray<NSValue *> *keyPoints;

@end
