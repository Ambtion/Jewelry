//
//  UploadGoodsCell.h
//  JewelryApp
//
//  Created by kequ on 15/5/7.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@class UploadGoodsCell;
@protocol UploadGoodsCellDelegate <NSObject>
- (void)uploadGoodsCell:(UploadGoodsCell *)cell DidMofityClick:(GoodsModel *)model;
- (void)uploadGoodsCell:(UploadGoodsCell *)cell DidDeleteClick:(GoodsModel *)model;
@end
@interface UploadGoodsCell : UITableViewCell
@property(nonatomic,assign)id<UploadGoodsCellDelegate>delegate;
- (void)setModel:(GoodsModel *)model;
+ (CGFloat)hegiWithModel:(GoodsModel *)model;
@end
