//
//  CusTomerbutton.m
//  JewelryApp
//
//  Created by kequ on 15/5/24.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "CusTomerbutton.h"

@implementation CusTomerbutton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 4.f;
        self.layer.borderColor = [UIColor colorWithRed:0xeb/255.f green:0xeb/255.f blue:0xeb/255.f alpha:1].CGColor;
        self.layer.borderWidth = 1.f;
        self.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [self setTitleColor:RGB_Color(0x66, 0x66, 0x66) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = !highlighted ? [UIColor whiteColor] : [UIColor colorWithRed:0xde/255.f green:0xde/255.f blue:0xde/255.f alpha:1];
}
@end
