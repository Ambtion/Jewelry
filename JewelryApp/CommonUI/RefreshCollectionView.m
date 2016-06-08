//
//  RefreshCollectionView.m
//  JewelryApp
//
//  Created by kequ on 15/5/4.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "RefreshCollectionView.h"

@implementation RefreshCollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
//        self.showsVerticalScrollIndicator = NO;
        [self initRefreshView];
    }
    return self;
}

- (void)initRefreshView
{
    self.refreshHeader =[[YiRefreshHeader alloc] init];
    self.refreshHeader.scrollView = self;
    [self.refreshHeader header];
    
    self.refreshFooter = [[YiRefreshFooter alloc] init];
    self.refreshFooter.scrollView = self;
    [self.refreshFooter footer];
    
    self.refreshHeader.beginRefreshingBlock=^(){
    };
    
    self.refreshFooter.beginRefreshingBlock=^(){
    };
    
}

@end
