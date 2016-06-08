//
//  TagFillterModel.m
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "TagFillterModel.h"
#import "GoodsModel.h"

@implementation TagFillterModel

- (instancetype)init
{
    if (self = [super init]) {
        _goodsSourceSortType = @[@"新品",@"推荐"];
        self.seletedRecomendType = KGoodRecomendInvalid;
        
        NSMutableArray  * array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 1; i < KGoodsPriceSectionCount; i++) {
            [array addObject:[NSNumber numberWithInteger:i]];
        }
        _priceSectionArray = [array copy];
        _seletedPriceArray = [NSMutableArray arrayWithCapacity:0];

        _goodsStateArray = @[@"可约货",@"已约出",@"已售出"];
        self.seletedGoodState = KGoodsStateInvalid;
        
        _categorySeletedIndexs = [NSMutableArray arrayWithCapacity:0];
        
        self.tagType = KTagSearchTypeSaleGoods;
    }
    return self;
}

- (NSArray *)allSeletedTagsArray
{
    NSMutableArray * tags = [NSMutableArray arrayWithCapacity:0];
    
    //新品推荐
    if (self.seletedRecomendType < self.goodsSourceSortType.count) {
        NSString * str = [[self goodsSourceSortType] objectAtIndex:self.seletedRecomendType];
        if (str) {
            [tags addObject:str];
        }
    }
    
    //商品类别
    for (GoodsCategoryModel * cmodel in self.categorySeletedIndexs) {
        [tags addObject:cmodel.categoryKeyWorld];
    }
    
    //价格范围
    for (NSNumber * number in self.seletedPriceArray) {
        [tags addObject:[GoodsModel coverGoodPriceSectionToString:[number intValue]]];
    }
    
    //商品状态
    if (_seletedGoodState != KGoodsStateInvalid && _seletedGoodState < _goodsStateArray.count) {
        [tags addObject:[_goodsStateArray objectAtIndex:_seletedGoodState]];
    }
    return tags;
}

@end
