//
//  OrderHeadView.h
//  JewelryApp
//
//  Created by kequ on 15/5/13.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelDefine.h"

@class OrderHeadView;
@protocol OrderHeadViewDelegate <NSObject>
- (void)orderHeadViewSeletedButtonDidClick:(UIButton *)button;
- (void)orderHeadViewDidClick:(OrderHeadView *)headView;
@end

@interface OrderHeadViewModel : NSObject
//@property(nonatomic,strong)NSString * orderId;
@property(nonatomic,strong)NSString * orderNum;
@property(nonatomic,strong)NSString * factoryID;
@property(nonatomic,strong)NSString * factoryCode;
@property(nonatomic,assign)KOrderState orderState;
@property(nonatomic,assign)NSInteger goodsCount;
@property(nonatomic,assign)CGFloat totalPrice;
@property(nonatomic,assign)KOrderCellType cellType;
@property(nonatomic,assign)BOOL isOrderSeleted;
@end

@interface OrderHeadView : UIControl
@property(nonatomic,strong)UILabel * leftLabel;
@property(nonatomic,weak)id<OrderHeadViewDelegate>delegate;
@property(nonatomic,strong,readonly)OrderHeadViewModel * headViewModel;

+ (CGFloat)orderHeadViewHightWithOrderCelltype:(KOrderCellType)type;

//HeadView显示的元素 ： 选择状态，订单编码，厂家信息，订单状态，订单货货品数量
//显示元素根据不同状态的订单对应人物权限，自动变化
- (void)setDadaSourceWithOrderCelltype:(KOrderCellType)type
                        isOrderSeleted:(BOOL)isOrderSeleted
                               orderID:(NSString *)orderID
                             factoryID:(NSString *)factoryId
                           facyoryCode:(NSString *)factroyCode
                  orderGoodsTotalPrice:(CGFloat)totalPrice
                            orderState:(KOrderState)orderState
                            goodsCount:(NSInteger)goodsCount;
@end
