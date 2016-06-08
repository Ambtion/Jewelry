//
//  OrderTableViewCell.m
//  JewelryApp
//
//  Created by kequ on 15/5/10.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "OrderHeadView.h"
#import "OrderGoodsView.h"
#import "OrderPropertyView.h"


@interface  OrderTableViewCell()<OrderGoodsViewDelegate,OrderHeadViewDelegate,OrderPropertyViewDelegate>

@property(nonatomic,strong)OrderHeadView * headView;
@property(nonatomic,strong)NSMutableArray * orderGoodsViews;
@property(nonatomic,strong)OrderPropertyView * properyView;
@property(nonatomic,strong)OrderModel * orderModel;
@property(nonatomic,assign)KOrderCellType cellType;
@end

@implementation OrderTableViewCell

+ (CGFloat)cellHeightWithModel:(OrderModel *)model withCellType:(KOrderCellType)type
{
    CGFloat height = [OrderHeadView orderHeadViewHightWithOrderCelltype:type];
    for (int i = 0; i < model.ordergoodsList.count; i++) {
        height += [OrderGoodsView heightwithGoodModel:model.ordergoodsList[i] WithOrderCelltype:type];
    }
    height +=  [OrderPropertyView hegith:model.optionalPropertyArray WithOrderCelltype:type  goodsListCount:model.ordergoodsList.count totalPrice:model.totalPrice isExpand:model.isExpladDetail];
    return height;
}

#pragma mark - 

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
    self.headView = [[OrderHeadView alloc] init];
    [self.headView setHidden:YES];
    self.headView.delegate = self;
    [self.contentView addSubview:self.headView];
    
    self.orderGoodsViews = [NSMutableArray arrayWithCapacity:0];
    
    self.properyView = [[OrderPropertyView alloc] init];
    self.properyView.delegate = self;
    [self.properyView setHidden:YES];
    [self.contentView addSubview:self.properyView];
    
}
#pragma mark - Layout View

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [self.properyView sizeToFit];
    
    self.headView.frame = CGRectMake(0, 0, self.contentView.width, [OrderHeadView orderHeadViewHightWithOrderCelltype:self.cellType]);
    [self.headView setUserInteractionEnabled:YES];
    //GoodsView
    CGFloat offsetX = 0;
    CGFloat bottom = self.headView.bottom;
    for (int i =0 ; i < self.orderModel.ordergoodsList.count;i++) {
        OrderGoodsView * goodView = [[self orderGoodsViews] objectAtIndex:i];
        [goodView sizeToFit];
        goodView.frame = CGRectMake(0, bottom, self.width, goodView.height);
        bottom = goodView.bottom;
        offsetX = goodView.porViews.left;
    }
    
    CGFloat properViewHeight =  [OrderPropertyView hegith:_orderModel.optionalPropertyArray WithOrderCelltype:self.cellType  goodsListCount:_orderModel.ordergoodsList.count totalPrice:_orderModel.totalPrice isExpand:_orderModel.isExpladDetail];
    
    self.properyView.frame = CGRectMake(0, bottom, self.contentView.width,properViewHeight);
    self.properyView.offsetX = offsetX;
    
    [self bringSubviewToFront:self.headView];
    [CATransaction commit];
}

#pragma mark - SetDataSource
- (void)setOrderModel:(OrderModel *)orderModel cellType:(KOrderCellType)type

{
    _orderModel = orderModel;
    self.cellType = type;
    [self.headView setHidden:NO];
    [self.headView setDadaSourceWithOrderCelltype:type
                                   isOrderSeleted:_orderModel.isSeletedState
                                          orderID:_orderModel.orderNum
                                        factoryID:_orderModel.factoryID
                                      facyoryCode:_orderModel.factoryCode
                             orderGoodsTotalPrice:[_orderModel totalPrice]
                                       orderState:_orderModel.state
                                       goodsCount:_orderModel.ordergoodsList.count];
 
    [self setGoodsViewDataSourceWithcellType:type];

    [self.properyView setHidden:NO];
    [self.properyView setModel:_orderModel.optionalPropertyArray WithOrderCelltype:type goodsListCount:_orderModel.ordergoodsList.count totalPrice:_orderModel.totalPrice isExpand:_orderModel.isExpladDetail];
    
    [self setNeedsLayout];
}

- (void)setGoodsViewDataSourceWithcellType:(KOrderCellType)type
{
    for (UIView * view in self.orderGoodsViews) {
        if (view.superview) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < _orderModel.ordergoodsList.count ; i++) {
        OrderGoodsView * view = nil;
        if (i < self.orderGoodsViews.count) {
            view = [self.orderGoodsViews objectAtIndex:i];
        }else{
            view = [[OrderGoodsView alloc] init];
            view.delegate = self;
            [self.orderGoodsViews addObject:view];
        }
        //最后一条线隐藏
        [view.lineView setHidden:i == _orderModel.ordergoodsList.count - 1];
        [view setGoodModel:_orderModel.ordergoodsList[i] WithOrderCelltype:type orderSeletedStart:_orderModel.isSeletedState];
        [self.contentView addSubview:view];
    }
    [self setNeedsLayout];
}

- (void)setIsLastView:(BOOL)isLastView
{
    _isLastView = isLastView;
    self.properyView.isLastView = isLastView;
}

#pragma mark OrderHeadViewDelegate
- (void)orderHeadViewSeletedButtonDidClick:(UIButton *)button
{
    button.selected = !button.selected;
    self.orderModel.isSeletedState = button.selected;
    if ([_delegate respondsToSelector:@selector(orderHeadViewSeletedButtonDidClick:)]) {
        [_delegate orderHeadViewSeletedButtonDidClick:button];
    }
}

- (void)orderHeadViewDidClick:(OrderHeadView *)headView
{
    if(![headView.leftLabel.text hasPrefix:@"厂商"]){
        return;
    }
    if ([_delegate respondsToSelector:@selector(orderHeadViewDidClick:)]) {
        [_delegate orderHeadViewDidClick:headView];
    }
}

#pragma mark OrderGoodsViewDelegate
-(void)orderGoodsViewDidClickDetailInfoInView:(GoodsModel *)model
{
    if ([_delegate respondsToSelector:@selector(orderGoodsViewDidClickDetailInfoInView:)]) {
        [_delegate orderGoodsViewDidClickDetailInfoInView:model];
    }
}

-(void)orderGoodsViewDidDelegateGoodsFromOrder:(GoodsModel *)model
{
    if ([_delegate respondsToSelector:@selector(orderTableViewCellDidClickDeleteButton:model:goodModel:)]) {
        [_delegate orderTableViewCellDidClickDeleteButton:self model:self.orderModel goodModel:model];
    }
}

- (void)orderGoodsViewTextViewDidBeginEdit:(OrderGoodsView *)goodsView
{
    if ([_delegate respondsToSelector:@selector(orderGoodsViewTextViewDidBeginEdit:)]) {
        [_delegate orderGoodsViewTextViewDidBeginEdit:goodsView];
    }
}

- (void)orderGoodsViewDidFavGoods:(GoodsModel *)model button:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(orderGoodsViewDidFavGoods: button:)]) {
        [_delegate orderGoodsViewDidFavGoods:model button:button];
    }
}

- (void)orderPropertyViewDetailView:(OrderPropertyView *)view DidClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(orderTableViewCellDidClickDetailButton:model:)]) {
        [_delegate orderTableViewCellDidClickDetailButton:self model:self.orderModel];
    }
}
#pragma mark - private Method
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
}
- (void)setHighlighted:(BOOL)highlighted{
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
}
- (void)setSelected:(BOOL)selected{
}

@end
