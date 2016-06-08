//
//  OrderModel.m
//  JewelryApp
//
//  Created by kequ on 15/5/10.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "OrderModel.h"
#import <objc/runtime.h>

static const void * goodsPriceKey = &goodsPriceKey;
static const void * localgoodsPriceKey = &localgoodsPriceKey;
@implementation GoodsModel (Price)

- (void)setGoodsPrice:(CGFloat)goodsPrice
{
    objc_setAssociatedObject(self, goodsPriceKey, [NSNumber numberWithFloat:goodsPrice], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)goodsPrice
{
    NSNumber * number =  objc_getAssociatedObject(self, goodsPriceKey);
    return [number floatValue];
}

- (void)setLocalGoodsPrice:(CGFloat)localGoodsPrice
{
    objc_setAssociatedObject(self, localgoodsPriceKey, [NSNumber numberWithFloat:localGoodsPrice], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)localGoodsPrice
{
    NSNumber * number =  objc_getAssociatedObject(self, localgoodsPriceKey);
    return [number floatValue];
}


@end


@implementation OrderModel

+ (OrderModel *)converDicInfoToModel:(NSDictionary *)dic cellType:(KOrderCellType)type
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]] || ![dic allKeys].count) {
        return nil;
    }
    
    OrderModel * model = [[OrderModel alloc] init];
    
    NSMutableArray * fgoodList = [NSMutableArray arrayWithCapacity:0];
    NSArray * goodsList = [dic objectArrayForKey:@"goods_list"];
    for (int i = 0; i < goodsList.count; i++) {
        GoodsModel * goodsModel  = [GoodsModel coverDicToGoodsModel:goodsList[i]];
        goodsModel.goodsPrice = [[goodsList[i] objectStringForKey:@"price"] floatValue];
        [fgoodList addObject:goodsModel];
    }
    
    model.ordergoodsList = fgoodList;
    NSDictionary * pubInfo = [dic objectInfoForKey:@"public_info"];
    if (!pubInfo) {
        pubInfo = dic;
    }
    model.factoryID = [pubInfo objectStringForKey:@"supplier_id"];
    model.factoryCode = [pubInfo objectStringForKey:@"supplier_code"];

    model.orderId = [pubInfo objectStringForKey:@"order_id"];
    model.orderNum = [pubInfo objectStringForKey:@"order_num"];
    model.state = [[pubInfo objectForKey:@"order_status"] integerValue];
    model.optionalPropertyArray = [self optionArrayWithDic:dic WithCellType:type];
    
    //默认<=2行显示详情
    model.isExpladDetail = model.optionalPropertyArray.count > 2 ? NO: YES;
    return model;
}

