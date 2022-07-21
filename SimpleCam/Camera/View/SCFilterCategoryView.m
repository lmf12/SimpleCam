//
//  SCFilterCategoryView.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/1.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFilterCategoryCell.h"

#import "SCFilterCategoryView.h"

static NSString * const kFilterCategoryReuseIdentifier = @"kFilterCategoryReuseIdentifier";

@interface SCFilterCategoryView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic, assign, readwrite) NSInteger currentIndex;

@end

@implementation SCFilterCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _collectionView.frame = [self bounds];
    _collectionViewLayout.itemSize = CGSizeMake(_itemWidth, CGRectGetHeight(self.frame));
    
    [_collectionView reloadData];
}

#pragma mark - Custom Accessor

- (void)setItemList:(NSArray<SCTabModel *> *)itemList {
    
    _itemList = [itemList copy];
    [_collectionView reloadData];
}

- (void)setItemFont:(UIFont *)itemFont {
    
    _itemFont = itemFont;
    [_collectionView reloadData];
}

- (void)setItemWidth:(CGFloat)itemWidth {
    
    _itemWidth = itemWidth;
    [_collectionView reloadData];
}

- (void)setItemNormalColor:(UIColor *)itemNormalColor {
    
    _itemNormalColor = itemNormalColor;
    [_collectionView reloadData];
}

- (void)setItemSelectColor:(UIColor *)itemSelectColor {
    
    _itemSelectColor = itemSelectColor;
    [_collectionView reloadData];
}

#pragma mark - Public

- (void)scrollToIndex:(NSUInteger)index {
    
    if (_currentIndex == index) {
        return;
    }
    if (index >= _itemList.count) {
        return;
    }
    
    [self selectIndex:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - Private

- (void)commonInit {
    
    [self createCollectionViewLayout];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:[self bounds] collectionViewLayout:_collectionViewLayout];
    [self addSubview:_collectionView];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[SCFilterCategoryCell class] forCellWithReuseIdentifier:kFilterCategoryReuseIdentifier];
}

- (void)createCollectionViewLayout {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置间距
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    //设置item尺寸
    CGFloat itemW = _itemWidth;
    CGFloat itemH = CGRectGetHeight(self.frame);
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 设置水平滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionViewLayout = flowLayout;
}

- (void)selectIndex:(NSIndexPath *)indexPath {
    if (indexPath.row == _currentIndex) {
        return;
    }
    _currentIndex = indexPath.row;
    [_collectionView reloadData];
    
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(filterCategoryView:didScrollToIndex:)]) {
        [self.delegate filterCategoryView:self didScrollToIndex:_currentIndex];
    }
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _itemList ? [_itemList count] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCFilterCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFilterCategoryReuseIdentifier forIndexPath:indexPath];
    
    // 配置样式
    UILabel *label = cell.titleLabel;
    label.text = _itemList[indexPath.row].name;
    label.font = _itemFont;
    label.textColor = _currentIndex == indexPath.row ? _itemSelectColor : _itemNormalColor;
    
    UIView *bottomLine = cell.bottomLine;
    if (_currentIndex == indexPath.row) {
        bottomLine.hidden = NO;
        bottomLine.backgroundColor = _itemSelectColor;
    } else {
        bottomLine.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectIndex:indexPath];
}


@end
