//
//  WaitingForDealView.m
//  JewelryApp
//
//  Created by kequ on 15/5/24.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "WaitingForDealView.h"

@interface WaitingForDealView()

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * orderCountLabel;
@property(nonatomic,strong)UILabel * goodsCountLabel;
@property(nonatomic,strong)UIView * lineView;
@end
@implementation WaitingForDealView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initAllSubView];
    }
    return self;
}

- (void)initAllSubView
{
    self.seletedButton = [[CusSeletedButton alloc] init];
    [self addSubview:self.seletedButton];
    
    self.titleLabel = [self getHeadLabel];
    self.titleLabel.text = @"全选";
    [self addSubview:self.titleLabel];
    
    self.orderCountLabel= [self getHeadLabel];
    [self addSubview:self.orderCountLabel];
    
    self.goodsCountLabel = [self getHeadLabel];
    [self addSubview:self.goodsCountLabel];
    
    
    self.commitButton = [[UIButton alloc] init];
    self.commitButton.backgroundColor = RGB_Color(51, 179, 100);
    [self.commitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.commitButton setTitle:@"确认提交" forState:UIControlStateHighlighted];
    self.commitButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self addSubview:self.commitButton];
    
    [self addSubview:self.lineView];
}

- (UILabel *)getHeadLabel
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textColor = RGB_Color(51, 51, 51);
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (void)setOrderCount:(NSInteger)orderCount GoodsCount:(NSInteger)goodsCout
{
    UIColor * nColor = RGB_Color(51, 51, 51);
    UIColor * hColor = RGB_Color(51, 179, 100);
    
    NSString * orderCountS = [NSString stringWithFormat:@"共%ld条订单",(long)orderCount];
    NSMutableAttributedString * orderAttrStr = [[NSMutableAttributedString alloc] initWithString:orderCountS attributes:
                                           @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    
    [orderAttrStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, orderAttrStr.length)];
    [orderAttrStr addAttribute:NSForegroundColorAttributeName value:nColor range:NSMakeRange(0,1)];
    [orderAttrStr addAttribute:NSForegroundColorAttributeName value:hColor range:NSMakeRange(1,orderAttrStr.length - 3)];
    [orderAttrStr addAttribute:NSForegroundColorAttributeName value:nColor range:NSMakeRange(orderAttrStr.length - 3,3)];
    [self.orderCountLabel setAttributedText:orderAttrStr];
    
    NSString * goodsCountS = [NSString stringWithFormat:@"共%ld件货品",(long)goodsCout];
    NSMutableAttributedString * goodsAttrStr = [[NSMutableAttributedString alloc] initWithString:goodsCountS attributes:
                                                @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    
    [goodsAttrStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, goodsAttrStr.length)];
    [goodsAttrStr addAttribute:NSForegroundColorAttributeName value:nColor range:NSMakeRange(0,1)];
    [goodsAttrStr addAttribute:NSForegroundColorAttributeName value:hColor range:NSMakeRange(1,goodsCountS.length - 1)];
    [goodsAttrStr addAttribute:NSForegroundColorAttributeName value:nColor range:NSMakeRange(goodsCountS.length - 3,3)];
    [self.goodsCountLabel setAttributedText:goodsAttrStr];
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    self.seletedButton.frame = CGRectMake(10, self.height/2.f - 9, 18, 18);
    
    [self.titleLabel sizeToFit];
    
    self.titleLabel.frame = CGRectMake(self.seletedButton.right + 10, 0, self.titleLabel.width, self.height);
    self.commitButton.frame = CGRectMake(self.width - 90, 0, 90, self.height);
    
    
    [self.goodsCountLabel sizeToFit];
    [self.orderCountLabel sizeToFit];
    
    CGFloat maxWidth = self.commitButton.left - self.titleLabel.right;
    CGFloat offsetX = self.titleLabel.right + 20;
    self.orderCountLabel.frame = CGRectMake(offsetX, 0, (maxWidth - 10)/2.f, self.height);
    
    self.goodsCountLabel.frame = CGRectMake(self.orderCountLabel.right, 0,
                                       (maxWidth - 10)/2.f, self.height);
    
    self.lineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    [CATransaction commit];
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor  = RGB_Color(234, 234, 234);
    }
    
    return _lineView;
}

@end
