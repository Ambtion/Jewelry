//
//  OrderGoodsView.h
//  JewelryApp
//
//  Created by kequ on 15/5/10.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "PortraitView.h"

@class OrderGoodsView;
@protocol OrderGoodsViewDelegate <NSObject>
@optional
- (void)orderGoodsViewDidFavGoods:(GoodsModel *)model button:(UIButton *)button;
- (void)orderGoodsViewTextViewDidBeginEdit:(OrderGoodsView *)goodsView;
- (void)orderGoodsViewDidDelegateGoodsFromOrder:(GoodsModel *)model;
- (void)orderGoodsViewDidClickDetailInfoInView:(GoodsModel *)model;
@end

@interface OrderGoodsView : UIView

@property(nonatomic,weak)id<OrderGoodsViewDelegate>delegate;
@property(nonatomic,strong)GoodsModel * goodModel;
@property(nonatomic,assign)KOrderCellType type;
@property(nonatomic,strong)UIView * lineView;
@property(nonatomic,strong)PortraitView * porViews;

+ (CGFloat)heightwithGoodModel:(GoodsModel *)goodModel WithOrderCelltype:(KOrderCellType)type;

- (void)setGoodModel:(GoodsModel *)goodModel WithOrderCelltype:(KOrderCellType)type orderSeletedStart:(BOOL)orderSeletedState;

@end
