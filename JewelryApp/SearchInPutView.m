//
//  SearchInPutView.m
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "SearchInPutView.h"

@interface SearchInPutView()
@property(nonatomic,strong)UIView * borderbgView;
@property(nonatomic,strong)UIImageView * searchIconView;
@end

@implementation SearchInPutView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4.f;
        self.layer.borderColor = [UIColor colorWithRed:222/255.f green:222/255.f blue:222/255.f alpha:1].CGColor;
        self.layer.borderWidth = .5f;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.backgroundColor = [UIColor colorWithRed:0xed/255.f green:0xef/255.f blue:0xf0/255.f alpha:1];
    
    self.borderbgView = [[UIView alloc] init];
    self.borderbgView.backgroundColor = [UIColor whiteColor];
    self.borderbgView.clipsToBounds = YES;
    [self addSubview:self.borderbgView];
    
    self.searchIconView = [[UIImageView alloc] init];
    self.searchIconView.image = [UIImage imageNamed:@"search_"];
    [self addSubview:self.searchIconView];
    
    self.textFiled = [[UITextField alloc] init];
    self.textFiled.backgroundColor = [UIColor clearColor];
    self.textFiled.textColor = [UIColor colorWithRed:0x31/255.f green:0x32/255.f blue:0x33/255.f alpha:1];
    self.textFiled.font = [UIFont systemFontOfSize:15.f];
    self.textFiled.returnKeyType = UIReturnKeyDone;
    self.textFiled.textAlignment = NSTextAlignmentLeft;
    NSAttributedString * str = [[NSAttributedString alloc] initWithString:@"探索感兴趣的货品"
                                                               attributes:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont systemFontOfSize:15.f],NSFontAttributeName,
                                 [UIColor colorWithRed:0xcc/255.f green:0xcc/255.f blue:0xcc/255.f alpha:1],NSForegroundColorAttributeName ,nil]];
    
    self.textFiled.attributedPlaceholder = str;
    [self.borderbgView addSubview:self.textFiled];
    
    self.textButton = [[UIButton alloc] init];
    self.textButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textButton];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.borderbgView.frame = CGRectMake(0, 0, self.width , self.height);
    self.searchIconView.frame = CGRectMake(11, self.height/2.f - 8.f, 16, 16);
    self.textFiled.frame = CGRectMake(self.searchIconView.right + 9, 0, self.borderbgView.width - (self.searchIconView.right + 9), self.borderbgView.height);
    self.textButton.frame = self.borderbgView.frame;
    
}

- (BOOL)textBecomeFirstResponder
{
    [self.textButton setUserInteractionEnabled:NO];
    return [self.textFiled becomeFirstResponder];
}

- (BOOL)textResignFirstResponder
{
    [self.textButton setUserInteractionEnabled:YES];
    return [self.textFiled resignFirstResponder];
}


@end
