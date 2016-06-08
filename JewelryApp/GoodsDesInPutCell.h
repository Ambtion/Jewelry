//
//  GoodsDesInPutCell.h
//  JewelryApp
//
//  Created by kequ on 15/5/9.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDesInPutCell;
@protocol GoodsDesInPutCellDelegate <NSObject>
- (void)goodsDesInPutCellDidTextViewWillChangeToString:(NSString *)str;
@end
@interface GoodsDesInPutCell : UICollectionViewCell
@property(nonatomic,weak)id<GoodsDesInPutCellDelegate>delegate;
@property(nonatomic,strong)UITextView * textView;
@end
