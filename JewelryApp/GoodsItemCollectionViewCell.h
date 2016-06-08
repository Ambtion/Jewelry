//
//  GoodsItemCollectionViewCell.h
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
#import "UICollectionGoodsItemLayout.h"

@protocol GoodsItemCollectionViewCellDelegate <NSObject>
- (void)goodsItemCollectionViewCellDidClickGoodDetailInfo:(GoodsModel *)goodModel;
- (void)goodsItemCollectionViewCellDidClickFactoryDetailInfo:(GoodsModel *)goodModel;
@end
@interface GoodsItemCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak)id<GoodsItemCollectionViewCellDelegate>delegate;
//@property(nonatomic,assign)BOOL isNeedShowGoodsCounts; //默认显示厂家货品数量
- (void)setGoodsModel:(GoodsModel *)goodsModel;

@end
