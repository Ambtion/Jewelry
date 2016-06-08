//
//  TagFillterModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsCategoryModel.h"

typedef NS_ENUM(NSInteger, KTagSearchType) {
    KTagSearchTypeSaleGoods,
    KTagSearchTypeUploadGoods
};

@interface TagFillterModel : NSObject
@property(nonatomic,strong,readonly)NSArray *  goodsSourceSortType;  //新品，推荐
@property(nonatomic,strong,readonly)NSArray * priceSectionArray;
@property(nonatomic,strong)NSArray * goodsStateArray;
@property(nonatomic,strong)NSArray * categoryTagArray;
//特色针对从筛选进入的Search,优先使用
@property(nonatomic,strong)NSString * factoryID;

@property(nonatomic,assign)KGoodRecomendType seletedRecomendType;
@property(nonatomic,strong,readonly)NSMutableArray * categorySeletedIndexs;
@property(nonatomic,strong,readonly)NSMutableArray * seletedPriceArray;

@property(nonatomic,assign)KGoodsState  seletedGoodState;

- (NSArray *)allSeletedTagsArray;

@property(nonatomic,assign)KTagSearchType tagType;


@end
