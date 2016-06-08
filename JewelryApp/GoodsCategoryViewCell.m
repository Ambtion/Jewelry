//
//  FactroyCollectionViewCell.m
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "GoodsCategoryViewCell.h"
#import "GoodsCategoryModel.h"
#import "PortraitView.h"


@interface GoodsCategoryViewCell()
@property(nonatomic,strong)PortraitView * porViews;
@property(nonatomic,strong)GoodsCategoryModel * recommendModel;

@end
@implementation GoodsCategoryViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.needShowSeleteState = NO;
        [self initAllSubViews];
    }
    return self;
}

- (void)initAllSubViews
{
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.porViews = [[PortraitView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.porViews];
    self.caterLabel = [[UILabel alloc] init];
    self.caterLabel.textAlignment = NSTextAlignmentCenter;
    self.caterLabel.font = [UIFont boldSystemFontOfSize:20.f];
    self.caterLabel.backgroundColor = [UIColor clearColor];
    self.caterLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.caterLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.porViews.frame = self.bounds;
    self.caterLabel.frame = self.bounds;
    [CATransaction commit];
}


- (void)setCategoryModel:(GoodsCategoryModel *)recommendModel
{
    if (_recommendModel == recommendModel) {
        return;
    }
    _recommendModel = recommendModel;
    UIImage * defaultImage = [UIImage imageNamed:@"temp"];
    [_porViews.imageView sd_setImageWithURL:[NSURL URLWithString:_recommendModel.categoryImageStr] placeholderImage:defaultImage];
    self.caterLabel.text = _recommendModel.categoryKeyWorld;
}

- (void)setSelected:(BOOL)selected
{

}

- (void)setSelectedSate:(BOOL)selected
{
    if (!self.isNeedShowSeletedState) {
        return;
    }
    //区分选择态
    if (selected) {
        self.layer.borderColor =  [UIColor redColor].CGColor;
    }else{
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
