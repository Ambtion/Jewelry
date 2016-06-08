//
//  GoodsModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDefine.h"
#import "GoodsCategoryModel.h"

@interface GoodsModel : NSObject

@property(nonatomic,strong)NSString * goodsID;
@property(nonatomic,strong)NSString * goodsName;
//厂家信息
@property(nonatomic,strong)NSString * goodsFactoryID;
@property(nonatomic,strong)NSString * goddsFactoryCode;
@property(nonatomic,assign)NSInteger facgoryGoodsCountNum;
//商品信息
@property(nonatomic,strong)NSMutableArray * goodsImageArry;
@property(nonatomic,strong)NSString * goodsDes;

@property(nonatomic,assign)NSInteger  goodsCount;                     //数量规格
@property(nonatomic,strong)GoodsCategoryModel * goodsCatery;          //类别，如：翡翠，戒指等
@property(nonatomic,assign)KGoodsPriceSection  goodsPriceSection;     //价格区间
@property(nonatomic,assign)KGoodsState state;                         //商品状态

@property(nonatomic,strong)NSString * goodSUpLoaddata;                //上架时间
@property(nonatomic,strong)NSString * goodsUploaderName;            //上传人姓名

@property(nonatomic,assign)BOOL isFaved;                            //是否关注
@property(nonatomic,assign)BOOL isInOrder;                          //是否在订单中
@property(nonatomic,assign)BOOL modifyPermission;
@property(nonatomic,assign)BOOL deletePermission;

@property(nonatomic,strong)NSMutableArray * uploadImagesArray;


+ (GoodsModel *)coverDicToGoodsModel:(NSDictionary *)dic;
+ (NSString *)coverGoodPriceSectionToString:(KGoodsPriceSection)section;
+ (NSString *)converStateTostring:(KGoodsState)state;
+ (NSString *)coverDataToString:(NSDate *)date;

//争对商品详情页设计的接口
- (NSArray *)getPeropertys;
@end
