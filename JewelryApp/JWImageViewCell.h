//
//  BMImageViewCell.h
//  basicmap
//
//  Created by quke on 15/4/14.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"

@interface JWImageViewCell : UICollectionViewCell
@property(nonatomic,strong)PortraitView* porView;
@property(nonatomic,assign)BOOL needShowSeletedState;
@end
