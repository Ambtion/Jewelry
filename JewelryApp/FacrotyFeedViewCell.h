//
//  FacrotyFeedViewCell.h
//  JewelryApp
//
//  Created by kequ on 15/5/4.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FactoryModel.h"
#import "FactoryModel.h"

@class FacrotyFeedViewCell;
@protocol FacrotyFeedViewCellDelegate <NSObject>
- (void)factoryFeedViewCell:(FacrotyFeedViewCell *)cell didClickFavButton:(UIButton *)button;
@end


@interface FacrotyFeedViewCell : UITableViewCell
@property(nonatomic,weak)id<FacrotyFeedViewCellDelegate>delegate;
@property(nonatomic,strong)FactoryModel * model;

+ (CGFloat)cellHeight;

@end
