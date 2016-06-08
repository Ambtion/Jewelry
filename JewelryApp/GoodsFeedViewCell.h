//
//  GoodsFeedViewCell.h
//  JewelryApp
//
//  Created by kequ on 15/5/4.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@class GoodsFeedViewCell;

@protocol GoodsFeedViewCellDelegate <NSObject>
- (void)goodsFeedViewCell:(GoodsFeedViewCell *)cell DidClickFavedButton:(UIButton *)button;
- (void)goodsFeedViewCell:(GoodsFeedViewCell *)cell DidClickAddIntoOrder:(UIButton *)button;
@end
@interface GoodsFeedViewCell : UITableViewCell
@property(nonatomic,weak)id<GoodsFeedViewCellDelegate>delegate;
@property(nonatomic,strong)GoodsModel * model;
+ (CGFloat)cellHeight;
@end
