//
//  SearchTagViews.m
//  JewelryApp
//
//  Created by kequ on 15/5/17.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "SearchTagViews.h"
#import "TagLabelCell.h"
#import "JWCollectionViewFlowLayout.h"

@interface SearchTagViews()<UICollectionViewDataSource,UICollectionViewDelegate>
@end

@implementation SearchTagViews

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.spacing = 13.f;
    }
    return self;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = _spacing;
        layout.minimumInteritemSpacing = _spacing;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 1000,1000) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.clipsToBounds = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
        [_collectionView registerClass:[TagLabelCell class] forCellWithReuseIdentifier:@"CELL"];
        
    }
    return _collectionView;
}

- (void)setDataSourceArray:(NSArray *)dataSourceArray
{
    if (_dataSourceArray == dataSourceArray) {
        return;
    }
    _dataSourceArray = dataSourceArray;
    [self.collectionView reloadData];
}

#pragma mark - Delegate | DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return self.imageSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagLabelCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    if (indexPath.row < self.dataSourceArray.count) {
        cell.label.text = self.dataSourceArray[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(searchTagViews:DidIndePath:)]) {
        [_delegate searchTagViews:self DidIndePath:indexPath];
    }
}


@end
