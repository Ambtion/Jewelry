//
//  CusSeletedButton.m
//  JewelryApp
//
//  Created by kequ on 15/5/27.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "CusSeletedButton.h"

@implementation CusSeletedButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setImage:[UIImage imageNamed:@"dingdan_choice"] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"dingdan_choice_1"] forState:UIControlStateNormal];
    }
    return self;
}
@end
