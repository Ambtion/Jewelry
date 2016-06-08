//
//  SearchTagViews.h
//  JewelryApp
//
//  Created by kequ on 15/5/17.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchTagViews;

@protocol SearchTagViewsViewDelegate <NSObject>
- (void)searchTagViews:(SearchTagViews *)imageScrollView DidIndePath:(NSIndexPath *)path;
@end


@interface SearchTagViews : UIView

@property(nonatomic,weak)id<SearchTagViewsViewDelegate> delegate;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)NSArray * dataSourceArray;
@property(nonatomic,assign)CGSize imageSize;
@property(nonatomic,assign)CGFloat spacing;

@end
