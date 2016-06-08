//
//  JWImageItemScrollView.h
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWImageItemScrollView;
@class PortraitView;

@protocol JWImageItemScrollViewDelegate <NSObject>
- (void)jwimagesScrollView:(JWImageItemScrollView *)imageScrollView DidImageView:(PortraitView *)imageView indePath:(NSIndexPath *)path;
@end

@interface JWImageItemScrollView : UIView

@property(nonatomic,weak)id<JWImageItemScrollViewDelegate> delegate;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)NSArray * dataSourceArray;
@property(nonatomic,assign)CGSize imageSize;

//为了满足UI展示效果添加的业务。当图片不足全屏幕显示的时候，需要补齐的图片数目 completionMaxCount = 0的时候不补全
@property(nonatomic,assign)NSInteger completionMaxCount;
//补全默认的图片
@property(nonatomic,strong)NSString * complectionImage;

@property(nonatomic,assign)BOOL isShowSeletedState;
@property(nonatomic,assign,readonly)NSInteger seletedIndex;

- (instancetype)initWithMinimumInteritemSpacing:(CGFloat)spacing;

- (void)setDataSourceArray:(NSArray *)dataSourceArray;

- (void)setSeletedIndexPath:(NSInteger)indexPath;

@end

