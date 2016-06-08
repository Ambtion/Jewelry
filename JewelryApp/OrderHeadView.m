//
//  OrderHeadView.m
//  JewelryApp
//
//  Created by kequ on 15/5/13.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "OrderHeadView.h"
#import "OrderModel.h"
#import "CusSeletedButton.h"

@interface OrderHeadView()

@property(nonatomic,strong)CusSeletedButton * seletedButton;
@property(nonatomic,strong)UIView * lineView;
@property(nonatomic,strong)UILabel * centerLabel;
@property(nonatomic,strong)UILabel * rightLabel;

@property(nonatomic,strong)OrderHeadViewModel * headViewModel;
@end

@implementation OrderHeadViewModel
@end

@implementation OrderHeadView

#pragma mark - PubLic
+ (CGFloat)orderHeadViewHightWithOrderCelltype:(KOrderCellType)type
{
    return 37.f;
}

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initAllSubViews];
        [self setUserInteractionEnabled:YES];
        [self layoutSubviews];
    }
    return self;
}

- (void)initAllSubViews
{
    [self addTarget:self action:@selector(headViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.seletedButton = [[CusSeletedButton alloc] init];
    [self.seletedButton addTarget:self action:@selector(seletedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.seletedButton];
    
    self.leftLabel = [self getHeadLabel];
    self.leftLabel.textColor = RGB_Color(102, 102, 102);
    [self addSubview:self.leftLabel];
    
    self.centerLabel = [self getHeadLabel];
    self.centerLabel.textColor = RGB_Color(153, 153, 153);
    [self addSubview:self.centerLabel];
    
    self.rightLabel = [self getHeadLabel];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.textColor  = RGB_Color(53, 179, 100);
    [self addSubview:self.rightLabel];

    [self addSubview:self.lineView];
}

#pragma mark Layout 

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionAnimationDuration];
    
    [self.leftLabel sizeToFit];
    [self.centerLabel sizeToFit];
    [self.rightLabel sizeToFit];
    
    
    CGFloat offsetX = 10.f;
    
    self.seletedButton.frame = CGRectMake(offsetX, self.height/2.f - 9, 18, 18);
    
    if (self.seletedButton.isHidden) {
        self.leftLabel.frame = CGRectMake(offsetX, 0, self.leftLabel.width, self.height);
    }else{
        self.leftLabel.frame = CGRectMake(self.seletedButton.right + offsetX, 0, self.leftLabel.width, self.height);
    }
    
    self.centerLabel.frame  = CGRectMake(self.leftLabel.right + offsetX, 0, self.centerLabel.width, self.height);
    
    self.rightLabel.frame = CGRectMake(self.width - self.rightLabel.width - offsetX, 0, self.rightLabel.width, self.height);
    
    self.lineView.frame = CGRectMake(-10, self.height - 1, self.width + 20, 1);
    
    [CATransaction commit];
}

#pragma mark DataSource
//HeadView显示的元素 ： 选择状态，订单编码，厂家信息，订单状态，订单货货品数量
//显示元素根据不同状态的订单对应人物权限，自动变化
- (void)setDadaSourceWithOrderCelltype:(KOrderCellType)type
                        isOrderSeleted:(BOOL)isOrderSeleted
                               orderID:(NSString *)orderID
                             factoryID:(NSString *)factoryId
                           facyoryCode:(NSString *)factroyCode
                  orderGoodsTotalPrice:(CGFloat)totalPrice
                            orderState:(KOrderState)orderState
                            goodsCount:(NSInteger)goodsCount
{
    self.headViewModel = [[OrderHeadViewModel alloc] init];
    self.headViewModel.orderNum = orderID;
    self.headViewModel.factoryID = factoryId;
    self.headViewModel.factoryCode = factroyCode;
    self.headViewModel.orderState = orderState;
    self.headViewModel.totalPrice = totalPrice;
    self.headViewModel.goodsCount = goodsCount;
    self.headViewModel.cellType = type;
    self.headViewModel.isOrderSeleted = isOrderSeleted;
    
    [self adjsutContent];
    [self setNeedsLayout];
}

- (void)adjsutContent
{
    
    self.leftLabel.text = nil;
    self.centerLabel.text = nil;
    self.rightLabel.text = nil;
    
    
    //进行中的订单全部显示选择态
    [self.seletedButton setHidden:self.headViewModel.cellType != KOrderCellTypeWait];
    [self.seletedButton setSelected:self.headViewModel.isOrderSeleted];

    KUserRole role = [[UserInfoModel defaultUserInfo] role];
    
    
    //中间Label.有总价格的时候，不显示count，会在其他地方显示。
    if (self.headViewModel.goodsCount) {
        self.centerLabel.text = [NSString stringWithFormat:@"共%ld件货品",(long)self.headViewModel.goodsCount];
    }
    
    //左边Label，特殊定角色显示厂家信息，并且可以参看厂家详情
    //角色是 购物，订约，boss
    //否则显示订单编号
    
    
    
    if (role == KUserBuyInShopping ||
        role == KUserBuyInShoppingEnsure ||
        role == KUserBuyBossEnsture) {
        self.leftLabel.text = [NSString stringWithFormat:@"厂商:%@",[[self headViewModel] factoryCode]];
    }else{
        self.leftLabel.text = [NSString stringWithFormat:@"订单编号:%@",[[self headViewModel] orderNum]];
    }
    
    
//    if (选货人 || 定约人){
//        if(待处理){
//            左边显示厂商 右边订单状态
//        }else{
//            左边厂商右边显示订单号
//        }
//    } else if(终选人){
//        所有订单都是 左边显示厂商 右边订单状态 订单号在详细信息里
//    }else{
//        if (待处理){
//            左边是订单编号 右边是状态
//        }else{
//            左边是订单编号 右边不显示信息
//        }
//    }
    
    if(role == KUserBuyInShopping || role == KUserBuyInShoppingEnsure){
        self.leftLabel.text = [NSString stringWithFormat:@"厂商:%@",[[self headViewModel] factoryCode]];
        if (self.headViewModel.cellType == KOrderCellTypeWait ) {
            self.rightLabel.text = [NSString stringWithFormat:@"状态：%@",[OrderModel coverStateToString:self.headViewModel.orderState]];
        }else{
             self.rightLabel.text = [NSString stringWithFormat:@"订单编号:%@",[[self headViewModel] orderNum]];
        }
    }else if (role == KUserBuyBossEnsture){
        self.leftLabel.text = [NSString stringWithFormat:@"厂商:%@",[[self headViewModel] factoryCode]];
        self.rightLabel.text = [NSString stringWithFormat:@"状态：%@",[OrderModel coverStateToString:self.headViewModel.orderState]];
    }else{
        
        self.leftLabel.text = [NSString stringWithFormat:@"订单编号:%@",[[self headViewModel] orderNum]];

        if (self.headViewModel.cellType == KOrderCellTypeWait) {
            self.rightLabel.text = [NSString stringWithFormat:@"状态：%@",[OrderModel coverStateToString:self.headViewModel.orderState]];
        }
    }
    
    if(role == KUserSaleEnsureGoods){
        self.rightLabel.text = [NSString stringWithFormat:@"状态：%@",[OrderModel coverStateToString:self.headViewModel.orderState]];
    }
    
}



#pragma mark - Action
- (void)headViewDidClick:(UIButton *)button
{
    if([_delegate respondsToSelector:@selector(orderHeadViewDidClick:)]){
        [_delegate orderHeadViewDidClick:self];
    }
}

- (void)seletedButtonClick:(UIButton *)seleteButton
{
    if ([_delegate respondsToSelector:@selector(orderHeadViewSeletedButtonDidClick:)]) {
        [_delegate orderHeadViewSeletedButtonDidClick:seleteButton];
    }
}

#pragma mark - GetMethod
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor  = RGB_Color(234, 234, 234);
    }
    
    return _lineView;
}

- (UILabel *)getHeadLabel
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
@end
