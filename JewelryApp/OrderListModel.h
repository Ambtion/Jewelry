//
//  OrderListModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/13.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"

@interface OrderSateNumModel : NSObject
@property(nonatomic,assign)KOrderProgressState state;
@property(nonatomic,assign)NSInteger stateNumber;
- (NSString *)orderProgessStateStr;
@end

@interface OrderListModel : NSObject
@property(nonatomic,assign)NSInteger totalOrderCount;
@property(nonatomic,assign)NSInteger curPage;
@property(nonatomic,assign)NSInteger totalPage;
@property(nonatomic,strong)NSArray * orderStateNumList; //stateModel List
@property(nonatomic,strong)NSMutableArray * orderList;
- (NSArray *)allgoodsModelArray;
- (NSArray *)allSeletedGoodsModelArray;
- (NSArray *)allSeletedOrderModelArray;
- (void)setAllSeleted:(BOOL)isAllSeleted;
@end
