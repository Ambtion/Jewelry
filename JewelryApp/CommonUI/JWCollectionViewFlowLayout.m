//
//  JWCollectionViewFlowLayout.m
//  JewelryApp
//
//  Created by kequ on 15/5/17.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "JWCollectionViewFlowLayout.h"

@implementation JWCollectionViewFlowLayout

- (CGSize)collectionViewContentSize
{
    CGSize size = [super collectionViewContentSize];
    if (size.height <= self.collectionView.height) {
        size =  CGSizeMake(size.width, self.collectionView.height + 10);
    }
    return size;
}

@end
