//
//  FacrotyFeedViewCell.m
//  JewelryApp
//
//  Created by kequ on 15/5/4.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "FacrotyFeedViewCell.h"
#import "PortraitView.h"
#import "CusTomerbutton.h"

@interface FacrotyFeedViewCell()

@property(nonatomic,strong)PortraitView * iconImageView;
@property(nonatomic,strong)UILabel * idTilteLabel;
@property(nonatomic,strong)UILabel * idValueLabel;
@property(nonatomic,strong)UILabel * numberTitle;
@property(nonatomic,strong)UILabel * numberValue;
@property(nonatomic,strong)UILabel * lastUpNumTitle;
@property(nonatomic,strong)UILabel * lastUpNumValue;
@property(nonatomic,strong)UIButton * favButton;
@property(nonatomic,strong)UIView * lineView;
@end

@implementation FacrotyFeedViewCell
+ (CGFloat)cellHeight
{
    return 128;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
        [self updateConstraints];
    }
    return self;
}

- (void)initUI
{
    self.iconImageView = [[PortraitView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    self.idTilteLabel = [self getoneTitleLabel];
    [self.contentView addSubview:self.idTilteLabel];
    self.idValueLabel = [self getOneValueLabel];
    [self.contentView addSubview:self.idValueLabel];
    self.numberTitle = [self getoneTitleLabel];
    [self.contentView addSubview:self.numberTitle];
    self.numberValue = [self getOneValueLabel];
    [self.contentView addSubview:self.numberValue];
    self.lastUpNumTitle = [self getoneTitleLabel];
    [self.contentView addSubview:self.lastUpNumTitle];
    self.lastUpNumValue = [self getOneValueLabel];
    [self.contentView addSubview:self.lastUpNumValue];
    
 
    self.favButton = [[CusTomerbutton alloc] init];
    [self.favButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.favButton setTitle:@"取消关注" forState:UIControlStateSelected];
    [self.favButton addTarget:self action:@selector(favButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.favButton];
    
    self.idTilteLabel.text = @"厂方编号: ";
    self.numberTitle.text = @"货品数量: ";
    self.lastUpNumTitle.text = @"最新上货: ";
}

- (UILabel *)getoneTitleLabel
{
    UILabel * label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = RGB_Color(51, 51, 51);
    return label;
}

- (UILabel *)getOneValueLabel
{
    UILabel * label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = RGB_Color(128, 128, 128);
    return label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    self.iconImageView.frame = CGRectMake(10, 10, self.contentView.height - 20, self.contentView.height - 20);
    
    [self.idTilteLabel sizeToFit];
    [self.idValueLabel sizeToFit];
    [self.numberTitle sizeToFit];
    [self.numberValue sizeToFit];
    [self.lastUpNumTitle sizeToFit];
    [self.lastUpNumValue sizeToFit];
    
    self.idTilteLabel.frame = CGRectMake(self.iconImageView.right + 15, self.iconImageView.top + 5, self.idTilteLabel.width, self.idTilteLabel.height);
    self.idValueLabel.frame = CGRectMake(self.idTilteLabel.right, self.idTilteLabel.top, self.idValueLabel.width, self.idValueLabel.height);
    
    self.numberTitle.frame = CGRectMake(self.idTilteLabel.left, self.idTilteLabel.bottom + 10, self.numberTitle.width, self.numberTitle.height);
    self.numberValue.frame = CGRectMake(self.numberTitle.right, self.numberTitle.top, self.numberValue.width, self.numberValue.height);
    
    
    self.lastUpNumTitle.frame  = CGRectMake(self.idTilteLabel.left, self.numberTitle.bottom + 10, self.lastUpNumTitle.width, self.lastUpNumTitle.height);
    
    self.lastUpNumValue.frame = CGRectMake(self.lastUpNumTitle.right, self.lastUpNumTitle.top, self.lastUpNumValue.width, self.lastUpNumValue.height);
    
    self.favButton.frame = CGRectMake(self.contentView.width - 79 - 10 , self.contentView.height - 10 - 23, 79, 23);
    
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

- (void)setModel:(FactoryModel *)model
{
    if (_model == model) {
        return;
    }
    _model = model;
    UIImage * defaultImage = [UIImage imageNamed:@"temp"];
    if(_model.iconImageView)
        [self.iconImageView.imageView sd_setImageWithURL:[NSURL URLWithString:_model.iconImageView] placeholderImage:defaultImage];
    else
        [self.iconImageView.imageView sd_setImageWithURL:[NSURL URLWithString:_model.bgImageView] placeholderImage:defaultImage];
    self.idValueLabel.text = _model.factoryName;
    self.numberValue.text = [NSString stringWithFormat:@"%ld件",(long)_model.factoryGoodsNum];
    self.lastUpNumValue.text = [NSString stringWithFormat:@"%ld件",(long)_model.lastestGoodsNum];
    [self.favButton setSelected:_model.isFav];
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
#pragma mark - action

- (void)favButtonClick:(UIButton *)button
{
    if([_delegate respondsToSelector:@selector(factoryFeedViewCell:didClickFavButton:)]){
        [_delegate factoryFeedViewCell:self didClickFavButton:button];
    }
}

@end
