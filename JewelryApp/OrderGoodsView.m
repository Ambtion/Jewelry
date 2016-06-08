//
//  OrderGoodsView.m
//  JewelryApp
//
//  Created by kequ on 15/5/10.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "OrderGoodsView.h"
#import "PortraitView.h"
#import "UserInfoModel.h"
#import "OrderModel.h"
#import "CusTomerbutton.h"
#import "CusSeletedButton.h"

#define BUTTONITEMHEIGHT 38.f

@interface OrderGoodsView()<UITextFieldDelegate>

@property(nonatomic,strong)CusSeletedButton * seletedButton;
@property(nonatomic,strong)UILabel * goodsIdLabel;
@property(nonatomic,strong)UILabel * goodsPriceLabel;
@property(nonatomic,strong)UILabel * goodsDesLabel;
@property(nonatomic,strong)UIView * priceLineView;
@property(nonatomic,strong)UILabel * goodsPriceTitleLabel;
@property(nonatomic,strong)UITextField * goodsPriceTextFiled;
@property(nonatomic,strong)UIView * buttonLineView;
@property(nonatomic,strong)CusTomerbutton * deleteButton;
@property(nonatomic,strong)CusTomerbutton * favButton;

@end

@implementation OrderGoodsView

+ (CGFloat)heightwithGoodModel:(GoodsModel *)goodModel WithOrderCelltype:(KOrderCellType)type
{
    CGFloat heigth  = 106 - 5; //基本高度
    if ([self isNeedShowPriceInPutTextFieldWith:type goodsModel:goodModel]) {
        heigth += 30.f;
    }
    if ([self isNeedShowDeletebuttonWith:type] || [self isNeedShowFavButtonWith:type]) {
        heigth += BUTTONITEMHEIGHT;
    }
    return heigth;
}

+ (BOOL)isNeedShowFavButtonWith:(KOrderCellType)type
{
    //关注，(选货人等待处理的订单显示)
    KUserRole role = [[UserInfoModel defaultUserInfo] role];
    return type == KOrderCellTypeWait && (role == KUserBuyInShopping || role == KUserBuyInShoppingEnsure || role == KUserBuyBossEnsture);
}

+ (BOOL)isNeedShowDeletebuttonWith:(KOrderCellType)type
{
    //删除按钮逻辑（等待中的订单，选货人，大Boss）
    KUserRole role = [[UserInfoModel defaultUserInfo] role];
    return type == KOrderCellTypeWait && (role == KUserBuyInShopping || role == KUserBuyInShoppingEnsure || role == KUserBuyOrderEnsure || role == KUserBuyBossEnsture);
}

+ (BOOL)isNeedShowPriceInPutTextFieldWith:(KOrderCellType)type goodsModel:(GoodsModel *)goodModel
{
    //订单进行中，议价人员与厂方负责人显示
    KUserRole role = [[UserInfoModel defaultUserInfo] role];
    return type == KOrderCellTypeWait && role == KUserSaleEnsureGoods && goodModel.goodsPrice <= 0;
}

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.lineView = [self getOnelineView];
    [self addSubview:self.lineView];
    
    
    self.seletedButton = [[CusSeletedButton alloc] init];
    [self addSubview:self.seletedButton];
    
    self.porViews = [[PortraitView alloc] init];
    [self.porViews setUserInteractionEnabled:YES];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    [self.porViews addGestureRecognizer:tap];
    [self addSubview:self.porViews];
    
    self.goodsIdLabel = [self getoneLabel];
    self.goodsIdLabel.textColor = RGB_Color(102, 102, 102);
    [self addSubview:self.goodsIdLabel];
    
    self.goodsDesLabel = [[UILabel alloc] init];
    self.goodsDesLabel.textColor = RGB_Color(102, 102, 102);
    self.goodsDesLabel.font = [UIFont systemFontOfSize:12.f];
    self.goodsDesLabel.textAlignment = NSTextAlignmentLeft;
    self.goodsDesLabel.numberOfLines = 2;
    [self addSubview:self.goodsDesLabel];
    
    self.goodsPriceLabel = [self getoneLabel];
    self.goodsPriceLabel.textColor = RGB_Color(53, 179, 100);
    [self addSubview:self.goodsPriceLabel];
    
    self.priceLineView = [self getOnelineView];
    [self addSubview:self.priceLineView];
    
    self.goodsPriceTitleLabel = [self getoneLabel];
    self.goodsPriceTitleLabel.textColor = RGB_Color(102, 102, 102);
    self.goodsPriceTitleLabel.textAlignment = NSTextAlignmentRight;
    self.goodsPriceTitleLabel.font = [UIFont systemFontOfSize:11];
    self.goodsPriceTitleLabel.text = @"成交价格";
    [self addSubview:self.goodsPriceTitleLabel];
    
    self.goodsPriceTextFiled = [[UITextField alloc] init];
    self.goodsPriceTextFiled.returnKeyType = UIReturnKeyDone;
    self.goodsPriceTextFiled.delegate =  self;
    self.goodsPriceTextFiled.placeholder = @"议价后填写";
    self.goodsPriceTextFiled.textAlignment = NSTextAlignmentCenter;
    self.goodsPriceTextFiled.font = [UIFont systemFontOfSize:11.f];
    self.goodsPriceTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.goodsPriceTextFiled.textColor = [UIColor blackColor];
    [self.goodsPriceTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self addSubview:self.goodsPriceTextFiled];
    
    self.buttonLineView = [self getOnelineView];
    [self addSubview:self.buttonLineView];
    
    self.favButton = [[CusTomerbutton alloc] init];
    self.favButton.tag = 200;
    [self.favButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.favButton setTitle:@"取消关注" forState:UIControlStateSelected];
    [self.favButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.favButton];
    
    self.deleteButton = [[CusTomerbutton alloc] init];
    self.deleteButton.tag = 300;
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
    
}

