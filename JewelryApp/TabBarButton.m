//
//  TabBarButton.m
//  JewelryApp
//
//  Created by kequ on 15/6/7.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "TabBarButton.h"
@interface  TabBarButton()
@property(nonatomic,strong)NSString * normalStr;
@property(nonatomic,strong)NSString * seletedStr;
@property(nonatomic,strong)UIImage * nImage;
@property(nonatomic,strong)UIImage * himage;
@end

@implementation TabBarButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2.f - 12, 6, 24, 24)];
        self.iconImage.backgroundColor = [UIColor clearColor];
        [self addSubview:self.iconImage];
        
        self.mtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImage.bottom + 2, self.width, self.height - (self.iconImage.bottom + 2))];
        self.mtitleLabel.font = [UIFont systemFontOfSize:12.f];
        self.mtitleLabel.backgroundColor = [UIColor clearColor];
        self.mtitleLabel.textColor = [UIColor whiteColor];
        self.mtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.mtitleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        self.normalStr = title;
    }
    if (state == UIControlStateSelected) {
        self.seletedStr = title;
    }
    [self setSelected:self.isSelected];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        self.nImage = image;
    }
    if (state == UIControlStateSelected || state == UIControlStateHighlighted) {
        self.himage = image;
    }
    [self setSelected:self.isSelected];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.iconImage.image = highlighted ? self.himage : self.nImage;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.mtitleLabel.text = selected ? self.seletedStr : self.normalStr;
    self.iconImage.image = selected ? self.himage : self.nImage;
}
@end
