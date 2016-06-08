//
//  FactroyCollectionViewCell.h
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsCategoryModel;
@interface GoodsCategoryViewCell : UICollectionViewCell
@property(nonatomic,assign,getter=isNeedShowSeletedState)BOOL needShowSeleteState;
@property(nonatomic,strong)UILabel * caterLabel;
- (void)setCategoryModel:(GoodsCategoryModel *)recommendModel;

- (void)setSelectedSate:(BOOL)selected;
@end
