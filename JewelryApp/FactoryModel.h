//
//  FactoryModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsCategoryModel.h"

@interface FactoryModel : NSObject
@property(nonatomic,strong)NSString * factoryId;
@property(nonatomic,strong)NSString * factoryName;
@property(nonatomic,strong)NSString * bgImageView;
@property(nonatomic,strong)NSString * iconImageView;
@property(nonatomic,assign)NSInteger factoryGoodsNum;
@property(nonatomic,assign)NSInteger lastestGoodsNum;
@property(nonatomic,strong)NSString * facroyDes;
@property(nonatomic,strong)NSString * factoryTel;
@property(nonatomic,assign)BOOL isFav;

+ (FactoryModel *)coverDicToModel:(NSDictionary *)dic;

@end
