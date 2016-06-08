//
//  FactoryHeadView.h
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FactoryModel.h"

@class FactoryHeadView;
@protocol FactoryHeadViewDelegate <NSObject>
- (void)factoryHeadViewDidClickFavButton:(UIButton *)favButton;
@end


@interface FactoryHeadView : UICollectionReusableView

@property(nonatomic,weak)id<FactoryHeadViewDelegate>delegate;

- (void)setFactoryMoedl:(FactoryModel *)model;

@end
