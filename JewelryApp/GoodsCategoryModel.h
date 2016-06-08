//
//  RecomendGoogsModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsCategoryModel : NSObject

@property(nonatomic,strong)NSString * categoryImageStr;
@property(nonatomic,strong)NSString * categoryKeyWorld;
@property(nonatomic,strong)NSString * categoryID;

+ (GoodsCategoryModel *)converDicInfoToModel:(NSDictionary *)info;
@end
