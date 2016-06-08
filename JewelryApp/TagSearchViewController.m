//
//  TagSearchViewController.m
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "TagSearchViewController.h"
#import "TagLabelCell.h"
#import "GoodsModel.h"
#import "JWCollectionViewFlowLayout.h"

@interface TagSearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView * collectionView;

@end

@implementation TagSearchViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    [self initCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBar];
}

- (void)initNavBar
{
    [self resetNavBar];
    self.myNavigationItem.title = @"筛选";
    
    UIButton * buttonRight = [self getBarButtonWithTitle:@"完成"];
    [buttonRight addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.myNavigationItem.rightBarButtonItems = @[[self barSpaingItem],barItem];
}

- (void)initCollectionView
{
    JWCollectionViewFlowLayout *layout = [[JWCollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10.f;
    layout.minimumLineSpacing = 10.f;
    layout.itemSize = CGSizeMake(66,24);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) collectionViewLayout:layout];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.clipsToBounds = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[TagLabelCell class] forCellWithReuseIdentifier:@"GOODITEMCELL"];

    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootView"];

}
- (void)setModel:(TagFillterModel *)model
{
    _model = model;
    [self.collectionView reloadData];
}

#pragma mark - Delegate | DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            switch (self.model.tagType) {
                case KTagSearchTypeSaleGoods:
                    return self.model.goodsSourceSortType.count;
                    break;
                case KTagSearchTypeUploadGoods:
                    return self.model.goodsStateArray.count;
                default:
                    break;
            }
            break;
        case 1:
            return self.model.categoryTagArray.count;
            break;
        case 2:
            return self.model.priceSectionArray.count;
            break;
        default:
            break;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return CGSizeMake(98,24);
    }
    return CGSizeMake(66,24);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return [self getLineSpacingWithIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [self getLineSpacingWithIndex:section];
}

- (CGFloat)getLineSpacingWithIndex:(NSInteger)section
{
    if (section == 2) {
        return (self.collectionView.width - 20 - 98 * 3)/2.f;
    }
    return 12.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (!self.model) {
        return CGSizeZero;
    }
    return CGSizeMake(collectionView.width - collectionView.contentInset.right - collectionView.contentInset.left , 52);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (!self.model) {
        return CGSizeZero;
    }
    if (section == 2) {
        return CGSizeZero;
    }
    return CGSizeMake(collectionView.width - 20, 24);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * view  = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeadView"  forIndexPath:indexPath];
        view.backgroundColor  = [UIColor whiteColor];
        view.clipsToBounds = YES;
        UILabel * label = (UILabel *)[view viewWithTag:1000];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, view.width, view.height - 22 - 15)];
            label.tag = 1000;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:13.f];
            label.textColor = [UIColor colorWithRed:0x66/255.f green:0x66/255.f blue:0x66/255.f alpha:1.f];
            [view addSubview:label];
        }
        switch (indexPath.section) {
            case 0:
                switch (self.model.tagType) {
                    case KTagSearchTypeSaleGoods:
                        label.text = @"翠源精选";
                        break;
                    case KTagSearchTypeUploadGoods:
                        label.text = @"货品状态";
                    default:
                        break;
                }
                break;
            case 1:
                label.text = @"分类";
                break;
            case 2:
                label.text = @"价格区间";
                break;
            default:
                break;
        }
        return view;
    }else{
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FootView"  forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
        if (![view viewWithTag:100]) {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(-10, view.height - 1, view.width + 20, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha:1];
            lineView.tag = 100;
            [view addSubview:lineView];
        }
    }
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TagLabelCell * recomendCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GOODITEMCELL" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            
            switch (self.model.tagType) {
                case KTagSearchTypeSaleGoods:
                    recomendCell.label.text = self.model.goodsSourceSortType[indexPath.row];
                    [recomendCell setselectedState:self.model.seletedRecomendType == indexPath.row];
                    break;
                case KTagSearchTypeUploadGoods:
                    recomendCell.label.text = self.model.goodsStateArray[indexPath.row];
                    [recomendCell setselectedState:self.model.seletedGoodState == indexPath.row];
                    break;
                default:
                    break;
            }
            break;
        case 1:
        {
            GoodsCategoryModel * categoryModel = [[self.model categoryTagArray] objectAtIndex:indexPath.row];
            recomendCell.label.text = categoryModel.categoryKeyWorld;
            [recomendCell setselectedState:[self.model.categorySeletedIndexs containsObject:categoryModel]];
        }
            break;
            
        case 2:
        {
            NSNumber * number = [[self.model priceSectionArray] objectAtIndex:indexPath.row];
            recomendCell.label.text = [NSString stringWithFormat:@"%@",[GoodsModel coverGoodPriceSectionToString:[number integerValue]]];
//            if ([number integerValue] == KGoodsPriceSection50000_) {
//                recomendCell.label.text = @"50000元以上";
//            }
            [recomendCell setselectedState:[self.model.seletedPriceArray containsObject:number]];
        }
        default:
            break;
    }
   
    return recomendCell;
    
}

#pragma mark - Action
- (void)backButtonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(tagSearchViewControllerDidClickCancel:)]) {
        [_delegate tagSearchViewControllerDidClickCancel:self];
    }
}

- (void)rightBarButtonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(tagSearchViewController:DidSeleted:)]) {
        [_delegate tagSearchViewController:self DidSeleted:self.model];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (self.model.tagType) {
                case KTagSearchTypeSaleGoods:
                    self.model.seletedRecomendType = indexPath.row;
                    break;
                case KTagSearchTypeUploadGoods:
                    self.model.seletedGoodState = indexPath.row;
                    break;
                default:
                    break;
            }
            break;
        case 1:
        {
            GoodsCategoryModel * catModel = [[self.model categoryTagArray] objectAtIndex:indexPath.row];
            if (![self.model.categorySeletedIndexs containsObject:catModel]) {
                [self.model.categorySeletedIndexs addObject:catModel];
            }else{
                [self.model.categorySeletedIndexs removeObject:catModel];
            }
        }
            break;
        case 2:
        {
            NSNumber * number = [[self.model priceSectionArray] objectAtIndex:indexPath.row];
            if (![self.model.seletedPriceArray containsObject:number]) {
                [self.model.seletedPriceArray addObject:number];
            }else{
                [self.model.seletedPriceArray removeObject:number];
            }
        }
            break;
        default:
            break;
    }
    [self.collectionView reloadData];
}
@end