+ (NSArray *)optionArrayWithDic:(NSDictionary *)info WithCellType:(KOrderCellType)type
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
  
    KUserRole role = [[UserInfoModel defaultUserInfo] role];
    switch (role) {
        case KUserBuyInShopping:
            [array addObjectsFromArray:[self getXuanhuoInfoWithOdic:info cellType:type]];
            break;
        case KUserBuyInShoppingEnsure:
        {
            
            if (type == KOrderCellTypeWait) {
                NSDictionary * dic = [self getDicWithkey:@"订单编号: " value:[[info objectInfoForKey:@"public_info"] objectStringForKey:@"order_num"]];
                if (dic) {
                    [array addObject:dic];
                    
                }
            }
            [array addObjectsFromArray:[self getXuanhuoInfoWithOdic:info cellType:type]];

            if(type == KOrderCellTypeFinish){
                [array addObjectsFromArray:[self getDingyueInfoWithDic:info cellType:type]];
            }
        }
            break;
        case KUserBuyAboutGoods:
            
            [array addObjectsFromArray:[self getDingyueInfoWithDic:info cellType:type]];
            [array addObjectsFromArray:[self getYueHuoInfoWithDic:info cellType:type]];

            break;
            
        case KUserBuyAboutPrice:
            if(type == KOrderCellTypeWait){
                [array addObjectsFromArray:[self getYueHuoInfoWithDic:info cellType:type]];
                NSDictionary * pubDic = [info objectInfoForKey:@"public_info"];
                NSString * tel = [pubDic objectStringForKey:@"supplier_tel400"];
                [array addObject:[self getDicWithkey:@"厂商电话: " value:tel]];
            }else if(type == KOrderCellTypeFinish){
                [array addObjectsFromArray:[self getYueHuoInfoWithDic:info cellType:type]];
                [array addObjectsFromArray:[self getYijiaInfoWithDic:info cellType:type]];
            }
            break;
        case KUserBuyOrderEnsure:
            
            [array addObjectsFromArray:[self getYijiaInfoWithDic:info cellType:type]];
            
            if(type == KOrderCellTypeWait){
                
            }else if(type == KOrderCellTypeFinish){
                [array addObjectsFromArray:[self getDingHuoWithDic:info cellType:type]];
            }

            break;
        case KUserBuyBossEnsture:
        {
            NSDictionary * dic = [self getDicWithkey:@"订单编号: " value:[[info objectInfoForKey:@"public_info"] objectStringForKey:@"order_num"]];
            if (dic) {
                [array addObject:dic];
            }
            
//            dic = [self getDicWithkey:@"创建时间: " value:[[info objectInfoForKey:@"public_info"] objectStringForKey:@"create_time"]];
//            if (dic) {
//                [array addObject:dic];
//            }
            
            //选货
            [array addObjectsFromArray:[self getXuanhuoInfoWithOdic:info cellType:type]];
            //订约
            [array addObjectsFromArray:[self getDingyueInfoWithDic:info cellType:type]];
            //约货
            [array addObjectsFromArray:[self getYueHuoInfoWithDic:info cellType:type]];
            //议价
            [array addObjectsFromArray:[self getYijiaInfoWithDic:info cellType:type]];
            //订货
            [array addObjectsFromArray:[self getDingHuoWithDic:info cellType:type]];
            //Boss确定

        }
            
            
            break;
            
        case KUserSaleEnsureGoods:
            if(type == KOrderCellTypeWait){
                NSDictionary * dic = [self getDicWithkey:@"订单时间: " value:[info objectStringForKey:@"order_time"]];
                if (dic)
                    [array addObject:dic];
            }else if(type == KOrderCellTypeFinish){
                NSDictionary * dic = [self getDicWithkey:@"订单时间: " value:[info objectStringForKey:@"order_time"]];
                [array addObject:dic];
//                if (dic && [[[info objectInfoForKey:@"public_info"] objectForKey:@"order_status"] integerValue] != KOrderStateOrderFailture)
//                [array addObjectsFromArray:[self getYijiaInfoWithDic:info cellType:type]];
            }

            break;
            
        case KUserSaleUploadGoods:
            
            break;
        default:
            break;
    }
    
    return array;
}

+ (NSArray *)getXuanhuoInfoWithOdic:(NSDictionary *)dic cellType:(KOrderCellType)type
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary * dicInfo = [dic objectInfoForKey:@"xuanhuo_info"];
    NSDictionary * xTimeInfo = [self getDicWithkey:@"选货时间: " value:[dicInfo objectStringForKey:@"time"]];
    NSDictionary * XNameInfo = [self getDicWithkey:@"选货操作: " value:[dicInfo objectStringForKey:@"operator"]];
    if (xTimeInfo)
        [array addObject:xTimeInfo];
    if (XNameInfo)
        [array addObject:XNameInfo];
                                
    return array.count ? array : nil;
}


+ (NSArray *)getDingyueInfoWithDic:(NSDictionary *)dic cellType:(KOrderCellType)type
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary * dicInfo = [dic objectInfoForKey:@"dingyue_info"];
    NSDictionary * xTimeInfo = [self getDicWithkey:@"定约时间: " value:[dicInfo objectStringForKey:@"time"]];
    NSDictionary * XNameInfo = [self getDicWithkey:@"定约操作: " value:[dicInfo objectStringForKey:@"operator"]];
    if (xTimeInfo)
        [array addObject:xTimeInfo];
    if (XNameInfo)
        [array addObject:XNameInfo];
    
    return array.count ? array : nil;

}

