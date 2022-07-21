//
//  SCTabModel.m
//  SimpleCam
//
//  Created by Lyman Li on 2022/7/19.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import "SCTabModel.h"

@implementation SCTabModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.tabID = dictionary[@"id"];
        self.name = dictionary[@"name"];
    }
    return self;
}

@end
