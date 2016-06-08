//
//  UploadImageCell.m
//  JewelryApp
//
//  Created by kequ on 15/5/9.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "UploadImageCell.h"
#import "PortraitView.h"

@implementation UploadImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _porView = [[PortraitView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_porView];
//        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        self.deleteButton.backgroundColor = [UIColor redColor];
//        [self.deleteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.porView.bounds = self.bounds;
    self.deleteButton.frame = CGRectMake(self.width - 30, 0, 30, 30);
    [CATransaction commit];
}

- (void)buttonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(uploadImageCellDidClickDeleteButton:)]) {
        [_delegate uploadImageCellDidClickDeleteButton:self];
    }
}

@end


@implementation UploadImageCellADD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _porView = [[PortraitView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_porView];
        //        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        //        self.deleteButton.backgroundColor = [UIColor redColor];
        //        [self.deleteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [self.contentView addSubview:self.deleteButton];
        self.porView.imageView.image = [UIImage imageNamed:@"add"];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.porView.bounds = self.bounds;
    self.deleteButton.frame = CGRectMake(self.width - 30, 0, 30, 30);
    [CATransaction commit];
}

- (void)buttonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(uploadImageCellDidClickDeleteButton:)]) {
        [_delegate uploadImageCellDidClickDeleteButton:(UploadImageCell*)self];
    }
}

@end
