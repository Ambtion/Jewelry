//
//  TagLabelCell.m
//  JewelryApp
//
//  Created by kequ on 15/5/17.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "TagLabelCell.h"

@implementation TagLabelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.layer.masksToBounds = YES;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.backgroundColor = RGB_Color(247.f, 247, 247);
        self.label.layer.borderColor = RGB_Color(238, 238, 238).CGColor;
        self.label.layer.borderWidth = 1.f;
        self.label.layer.cornerRadius = 3.f;
        self.label.font = [UIFont systemFontOfSize:13.f];
        self.label.textColor = [UIColor colorWithRed:0xae/255.f green:0xae/255.f blue:0xae/255.f alpha:1];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.label.frame = self.bounds;
    [CATransaction commit];
}

- (void)setselectedState:(BOOL)isSeletedState
{
    self.label.backgroundColor = !isSeletedState ? RGB_Color(247, 247, 247):RGB_Color(53, 179, 100);
    self.label.textColor = !isSeletedState ? RGB_Color(51, 51, 51):[UIColor whiteColor];
    self.label.layer.borderColor = !isSeletedState ? RGB_Color(238, 238, 238).CGColor : RGB_Color(174, 225, 193).CGColor;

}
@end
