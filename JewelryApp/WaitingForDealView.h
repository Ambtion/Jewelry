//
//  WaitingForDealView.h
//  JewelryApp
//
//  Created by kequ on 15/5/24.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusSeletedButton.h"


@interface WaitingForDealView : UIView

@property(nonatomic,strong)CusSeletedButton * seletedButton;

@property(nonatomic,strong)UIButton * commitButton;
- (void)setOrderCount:(NSInteger)orderCount GoodsCount:(NSInteger)goodsCout;
@end