+ (NSArray *)getYueHuoInfoWithDic:(NSDictionary *)dic cellType:(KOrderCellType)type
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary * dicInfo = [dic objectInfoForKey:@"yuehuo_info"];
    
    NSDictionary * xTimeInfo = [self getDicWithkey:@"约货时间: " value:[dicInfo objectStringForKey:@"time"]];
    NSDictionary * XNameInfo = [self getDicWithkey:@"约货操作: " value:[dicInfo objectStringForKey:@"operator"]];
    NSDictionary * aTimeInfo = [self getDicWithkey:@"到货时间: " value:[dicInfo objectStringForKey:@"arrive_time"]];
    NSDictionary * aNameInfo = [self getDicWithkey:@"到货地点: " value:[dicInfo objectStringForKey:@"arrive_addr"]];
    
    if (!aNameInfo && type == KOrderCellTypeWait) {
        aNameInfo = [self getDicWithkey:@"到货地点: " value:@"待定"];
    }
    if (!aTimeInfo && type == KOrderCellTypeWait) {
        aTimeInfo = [self getDicWithkey:@"到货时间: " value:@"待定"];
    }
    
    if (xTimeInfo)
        [array addObject:xTimeInfo];
    if (XNameInfo)
        [array addObject:XNameInfo];
    
    if(aTimeInfo)
        [array addObject:aTimeInfo];
    if (aNameInfo) {
        [array addObject:aNameInfo];
    }
    return array.count ? array : nil;
}


+ (NSArray *)getYijiaInfoWithDic:(NSDictionary *)dic cellType:(KOrderCellType)type
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary * dicInfo = [dic objectInfoForKey:@"yijia_info"];
    
    NSDictionary * xTimeInfo = [self getDicWithkey:@"议价时间: " value:[dicInfo objectStringForKey:@"time"]];
    NSDictionary * XNameInfo = [self getDicWithkey:@"议价操作: " value:[dicInfo objectStringForKey:@"operator"]];
    
    if (xTimeInfo)
        [array addObject:xTimeInfo];
    if (XNameInfo)
        [array addObject:XNameInfo];
    
    return array.count ? array : nil;

}

+ (NSArray *)getDingHuoWithDic:(NSDictionary *)dic cellType:(KOrderCellType)type
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary * dicInfo = [dic objectInfoForKey:@"dinghuo_info"];
    
    NSDictionary * xTimeInfo = [self getDicWithkey:@"定货时间: " value:[dicInfo objectStringForKey:@"time"]];
    NSDictionary * XNameInfo = [self getDicWithkey:@"定货操作: " value:[dicInfo objectStringForKey:@"operator"]];
    
    if (xTimeInfo)
        [array addObject:xTimeInfo];
    if (XNameInfo)
        [array addObject:XNameInfo];
    
    return array.count ? array : nil;
}

#pragma mark -  common-Method

+ (NSDictionary *)getDicWithkey:(NSString *)key value:(NSString *)value
{
    if (key && value && ![value isEqualToString:@""]) {
        return @{@"key":key,@"value":value};
    }
    return nil;
}

#pragma mark - UIModel
+ (NSString *)coverStateToString:(KOrderState)state
{
    switch (state) {
        case KOrderStateShopping:
            return @"选货中";
        case KOrderStateInShopping:
            return @"定约中";
            break;
        case KOrderStateInorder:
            return @"约货中";
            break;
        case KOrderStateAboutGoods:
            return @"议价中";
        case KOrderStateFactoryEnsturPrice:
            return @"议价中";
        case KOrderStateAboutPriceEnsure:
            return @"定货中";
            break;
        case KOrderStateOrderEnsture:
            return @"终选中";
            break;
        case KOrderStateOrderEnsrureByBoss:
            return @"待付款";
            break;            
        case KOrderStateOrderSucess:
            return @"交易完成";
            break;
        case KOrderStateOrderFailture:
            return @"交易取消";
            break;
            
            break;
            
        default:
            break;
    }
    return @"";
}

- (double)totalPrice
{
    double  price = 0;
    for (GoodsModel * model in self.ordergoodsList) {
        price += model.goodsPrice;
    }
    return price;
}

- (BOOL)hasAboutPriceInfo
{
    for (NSDictionary * dic in self.optionalPropertyArray) {
        NSString * key = [dic objectStringForKey:@"key"];
        NSString * value = [dic objectStringForKey:@"value"];
        NSRange rang = [key rangeOfString:@"到货地点"];
        if (rang.location != NSNotFound && ![value isEqualToString:@"待定"]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isAllGoodsHasPrice
{
    for (GoodsModel * model in self.ordergoodsList) {
//        NSLog(@"%d",model.goodsPrice <= 0 && model.localGoodsPrice <= 0);
        if (model.goodsPrice <= 0 && model.localGoodsPrice <= 0) {
            return NO;
        }
    }
    return YES;
}

- (NSString *)coverDataToString:(NSDate *)date
{
    NSDateFormatter * format = [[NSDateFormatter  alloc] init];
    [format setDateFormat:@"yyyy-MM-dd  HH:mm"];
    return [format stringFromDate:date];
}

@end
