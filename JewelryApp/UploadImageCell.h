//
//  UploadImageCell.h
//  JewelryApp
//
//  Created by kequ on 15/5/9.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"
@class UploadImageCell;
@protocol UploadImageCellDelegate <NSObject>
- (void)uploadImageCellDidClickDeleteButton:(UploadImageCell *)cell;
@end
@interface UploadImageCell : UICollectionViewCell
@property(nonatomic,weak)id<UploadImageCellDelegate>delegate;
@property(nonatomic,strong)PortraitView* porView;
@property(nonatomic,strong)UIButton * deleteButton;
@end


@interface UploadImageCellADD : UICollectionViewCell
@property(nonatomic,weak)id<UploadImageCellDelegate>delegate;
@property(nonatomic,strong)PortraitView* porView;
@property(nonatomic,strong)UIButton * deleteButton;
@end