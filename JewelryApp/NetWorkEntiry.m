//
//  NetWorkEntiry.m
//  JewelryApp
//
//  Created by kequ on 15/5/12.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "NetWorkEntiry.h"
#import "UserInfoModel.h"
#import "JSONKit.h"
#import "OrderModel.h"

typedef     void (^CallBack)(AFHTTPRequestOperation *operation, id responseObject);
static CallBack upSucess;


@implementation NetWorkEntiry

+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSDictionary * dic = @{@"phone":userName,@"code":password};
    NSString * urlStr = [NSString stringWithFormat:@"%@/login",KNETBASEURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
    
}

+ (void)mofifyPassWord:(NSString *)pasWord
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    NSString * urlStr = [NSString stringWithFormat:@"%@/user/change_password",KNETBASEURL];
    dic[@"password"] = pasWord;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

#pragma mark - Upload | modify

+ (void)uploadGoodsWithGoodsID:(NSString *)goodsId Category:(NSString *)categoryID goodsDes:(NSString *)goodsDes price_range:(KGoodsPriceSection)priceRange spes:(NSInteger)spes images:(NSArray *)images success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    return [self modifyGoodsWithGoodsId:goodsId Category:categoryID goodsDes:goodsDes price_range:priceRange spes:spes netImages:nil localImages:images success:success failure:failure];
}

+ (void)modifyGoodsWithGoodsId:(NSString *)goodsID
                      Category:(NSString *)categoryID
                      goodsDes:(NSString *)goodsDes
                   price_range:(KGoodsPriceSection)priceRange
                          spes:(NSInteger)spes
                     netImages:(NSArray *)netImages
                   localImages:(NSArray *)localImages
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    if (!(localImages.count + netImages.count) || localImages.count + netImages.count > 9) {
        [self missParagramercallBackFailure:failure];
        return;
    }
    
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:categoryID forKey:@"category_id"];
    if (goodsDes) {
        [dic setValue:goodsDes forKey:@"description"];
    }
    [dic setValue:[NSNumber numberWithInteger:priceRange] forKey:@"price_range"];
    [dic setValue:[NSNumber numberWithInteger:spes] forKey:@"spec"];
    
    
    NSString * baseUrl = KNETBASEURL;
    if (!goodsID) {
        //id不存在上传
        baseUrl = [baseUrl stringByAppendingString:@"/goods/upload"];
    }else{
        //修改属性
        [dic setValue:goodsID forKey:@"id"];
        baseUrl = [baseUrl stringByAppendingString:@"/goods/edit"];
    }

    NSMutableArray * allNetImages = [NSMutableArray arrayWithArray:netImages];
    
    if (localImages.count) {
        [self uploadImags:localImages sucess:^(NSArray *array) {
            [allNetImages addObjectsFromArray:array];
            [self uploadWithNetImages:allNetImages baseUrl:baseUrl par:dic success:success failure:failure];
        }];
    }else{
        [self uploadWithNetImages:allNetImages baseUrl:baseUrl par:dic success:success failure:failure];
    }
}

+ (void)uploadWithNetImages:(NSArray *)netImages baseUrl:(NSString *)baseUrl par:(NSDictionary *)dic
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSArray * narray = [netImages stripImageUrlBase:netImages];
    NSString * str = [narray  componentsJoinedByString:@","];
    [dic setValue:str forKey:@"image"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:baseUrl parameters:dic success:success failure:failure];
}


+ (void)uploadImags:(NSArray*)images sucess:(void(^)(NSArray *array))sucess
{
    
    __block NSInteger index = 0;
    NSMutableArray * arrayNs = [NSMutableArray arrayWithCapacity:0];
    upSucess = ^(AFHTTPRequestOperation *operation, id responseObject){
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([responseObject objectForKey:@"path"] && [[responseObject objectForKey:@"path"] isKindOfClass:[NSString class]]){
                [arrayNs addObject:[responseObject objectForKey:@"path"]];
            }
        }
        index++;
        if (index < images.count) {
            [self uploadImage:images[index] success:upSucess failure:upSucess];
        }else{
            sucess(arrayNs);
        }
    };
    [self uploadImage:images[index] success:upSucess failure:upSucess];
}

