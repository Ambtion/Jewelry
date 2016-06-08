//
//  ExPloreHeadView.m
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "ExPloreHeadView.h"
#import "JWImageItemScrollView.h"
#import "BMTagLayoutView.h"

@interface HeadTitleView : UIView
@property(nonatomic,strong)UILabel * leftTitleLabel;
@property(nonatomic,strong)UIImageView * rightView;
@property(nonatomic,strong)UILabel * rightTitleLabel;
@property(nonatomic,strong)UIImageView * lefticonView;

@end

@implementation HeadTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initAllSubViews];
        [self layoutSubviews];
    }
    return self;
}

- (void)initAllSubViews
{
    self.lefticonView = [[UIImageView alloc] init];
    self.lefticonView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lefticonView];
    
    self.leftTitleLabel = [[UILabel alloc] init];
    self.leftTitleLabel.font = [UIFont systemFontOfSize:16.f];
    self.leftTitleLabel.textColor = RGB_Color(53, 179, 100);
    self.leftTitleLabel.backgroundColor = [UIColor redColor];
    self.leftTitleLabel.backgroundColor = [UIColor clearColor];
    self.leftTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.leftTitleLabel];
    
    self.rightView = [[UIImageView alloc] init];
    self.rightView.backgroundColor = [UIColor redColor];
    [self addSubview:self.rightView];
    
    self.rightTitleLabel = [[UILabel alloc] init];
    self.rightTitleLabel.font = [UIFont systemFontOfSize:14.f];
    self.rightTitleLabel.textColor = RGB_Color(102, 102, 102);
    self.rightTitleLabel.backgroundColor = [UIColor clearColor];
    self.rightTitleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.rightTitleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.lefticonView.frame = CGRectMake(0, self.height/2.f - 10, 20, 20);
    self.lefticonView.layer.cornerRadius = self.lefticonView.width/2.f;
    
    self.leftTitleLabel.frame = CGRectMake(self.lefticonView.right + 5, 0, self.width/2.f - (self.lefticonView.right + 5), self.height);
    //
    self.rightView.frame = CGRectMake(self.width - 10 - self.rightView.image.size.width,
                                      self.height/2.f - self.rightView.image.size.height/2.f, self.rightView.image.size.width, self.rightView.size.height);
    self.rightTitleLabel.frame = CGRectMake(self.width/2.f + 10, 0, self.width/2.f - (self.rightView.width + 10 + 10), self.height);
    [CATransaction commit];
}

@end

@interface ExPloreHeadView()<JWImageItemScrollViewDelegate,BMTagLayoutViewDelegate>

@property(nonatomic,strong)BMTagLayoutView * categoryView;

@property(nonatomic,strong)UIView * lineView1;
@property(nonatomic,strong)HeadTitleView * qGoodsTitle;
@property(nonatomic,strong)JWImageItemScrollView * qGoodsImageViews;

@property(nonatomic,strong)UIView * lineView2;
@property(nonatomic,strong)HeadTitleView * nGoodsTitle;
@property(nonatomic,strong)JWImageItemScrollView * nGoodsImageViews;

@property(nonatomic,strong)UIView * lineView3;
@property(nonatomic,strong)HeadTitleView * moreHeadView;

@end

@implementation ExPloreHeadView

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
    
    [self initCategoryView];
    
    self.lineView1 = [self lineView];
    self.lineView1.frame = CGRectMake(-20, self.categoryView.bottom, self.width + 40, 10);
    [self addSubview:self.lineView1];
    
    
    self.qGoodsTitle  = [[HeadTitleView alloc] initWithFrame:CGRectMake(0, self.lineView1.bottom, self.width, 40.f)];
    self.qGoodsTitle.leftTitleLabel.text = @"精品推荐";
    self.qGoodsTitle.rightTitleLabel.text = @"精心为您挑选 >";
    self.qGoodsTitle.lefticonView.image = [UIImage imageNamed:@"home_1"];
    [self addSubview:self.qGoodsTitle];
    

    self.qGoodsImageViews = [self getOneImageScrollView];
    self.qGoodsImageViews.frame = CGRectMake(0, self.qGoodsTitle.bottom, self.width, 67.f);
    self.qGoodsImageViews.collectionView.frame = self.qGoodsImageViews.bounds;
    self.qGoodsImageViews.tag = 1  + 1000;
    [self addSubview:self.qGoodsImageViews];

    self.lineView2 = [self lineView];
    self.lineView2.frame = CGRectMake(-20, self.qGoodsImageViews.bottom + 15.f, self.width + 40, 10);
    [self addSubview:self.lineView2];

    self.nGoodsTitle =  [[HeadTitleView alloc] initWithFrame:CGRectMake(0, self.lineView2.bottom, self.width, 40.f)];
    self.nGoodsTitle.leftTitleLabel.text = @"最新货品";
    self.nGoodsTitle.rightTitleLabel.text = @"只能比别人更快 >";
    self.nGoodsTitle.lefticonView.image = [UIImage imageNamed:@"home_2"];
    [self addSubview:self.nGoodsTitle];
    
    self.nGoodsImageViews = [self getOneImageScrollView];
    self.nGoodsImageViews.frame = CGRectMake(0, self.nGoodsTitle.bottom, self.width, 67.f);
    self.nGoodsImageViews.collectionView.frame = self.qGoodsImageViews.bounds;
    self.nGoodsImageViews.tag = 1000;
    [self addSubview:self.nGoodsImageViews];
    
    
    self.lineView3 = [self lineView];
    self.lineView3.frame = CGRectMake(-20, self.nGoodsImageViews.bottom + 15.f, self.width + 40, 10);
    [self addSubview:self.lineView3];
    
    self.moreHeadView = [[HeadTitleView alloc] initWithFrame:CGRectMake(0, self.lineView3.bottom, self.width, 40.f)];
    self.moreHeadView.lefticonView.image = [UIImage imageNamed:@"home_3"];
    self.moreHeadView.leftTitleLabel.text = @"更多货品";
    [self addSubview:self.moreHeadView];
}