- (UILabel *)getoneLabel
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.f];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

#pragma mark - Layout
- (void)sizeToFit
{
    [super sizeToFit];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    self.frame = CGRectMake(0, 0, self.superview.width, [[self class] heightwithGoodModel:self.goodModel WithOrderCelltype:self.type]);
    
    CGFloat offsetX = 10.f;
    CGFloat offsetY = 10.f;
    
    [self.goodsIdLabel sizeToFit];

    
    if(!self.seletedButton.isHidden){
        self.seletedButton.frame =  CGRectMake(offsetX, offsetY, 18, 18);
        self.porViews.frame = CGRectMake(self.seletedButton.right + 10, offsetY, 86 - 5, 86 - 5);
    }else{
        self.porViews.frame = CGRectMake(offsetX, offsetY, 86 - 5, 86 - 5);
    }

    self.seletedButton.center = CGPointMake(self.seletedButton.center.x, self.porViews.center.y);
    
    
    self.goodsIdLabel.frame = CGRectMake(self.porViews.right + 13, self.porViews.top + 6, self.goodsIdLabel.width, self.goodsIdLabel.height);
    
    
    CGSize size =  [self.goodsDesLabel sizeThatFits:CGSizeMake(self.width - 10 - self.goodsIdLabel.left, 10000)];
    self.goodsDesLabel.frame = CGRectMake(self.goodsIdLabel.left,
                                          self.goodsIdLabel.bottom + 12,
                                          size.width,
                                          size.height);
    
    [self.goodsPriceLabel sizeToFit];
    self.goodsPriceLabel.frame = CGRectMake(self.goodsDesLabel.left, self.porViews.bottom - self.goodsPriceLabel.height, self.width - self.goodsDesLabel.left - 10 , self.goodsPriceLabel.height);
    
    offsetY = self.porViews.bottom + 10;
    
    //可变控件
    if (self.goodsPriceTextFiled.isHidden) {
        self.goodsPriceTextFiled.frame = CGRectZero;
        self.goodsPriceTextFiled.frame = CGRectZero;
        
    }else{
        self.priceLineView.frame = CGRectMake(self.porViews.left, offsetY, self.width + 20, 1);
        
        
        NSString *oldText = self.goodsPriceTextFiled.text;
        if ([oldText isEqual:@""]) {
            oldText = self.goodsPriceTextFiled.placeholder;
        }
        CGSize size = [oldText sizeWithAttributes:@{
                                                    NSFontAttributeName:self.goodsPriceTextFiled.font
                                                    }];
        
        size.width = MAX(30, size.width + 10);
        size.width = 65;
        
        self.goodsPriceTextFiled.frame = CGRectMake(self.width - size.width - offsetX , offsetY, size.width, 30.f);
        
        [self.goodsPriceTitleLabel sizeToFit];
        self.goodsPriceTitleLabel.frame = CGRectMake(self.goodsPriceTextFiled.left - self.goodsPriceTitleLabel.width - 10, offsetY, self.goodsPriceTitleLabel.width, 30.f);
        offsetY = self.goodsPriceTextFiled.bottom;
    }

    self.buttonLineView.frame = CGRectMake(self.porViews.left, offsetY, self.width + 20, 1);
    
    CGFloat rightOffsetX = self.width - offsetX;
    
    if (![self.deleteButton isHidden]) {
        self.deleteButton.frame = CGRectMake(rightOffsetX - 55, (BUTTONITEMHEIGHT - 24 - 2)/2.f + self.buttonLineView.bottom, 55, 24);
        rightOffsetX = self.deleteButton.left;
    }
    
    self.favButton.frame = CGRectMake(rightOffsetX - 55 - 20, (BUTTONITEMHEIGHT - 24 - 2)/2.f + self.buttonLineView.bottom, 55, 24);
    
    self.lineView.frame = CGRectMake(self.porViews.left, self.height - 1, self.width + 20, 1);

    [CATransaction commit];
}

#pragma mark Data