+ (void)uploadImage:(UIImage *)image success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/upload_image",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSData * data = UIImageJPEGRepresentation(image, 1);
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"image" fileName:@"1" mimeType:@"image/jpeg"];
    } success:success failure:failure];
}

+ (void)deleteuploadedGoodsWithGoodsID:(NSString *)goodsid
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/goods/delete",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:goodsid forKey:@"id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}

#pragma mark - Cateroy
+ (void)getAllCategoryTypeWith:(NSString*)categoryID Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure

{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/get_category",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    if (categoryID) {
        [dic setValue:categoryID forKey:@"supplier_id"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
    
}

+ (void)getRecomendGoodsListWith:(NSString*)categoryID Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/goods/get_recommend_goods",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    if (categoryID) {
        [dic setValue:categoryID forKey:@"supplier_id"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

+ (void)getNewsGoodsListWith:(NSString*)categoryID
                          Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/goods/get_new_goods",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    if (categoryID) {
        [dic setValue:categoryID forKey:@"supplier_id"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}


+ (void)getExploreGoodsListWithStart:(NSInteger)start count:(NSInteger)count catergory:(NSString *)catgoryId
                             Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/goods/random",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:[NSNumber numberWithInteger:start] forKey:@"start"];
    [dic setValue:[NSNumber numberWithInteger:count] forKey:@"count"];
    if (catgoryId) {
        [dic setValue:catgoryId forKey:@"category_id"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

+ (void)searchGoodsWithCategoryID:(NSArray *)categoryIDs goodsState:(KGoodsState)state
                    priceSecction:(NSArray *)priceSection
                         keyWorld:(NSString *)keyWorld
                isSpecial_param:(KGoodRecomendType)recomendType
                        factoryID:(NSString *)factoryID
                            start:(NSInteger)start count:(NSInteger)count
                          Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/goods/search",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    if (categoryIDs.count) {
        [dic setValue:[categoryIDs componentsJoinedByString:@","] forKey:@"category_id"];
    }
    if (state != KGoodsStateInvalid) {
        [dic setValue:[NSNumber numberWithInteger:state] forKey:@"status"];
    }
    if (priceSection.count) {
        [dic setValue:[priceSection componentsJoinedByString:@","] forKey:@"price_range"];
    }
    if(keyWorld){
        [dic setValue:keyWorld forKey:@"keywords"];
    }
    if(recomendType != KGoodRecomendInvalid){
        [dic setValue:[NSNumber numberWithInteger:recomendType] forKey:@"special_param"];
    }
    if (factoryID) {
        [dic setValue:factoryID forKey:@"supplier_id"];
    }
    
    [dic setValue:[NSNumber numberWithInteger:start] forKey:@"start"];
    [dic setValue:[NSNumber numberWithInteger:count] forKey:@"count"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}

+ (void)getGoodsDetailInfo:(NSString *)goodsID
                   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!goodsID) {
        [self missParagramercallBackFailure:failure];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/goods/view",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:goodsID forKey:@"id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

/**
 *  关注获取取消关注
 */
+ (void)favGoods:(NSString *)goodsId :(BOOL)isFav
         Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!goodsId) {
        [self missParagramercallBackFailure:failure];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/goods/focus",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:goodsId forKey:@"goods_id"];
    [dic setValue:[NSNumber numberWithBool:isFav] forKey:@"is_focus"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
    
}


+ (void)getgoodsFeedListStart:(NSInteger)start count:(NSInteger)count
                      Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/goods/focus_goods",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:[NSNumber numberWithInteger:start] forKey:@"start"];
    [dic setValue:[NSNumber numberWithInteger:count] forKey:@"count"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];

}

+ (void)getFactroyFeedListStart:(NSInteger)start count:(NSInteger)count
                        Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/supplier/get_concern_supplier",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:[NSNumber numberWithInteger:start] forKey:@"start"];
    [dic setValue:[NSNumber numberWithInteger:count] forKey:@"count"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

+ (void)favfactory:(NSString *)factoryId :(BOOL)isFav
           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!factoryId) {
        [self missParagramercallBackFailure:failure];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/supplier/focus",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:factoryId forKey:@"supplier_id"];
    [dic setValue:[NSNumber numberWithBool:isFav] forKey:@"is_focus"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}

/**
 *  获取厂家详细信息
 */
+ (void)getFactroyDetailInfoWithFactroyId:(NSString *)factoryID orFactoryCode:(NSString *)factoryCode
                                  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!factoryID && !factoryCode) {
        [self missParagramercallBackFailure:failure];
        return;
    }
    NSString * urlStr = nil;
    NSMutableDictionary * dic = [self commonComonPar];
    urlStr =  [NSString stringWithFormat:@"%@/supplier/supplier_info",KNETBASEURL];
    if (factoryCode){
        [dic setValue:factoryCode forKey:@"supplier_code"];
    }
    if (factoryID){
        [dic setValue:factoryID forKey:@"supplier_id"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}


/**
 *  --------------------------------------------订单模块----------------------------------------------------
 */
+ (void)addGoodsInShopingWithGoodsId:(NSString *)goodsId facyory_Code:(NSString *)facory_code
                             Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!goodsId || !facory_code) {
        [self missParagramercallBackFailure:failure];
        return;
    }
    
    if ([[UserInfoModel defaultUserInfo] role] == KUserBuyInShopping) {
        NSString * urlStr = [NSString stringWithFormat:@"%@/add_cart",KNETBASEURL];
        NSMutableDictionary * dic = [self commonComonPar];
        dic[@"product_id"] =  goodsId;
        dic[@"supplier_code"] = facory_code;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:dic success:success failure:failure];
    }else{
        //订约人直接加入订单
        NSString * urlStr = [NSString stringWithFormat:@"%@/order/dingyueren_add",KNETBASEURL];
        NSMutableDictionary * dic = [self commonComonPar];
        NSMutableArray * data = [NSMutableArray arrayWithCapacity:0];
        NSDictionary * dicC  = @{
                                    @"supplier_code" :facory_code,
                                    @"product_id" : goodsId
                                    };
        [data addObject:dicC];
        dic[@"data"] = [data JSONString];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:urlStr parameters:dic success:success failure:failure];
    }
}

