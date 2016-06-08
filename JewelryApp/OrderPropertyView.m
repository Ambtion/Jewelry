//
//  OrderPropertyView.m
//  JewelryApp
//
//  Created by kequ on 15/5/10.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "OrderPropertyView.h"
#import "ModelDefine.h"
#import "PropertyLabel.h"

#define DBUTTONHEIGHT           32
#define PLABELHEIGHT            13.f
#define PLABELHEIGHTSPACING     7.f
#define COUNTLABELHEIGHT        37.f
#define BOTTOMLINEHEIGHT        20.f


@interface OrderPropertyView()<UIAlertViewDelegate>
{
    NSString * tempPhoneNum;
}
@property(nonatomic,strong)UIView * topLineView;
@property(nonatomic,strong)UIButton * detailButton;
@property(nonatomic,strong)NSMutableArray * propertyLabelArrays;
@property(nonatomic,strong)UIView * countLineView;
@property(nonatomic,strong)UILabel * countLabel;
@property(nonatomic,strong)UILabel * totalPriceLabel;
@property(nonatomic,strong)UIView * bottomLineView;

//Data
@property(nonatomic,assign)KOrderCellType type;
@property(nonatomic,strong)NSArray * modelArray;
@property(nonatomic,assign)CGFloat totalPrice;
@property(nonatomic,assign)NSInteger totalGoodsCount;
@property(nonatomic,assign)BOOL isExpand;
@end

@implementation OrderPropertyView

+ (CGFloat)hegith:(NSArray *)modelArrays  WithOrderCelltype:(KOrderCellType)type goodsListCount:(NSInteger)goodsCount totalPrice:(double)totalPrice isExpand:(BOOL)isExpand
{
    
    CGFloat height = 0.f;
    
    if (modelArrays.count) {
        //存在属性，考虑展开
        if(!isExpand){
            height += DBUTTONHEIGHT;
        }else{
            height += 11.f;
//            height += PLABELHEIGHT * modelArrays.count;
            for (int i = 0; i < modelArrays.count; i++) {
                NSDictionary * pInfo = [modelArrays objectAtIndex:i];
                NSString * title = [pInfo objectStringForKey:@"key"];
                NSString * value = [pInfo objectStringForKey:@"value"];
                height += [PropertyLabel heightForTitleStr:title value:value];
            }
            height += PLABELHEIGHTSPACING * (modelArrays.count - 1);
            height += 11.f;
        }
    }
    if ([self isNeedShowCountLabelWithTotalPrice:totalPrice]) {
        height += COUNTLABELHEIGHT;
    }
    height += BOTTOMLINEHEIGHT;
    
    return height;
}

+ (BOOL)isNeedShowCountLabelWithTotalPrice:(CGFloat)totalPrice
{
    return totalPrice > 0;
//    KUserRole role = [[UserInfoModel defaultUserInfo] role];
//    return role == KUserBuyAboutPrice ||
//            role == KUserBuyOrderEnsure ||
//            role == KUserBuyAboutPrice ||
//            role == KUserBuyBossEnsture;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        //显示详情 | 详情
        //价格和数量
        //分割线
        self.detailButton = [[UIButton alloc] init];
        [self.detailButton setTitle:@"显示详情信息" forState:UIControlStateNormal];
        
        [self.detailButton setTitleColor:RGB_Color(153, 153, 153) forState:UIControlStateNormal];
        [self.detailButton setTitleColor:RGB_Color(153, 153, 153) forState:UIControlStateHighlighted];
        self.detailButton.backgroundColor = [UIColor whiteColor];
        self.detailButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [self.detailButton addTarget:self action:@selector(detailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.detailButton];
        
        self.propertyLabelArrays = [NSMutableArray arrayWithCapacity:0];
        
        self.countLineView = [self getLineView];
        [self addSubview:self.countLineView];
        
        self.countLabel = [[UILabel alloc] init];
        self.countLabel.font = [UIFont systemFontOfSize:12.f];
        self.countLabel.textColor = RGB_Color(153, 153, 153);
        [self addSubview:self.countLabel];
        
        self.totalPriceLabel = [[UILabel alloc] init];
        [self addSubview:self.totalPriceLabel];
        
        self.topLineView = [self getLineView];
        [self addSubview:self.topLineView];
        [self addSubview:self.bottomLineView];
        
    }
    return self;
}