- (void)setGoodModel:(GoodsModel *)goodModel WithOrderCelltype:(KOrderCellType)type orderSeletedStart:(BOOL)orderSeletedState
{
    _goodModel = goodModel;
    _type = type;
    [self.seletedButton setSelected:orderSeletedState];
    [self.seletedButton setHidden:YES];
    UIImage * defaultImage = [UIImage imageNamed:@"temp"];
    NSString * imageStr = [_goodModel.goodsImageArry firstObject];
    if(imageStr)
        imageStr = [imageStr stringByAppendingString:@"_150*150"];
    [self.porViews.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:defaultImage];
    self.goodsIdLabel.text = [NSString stringWithFormat:@"货品编号:%@",_goodModel.goodsName];
    
    KUserRole role = [[UserInfoModel defaultUserInfo] role];
    
    self.goodsDesLabel.text = _goodModel.goodsDes;

    BOOL isNeedShowPriceInputView = [[self class] isNeedShowPriceInPutTextFieldWith:type goodsModel:goodModel];
    
    [self.goodsPriceTextFiled setHidden:!isNeedShowPriceInputView];
    [self.goodsPriceTitleLabel setHidden:!isNeedShowPriceInputView];
    if(goodModel.localGoodsPrice){
        self.goodsPriceTextFiled.text = [NSString stringWithFormat:@"%ld",(long)[goodModel localGoodsPrice]];
    }else{
        self.goodsPriceTextFiled.text = @"";
    }
    
    [self.favButton setSelected:_goodModel.isFaved];
    
    //价格显示策略
    //1:议价状态前订单不显示任何价格信息
    /*2:议价后
        a:厂家负责人：        有议价显示 @"货品价格 ￥%.1f"
                            无议价显示 价格范围 待议(%@）“
     
     
        b:其他人boss:         有议价显示 @"货品价格 ￥%.1f"
                             无议价显示 价格范围 (%@）“
    */
    
    UIColor * normalColor = [UIColor colorWithRed:0x66/255.f green:0x66/255.f blue:0x66/255.f alpha:1];
    UIColor * numberColor = [UIColor colorWithRed:0x0/255.f green:0x7f/255.f blue:0x0/255.f alpha:1];
    NSString * str = nil;
    
    if (role == KUserSaleEnsureGoods && type == KOrderCellTypeWait) {
        
        self.goodsPriceLabel.textColor = self.goodsIdLabel.textColor;
        self.goodsPriceLabel.text = [GoodsModel coverGoodPriceSectionToString:_goodModel.goodsPriceSection];
        
     
        if (_goodModel.goodsPrice > 0) {
            str = [NSString stringWithFormat:@"货品价格: ￥%.1f",_goodModel.goodsPrice];
        }else{
            str = [NSString stringWithFormat:@"价格范围: (￥%@）",[GoodsModel coverGoodPriceSectionToString:_goodModel.goodsPriceSection]];
        }
        
    }else{
        
        if (_goodModel.goodsPrice <= 0) {
            str = [NSString stringWithFormat:@"价格范围: (￥%@）",[GoodsModel coverGoodPriceSectionToString:_goodModel.goodsPriceSection]];
        }else if(_goodModel.goodsPrice > 0){
            str = [NSString stringWithFormat:@"货品价格: ￥%.1f",_goodModel.goodsPrice];
        }
    }
    if (str) {
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:
                                               @{NSForegroundColorAttributeName:[UIColor clearColor]}];
        [attrStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:11.f] range:NSMakeRange(0, str.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(0,6)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:numberColor range:NSMakeRange(6,str.length - 6)];
        self.goodsPriceLabel.attributedText = attrStr;
    }
    
    [self.priceLineView setHidden:self.goodsPriceTextFiled.isHidden];
    
    BOOL isNeedShowFavButton = [[self class] isNeedShowFavButtonWith:type];
    [self.favButton setHidden:!isNeedShowFavButton];

    BOOL isNeedShowDeletebutton = [[self class] isNeedShowDeletebuttonWith:type];
    [self.deleteButton setHidden:!isNeedShowDeletebutton];
    
    [self.buttonLineView setHidden:(self.deleteButton.isHidden && self.favButton.isHidden)];
    
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(orderGoodsViewTextViewDidBeginEdit:)]) {
        [_delegate orderGoodsViewTextViewDidBeginEdit:self];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    if (newtxt.length > 9 ) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    self.goodModel.localGoodsPrice = [textField.text floatValue];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Action

- (void)imageViewTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(orderGoodsViewDidClickDetailInfoInView:)]) {
        [_delegate orderGoodsViewDidClickDetailInfoInView:self.goodModel];
    }
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 200) {
        if ([_delegate respondsToSelector:@selector(orderGoodsViewDidFavGoods: button:)]) {
            [_delegate orderGoodsViewDidFavGoods:self.goodModel button:button];
        }
        return;
    }
    
    if (button.tag == 300) {
        if ([_delegate respondsToSelector:@selector(orderGoodsViewDidDelegateGoodsFromOrder:)]) {
            [_delegate orderGoodsViewDidDelegateGoodsFromOrder:self.goodModel];
        }
    }
}

#pragma mark - GetMethod
- (UIView *)getOnelineView
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor  = RGB_Color(234, 234, 234);
//    lineView.layer.borderColor = [UIColor colorWithRed:0xea/255.f green:0xea/255.f blue:0xea/255.f alpha:1.f].CGColor;
//    lineView.layer.borderWidth = 0.5;

    return lineView;
}
@end