//------------------------------------订单提交到下一步----------------------------------------

+ (void)commmitGoodsOrOrderToNextWithGoodsModels:(NSArray *)goodsModels orderID:(NSArray *)orderIDList
                                         Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * operas = nil;
    KUserRole role = [[UserInfoModel defaultUserInfo] role];
    switch (role) {
        case KUserBuyInShopping:
            return [self addGoodsInOrderWithGoodsId:goodsModels Success:success failure:failure];
            break;
        case KUserBuyInShoppingEnsure:
            operas = @"dingyue";
            break;
        case KUserBuyAboutGoods:
            operas = @"yuehuo";
            break;
        case KUserBuyAboutPrice:
            operas = @"yijia";
            break;
        case KUserBuyOrderEnsure:
            operas = @"dinghuo";
            break;
        case KUserBuyBossEnsture:
            operas = @"zhongxuan";
            break;
        case KUserSaleEnsureGoods:
            return [self commitPriceWithOrderModelArray:orderIDList Success:success failure:failure];
            
        case KUserSaleUploadGoods:
            break;
            
        default:
            break;
    }
    [self commmitGoodsOrOrderToNextOrderID:orderIDList WithOperType:operas Success:success failure:failure];
}

+ (void)addGoodsInOrderWithGoodsId:(NSArray *)goodModels
                           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if(!goodModels || !goodModels.count){
        [self missParagramercallBackFailure:failure];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/order/add",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    NSMutableArray * data = [NSMutableArray arrayWithCapacity:0];
    for (GoodsModel * goodsModel  in goodModels) {
        NSDictionary * dic  = @{
                                @"supplier_code" : goodsModel.goddsFactoryCode,
                                @"product_id" : goodsModel.goodsID
                                };
        [data addObject:dic];
    }
    dic[@"data"] = [data JSONString];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}

+ (void)commitPriceWithOrderModelArray:(NSArray *)orderModel
                               Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if(!orderModel || !orderModel.count){
        [self missParagramercallBackFailure:failure];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/order/change_price",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];

    
    NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:0];
    for(OrderModel * orderM in orderModel){
        [dataArray addObject:[self commentDicForOrderModel:orderM]];
    }
    [dic setValue:[dataArray JSONString] forKey:@"data"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}

