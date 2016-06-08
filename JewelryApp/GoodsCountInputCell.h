//
//  GoodsCountInputCell.h
//  JewelryApp
//
//  Created by kequ on 15/5/25.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsCountInputCell;
@protocol GoodsCountInputCellDelegate <NSObject>
- (void)goodsDesInPutCellDidTextFieldWillChangeToString:(NSString *)str;
@end
@interface GoodsCountInputCell : UICollectionViewCell
@property(nonatomic,weak)id<GoodsCountInputCellDelegate>delegate;
@property(nonatomic,strong)UITextField * countTextField;
@end
