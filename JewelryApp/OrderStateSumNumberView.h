//
//  OrderStateSumNumberView.h
//  JewelryApp
//
//  Created by kequ on 15/5/31.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderStateSumNumberView;
@protocol OrderStateSumNumberViewDelegate <NSObject>
@optional
- (void)orderStateSumNumberViewDidSeletedProgressView:(OrderStateSumNumberView *)view;
@end
@interface OrderStateSumNumberView : UIView
@property(nonatomic,assign)id<OrderStateSumNumberViewDelegate>delegate;
@property(nonatomic,strong)NSArray * dataSrouce;
@property(nonatomic,assign)NSInteger seletedIndex;
@property(nonatomic,assign)KOrderProgressState defaultProgressState;
- (KOrderProgressState)seletedProgessState;
- (void)setProgressNumber:(NSInteger)countNum withState:(KOrderProgressState )progessState;
@end
