//
//  UploadGoodsCell.m
//  JewelryApp
//
//  Created by kequ on 15/5/7.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "UploadGoodsCell.h"
#import "PortraitView.h"
#import "CusTomerbutton.h"

@interface UploadGoodsCell()

@property(nonatomic,strong)PortraitView * iconView;
@property(nonatomic,strong)UIView * lineView;
@property(nonatomic,strong)UILabel * uploadTimeValue;
@property(nonatomic,strong)UILabel * uploadGoodsIdValue;
@property(nonatomic,strong)UILabel * uploadNameValue;
@property(nonatomic,strong)UILabel * uploadGoodsStateValue;
@property(nonatomic,strong)UILabel * uploadGoodsDes;
@property(nonatomic,strong)UIButton * modifyButton;
@property(nonatomic,strong)UIButton * deleteButton;
@property(nonatomic,strong)GoodsModel * model;
@end

@implementation UploadGoodsCell

+ (CGFloat)hegiWithModel:(GoodsModel *)model
{
    CGFloat height = 105;
    if (model.modifyPermission || model.deletePermission) {
        height += 32;
    }
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initAllSubViews];
    }
    return self;
}

- (void)initAllSubViews
{
    
    [self.contentView addSubview:self.lineView];
    
    self.iconView = [[PortraitView alloc] init];
    [self.contentView addSubview:self.iconView];
    
    self.uploadGoodsIdValue = [self getOneValueLabel];
    [self.contentView addSubview:self.uploadGoodsIdValue];
    
    self.uploadGoodsStateValue = [self getOneValueLabel];
    self.uploadGoodsStateValue.textColor = [UIColor colorWithRed:0x35/255.f green:0xb3/255.f blue:0x64/255.f alpha:1];
    [self.contentView addSubview:self.uploadGoodsStateValue];
   
    self.uploadNameValue = [self getOneValueLabel];
    [self.contentView addSubview:self.uploadNameValue];
    
    self.uploadTimeValue = [self getOneValueLabel];
    [self.contentView addSubview:self.uploadTimeValue];
    
    self.uploadGoodsDes = [self getOneValueLabel];
    self.uploadGoodsDes.font = [UIFont systemFontOfSize:12.f];
    self.uploadGoodsDes.textColor = [UIColor colorWithRed:0x66/255.f green:0x66/255.f blue:0x66/255.f alpha:1];
    self.uploadGoodsDes.numberOfLines = 2.f;
    self.uploadGoodsDes.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.uploadGoodsDes];
    
    self.modifyButton = [[CusTomerbutton alloc] init];
    self.modifyButton.tag = 100;
    [self.modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    [self.modifyButton setTitle:@"修改" forState:UIControlStateHighlighted];
    [self.modifyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.modifyButton];
    
    self.deleteButton = [[CusTomerbutton alloc] init];
    self.deleteButton.tag = 200;
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateHighlighted];
    [self.deleteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    
}