- (void)setModel:(NSArray *)modelArrays  WithOrderCelltype:(KOrderCellType)type goodsListCount:(NSInteger)goodsCount totalPrice:(double)totalPrice isExpand:(BOOL)isExpand
{
    _modelArray  = modelArrays;
    self.type = type;
    self.totalPrice = totalPrice;
    self.totalGoodsCount = goodsCount;
    self.isExpand =  isExpand;
    
    if (modelArrays.count) {
        [self.detailButton setHidden:isExpand];
    }else{
        [self.detailButton setHidden:YES];
    }
    
    [self.topLineView setHidden: !(!self.detailButton.isHidden || (self.isExpand && _modelArray.count))];
    
    //商品详情信息
    for (UIView * view in self.propertyLabelArrays) {
        if (view.superview) {
            [view removeFromSuperview];
        }
    }
    [self.propertyLabelArrays removeAllObjects];
    
    for (int i = 0; i < _modelArray.count; i++) {
        NSDictionary * pInfo = [_modelArray objectAtIndex:i];
        NSString * title = [pInfo objectStringForKey:@"key"];
        NSString * value = [pInfo objectStringForKey:@"value"];
        PropertyLabel * label = nil;
        if (i < self.propertyLabelArrays.count) {
            label = [[self propertyLabelArrays] objectAtIndex:i];
        }else{
            label = [[PropertyLabel alloc] init];
            [self addSubview:label];
            [self.propertyLabelArrays addObject:label];
        }
        label.keyLabel.text =  title;
        label.valueLabel.text = value;
//        [label addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [label setHidden:!self.isExpand];
        [self addSubview:label];
    }

    //有总价格的时候显示数量和价格
    self.countLabel.text = [NSString stringWithFormat:@"共%ld件货品",(long)goodsCount];
    self.countLabel.text = nil;
    
    NSString * priceString = @"合计: 待定";
    if (totalPrice > 0) {
        priceString =  [NSString stringWithFormat:@"合计: ￥%.1f",totalPrice];
    }
    
    UIColor * normalColor = RGB_Color(102, 102, 102);
    UIColor * numberColor = RGB_Color(53, 179, 100);
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:priceString attributes:
                                           @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    [attrStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(0,3)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:numberColor range:NSMakeRange(3,attrStr.length - 3)];
    [self.totalPriceLabel setAttributedText:attrStr];

    

    BOOL needShowCountLabel = [[self class] isNeedShowCountLabelWithTotalPrice:totalPrice];
    
    [self.countLabel setHidden:!needShowCountLabel];
    [self.totalPriceLabel setHidden:!needShowCountLabel];
    [self.countLineView setHidden:self.totalPriceLabel.isHidden && self.countLabel.isHidden];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CGFloat offsetY = 0;
    self.topLineView.frame = CGRectMake(self.offsetX, offsetY, self.width + 20, 1);
    
    if (!self.detailButton.isHidden) {
        self.detailButton.frame = CGRectMake(0, 0, self.width, DBUTTONHEIGHT);
        offsetY = self.detailButton.bottom;
    }
    
    if (self.isExpand && self.propertyLabelArrays.count) {
        offsetY += 11.f;
        for (PropertyLabel * label in self.propertyLabelArrays) {
            CGFloat height = [PropertyLabel heightForTitleStr:label.keyLabel.text value:label.valueLabel.text];
            label.frame = CGRectMake(self.offsetX, offsetY, self.width - self.offsetX, height);
            offsetY = label.bottom + PLABELHEIGHTSPACING;
        }
        offsetY += 11.f - PLABELHEIGHTSPACING;
    }
    
    [self.totalPriceLabel sizeToFit];
    [self.countLabel sizeToFit];
    
    if (!self.countLabel.isHidden) {
        self.countLineView.frame = CGRectMake(self.offsetX, offsetY, self.width + 20, 1);
        self.totalPriceLabel.frame = CGRectMake(self.width - 10 - self.totalPriceLabel.width,
                                                offsetY,
                                                self.totalPriceLabel.width,
                                                COUNTLABELHEIGHT);
        self.countLabel.frame = CGRectMake(self.totalPriceLabel.left - self.countLabel.width - 20, offsetY, self.countLabel.width,COUNTLABELHEIGHT);
        offsetY = self.countLabel.bottom;
    }
    
    [self changeBottomViewWithType];
    self.bottomLineView.frame = CGRectMake(-10, offsetY, self.width + 20, self.isLastView ? 1 : BOTTOMLINEHEIGHT);
    [CATransaction commit];

}


- (void)setOffsetX:(CGFloat)offsetX
{
    if (_offsetX == offsetX) {
        return;
    }
    _offsetX = offsetX;
    [self setNeedsLayout];
}

- (void)setIsLastView:(BOOL)isLastView
{
    if (_isLastView == isLastView) {
        return;
    }
    _isLastView = isLastView;
    [self setNeedsLayout];
}

#pragma mark Action
- (void)detailButtonClick:(UIButton *)button
{
    if([_delegate respondsToSelector:@selector(orderPropertyViewDetailView:DidClick:)]){
        [_delegate orderPropertyViewDetailView:self DidClick:button];
    }
}


#pragma mark -  DetailButtonClick
- (void)phoneButtonClick:(PropertyLabel *)proper
{
    return;
//    if (![proper.keyLabel.text isEqualToString:@"厂商电话："]) {
//        return;
//    }
//    
//    NSString * title = [NSString stringWithFormat:@"呼叫 %@",proper.valueLabel.text];
//    tempPhoneNum = proper.valueLabel.text;
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alertView.tag = 100;
//    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex) {
//        NSString *num  = alertView.message;
//        if (alertView.tag == 100) {
//            num = @"tel://4006928800";
//        }else{
//            num = @"tel://06928880999";
//        }
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
//        
//    }
}

#pragma mark - Get Method
- (UIView *)getLineView
{
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor  = RGB_Color(234, 234, 234);
    return lineView;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = RGB_Color(247, 247, 247);
        _bottomLineView.layer.borderColor = RGB_Color(234, 234, 234).CGColor;
        _bottomLineView.layer.borderWidth = 0.5;
    }
    return _bottomLineView;
}

- (void)changeBottomViewWithType
{
    if (self.isLastView) {
        self.bottomLineView.backgroundColor = RGB_Color(234, 234, 234);
        self.bottomLineView.layer.borderWidth = 0;
    }else{
        self.bottomLineView.backgroundColor = RGB_Color(247, 247, 247);
        self.bottomLineView.layer.borderColor = RGB_Color(234, 234, 234).CGColor;
        self.bottomLineView.layer.borderWidth = 0.5;
    }
}

@end
