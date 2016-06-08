//
//  FactoryAllInfoModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/17.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactoryModel.h"
#import "BaseModelMethod.h"

@interface FactoryControllerModel : NSObject

@property(nonatomic,strong)FactoryModel * factoryInfo;
@property(nonatomic,strong)NSArray * qualityGoodsList;  // GoodsCategoryModel
@property(nonatomic,strong)NSArray * newsGoodsList;     // GoodsCategoryModel
@property(nonatomic,strong)NSArray * tagsArray;        //  GoodsCategoryModel

@property(nonatomic,strong)NSMutableArray *  normalList; //内容是GoodsModel
@property(nonatomic,assign)NSInteger normalListMaxCount;

- (NSArray *)getArrayForRecomendArray:(NSArray *)recomArray;
@end
