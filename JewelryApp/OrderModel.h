//
//  OrderModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/10.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"
#import "ModelDefine.h"

@interface GoodsModel (Price)
@property(nonatomic,assign)CGFloat goodsPrice;
@property(nonatomic,assign)CGFloat localGoodsPrice;
@end

@interface OrderModel : NSObject

@property(nonatomic,assign)BOOL isSeletedState;
@property(nonatomic,strong)NSMutableArray * ordergoodsList;
@property(nonatomic,strong)NSString * orderId;
@property(nonatomic,strong)NSString * orderNum;
@property(nonatomic,strong)NSString * factoryID;
@property(nonatomic,strong)NSString * factoryCode;
@property(nonatomic,assign)KOrderState state;
@property(nonatomic,assign)BOOL isExpladDetail;
@property(nonatomic,strong)NSArray * optionalPropertyArray;

+ (OrderModel *)converDicInfoToModel:(NSDictionary *)dic cellType:(KOrderCellType)type;

+ (NSString *)coverStateToString:(KOrderState)state;

- (NSString *)coverDataToString:(NSDate *)date;

- (double)totalPrice;

- (BOOL)hasAboutPriceInfo;

- (BOOL)isAllGoodsHasPrice;
@end
