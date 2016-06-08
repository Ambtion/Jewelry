//
//  GoodsModel+UploadorModify.h
//  JewelryApp
//
//  Created by kequ on 15/5/9.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "GoodsModel.h"

@interface GoodsModel (UploadorModify)
@property(nonatomic,strong)NSArray * goodsCategoryArrays;
@property(nonatomic,strong)NSArray * goodsPriceSectionArrays;
@property(nonatomic,assign)NSInteger seletedCategory;        //单选使用
@property(nonatomic,assign)NSInteger seletedPriceSetion;
//@property(nonatomic,strong)NSMutableArray * uploadImagesArray;

@end