+ (NSDictionary *)commentDicForOrderModel:(OrderModel *)model
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:model.orderId forKey:@"order_id"];
    NSMutableArray * goodArray = [NSMutableArray arrayWithCapacity:0];
    for (GoodsModel * goodModel in model.ordergoodsList) {
        [goodArray addObject:@{
                               @"goods_id" : goodModel.goodsID,
                               @"commit_price":[NSString stringWithFormat:@"%f",goodModel.localGoodsPrice]
                               }];
    }
    [dic setValue:goodArray forKey:@"list"];
    return dic;
}

+ (void)commmitGoodsOrOrderToNextOrderID:(NSArray *)orderIDList WithOperType:(NSString *)opeartS
                                 Success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    if (!orderIDList || !orderIDList.count || !opeartS) {
        [self missParagramercallBackFailure:failure];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/order/operate",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    dic[@"operate"] = opeartS;
    
    NSMutableArray * idArray = [NSMutableArray arrayWithCapacity:0];
    for (OrderModel * model in orderIDList) {
        [idArray addObject:model.orderId];
    }
    NSMutableString * multStr = [NSMutableString stringWithFormat:@"("];
    [multStr appendString:[idArray componentsJoinedByString:@","]];
    [multStr appendString:@")"];
    dic[@"order_id"] = multStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
    
}

//---------------------------------------------删除---------------------------------------------------------------------------------

+ (void)deleteGoodsFromOrderListWithGoodsId:(NSString *)googdsID orderID:(NSString *)orderID
                                    Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    KUserRole role = [[UserInfoModel defaultUserInfo] role];
    switch (role) {
        case KUserBuyInShopping:
            [self deletGoodsFromShoppingListGoodsId:googdsID Success:success failure:failure];
            break;
        case KUserBuyInShoppingEnsure:
            [self deleteOrderWithOrderId:orderID goods_id:googdsID Success:success failure:failure];
            break;
        case KUserBuyAboutGoods:
            break;
        case KUserBuyAboutPrice:
            break;
        case KUserBuyOrderEnsure:
            [self deleteOrderWithOrderId:orderID goods_id:googdsID Success:success failure:failure];
            break;
        case KUserBuyBossEnsture:
            [self deleteOrderWithOrderId:orderID goods_id:googdsID Success:success failure:failure];
            break;
        case KUserSaleUploadGoods:
            break;
        case KUserSaleEnsureGoods:
        default:
            break;
    }

}

+ (void)deletGoodsFromShoppingListGoodsId:(NSString *)goodsId
                                  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!goodsId) {
        [self missParagramercallBackFailure:failure];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/delete_cart",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    NSArray * goodList =  @[goodsId];
    dic[@"goods_list"] =  [goodList JSONString];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

+ (void)deleteOrderWithOrderId:(NSString *)orderID goods_id:(NSString *)goodsId
                       Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!orderID || !goodsId) {
        [self missParagramercallBackFailure:failure];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/order/delete_order",KNETBASEURL];
    NSMutableDictionary * dic = [self commonComonPar];
    dic[@"goods_id"] =  goodsId;
    dic[@"order_id"] = orderID;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}


//---------------------------------------------获取---------------------------------------------------------------------------------
+ (void)getOrderListWithKeyWorld:(NSString*)keyWorld orderCellType:(KOrderCellType)type orderState:(KOrderProgressState)orderState
                      PageNumber:(NSInteger)pageNumber
                         Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [self urlStrWithRole:[[UserInfoModel defaultUserInfo] role] orderCellType:type orderState:orderState];
    NSMutableDictionary * dic = [self commonComonPar];
    if (keyWorld) {
        dic[@"keywords"] = keyWorld;
    }else{
        dic[@"keywords"] = @"";
    }
    dic[@"page_num"] = @(pageNumber);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

