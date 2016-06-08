//
//  FeedsModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/4.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactoryModel.h"
#import "BaseModelMethod.h"

@interface FeedsModel : NSObject

@property(nonatomic,strong)NSMutableArray * feedsList;
@property(nonatomic,assign)NSInteger maxFeedCount;

@end
