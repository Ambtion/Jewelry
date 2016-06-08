//
//  OrderStateSumNumberView.m
//  JewelryApp
//
//  Created by kequ on 15/5/31.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "OrderStateSumNumberView.h"
#import "OrderListModel.h"
@interface IconButton:UIView
@property(nonatomic,strong)UIImageView * iconView;
@property(nonatomic,strong)UIView * btView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * valueLabel;
@property(nonatomic,assign)BOOL seleted;
@property(nonatomic,strong)OrderSateNumModel * numberModel;
@end

@implementation IconButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAllSubView];
    }
    return self;
}

- (void)initAllSubView
{
    self.iconView = [[UIImageView alloc] init];
    self.iconView.backgroundColor = RGB_Color(80, 218, 132);
    self.iconView.layer.cornerRadius = 7.5;
    self.iconView.layer.masksToBounds = YES;
    [self addSubview:self.iconView];
    
    self.btView = [[UIView alloc] init];
    self.btView.backgroundColor = RGB_Color(247, 247, 247);
    self.btView.layer.borderColor = RGB_Color(238, 238, 238).CGColor;
    self.btView.layer.borderWidth = 1.f;
    self.btView.layer.cornerRadius = 5.f;
    [self addSubview:self.btView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:11.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = RGB_Color(102, 102, 102);
    [self.btView addSubview:self.titleLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.font = [UIFont systemFontOfSize:10.f];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.backgroundColor = [UIColor clearColor];
    self.valueLabel.textColor = RGB_Color(102, 102, 102);
    [self.btView addSubview:self.valueLabel];
    self.seleted = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconView.frame = CGRectMake(self.width/2.f - 7.5,0, 15, 15);
    self.btView.frame = CGRectMake(1, self.iconView.bottom + 7, self.width - 2, 36.f);
    [self.titleLabel sizeToFit];
    [self.valueLabel sizeToFit];
    
    CGFloat spacing = 3;
    CGFloat height = (self.btView.height - spacing - self.titleLabel.height - self.valueLabel.height)/2.f;
    self.titleLabel.frame = CGRectMake(0, height, self.btView.width, self.titleLabel.height);
    self.valueLabel.frame = CGRectMake(0, self.titleLabel.bottom + spacing, self.btView.width, self.valueLabel.height);
}

- (void)setNumberModel:(OrderSateNumModel *)numberModel
{
    _numberModel = numberModel;
    
    self.titleLabel.text = [numberModel orderProgessStateStr];
    if (_numberModel.stateNumber < 0) {
        self.valueLabel.text = @"--";
    }else{
        self.valueLabel.text = [NSString stringWithFormat:@"%ld订单",(long)_numberModel.stateNumber];
    }
    
    [self setNeedsLayout];
}

- (void)setSeleted:(BOOL)seleted
{
    _seleted = seleted;
    if (_seleted) {
        self.iconView.backgroundColor = RGB_Color(80, 218, 132);
        self.titleLabel.font = [UIFont systemFontOfSize:11.f];
        self.valueLabel.font = [UIFont systemFontOfSize:10.f];
        self.titleLabel.textColor = RGB_Color(102, 102, 102);
        self.valueLabel.textColor = RGB_Color(102, 102, 102);
    }else{
        self.iconView.backgroundColor = RGB_Color(229, 229, 229);
        self.titleLabel.font = [UIFont systemFontOfSize:11.f];
        self.valueLabel.font = [UIFont systemFontOfSize:10.f];
        self.titleLabel.textColor = RGB_Color(102, 102, 102);
        self.valueLabel.textColor = RGB_Color(102, 102, 102);
    }
    [self setNeedsLayout];
}

@end


#define ICONBUTTONSIZE        CGSizeMake(57, 55)


@interface OrderStateSumNumberView()
@property(nonatomic,strong)NSMutableArray * buttonArray;
@property(nonatomic,strong)UIView * lineView;
@property(nonatomic,strong)UIView * bottomLineView;
@end

@implementation OrderStateSumNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    // h：85
    frame.size.height = 85.f;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initAllSubViews];
        self.seletedIndex = 0;
    }
    return self;
}

- (void)initAllSubViews
{
    [self addSubview:self.lineView];
    [self addSubview:self.bottomLineView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_dataSrouce.count) {
        return;
    }
    self.lineView.frame = CGRectMake(10, 22, self.width - 20, 1);
    
    CGFloat buttonOffsetY = self.lineView.top  - 7;
    
    if (_dataSrouce.count == 1) {
        IconButton * button = self.buttonArray[0];
        button.top = buttonOffsetY;
        button.center = CGPointMake(self.width/2.f, button.center.y);
        
    }else{
        CGFloat spacingX = 25.f;
        CGFloat buttonSpacing = (self.width - (_dataSrouce.count * ICONBUTTONSIZE.width) - 2 * spacingX)/(_dataSrouce.count - 1);

        for (int i =0; i<_dataSrouce.count; i++) {
            IconButton * button = self.buttonArray[i];
            button.origin = CGPointMake(spacingX + (button.width + buttonSpacing) * i, buttonOffsetY);
        }

    }
    self.bottomLineView.frame = CGRectMake(0, self.height - 10, self.width, 10);
}

- (void)setProgressNumber:(NSInteger)countNum withState:(KOrderProgressState )progessState
{
    OrderSateNumModel * model = nil;
    for (OrderSateNumModel * smodel in self.dataSrouce) {
        if (smodel.state == progessState) {
            model = smodel;
        }
    }
    if (model) {
        model.stateNumber = countNum;
        IconButton * button = [self.buttonArray objectAtIndex:[self.dataSrouce indexOfObject:model]];
        [button setNumberModel:model];
    }
}

#pragma mark - Action
- (void)tapGes:(UITapGestureRecognizer *)ges
{
    UIView  * view = [ges view];
    self.seletedIndex = view.tag;
    if ([_delegate respondsToSelector:@selector(orderStateSumNumberViewDidSeletedProgressView:)]) {
        [_delegate orderStateSumNumberViewDidSeletedProgressView:self];
    }
}

- (void)setDataSrouce:(NSArray *)dataSrouce
{
    _dataSrouce = dataSrouce;

    if (!self.buttonArray) {
        self.buttonArray = [NSMutableArray arrayWithCapacity:0];
    }
    for (UIView * view in self.buttonArray) {
        if (view.superview) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < _dataSrouce.count; i++) {
        IconButton * icon  = nil;
        if (i < self.buttonArray.count) {
            icon = self.buttonArray[i];
        }else{
            icon = [[IconButton alloc] initWithFrame:CGRectMake(0, 0, ICONBUTTONSIZE.width, ICONBUTTONSIZE.height)];
            icon.tag = i;
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
            [icon addGestureRecognizer:ges];
            [self addSubview:icon];
        }
        [self.buttonArray addObject:icon];
        [icon setNumberModel:_dataSrouce[i]];
        [self addSubview:icon];
    }
    
    self.seletedIndex = 0;
    
    [self setNeedsLayout];

}

- (void)setSeletedIndex:(NSInteger)seletedIndex
{
    _seletedIndex = seletedIndex;
    if (_seletedIndex < self.buttonArray.count) {
        for (IconButton * button in self.buttonArray) {
            button.seleted = _seletedIndex == button.tag;
        }
    }
}

- (KOrderProgressState)seletedProgessState
{
    if (_dataSrouce.count && _seletedIndex < _dataSrouce.count) {
        OrderSateNumModel *  numberModel  = self.dataSrouce[_seletedIndex];
        return numberModel.state;
    }
    return _defaultProgressState;
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


@end
