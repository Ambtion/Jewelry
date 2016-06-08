//
//  ModelDefine.h
//  JewelryApp
//
//  Created by kequ on 15/5/9.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

//刷新加载数据个数
#define RELOADDATACOUNT     30
//更多加载数据个数
#define LOADMOREDATACOUNT   20


//用户权限
typedef NS_ENUM(NSInteger, KUserRole){
    //买方
    KUserBuyInShopping  = 1,                     //采购
    KUserBuyInShoppingEnsure,                    //确定订单
    KUserBuyAboutGoods,                          //联系翠源平台方确定可约货品及看货的时间地点
    KUserBuyAboutPrice,                            //看到货品后通过400电话与供货厂方取得联系，议价
    KUserBuyOrderEnsure,                            //负责定货操作
    KUserBuyBossEnsture = 6,                           //负责定货操作
    
    //卖方
    KUserSaleUploadGoods = 71,                           //只可以通过厂方端app按要求上传货品
    KUserSaleEnsureGoods                            //具体专职上货人员操作权限外，还可对所上传货品进行删除修改等操作；可对采购订单进行查询和修改
    
};


//商品状态
typedef NS_ENUM(NSInteger, KGoodsState){
    KGoodsStateInvalid = -1,
    KGoodsStateHaveSource = 0,          //  可约货
    KGoodsStateScaleInOrder,            //  已约出
    KGoodsStateScaleOver,               //  已售出
    KGoodsStateScaleCount
};


//商品价格区间
//0~1999
//2000~4999
//5000~9999
//10000~49999
//50000以上
typedef NS_ENUM(NSInteger, KGoodsPriceSection) {
    KGoodsPriceSection0_1999 = 1,
    KGoodsPriceSection2000_4999,
    KGoodsPriceSection5000_9999,
    KGoodsPriceSection10000_49999,
    KGoodsPriceSection50000_,
    KGoodsPriceSectionCount
};

//1选货，2订约，3约货，4厂商改价，5议价确认，6订货，7终选，8交易成功，11交易失败
//订单状态 //服务端定的订单状态
typedef NS_ENUM(NSInteger, KOrderState) {
    KOrderStateShopping = 0,
    KOrderStateInShopping = 1,
    KOrderStateInorder = 2,
    KOrderStateAboutGoods = 3,
    KOrderStateFactoryEnsturPrice = 4,
    KOrderStateAboutPriceEnsure = 5,
    KOrderStateOrderEnsture = 6,
    KOrderStateOrderEnsrureByBoss = 7,
    KOrderStateOrderSucess = 8,
    KOrderStateOrderFailture = 11,
};


typedef NS_ENUM(NSInteger, KOrderProgressState) {
    KOrderProgressStateInvalid = 0,
    KOrderProgressStateInOrdering = 1,
    KOrderProgressStateInAboutGoods = 2,
    KOrderProgressStateInAbutPrice = 3,
    KOrderProgressStateInOrderEnsutre = 4,
    KOrderProgressStateInWaitngPay = 5,
    KOrderProgressStateInDone = 6,
    KOrderProgressStateInCancel = 7,
    
    KOrderProgressStateSaleWaitEnsure,
    KOrderProgressStateSaleInWaitngPay,
    KOrderProgressStateSaleInDone,
    KOrderProgressStateSaleInCancel
};



//不同人物的订单状态
typedef enum : NSUInteger {
    KOrderCellTypeWait = 1,
    KOrderCellTypeProgress,
    KOrderCellTypeFinish,
} KOrderCellType;


typedef NS_ENUM(NSInteger, KGoodRecomendType) {
    KGoodRecomendInvalid = -1,
    KGoodRecomendNew = 0,
    KGoodRecomendRecomend
};


typedef NS_ENUM(NSInteger, KOrderOperateType) {
    KOrderOperateTypeInvalid = -1,
    KOrderOperateTypeAddInShoping = 0,
    KOrderOperateTypeEnstureInShoping
};

