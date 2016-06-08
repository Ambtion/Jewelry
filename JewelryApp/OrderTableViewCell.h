//
//  OrderTableViewCell.h
//  JewelryApp
//
//  Created by kequ on 15/5/10.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderModel.h"
#import "OrderHeadView.h"
#import "OrderGoodsView.h"
#import "OrderPropertyView.h"
#import "ModelDefine.h"

@class OrderTableViewCell;
@protocol OrderTableViewCellDelegate <OrderGoodsViewDelegate,OrderHeadViewDelegate>
- (void)orderTableViewCellDidClickDetailButton:(OrderTableViewCell *)cell model:(OrderModel *)model;
- (void)orderTableViewCellDidClickDeleteButton:(OrderTableViewCell *)cell model:(OrderModel *)orderModel goodModel:(GoodsModel *)goodsModel;
@end

@interface OrderTableViewCell : UITableViewCell

@property(nonatomic,weak)id<OrderTableViewCellDelegate>delegate;
@property(nonatomic,weak)UITableView * tableView;
@property(nonatomic,assign)BOOL isLastView;

+ (CGFloat)cellHeightWithModel:(OrderModel *)model withCellType:(KOrderCellType)type;
- (void)setOrderModel:(OrderModel *)orderModel cellType:(KOrderCellType)type;

@end
