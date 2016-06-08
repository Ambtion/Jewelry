//
//  PropertyLabel.h
//  JewelryApp
//
//  Created by kequ on 15/5/27.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyLabel : UIControl

@property(nonatomic,strong)UILabel * keyLabel;
@property(nonatomic,strong)UILabel * valueLabel;
+ (CGFloat)heightForTitleStr:(NSString *)key value:(NSString *)value;
@end
