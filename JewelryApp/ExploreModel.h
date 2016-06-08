//
//  ExploreModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"
#import "GoodsCategoryModel.h"
#import "BaseModelMethod.h"

@interface ExploreModel : NSObject
@property(nonatomic,strong)NSArray * qualityGoodsList;  // GoodsCategoryModel
@property(nonatomic,strong)NSArray * newsGoodsList;     // GoodsCategoryModel
@property(nonatomic,strong)NSArray * tagsArray;        //  GoodsCategoryModel

@property(nonatomic,strong)NSMutableArray *  normalList; //内容是GoodsModel
@property(nonatomic,assign)NSInteger normalListMaxCount;

- (NSArray *)getArrayForRecomendArray:(NSArray *)recomArray;

@end
