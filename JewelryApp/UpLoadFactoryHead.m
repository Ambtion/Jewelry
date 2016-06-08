//
//  UpLoadFactoryHead.m
//  JewelryApp
//
//  Created by kequ on 15/5/19.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "UpLoadFactoryHead.h"


@interface UpLoadFactoryHead()
@property(nonatomic,strong)UIImageView * sumBgView;
@property(nonatomic,strong)UILabel * factoryIdLabel;
@property(nonatomic,strong)UILabel * factoryDesTitle;
@property(nonatomic,strong)UILabel * factoryDesLabel;
@property(nonatomic,strong)UILabel * goodsNumberLabel;
@property(nonatomic,strong)UIView * lineView;
@end

@implementation UpLoadFactoryHead

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    
    if (!self.sumBgView) {
        
        [self addSubview:self.lineView];
        
        self.sumBgView = [[UIImageView alloc] init];
        [self.sumBgView setUserInteractionEnabled:YES];
        self.sumBgView.image = [UIImage imageNamed:@"factory_background"];
        [self addSubview:self.sumBgView];
        
        
        UIColor * bgColor = [UIColor clearColor];
        self.factoryIdLabel = [[UILabel alloc] init];
        self.factoryIdLabel.font = [UIFont systemFontOfSize:16.f];
        self.factoryIdLabel.backgroundColor = bgColor;
        self.factoryIdLabel.textAlignment = NSTextAlignmentLeft;
        self.factoryIdLabel.textColor = [UIColor whiteColor];
        self.factoryDesLabel.alpha = 0.8;
        [self addSubview:self.factoryIdLabel];
        
    
        self.factoryDesTitle = [[UILabel alloc] init];
        self.factoryDesTitle.text = @"厂家介绍:";
        self.factoryDesTitle.backgroundColor = bgColor;
        self.factoryDesTitle.textColor = [UIColor whiteColor];
        self.factoryDesTitle.font = [UIFont systemFontOfSize:14.f];
        self.factoryDesTitle.textAlignment = NSTextAlignmentLeft;
        self.factoryDesTitle.alpha = 0.8;
        [self addSubview:self.factoryDesTitle];
        
        self.factoryDesLabel = [[UILabel alloc] init];
        self.factoryDesLabel.backgroundColor = bgColor;
        self.factoryDesLabel.textColor = [UIColor whiteColor];
        self.factoryDesLabel.font = [UIFont systemFontOfSize:14.f];
        self.factoryDesLabel.alpha = 0.8;
        self.factoryDesLabel.numberOfLines = 2;
        self.factoryDesLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.factoryDesLabel];
        
        self.goodsNumberLabel  = [[UILabel alloc] init];
        self.goodsNumberLabel.backgroundColor = bgColor;
        self.goodsNumberLabel.textColor = [UIColor whiteColor];
        self.goodsNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.goodsNumberLabel];
    
    }
    
}

- (UILabel *)getOneTitleLabel
{
    UILabel * label = [[UILabel alloc] init];
    
    label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12.f];
    return label;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor  = [UIColor colorWithRed:0xf7/255.f green:0xf7/255.f blue:0xf7/255.f alpha:1];
        _lineView.layer.borderColor = [UIColor colorWithRed:0xea/255.f green:0xea/255.f blue:0xea/255.f alpha:1.f].CGColor;
        _lineView.layer.borderWidth = 0.5;
    }
  
    return _lineView;
}

#pragma mark DataSource
- (void)setFactoryMoedl:(FactoryModel *)model
{
    self.factoryIdLabel.text = [[UserInfoModel defaultUserInfo] factoryName];
    self.factoryDesLabel.text = model.facroyDes;
    
    UIColor * normalColor = [UIColor colorWithRed:0x66/255.f green:0x66/255.f blue:0x66/255.f alpha:1];
    UIColor * numberColor = [UIColor colorWithRed:0x0/255.f green:0x7f/255.f blue:0x0/255.f alpha:1];
    
    NSString * str = [NSString stringWithFormat:@"已上传货品:%ld件",(long)model.factoryGoodsNum];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:
                                                            @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    [attrStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:11.f] range:NSMakeRange(0, str.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(0,6)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:numberColor range:NSMakeRange(6,str.length - 7)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(str.length - 1,1)];
    [self.goodsNumberLabel setAttributedText:attrStr];
}

- (void)sizeToFit
{
    [super sizeToFit];
    
    CGFloat contetOffsetH = 10;
    CGFloat contetOffsetV = 23.f;
    CGFloat spaceTitleAndValue = 6.f;    //标题和内容距离
    CGFloat titleHeitgh = 16.f;
    
    self.factoryIdLabel.frame = CGRectMake(contetOffsetH,
                                           contetOffsetV,
                                           self.width - contetOffsetH * 2,
                                           titleHeitgh);
    
    [self.factoryDesTitle sizeToFit];
    self.factoryDesTitle.frame = CGRectMake(self.factoryIdLabel.left, self.factoryIdLabel.bottom + 18.f,
                                              self.factoryDesTitle.width, self.factoryDesTitle.height);

    CGFloat valueMaxWidth = self.width - contetOffsetH - (self.factoryDesTitle.right + spaceTitleAndValue);
    CGSize size = [self.factoryDesLabel sizeThatFits:CGSizeMake(valueMaxWidth, 50)];

    self.factoryDesLabel.frame = CGRectMake(self.factoryDesTitle.right + spaceTitleAndValue, self.factoryDesTitle.top,
                                            size.width, size.height);

    self.sumBgView.frame = CGRectMake(0, 0, self.width, self.factoryDesTitle.bottom + 19.f);

    self.goodsNumberLabel.frame = CGRectMake(0, self.sumBgView.bottom, self.width, 36.f);
    self.lineView.frame = CGRectMake(-10, self.goodsNumberLabel.bottom, self.width + 20, 10.f);
    
    self.frame = CGRectMake(0, 0, self.width, self.lineView.bottom);
    
}
@end
