//
//  GoodsItemCollectionViewCell.m
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "GoodsItemCollectionViewCell.h"
#import "PortraitView.h"

@interface GoodsItemCollectionViewCell()

@property(nonatomic,strong)PortraitView * porViews;
@property(nonatomic,strong)UIView * goodsDesBgView;
@property(nonatomic,strong)UILabel * goodsDesLabel;
@property(nonatomic,strong)UIView * goodsNumBgView;
@property(nonatomic,strong)UILabel * goodsFactoryName;
@property(nonatomic,strong)UILabel * goodsNumberLabel;

@property(nonatomic,strong)UIButton * imageButton;
@property(nonatomic,strong)GoodsModel * goodsModel;

@end

@implementation GoodsItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
//        self.isNeedShowGoodsCounts = NO;
        [self initAllSubViews];
        [self initAllGesture];
    }
    return self;
}

- (void)initAllSubViews
{
    self.porViews = [[PortraitView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.porViews];
    
    self.goodsDesBgView = [[UIView alloc] init];
    self.goodsDesBgView.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.contentView addSubview:self.goodsDesBgView];
    
    self.goodsDesLabel = [[UILabel alloc] init];
    self.goodsDesLabel.textAlignment = NSTextAlignmentLeft;
    self.goodsDesLabel.font = [UIFont systemFontOfSize:13.f];
    self.goodsDesLabel.backgroundColor = [UIColor clearColor];
    self.goodsDesLabel.textColor = [UIColor whiteColor];
    self.goodsDesLabel.numberOfLines = 2;
    self.goodsDesLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.goodsDesLabel];
    
    self.goodsNumBgView = [[UIView alloc] init];
    [self.goodsNumBgView setUserInteractionEnabled:NO];
    self.goodsNumBgView.backgroundColor  = [UIColor clearColor];
    [self.contentView addSubview:self.goodsNumBgView];
    
    
    self.goodsFactoryName = [[UILabel alloc] init];
    self.goodsFactoryName.backgroundColor = [UIColor clearColor];
    self.goodsFactoryName.font = [UIFont systemFontOfSize:13.f];
    self.goodsFactoryName.textAlignment = NSTextAlignmentLeft;
    self.goodsFactoryName.textColor = [UIColor colorWithRed:0x7d/255.f green:0x7d/255.f blue:0x7d/255.f alpha:1];
    self.goodsFactoryName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.goodsFactoryName];
    
    self.goodsNumberLabel = [[UILabel alloc] init];
    self.goodsNumberLabel.backgroundColor = [UIColor clearColor];
    self.goodsNumberLabel.font = [UIFont systemFontOfSize:10.f];
    self.goodsNumberLabel.textAlignment = NSTextAlignmentLeft;
    self.goodsNumberLabel.backgroundColor = [UIColor clearColor];
    self.goodsNumberLabel.textColor = [UIColor colorWithRed:0xb4/255.f green:0xb4/255.f blue:0xb4/255.f alpha:1];
    [self.contentView addSubview:self.goodsNumberLabel];
}

- (void)initAllGesture
{
    [self.porViews setUserInteractionEnabled:YES];
    self.imageButton = [[UIButton alloc] initWithFrame:self.porViews.bounds];
    [self.imageButton addTarget:self action:@selector(tapOnImageView:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.imageButton];
   
    [self.goodsNumBgView setUserInteractionEnabled:YES];
    UITapGestureRecognizer * labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnNumnberLaebl:)];
    [self.goodsNumBgView addGestureRecognizer:labelTap];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.porViews.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.width);
    self.imageButton.frame =  self.porViews.bounds;
    
    self.goodsDesBgView.frame  = CGRectMake(0, self.porViews.height - 35, self.width, 35);
    self.goodsDesLabel.frame = CGRectMake(5, self.goodsDesBgView.top, self.goodsDesBgView.width - 5, self.goodsDesBgView.height);
    
    self.goodsNumBgView.frame = CGRectMake(0, self.porViews.bottom, self.width, self.height - self.porViews.bottom);
    
    self.goodsFactoryName.frame = CGRectMake(5, self.goodsNumBgView.top + 4, self.goodsNumBgView.width - 10, self.goodsNumBgView.height/2.f - 4);
    self.goodsNumberLabel.frame = CGRectMake(5, self.goodsFactoryName.bottom, self.goodsNumBgView.width - 10, self.goodsNumBgView.height/2.f);
    [CATransaction commit];
}

- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    if (_goodsModel == goodsModel) {
        return;
    }
    
    _goodsModel = goodsModel;
    UIImage * defaultImage = [UIImage imageNamed:@"temp"];
    NSString * imageStr = [_goodsModel.goodsImageArry firstObject];
    if(imageStr)
        imageStr = [imageStr stringByAppendingString:@"_150*150"];
    [_porViews.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:defaultImage];
    self.goodsDesLabel.text = _goodsModel.goodsDes;
    self.goodsNumberLabel.text =  [NSString stringWithFormat:@"%ld个/件",(long)_goodsModel.goodsCount];
//    if (self.isNeedShowGoodsCounts) {
//        self.goodsNumberLabel.text =  [NSString stringWithFormat:@"%ld个/件",(long)_goodsModel.goodsCount];
//    }else{
//        self.goodsNumberLabel.text =  [NSString stringWithFormat:@"%ld件货品",(long)_goodsModel.facgoryGoodsCountNum];
//    }
    self.goodsFactoryName.text = _goodsModel.goddsFactoryCode;
    [self setNeedsLayout];
}

#pragma mark  - Action

- (void)tapOnImageView:(id)sender
{
    if (!_goodsModel) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(goodsItemCollectionViewCellDidClickGoodDetailInfo:)]) {
        [_delegate goodsItemCollectionViewCellDidClickGoodDetailInfo:self.goodsModel];
    }
}

- (void)tapOnNumnberLaebl:(id)sender
{
    if (!_goodsModel) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(goodsItemCollectionViewCellDidClickFactoryDetailInfo:)]) {
        [_delegate goodsItemCollectionViewCellDidClickFactoryDetailInfo:self.goodsModel];
    }

}
@end
