//
//  GoodsModel+UploadorModify.m
//  JewelryApp
//
//  Created by kequ on 15/5/9.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "GoodsModel+UploadorModify.h"
#import <objc/runtime.h>

static const void * goodsCategoryArraysKey = &goodsCategoryArraysKey;
static const void * goodsPriceSectionArraysKey = &goodsPriceSectionArraysKey;
static const void * uploadImagesArrayKey = &uploadImagesArrayKey;
static const void * goodsStateArraysKey = &goodsStateArraysKey;
static const void * goodsCategorySeletedArraysKey = &goodsCategorySeletedArraysKey;


@implementation GoodsModel (UploadorModify)

#pragma mark goodsCategoryArrays
- (void)setGoodsCategoryArrays:(NSArray *)goodsCategoryArrays
{
    objc_setAssociatedObject(self, goodsCategoryArraysKey, goodsCategoryArrays, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)goodsCategoryArrays
{
    NSArray * caterArray  =  objc_getAssociatedObject(self, goodsCategoryArraysKey);
    return caterArray;
}

#pragma mark goodsPriceSectionArrays
- (void)setGoodsPriceSectionArrays:(NSArray *)goodsPriceSectionArrays
{
    objc_setAssociatedObject(self, goodsPriceSectionArraysKey, goodsPriceSectionArrays, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSArray *)goodsPriceSectionArrays
{
    NSArray * sectionArray = objc_getAssociatedObject(self, goodsPriceSectionArraysKey);
    return sectionArray;
}

#pragma mark goodsStateArrays
- (void)setGoodsStateArrays:(NSArray *)goodsStateArrays
{
    objc_setAssociatedObject(self, goodsStateArraysKey, goodsStateArrays, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)goodsStateArrays
{
    NSArray * goodsStateArray = objc_getAssociatedObject(self, goodsStateArraysKey);
    if (!goodsStateArray) {
        NSMutableArray  * array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < KGoodsStateScaleCount; i++) {
            GoodsCategoryModel * model = [[GoodsCategoryModel alloc] init];
            model.categoryImageStr = @"temp";
            model.categoryKeyWorld = [GoodsModel converStateTostring:i];
            [array addObject:model];
        }
        goodsStateArray = [array copy];
        objc_setAssociatedObject(self, goodsStateArraysKey, goodsStateArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return goodsStateArray;
}

#pragma mark seletedPriceSetion
- (void)setSeletedPriceSetion:(NSInteger)seletedPriceSetion
{
    if (seletedPriceSetion < self.goodsPriceSectionArrays.count && seletedPriceSetion >= 0 )
        self.goodsPriceSection = [self.goodsPriceSectionArrays[seletedPriceSetion] intValue];
}

- (NSInteger)seletedPriceSetion
{
    for (int i = 0; i < self.goodsPriceSectionArrays.count; i++) {
        KGoodsPriceSection price = [[self.goodsPriceSectionArrays objectAtIndex:i] intValue];
        if (price == self.goodsPriceSection) {
            return i;
        }
    }
    return -1;
}

#pragma mark seletedCategory
- (void)setSeletedCategory:(NSInteger)seletedCategory
{
    if (seletedCategory < self.goodsCategoryArrays.count && seletedCategory >= 0)
        self.goodsCatery = [self.goodsCategoryArrays objectAtIndex:seletedCategory];
}

- (NSInteger)seletedCategory
{
    return [self isCatgoryModelInGoodsCategoryArrays:self.goodsCatery];
}

- (NSInteger)isCatgoryModelInGoodsCategoryArrays:(GoodsCategoryModel *)model
{
    for (int i = 0; i < self.goodsCategoryArrays.count; i++) {
        GoodsCategoryModel * catModel = self.goodsCategoryArrays[i];
        if ([catModel.categoryID isEqualToString:model.categoryID]) {
            return i;
        }
    }
    return -1;
}
#pragma mark goodsCategorySeletedArrays
- (NSMutableArray *)goodsCategorySeletedArrays
{
    NSMutableArray * catgorySeltedArray = objc_getAssociatedObject(self, goodsCategorySeletedArraysKey);
    if (!catgorySeltedArray) {
        catgorySeltedArray = [NSMutableArray arrayWithCapacity:0];
        objc_setAssociatedObject(self, goodsCategorySeletedArraysKey, catgorySeltedArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return catgorySeltedArray;

}

- (void)setGoodsCategorySeletedArrays:(NSMutableArray *)goodsCategorySeletedArrays
{
    objc_setAssociatedObject(self, goodsCategorySeletedArraysKey, goodsCategorySeletedArrays, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark uploadImagesArray
//- (void)setUploadImagesArray:(NSMutableArray *)uploadImagesArray
//{
//    objc_setAssociatedObject(self, uploadImagesArrayKey, uploadImagesArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSMutableArray *)uploadImagesArray
//{
//    NSMutableArray * uploadA = objc_getAssociatedObject(self, uploadImagesArrayKey);
//    if (!uploadA) {
//        uploadA = [NSMutableArray arrayWithCapacity:0];
//        objc_setAssociatedObject(self, uploadImagesArrayKey, uploadA, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//    }
//    return uploadA;
//}


@end