+ (NSString *)urlStrWithRole:(KUserRole)role orderCellType:(KOrderCellType)type orderState:(KOrderProgressState)orderState
{
    //选货查询,订约,约货
    
    NSString * urlStr = [NSString stringWithFormat:@"%@",KNETBASEURL];    
    switch (role) {
        case KUserBuyInShopping:
            if (type == KOrderCellTypeWait){
             urlStr = [urlStr stringByAppendingString:@"/get_cart"];
            }else if (type == KOrderCellTypeFinish) {
                urlStr = [urlStr stringByAppendingString:@"/order/xuanhuo"];
            }
            break;
        case KUserBuyInShoppingEnsure:
            if (type == KOrderCellTypeWait){
                urlStr = [urlStr stringByAppendingString:@"/order/xuanhuo"];
            }else if (type == KOrderCellTypeFinish) {
                urlStr = [urlStr stringByAppendingString:@"/order/dingyue"];
            }
            break;
        case KUserBuyAboutGoods:
            if (type == KOrderCellTypeWait){
                urlStr = [urlStr stringByAppendingString:@"/order/dingyue"];
            }else if (type == KOrderCellTypeFinish) {
                urlStr = [urlStr stringByAppendingString:@"/order/yuehuo"];
            }
            break;
        case KUserBuyAboutPrice:
            if(type == KOrderCellTypeWait){
                urlStr = [urlStr stringByAppendingString:@"/order/yuehuo2"];
            }else if(type == KOrderCellTypeFinish){
                urlStr = [urlStr stringByAppendingString:@"/order/yijia"];
            }
            break;
        case KUserBuyOrderEnsure:
            if(type == KOrderCellTypeWait){
                urlStr = [urlStr stringByAppendingString:@"/order/yijia"];
            }else if(type == KOrderCellTypeFinish){
                urlStr = [urlStr stringByAppendingString:@"/order/dinghuo"];
            }
            break;
        case KUserBuyBossEnsture:
            if(type == KOrderCellTypeWait){
                urlStr = [urlStr stringByAppendingString:@"/order/dinghuo"];
            }else{
                urlStr = [urlStr stringByAppendingString:[self getUrlParaWithOrderState:orderState]];
            }
            

            break;
        case KUserSaleUploadGoods:
            break;
            
        case KUserSaleEnsureGoods:
            if(type == KOrderCellTypeWait){
                urlStr = [urlStr stringByAppendingString:@"/supplier/yuehuo"];
            }else{
                urlStr = [urlStr stringByAppendingString:[self getUrlParaWithOrderState:orderState]];
            }
        default:
            break;
    }
    return urlStr;
}

+ (NSString *)getUrlParaWithOrderState:(KOrderProgressState)state
{
    switch (state) {
        case KOrderProgressStateInOrdering:
            return @"/order/xuanhuo";
        case KOrderProgressStateInAboutGoods:
            return @"/order/dingyue";
        case KOrderProgressStateInAbutPrice:
            return @"/order/yuehuo";
        case KOrderProgressStateInOrderEnsutre:
            return @"/order/yijia";
        case KOrderProgressStateInWaitngPay:
            return @"/order/zhongxuan";
        case KOrderProgressStateInDone:
            return @"/order/finish";
        case KOrderProgressStateInCancel:
            return @"/order/find_delete_order";
        case KOrderProgressStateSaleWaitEnsure:
            return @"/supplier/daiqueren";
        case KOrderProgressStateSaleInWaitngPay:
            return @"/supplier/zhongxuan";
        case KOrderProgressStateSaleInDone:
            return @"/supplier/finish";
        case KOrderProgressStateSaleInCancel:
            return @"/order/find_delete_order";
        default:
            break;
    }
    return @"";
}

+ (void)getOrderCountInfoSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSString * urlStr = nil;
    if ([[UserInfoModel defaultUserInfo] role] == KUserBuyBossEnsture) {
        urlStr = [NSString stringWithFormat:@"%@/ka/count_info",KNETBASEURL];
    }else{
        urlStr = [NSString stringWithFormat:@"%@/supplier/count_info",KNETBASEURL];
    }
    NSMutableDictionary * dic = [self commonComonPar];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];

}

#pragma mark - Common
+ (NSMutableDictionary *)commonComonPar
{
    NSMutableDictionary  * paragramer = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([[UserInfoModel defaultUserInfo] toke])
        [paragramer setValue:[[UserInfoModel defaultUserInfo] toke] forKey:@"token"];
    return paragramer;
}

+ (void)missParagramercallBackFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSError * error = [NSError errorWithDomain:@"Deomin" code:0
                                      userInfo:@{@"error":@"缺少参数"}];
    failure(nil,error);
}
@end
