//
//  NetWorkEntiry.h
//  JewelryApp
//
//  Created by kequ on 15/5/12.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ModelDefine.h"
#import "GoodsModel.h"

//#define KNETBASEURL          @"http://120.25.209.9/f3"
#define  KNETBASEURL           @"http://121.34.240.132:96/f3"

@interface NetWorkEntiry : NSObject

/**
 *  @param success  用户名
 *  @param failure  用户密码
 */

+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)mofifyPassWord:(NSString *)pasWord
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  批量上传图片
 *
 *  @param images 图片list，UIImage元素
 *  @param sucess callBack，返回图片网络地址的list,网络地址 NSString类型
 */
+ (void)uploadImags:(NSArray*)images sucess:(void(^)(NSArray *array))sucess;


/**
 *  上传 | 修改货品
 *
 *  @param goodsId    商品ID，有ID表示修改，没有表示上传
 *  @param categoryID 类比ID
 *  @param goodsDes   描述，最多200字
 *  @param priceRange 价格
 *  @param spes       商品规格
 *  @param images     图片列表 NSString 元素
 */
+ (void)uploadGoodsWithGoodsID:(NSString *)goodsId Category:(NSString *)categoryID
                      goodsDes:(NSString *)goodsDes price_range:(KGoodsPriceSection)priceRange
                          spes:(NSInteger)spes  images:(NSArray *)images
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)modifyGoodsWithGoodsId:(NSString *)goodsID
                      Category:(NSString *)categoryID
                      goodsDes:(NSString *)goodsDes
                   price_range:(KGoodsPriceSection)priceRange
                          spes:(NSInteger)spes
                        netImages:(NSArray *)netImages
                   localImages:(NSArray *)localImages
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  删除上传过的商品
 */
+ (void)deleteuploadedGoodsWithGoodsID:(NSString *)goodsid
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
    买方接口
 */
// ------------------------------------------------------------------------

/**
 *  获取物品分类
 */
+ (void)getAllCategoryTypeWith:(NSString*)categoryID Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取推荐商品名称列表
 */
+ (void)getRecomendGoodsListWith:(NSString*)categoryID
                         Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 * 获取最新商品名称列表
 */
+ (void)getNewsGoodsListWith:(NSString*)categoryID
                          Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  获取广场商品列表
 *  @param catgoryId 根据类别获取商品列表 ，optional，默认全部类别
 */
+ (void)getExploreGoodsListWithStart:(NSInteger)start count:(NSInteger)count catergory:(NSString *)catgoryId
                             Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  厂商货品查询、搜索、筛选
 *
 *  @param categoryID 货品的类别Id（为空选择全部类别）
 *  @param state      货品的当前状态（是否可约，为空选择所有状态货品） 
 *  @param keyWorld   关键字模糊查询（为空则查询全部）
 *  @param isSpecial  新品/推荐（属性新品还是推荐，为空则不区分新品推荐）0新品 1推荐
 *  @param factoryID  厂商id（为空不区分厂商）
 */

+ (void)searchGoodsWithCategoryID:(NSArray *)categoryIDs goodsState:(KGoodsState)state
                    priceSecction:(NSArray *)priceSection
                         keyWorld:(NSString *)keyWorld
                  isSpecial_param:(KGoodRecomendType)recomendType
                        factoryID:(NSString *)factoryID
                            start:(NSInteger)start count:(NSInteger)count
                          Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取商品详细信息
 */
+ (void)getGoodsDetailInfo:(NSString *)goodsID
                   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  关注获取取消关注
 */
+ (void)favGoods:(NSString *)goodsId :(BOOL)isFav
         Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取关注商品列表
 */
+ (void)getgoodsFeedListStart:(NSInteger)start count:(NSInteger)count
                      Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  获取关注厂家列表
 */
+ (void)getFactroyFeedListStart:(NSInteger)start count:(NSInteger)count
                        Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/**
 *  关注厂家获取取消关注
 */
+ (void)favfactory:(NSString *)factoryId :(BOOL)isFav
         Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取厂家详细信息
 */
+ (void)getFactroyDetailInfoWithFactroyId:(NSString *)factoryID orFactoryCode:(NSString *)factoryCode
                                  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  --------------------------------------------订单模块----------------------------------------------
 */

+ (void)addGoodsInShopingWithGoodsId:(NSString *)goodsId facyory_Code:(NSString *)facory_code
                             Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  提交(根据人物属性实现不同的添加操作)
 */
//------------------------------------订单提交到下一步--------------------------------------------------
+ (void)commmitGoodsOrOrderToNextWithGoodsModels:(NSArray *)goodsModels orderID:(NSArray *)orderIDList
                                         Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  查询 （自动根据人物权限和相对人物订单是否完成查询对应的订单）
 */
+ (void)getOrderListWithKeyWorld:(NSString*)keyWorld orderCellType:(KOrderCellType)type orderState:(KOrderProgressState)orderState
                      PageNumber:(NSInteger)pageNumber
                         Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  删除（自动根据人物权限和删除订单）
 */
//---------------------------------------------删除-----------------------------------------------------
+ (void)deleteGoodsFromOrderListWithGoodsId:(NSString *)googdsID orderID:(NSString *)orderID
                                    Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)getOrderCountInfoSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
