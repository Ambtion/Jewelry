//
//  GoodsDesInPutCell.m
//  JewelryApp
//
//  Created by kequ on 15/5/9.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "GoodsDesInPutCell.h"
#define MAXSEARCHCOUNT 200

@interface GoodsDesInPutCell()<UITextViewDelegate>
@property(nonatomic,strong)UILabel * placeLabel;
@end

@implementation GoodsDesInPutCell
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
    self.textView = [[UITextView alloc] init];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyNext;//返回键的类型
    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    self.textView.backgroundColor = [UIColor clearColor];
//    self.textView.scrollEnabled = NO;
    [self.contentView addSubview:self.textView];
    
    self.placeLabel = [[UILabel alloc] init];
//    self.placeLabel.text = @"请输入描述（）"
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.textView.frame = CGRectMake(0, 0, self.width, self.height);
    [CATransaction commit];
}


#pragma mark  - Delegate
//#pragma mark 字数限制
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    
//    NSMutableString *newtxt = [NSMutableString stringWithString:textView.text];
//    [newtxt replaceCharactersInRange:range withString:text];
//    if (newtxt.length > MAXSEARCHCOUNT ) {
//        newtxt = [newtxt substringWithRange:NSMakeRange(0,MAXSEARCHCOUNT)];
//    }
//    textView.text = newtxt;
//    if ([_delegate respondsToSelector:@selector(goodsDesInPutCellDidTextViewWillChangeToString:)]) {
//        [_delegate goodsDesInPutCellDidTextViewWillChangeToString:newtxt];
//    }
//    return ([newtxt length] <= MAXSEARCHCOUNT);
//}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(goodsDesInPutCellDidTextViewWillChangeToString:)]) {
        [_delegate goodsDesInPutCellDidTextViewWillChangeToString:textView.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.textView becomeFirstResponder];
    return YES;
}

@end
