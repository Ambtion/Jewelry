//
//  BMTagView.h
//  basicmap
//
//  Created by quke on 15/4/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCategoryModel.h"

@protocol BMTagLayoutViewDelegate;



@interface BMTagLayoutView : UIView

@property(nonatomic, weak)id<BMTagLayoutViewDelegate>delegate;
@property(nonatomic,assign)NSInteger maxTagViewCount;
+ (CGFloat)tagHeightWithTagArray:(NSArray *)dataSource;
- (void)setTitleSource:(NSArray *)dataSource;
@end

@protocol BMTagLayoutViewDelegate <NSObject>
- (void)tagLayoutViewDidClickIndex:(NSInteger)index;
@end
