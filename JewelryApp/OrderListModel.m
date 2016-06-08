//
//  OrderListModel.m
//  JewelryApp
//
//  Created by kequ on 15/5/13.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderSateNumModel

- (NSString *)orderProgessStateStr
{
    switch (self.state) {
        case KOrderProgressStateInOrdering:
            return @"定约中";
        case KOrderProgressStateInAboutGoods:
            return @"约货中";
        case KOrderProgressStateInAbutPrice:
            return @"议价中";
        case KOrderProgressStateInOrderEnsutre:
            return @"定货中";
        case KOrderProgressStateSaleWaitEnsure:
            return @"待确认";
        case KOrderProgressStateSaleInWaitngPay:
        case KOrderProgressStateInWaitngPay:
            return @"待付款";
        case KOrderProgressStateSaleInDone:
        case KOrderProgressStateInDone:
            return @"交易完成";
        case KOrderProgressStateSaleInCancel:
        case KOrderProgressStateInCancel:
            return @"交易取消";
        default:
            break;
    }
    return @"";
}
@end

@implementation OrderListModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.totalOrderCount = 0;
        self.orderStateNumList = [[NSArray alloc] init];
        self.orderList =  [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (NSArray *)allgoodsModelArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (OrderModel * model in self.orderList) {
        for (GoodsModel * goodsModel in model.ordergoodsList) {
            goodsModel.goodsFactoryID = model.factoryID;
            goodsModel.goddsFactoryCode = model.factoryCode;
            [array addObject:goodsModel];
        }
    }
    return array;
}

- (NSArray *)allSeletedGoodsModelArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (OrderModel * model in self.orderList) {
        if (!model.isSeletedState)
            continue;
        for (GoodsModel * goodsModel in model.ordergoodsList) {
            goodsModel.goodsFactoryID = model.factoryID;
            goodsModel.goddsFactoryCode = model.factoryCode;
            [array addObject: goodsModel];
        }

    }
    return array;

}

- (NSArray *)allSeletedOrderModelArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (OrderModel * model in self.orderList) {
        if (model.orderId && model.isSeletedState) {
            [array addObject:model];
        }
    }
    return array;
}

- (void)setAllSeleted:(BOOL)isAllSeleted
{
    for (OrderModel * model in self.orderList) {
        model.isSeletedState = isAllSeleted;
    }
}

@end
