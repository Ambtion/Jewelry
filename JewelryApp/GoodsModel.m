//
//  GoodsModel.m
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

+ (GoodsModel *)coverDicToGoodsModel:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]] ||![dic allKeys].count) {
        return nil;
    }
    
    GoodsModel * model = [[GoodsModel alloc] init];
    
    model.goodsFactoryID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"supplier_id"]];
    model.goddsFactoryCode = [dic objectStringForKey:@"supplier_code"];
    model.facgoryGoodsCountNum = [[dic objectForKey:@"goods_count"] integerValue];
    
    model.goodsID = [dic objectStringForKey:@"goods_id"];
    model.goodsName = [dic objectStringForKey:@"goods_sn"];
    model.goodsImageArry = [[dic objectForImageArray:@"image"] mutableCopy];
    
    model.goodsCount = [[dic objectForKey:@"spec"] integerValue];
    model.goodsDes = [dic objectStringForKey:@"description"];
//    if (!model.goodsDes) {
//        model.goodsDes = @"该货品无描述";
//    }
    
    GoodsCategoryModel * cater = [[GoodsCategoryModel alloc] init];
    cater.categoryKeyWorld = [dic objectStringForKey:@"category_name"];
    cater.categoryID = [dic objectStringForKey:@"category_id"];
    model.goodsCatery = cater;
    
    model.goodsPriceSection = [[dic objectForKey:@"price_range"] intValue];
    model.state = [[dic objectForKey:@"status"] intValue];
    
    model.goodSUpLoaddata = [dic objectStringForKey:@"create_time"];
    
    model.goodsUploaderName = [dic objectStringForKey:@"uploader"];
    model.isFaved = [[dic objectForKey:@"is_focus"] boolValue];
    model.modifyPermission = [[dic objectForKey:@"modify_permission"] boolValue];
    model.deletePermission = [[dic objectForKey:@"delete_permission"] boolValue];

    
    return model;
}

- (NSMutableArray *)uploadImagesArray
{
    if (!_uploadImagesArray) {
        _uploadImagesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _uploadImagesArray;
}

- (NSArray *)getPeropertys
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    //产品编号
    if (self.goodsName) {
        [array addObject:@{@"货品编号":self.goodsName}];
    }
    //货物状态
    [array addObject:[self converStateToDic:self]];
    
    //货品类型
    if(self.goodsCatery.categoryKeyWorld){
        [array addObject:@{@"货品类型":self.goodsCatery.categoryKeyWorld}];
    }
    
    //数量规格
    NSNumber * number = [NSNumber numberWithInteger:self.goodsCount];
    NSString * value = [NSString stringWithFormat:@"%@个/件",number];
    [array addObject:@{@"数量规格":value}];
    
    //价格区间
    value = [NSString stringWithFormat:@"￥%@",[GoodsModel coverGoodPriceSectionToString:self.goodsPriceSection]];
    [array addObject:@{@"价格区间":value}];

    //上货时间
    if(self.goodSUpLoaddata){
        [array addObject:@{@"上货时间":self.goodSUpLoaddata}];
    }    
    return array;
}

#pragma mark Data Oper
- (NSDictionary *)converStateToDic:(GoodsModel *)model
{
    NSString * value = [GoodsModel converStateTostring:model.state];
    return @{@"货品状态":value};
}

+ (NSString *)coverGoodPriceSectionToString:(KGoodsPriceSection)section
{
    NSString * value = @"";
    switch (section) {
        case KGoodsPriceSection0_1999:
            value =  @"0~1999";
            break;
        case KGoodsPriceSection2000_4999:
            value =  @"2000~4999";
            break;
        case KGoodsPriceSection5000_9999:
            value =  @"5000~9999";
            break;
        case KGoodsPriceSection10000_49999:
            value = @"10000~49999";
            break;
        case KGoodsPriceSection50000_:
            value =  @"50000以上";
            break;
        default:
            break;
    }
    return value;
}

+ (NSString *)converStateTostring:(KGoodsState)state
{
    NSString * value =  @"可约货";
    switch (state) {
        case KGoodsStateHaveSource:
            value = @"可约货";
            break;
        case KGoodsStateScaleInOrder:
            value = @"已约出";
            break;
        case KGoodsStateScaleOver:
            value = @"已售出";
        default:
            break;
    }
    return value;
}

+ (NSString *)coverDataToString:(NSDate *)date
{
    NSDateFormatter * format = [[NSDateFormatter  alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:date];
}
@end
