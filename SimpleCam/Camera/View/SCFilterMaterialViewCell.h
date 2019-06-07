//
//  SCFilterMaterialViewCell.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCFilterMaterialModel.h"

@interface SCFilterMaterialViewCell : UICollectionViewCell

@property (nonatomic, strong) SCFilterMaterialModel *filterMaterialModel;
@property (nonatomic, assign) BOOL isSelect;  

@end
