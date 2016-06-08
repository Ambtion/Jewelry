//
//  PropertyLabel.m
//  JewelryApp
//
//  Created by kequ on 15/5/27.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "PropertyLabel.h"

@implementation PropertyLabel

- (UILabel *)keyLabel
{
    if (!_keyLabel) {
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _keyLabel.backgroundColor = [UIColor clearColor];
        _keyLabel.font = [UIFont systemFontOfSize:11.f];
        _keyLabel.textAlignment = NSTextAlignmentLeft;
        _keyLabel.textColor = RGB_Color(153, 153, 153);
        [self addSubview:_keyLabel];
    }
    return _keyLabel;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.font = [UIFont systemFontOfSize:11.f];
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.numberOfLines = 0;
        _valueLabel.textColor = RGB_Color(153, 153, 153);
        [self addSubview:_valueLabel];
    }
    return _valueLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [self.keyLabel sizeToFit];
    [self.valueLabel sizeToFit];
    self.keyLabel.frame = CGRectMake(0, 0, self.keyLabel.width, self.keyLabel.height);
    self.valueLabel.frame = CGRectMake(self.keyLabel.right, 0, self.width - self.keyLabel.right - 10, self.height);
    [CATransaction commit];
}

+ (CGFloat)heightForTitleStr:(NSString *)key value:(NSString *)value
{
    CGFloat maxWithdth = [[UIScreen mainScreen] bounds].size.width - 10;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:11.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.text = key;
    CGSize keySize = [label sizeThatFits:CGSizeMake(maxWithdth, 32)];
    label.text = value;
    CGSize valueSize = [label sizeThatFits:CGSizeMake(maxWithdth - keySize.width - 10, 100000)];
    return valueSize.height;
}
@end
