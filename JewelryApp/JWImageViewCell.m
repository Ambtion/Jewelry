//
//  BMImageViewCell.m
//  basicmap
//
//  Created by quke on 15/4/14.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "JWImageViewCell.h"

@implementation JWImageViewCell

- (PortraitView *)porView
{
    if (!_porView) {
        _porView = [[PortraitView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_porView];
    }
    return _porView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.porView.bounds = self.bounds;
}


- (void)setSelected:(BOOL)selected
{
    if (!self.needShowSeletedState) return;
    [super setSelected:selected];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (selected) {
            self.porView.layer.borderColor = [UIColor colorWithRed:0x3d/255.f green:0x84/255.f blue:0xf0/255.f alpha:1].CGColor;
            self.porView.layer.borderWidth = 3.f;
        }else{
            self.porView.layer.borderColor = [UIColor clearColor].CGColor;
            self.porView.layer.borderWidth = 0.f;
        }
    }];
}

@end
