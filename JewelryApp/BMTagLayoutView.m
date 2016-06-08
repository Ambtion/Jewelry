//
//  BMTagView.m
//  basicmap
//
//  Created by quke on 15/4/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "BMTagLayoutView.h"

@interface BMTagView  : UIView
@property(nonatomic,strong)UIImageView * iconView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,assign,getter=isSeleted)BOOL seleted;
@end

@implementation BMTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUserInteractionEnabled:YES];

        self.iconView = [[UIImageView alloc] init];
        self.iconView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.iconView];
        self.titleLabel = [[UILabel alloc] init];
        [self addSubview:self.titleLabel];
        [self defoutSet];
    }
    return self;
}

- (void)defoutSet
{
    
    self.titleLabel.font = [UIFont systemFontOfSize:13.f];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.f];
}
    
- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

    self.iconView.frame = CGRectMake(0,self.height/2.f - 13, 26.f, 26.f);
    self.iconView.layer.cornerRadius = self.iconView.width/2.f;
    self.iconView.layer.masksToBounds = YES;
    self.titleLabel.frame = CGRectMake(self.iconView.right + 10, 0, self.width - self.iconView.right - 10,self.height);
    [CATransaction commit];
}

@end

@interface BMTagLayoutView()

//UI
@property(nonatomic,strong)NSMutableArray * tagViews;
@property(nonatomic,assign)UIEdgeInsets insets;
@end


@implementation BMTagLayoutView

+ (CGFloat)tagHeightWithTagArray:(NSArray *)dataSource
{
    UIEdgeInsets instet = UIEdgeInsetsMake(10, 23, 10, 0);
    CGFloat lineSapcing = 20.f;
    CGFloat tagViewHeigth = 30.f;
    
    CGFloat offsetY  = instet.top + tagViewHeigth + instet.bottom;
    
    if (dataSource.count > 3) {
        offsetY += lineSapcing + tagViewHeigth;
    }
    return offsetY;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.maxTagViewCount = 6;
        self.tagViews  = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

#pragma mark - Data

- (void)selectIndex:(NSInteger)index
{
    if (index > self.subviews.count || index < 0) {
        return;
    }
    for (BMTagView * view in self.subviews) {
        [view setSeleted:index == view.tag];
    }
}

- (void)setTitleSource:(NSArray *)dataSource
{

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger  maxCount = MIN(dataSource.count, self.maxTagViewCount);
    maxCount = dataSource.count;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[BMTagView class]] && view.superview ) {
            [view removeFromSuperview];
        }
    }

    for (int i = 0; i < maxCount; i++) {
        BMTagView * tagView = nil;
        if (self.tagViews.count > i) {
            tagView =  self.tagViews[i];
        }else{
            tagView = [[BMTagView alloc] init];
            [self.tagViews addObject:tagView];
            tagView.tag = i;
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureOnTapClick:)];
            [tagView addGestureRecognizer:ges];
        }
        GoodsCategoryModel * model = dataSource[i];
        tagView.titleLabel.text = model.categoryKeyWorld;
        NSString * imageStr = model.categoryImageStr;
        [tagView.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"temp"]];

        [self addSubview:tagView];
    }
    [self setNeedsDisplay];
    [CATransaction commit];
}

- (void)sizeToFit
{
    [super sizeToFit];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    self.insets = UIEdgeInsetsMake(10, 23, 10, 0);
    CGFloat lineSapcing = 20.f;
    
    CGFloat tagViewWidth = (self.width -  self.insets.left - self.insets.right)/3.f;
    CGFloat tagViewHeigth = 30.f;

    NSArray *subviews = self.subviews;
    
    CGFloat offsetX = self.insets.left;
    CGFloat offsetY = self.insets.top;
    UIView * lastView = nil;
    for (BMTagView * view in subviews) {
        
        if (view.tag % 3 == 0 && lastView) {
            offsetY = lastView.bottom + lineSapcing;
            offsetX = self.insets.left;
        }
        view.frame = CGRectMake(offsetX, offsetY, tagViewWidth, tagViewHeigth);
        [view setNeedsLayout];
        
        offsetX = view.right;
        lastView = view;
    }
    self.frame = CGRectMake(0, 0, self.width, offsetY + tagViewHeigth + self.insets.bottom);
    [CATransaction commit];
}

#pragma mark - Action
- (void)gestureOnTapClick:(UITapGestureRecognizer *)ges
{
    UIView * view = [ges view];
    if([_delegate respondsToSelector:@selector(tagLayoutViewDidClickIndex:)]){
        [_delegate tagLayoutViewDidClickIndex:view.tag];
    }
}
@end
