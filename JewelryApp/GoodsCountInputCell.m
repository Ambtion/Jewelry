//
//  GoodsCountInputCell.m
//  JewelryApp
//
//  Created by kequ on 15/5/25.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "GoodsCountInputCell.h"


@interface GoodsCountInputCell()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel * countUnitLabel;

@end
@implementation GoodsCountInputCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.countUnitLabel = [[UILabel alloc] init];
    self.countUnitLabel.textAlignment = NSTextAlignmentLeft;
    self.countUnitLabel.textColor = RGB_Color(51, 51, 51);
    self.countUnitLabel.backgroundColor = [UIColor clearColor];
    self.countUnitLabel.font = [UIFont systemFontOfSize:12];
    self.countUnitLabel.text = @"个/件";
    [self.contentView addSubview:self.countUnitLabel];
    
    self.countTextField = [[UITextField alloc] init];
    self.countTextField.returnKeyType = UIReturnKeyNext;
    self.countTextField.delegate =  self;
    self.countTextField.textAlignment = NSTextAlignmentCenter;
    self.countTextField.font = [UIFont systemFontOfSize:13.f];
    self.countTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.countTextField.textColor = RGB_Color(51, 51, 51);
    self.countTextField.backgroundColor = RGB_Color(247.f, 247, 247);
    self.countTextField.layer.borderColor = RGB_Color(238, 238, 238).CGColor;
    self.countTextField.layer.borderWidth = 1.f;
    self.countTextField.layer.cornerRadius = 3.f;
    [self.contentView addSubview:self.countTextField];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    [self.countUnitLabel sizeToFit];
    self.countTextField.frame = CGRectMake(0,
                                           0, 67, self.height);
    self.countUnitLabel.frame = CGRectMake(self.countTextField.right + 5, 0,
                                           self.countUnitLabel.width, self.height);
    [CATransaction commit];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    if (newtxt.length > 4) {
        return NO;
    }
    if ([_delegate respondsToSelector:@selector(goodsDesInPutCellDidTextFieldWillChangeToString:)]) {
        [_delegate goodsDesInPutCellDidTextFieldWillChangeToString:newtxt];
    }
    return YES;
}

@end
