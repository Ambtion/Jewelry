//
//  KGoodOrderModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/10.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "KGoodOrderModel.h"

@interface KGoodNormalOrderModel : NSObject
//普通订单
@property(nonatomic,strong)KGoodOrderModel * watingForDeal;
@property(nonatomic,strong)KGoodOrderModel * alreadyDeal;

@end

//@interface KGoodBossOrderModel : NSObject
////普通订单
//@property(nonatomic,strong)KGoodOrderModel * watingForDeal;
//@property(nonatomic,strong)KGoodOrderModel * alreadyDeal;
//@property(nonatomic,strong)KGoodOrderModel * finishedOrder;
//
//@end