- (UILabel *)getOneValueLabel
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0x99/255.f green:0x99/255.f blue:0x99/255.f alpha:1];
    return label;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor  = [UIColor whiteColor];
        _lineView.layer.borderColor = [UIColor colorWithRed:0xea/255.f green:0xea/255.f blue:0xea/255.f alpha:1.f].CGColor;
        _lineView.layer.borderWidth = 0.5;
    }
    
    return _lineView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CGFloat offsetX = 10.f;
    CGFloat offsetY = 10.f;
    CGFloat spacingLabels = 29.f;
    self.iconView.frame = CGRectMake(offsetX, offsetY, 85, 85);
    
    [self.uploadGoodsIdValue sizeToFit];
    [self.uploadGoodsStateValue sizeToFit];
    [self.uploadNameValue sizeToFit];
    [self.uploadTimeValue sizeToFit];
    
    self.uploadGoodsIdValue.frame = CGRectMake(self.iconView.right + 12.f, self.iconView.top + 7,
                                               self.uploadGoodsIdValue.width, self.uploadGoodsIdValue.height);
    
    self.uploadGoodsStateValue.frame = CGRectMake(self.uploadGoodsIdValue.right + spacingLabels,
                                                  self.uploadGoodsIdValue.top,
                                                  self.uploadGoodsStateValue.width, self.uploadGoodsStateValue.height);
    
    
    self.uploadNameValue.frame = CGRectMake(self.uploadGoodsIdValue.left, self.uploadGoodsIdValue.bottom + 8,
                                            self.uploadNameValue.width, self.uploadNameValue.height);
    
    self.uploadTimeValue.frame = CGRectMake(self.uploadNameValue.right + spacingLabels, self.uploadNameValue.top,
                                            self.uploadTimeValue.width, self.uploadTimeValue.height);
    
    
    CGFloat spacing = self.width - offsetX - self.uploadTimeValue.right;
    if (spacing < 0) {
        //超出边界
        if (spacing + spacingLabels > 0) {
            spacingLabels = spacingLabels + spacing;
            self.uploadTimeValue.frame = CGRectMake(self.uploadNameValue.right + spacingLabels, self.uploadNameValue.top,
                                                    self.uploadTimeValue.width, self.uploadTimeValue.height);
        }else{
            self.uploadTimeValue.frame = CGRectMake(self.uploadNameValue.right , self.uploadNameValue.top,
                                                    self.width - offsetX - self.uploadNameValue.right, self.uploadTimeValue.height);
        }
    }

    self.uploadGoodsDes.frame = CGRectMake(self.uploadGoodsIdValue.left,
                                            self.uploadNameValue.top + 13,
                                            self.width - offsetX - self.uploadGoodsIdValue.left,
                                           self.iconView.bottom - 10 - (self.uploadNameValue.top + 13));
    
    self.lineView.frame = CGRectMake(-10, 0, self.width + 20, self.iconView.bottom + 10.f);

    self.deleteButton.frame = CGRectMake(self.width - 55 - offsetX, self.lineView.bottom + 5, 55, 21);
    if(self.deleteButton.isHidden){
        self.modifyButton.frame = CGRectMake(self.width - 55 - offsetX, self.uploadGoodsDes.bottom, 55, 21);
    }else{
        self.modifyButton.frame = CGRectOffset(self.deleteButton.frame, -19 - 55, 0);
    }
    
    [CATransaction commit];
}

#pragma mark DataSourc

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
    
    [self.iconView.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:defaultImage];

    self.uploadGoodsIdValue.text = [NSString stringWithFormat:@"编号:%@",[_model goodsName]];
    self.uploadGoodsStateValue.text = [NSString stringWithFormat:@"状态:%@",[GoodsModel converStateTostring:_model.state]];
    self.uploadTimeValue.text = [NSString stringWithFormat:@"上货时间:%@",_model.goodSUpLoaddata];
    self.uploadNameValue.text = [NSString stringWithFormat:@"上货人:%@",[_model goodsUploaderName]];
    if(![_model.goodsDes isEqualToString:@"该货品无描述"])
        self.uploadGoodsDes.text = [_model goodsDes];
    
    [self.modifyButton setHidden:!_model.modifyPermission];
    [self.deleteButton setHidden:!_model.deletePermission];
}

- (void)setSelected:(BOOL)selected
{
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
}
- (void)setHighlighted:(BOOL)highlighted
{
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
}
#pragma mark - Action
- (void)buttonClick:(UIButton *)button
{
    if(button.tag == 100){
        if ([_delegate respondsToSelector:@selector(uploadGoodsCell:DidMofityClick:)]) {
            [_delegate uploadGoodsCell:self DidMofityClick:self.model];
        }
        return;
    }
    
    if (button.tag == 200) {
        if ([_delegate respondsToSelector:@selector(uploadGoodsCell:DidDeleteClick:)]) {
            [_delegate uploadGoodsCell:self DidDeleteClick:self.model];
        }
    }
}
@end
