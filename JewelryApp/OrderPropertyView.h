//
//  OrderPropertyView.h
//  JewelryApp
//
//  Created by kequ on 15/5/10.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelDefine.h"


@class OrderPropertyView;
@protocol OrderPropertyViewDelegate <NSObject>
- (void)orderPropertyViewDetailView:(OrderPropertyView *)view DidClick:(UIButton *)button;
@end

@interface OrderPropertyView : UIView
@property(nonatomic,weak)id<OrderPropertyViewDelegate>delegate;
@property(nonatomic,assign)UIEdgeInsets inset;
@property(nonatomic,assign)CGFloat offsetX;
@property(nonatomic,assign)BOOL isLastView;
+ (CGFloat)hegith:(NSArray *)modelArrays  WithOrderCelltype:(KOrderCellType)type goodsListCount:(NSInteger)goodsCount totalPrice:(double)totalPrice isExpand:(BOOL)isExpand;

- (void)setModel:(NSArray *)modelArrays  WithOrderCelltype:(KOrderCellType)type goodsListCount:(NSInteger)goodsCount totalPrice:(double)totalPrice isExpand:(BOOL)isExpand;
@end
