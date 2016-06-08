//
//  GoodsFeedViewCell.m
//  JewelryApp
//
//  Created by kequ on 15/5/4.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "GoodsFeedViewCell.h"
#import "PortraitView.h"
#import "CusTomerbutton.h"

@interface GoodsFeedViewCell()
@property(nonatomic,strong)PortraitView * iconImageView;
@property(nonatomic,strong)UILabel * goodsDesLabel;
@property(nonatomic,strong)CusTomerbutton * favButton;
@property(nonatomic,strong)CusTomerbutton * orderButton;
@property(nonatomic,strong)UIView * lineView;
@end

@implementation GoodsFeedViewCell
+ (CGFloat)cellHeight
{
    return 128;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.iconImageView = [[PortraitView alloc] init];
    [self.contentView addSubview:self.iconImageView];
   
    self.goodsDesLabel = [[UILabel alloc] init];
    self.goodsDesLabel.textAlignment = NSTextAlignmentLeft;
    self.goodsDesLabel.font = [UIFont systemFontOfSize:13.f];
    self.goodsDesLabel.backgroundColor = [UIColor clearColor];
    self.goodsDesLabel.numberOfLines = 3.f;
    self.goodsDesLabel.textColor = RGB_Color(53, 53, 53);
    self.goodsDesLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.goodsDesLabel];
    
    self.favButton = [[CusTomerbutton alloc] init];
    [self.favButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.favButton setTitle:@"取消关注" forState:UIControlStateSelected];
    [self.favButton addTarget:self action:@selector(favButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.favButton];
    
    self.orderButton = [[CusTomerbutton alloc] init];
    [self.orderButton setTitle:@"加入订单" forState:UIControlStateNormal];
    [self.orderButton setTitle:@"取消订单" forState:UIControlStateSelected];
    [self.orderButton addTarget:self action:@selector(addToorderButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.orderButton];
    
    [self.orderButton setHidden:!([[UserInfoModel  defaultUserInfo] role] == KUserBuyInShopping || [[UserInfoModel  defaultUserInfo] role] == KUserBuyInShoppingEnsure)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.iconImageView.frame = CGRectMake(10, 10, self.contentView.height - 20, self.contentView.height - 20);
    
    self.favButton.frame = CGRectMake(self.contentView.width - 79 - 10 , self.contentView.height - 10 - 23, 79, 23);
    self.orderButton.frame = CGRectOffset(self.favButton.frame, -self.favButton.width - 16, 0);
    
    CGFloat maxWidth = self.contentView.width - self.iconImageView.right - 15 - 10;
    CGFloat maxHeight = self.contentView.height - 10 - 23 - 15;
    CGSize size = [self.goodsDesLabel sizeThatFits:CGSizeMake(maxWidth, maxHeight)];
    
    self.goodsDesLabel.frame = CGRectMake(self.iconImageView.right + 15, self.iconImageView.top + 5,
                                          size.width , size.height);
    self.lineView.frame = CGRectMake(0, self.contentView.height - 1, self.contentView.width, 1);
    [CATransaction commit];
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB_Color(229, 229, 229);
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted
{
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setSelected:(BOOL)selected
{
    
}
#pragma mark - 
- (void)setModel:(GoodsModel *)model
{
    if (_model == model) {
        return;
    }
    _model = model;
    UIImage * defaultImage = [UIImage imageNamed:@"temp"];
    NSString * imageStr = [_model.goodsImageArry firstObject];
    if(imageStr)
        imageStr = [imageStr stringByAppendingString:@"_150*150"];

    [self.iconImageView.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:defaultImage];

    self.goodsDesLabel.text = _model.goodsDes;
    [self.favButton setSelected:_model.isFaved];
    [self.orderButton setSelected:_model.isInOrder];
}

#pragma mark - action
- (void)favButtonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(goodsFeedViewCell:DidClickFavedButton:)]) {
        [_delegate goodsFeedViewCell:self DidClickFavedButton:button];
    }
}

- (void)addToorderButton:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(goodsFeedViewCell:DidClickAddIntoOrder:)]) {
        [_delegate goodsFeedViewCell:self DidClickAddIntoOrder:button];
    }
}

@end
