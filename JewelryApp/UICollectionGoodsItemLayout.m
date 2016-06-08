//
//  UICollectionGoodsItemLayout.m
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "UICollectionGoodsItemLayout.h"

@implementation UICollectionGoodsItemLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = 10.f;
        self.minimumLineSpacing = 10.f;
        self.itemSize = CGSizeMake(145, 184.f);
    }
    return self;
}

- (CGSize)collectionViewContentSize
{
    CGSize size = [super collectionViewContentSize];
    if (size.height <= self.collectionView.height) {
        size =  CGSizeMake(size.width, self.collectionView.height + 10);
    }
    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}
@end
