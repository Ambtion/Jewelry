//
//  FactoryHeadView.m
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "FactoryHeadView.h"
#import "PortraitView.h"

@interface FactoryHeadView()
@property(nonatomic,strong)PortraitView * sumBgView;
@property(nonatomic,strong)UILabel * factoryIdTitle;
@property(nonatomic,strong)UILabel * factoryIdLabel;
@property(nonatomic,strong)UILabel * goodsNumberTitle;
@property(nonatomic,strong)UILabel * goodsNumberLabel;
@property(nonatomic,strong)UILabel * factoryDesTitle;
@property(nonatomic,strong)UILabel * factoryDesLabel;
@property(nonatomic,strong)UIButton * favButton;

@end

@implementation FactoryHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    
    if (!self.sumBgView) {
        UIColor * bgColor = [UIColor clearColor];
        
        self.sumBgView = [[PortraitView alloc] init];
        [self.sumBgView setUserInteractionEnabled:YES];
        self.sumBgView.imageView.image = [UIImage imageNamed:@"factory_background"];
        [self addSubview:self.sumBgView];
        
        self.factoryIdTitle = [[UILabel alloc] init];
        self.factoryIdTitle.text = @"厂商编号:";
        self.factoryIdTitle.font = [UIFont systemFontOfSize:13.f];
        self.factoryIdTitle.backgroundColor = bgColor;
        self.factoryIdTitle.textAlignment = NSTextAlignmentLeft;
        self.factoryIdTitle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [self addSubview:self.factoryIdTitle];

        
        self.factoryIdLabel = [[UILabel alloc] init];
        self.factoryIdLabel.font = [UIFont systemFontOfSize:13.f];
        self.factoryIdLabel.backgroundColor = bgColor;
        self.factoryIdLabel.textAlignment = NSTextAlignmentLeft;
        self.factoryIdLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [self addSubview:self.factoryIdLabel];
  
        
        self.goodsNumberTitle  = [[UILabel alloc] init];
        self.goodsNumberTitle.text = @"货品数量:";
        self.goodsNumberTitle.backgroundColor = bgColor;
        self.goodsNumberTitle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.goodsNumberTitle.font = [UIFont systemFontOfSize:13.f];
        self.goodsNumberTitle.textAlignment = NSTextAlignmentLeft;
        self.goodsNumberTitle.numberOfLines = 2;
        self.goodsNumberTitle.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.goodsNumberTitle];
        
      
        self.goodsNumberLabel  = [[UILabel alloc] init];
        self.goodsNumberLabel.backgroundColor = bgColor;
        self.goodsNumberLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.goodsNumberLabel.font = [UIFont systemFontOfSize:13.f];
        self.goodsNumberLabel.textAlignment = NSTextAlignmentLeft;
        self.goodsNumberLabel.numberOfLines = 2;
        self.goodsNumberLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.goodsNumberLabel];
        
        self.factoryDesTitle = [[UILabel alloc] init];
        self.factoryDesTitle.text = @"厂家介绍:";
        self.factoryDesTitle.backgroundColor = bgColor;
        self.factoryDesTitle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.factoryDesTitle.font = [UIFont systemFontOfSize:13.f];
        self.factoryDesTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.factoryDesTitle];
        
        self.factoryDesLabel = [[UILabel alloc] init];
        self.factoryDesLabel.backgroundColor = bgColor;
        self.factoryDesLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.factoryDesLabel.font = [UIFont systemFontOfSize:13.f];
        self.factoryDesLabel.numberOfLines = 2;
        self.factoryDesLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.factoryDesLabel];
        
        self.favButton = [[UIButton alloc] init];
        [self.favButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.favButton setTitle:@"取消关注" forState:UIControlStateSelected];
        [[self.favButton titleLabel] setFont:[UIFont systemFontOfSize:15.f]];
        self.favButton.backgroundColor = RGB_Color(53, 179, 100);
        self.favButton.layer.cornerRadius = 2.f;
        [self.favButton addTarget:self action:@selector(favButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.favButton];
        
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


#pragma mark DataSource
- (void)setFactoryMoedl:(FactoryModel *)model
{
    self.factoryIdLabel.text = model.factoryName;
    [self.sumBgView.imageView sd_setImageWithURL:[NSURL URLWithString:model.bgImageView] placeholderImage:[UIImage imageNamed:@"factory_background"]];
    self.goodsNumberLabel.text = [NSString stringWithFormat:@"%ld件",(long)model.factoryGoodsNum];
    self.factoryDesLabel.text = model.facroyDes;
    [self.favButton setSelected:model.isFav];
}

- (void)sizeToFit
{
    [super sizeToFit];
    
    CGFloat contetOffsetH = 7;
    CGFloat contetOffsetV = 16;
    CGFloat labelSpacingAndButton  = 6.f;
    CGFloat spaceTitleAndValue = 10.f;    //标题和内容距离
    CGFloat titleWidth = 60;            //标题宽度
    CGFloat titleHeitgh = 15.f;
    CGFloat spacingLabel = 7.f;
    
    
    self.favButton.frame = CGRectMake(self.width  - 68 - 10, contetOffsetV, 68, 27.f);
    
    CGFloat valueMaxWidth = self.favButton.left - labelSpacingAndButton - (contetOffsetH + titleWidth + spaceTitleAndValue);

    self.factoryIdTitle.frame = CGRectMake(contetOffsetH, contetOffsetV, titleWidth, titleHeitgh);
    
    self.factoryIdLabel.frame = CGRectMake(self.factoryIdTitle.right + spaceTitleAndValue,
                                           self.factoryIdTitle.top,
                                           valueMaxWidth,
                                           self.factoryIdTitle.height);

    self.goodsNumberTitle.frame = CGRectOffset(self.factoryIdTitle.frame, 0, self.factoryIdTitle.height + spacingLabel);
    self.goodsNumberLabel.frame = CGRectOffset(self.factoryIdLabel.frame, 0, self.factoryIdTitle.height + spacingLabel);
    
    self.factoryDesTitle.frame = CGRectOffset(self.goodsNumberTitle.frame, 0, self.goodsNumberTitle.height + spacingLabel);
    
    CGSize size = [self.factoryDesLabel sizeThatFits:CGSizeMake(valueMaxWidth, 10000)];

    
    self.factoryDesLabel.frame = CGRectMake(self.factoryDesTitle.right + spaceTitleAndValue, self.factoryDesTitle.top, size.width, size.height);
    
    self.frame = CGRectMake(0, 0, self.width, self.factoryDesLabel.bottom + contetOffsetV);
    self.sumBgView.frame = CGRectMake(-20, 0, self.width+ 40, self.height);

}

#pragma mark - Action
- (void)favButtonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(factoryHeadViewDidClickFavButton:)]) {
        [_delegate factoryHeadViewDidClickFavButton:button];
    }
}

@end

