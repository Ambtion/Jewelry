//
//  ExPloreHeadView.h
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ExPloreHeadView;
@protocol ExPloreHeadViewDelegate <NSObject>
- (void)exPloreHeadViewDidClickImageScrollViewAdIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)exPloreHeadViewDidClickTagAtIndex:(NSInteger)index;
@end

@interface ExPloreHeadView : UICollectionReusableView
@property(nonatomic,weak)id<ExPloreHeadViewDelegate>delegate;
@property(nonatomic,assign)UIEdgeInsets insets;

- (void)setQgoodsImage:(NSArray *)qArray nArray:(NSArray *)nArray TagArray:(NSArray *)tagArray;

@end