- (void)initCategoryView
{
    self.categoryView = [[BMTagLayoutView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    self.categoryView.delegate = self;
    self.categoryView.maxTagViewCount = 6;
    [self addSubview:self.categoryView];
}


- (UIView *)lineView
{
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor  = [UIColor colorWithRed:0xf7/255.f green:0xf7/255.f blue:0xf7/255.f alpha:1];
    lineView.layer.borderColor = [UIColor colorWithRed:0xea/255.f green:0xea/255.f blue:0xea/255.f alpha:1.f].CGColor;
    lineView.layer.borderWidth = 0.5;
    return lineView;
}

- (JWImageItemScrollView *)getOneImageScrollView
{
    
    JWImageItemScrollView * imageScrollView = [[JWImageItemScrollView alloc] initWithMinimumInteritemSpacing:5.f];
    imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    imageScrollView.clipsToBounds = YES;
    imageScrollView.backgroundColor = [UIColor clearColor];
    imageScrollView.collectionView.backgroundColor = [UIColor clearColor];
    imageScrollView.imageSize = CGSizeMake(99.f, 67.f);
    imageScrollView.delegate = self;
    return imageScrollView;
}

#pragma mark DataSource
- (void)setQgoodsImage:(NSArray *)qArray nArray:(NSArray *)nArray TagArray:(NSArray *)tagArray
{
    [self.qGoodsImageViews setDataSourceArray:qArray];
    [self.nGoodsImageViews setDataSourceArray:nArray];
    [self.categoryView setTitleSource:tagArray];

}

-(void)sizeToFit
{
    [super sizeToFit];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [self.categoryView sizeToFit];
    self.lineView1.frame = CGRectMake(-20, self.categoryView.bottom, self.width + 40, 10);
    self.qGoodsTitle.frame = CGRectMake(0, self.lineView1.bottom, self.width, 40.f);
    self.qGoodsImageViews.frame = CGRectMake(0, self.qGoodsTitle.bottom, self.width, 67.f);
    self.lineView2.frame = CGRectMake(-20, self.qGoodsImageViews.bottom + 15.f, self.width + 40, 10);
    self.nGoodsTitle.frame = CGRectMake(0, self.lineView2.bottom, self.width, 40.f);
    self.nGoodsImageViews.frame = CGRectMake(0, self.nGoodsTitle.bottom, self.width, 67.f);
    self.lineView3.frame = CGRectMake(-20, self.nGoodsImageViews.bottom + 15.f, self.width + 40, 10);
    self.moreHeadView.frame = CGRectMake(0, self.lineView3.bottom, self.width, 40.f);
    self.frame = CGRectMake(0, 0, self.width, self.moreHeadView.bottom);
    [CATransaction commit];
}

#pragma mark 
-(void)jwimagesScrollView:(JWImageItemScrollView *)imageScrollView DidImageView:(PortraitView *)imageView indePath:(NSIndexPath *)path
{
    if ([_delegate respondsToSelector:@selector(exPloreHeadViewDidClickImageScrollViewAdIndexPath:)]) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:path.row inSection:imageScrollView.tag - 1000];
        [_delegate exPloreHeadViewDidClickImageScrollViewAdIndexPath:indexPath];
    }
}

- (void)tagLayoutViewDidClickIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(exPloreHeadViewDidClickTagAtIndex:)]) {
        [_delegate exPloreHeadViewDidClickTagAtIndex:index];
    }
}
@end
