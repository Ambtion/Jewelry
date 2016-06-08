//
//  UploadGoodsController.h
//  JewelryApp
//
//  Created by kequ on 15/5/7.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel+UploadorModify.h"

@class UploadGoodsController;
@protocol UploadGoodsControllerDeleteate <NSObject>
- (void)uploadGoodsControllerDidMofifySucess:(UploadGoodsController *)controller;
@end
@interface UploadGoodsController : UIViewController
@property(nonatomic,weak)id<UploadGoodsControllerDeleteate>delegate;
- (instancetype)initWithModel:(GoodsModel *)goodsModel;
@end
