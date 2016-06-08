//
//  JWImageItemScrollView.m
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "JWImageItemScrollView.h"
#import "JWImageViewCell.h"

@interface JWImageItemScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,assign)CGFloat spacing;
@property(nonatomic,assign)NSInteger seletedIndex;
@end

@implementation JWImageItemScrollView

- (instancetype)initWithMinimumInteritemSpacing:(CGFloat)spacing
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.spacing = spacing;
        self.complectionImage = @"temp";
        self.completionMaxCount = 0;
        self.isShowSeletedState = NO;
        self.seletedIndex = -1;
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
        
        [_collectionView registerClass:[JWImageViewCell class] forCellWithReuseIdentifier:@"CELL"];
        
    }
    return _collectionView;
}


- (void)setComplectionImage:(NSString *)complectionImage
{
    if(!complectionImage) return;
    _complectionImage = complectionImage;
    [self.collectionView reloadData];
}

- (void)setCompletionMaxCount:(NSInteger)completionMaxCount
{
    _completionMaxCount = completionMaxCount;
    [self.collectionView reloadData];
}


- (void)setSeletedIndexPath:(NSInteger)indexPath
{
    self.isShowSeletedState  = YES;
    self.seletedIndex = indexPath;
    NSIndexPath * path = [NSIndexPath indexPathForRow:self.seletedIndex inSection:0];
    [self.collectionView selectItemAtIndexPath:path animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
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
    return MAX(self.dataSourceArray.count, self.completionMaxCount);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return self.imageSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWImageViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    if (indexPath.row < self.dataSourceArray.count) {
        NSString * imageStr = [self.dataSourceArray objectAtIndex:indexPath.row];
        if (imageStr.length) {
            [cell.porView.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:self.complectionImage]];
        }else{
            cell.porView.imageView.image = [UIImage imageNamed:self.complectionImage];
        }
        
    }else{
        cell.porView.imageView.image = [UIImage imageNamed:self.complectionImage];
    }
    cell.needShowSeletedState = self.isShowSeletedState;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _seletedIndex = indexPath.row;
    if ([_delegate respondsToSelector:@selector(jwimagesScrollView:DidImageView:indePath:)]) {
        JWImageViewCell * cell = (JWImageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell) {
            [_delegate jwimagesScrollView:self DidImageView:cell.porView indePath:indexPath];
        }
    }
}

@end
