//
//  SCFilterMaterialModel.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>

@interface SCFilterMaterialModel : NSObject

@property (nonatomic, copy) NSString *filterID;
@property (nonatomic, copy) NSString *tabID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filterClass;

@property (nonatomic, assign) NSInteger sort;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                            floder:(NSString *)floder;

- (GPUImageFilter *)filter;

- (NSString *)floderPath;

- (NSString *)coverImagePath;

@end
