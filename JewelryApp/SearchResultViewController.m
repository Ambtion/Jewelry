//
//  SearchResultViewController.m
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchInPutView.h"
#import "GoodsItemCollectionViewCell.h"
#import "BMTagLayoutView.h"
#import "SearchInPutView.h"
#import "GoodsModel.h"
#import "KeyWordSearchViewController.h"
#import "GoodsDetailController.h"
#import "FactoryViewController.h"
#import "TagSearchViewController.h"
#import "TagSearchViewController.h"
#import "RefreshCollectionView.h"

#import "TagFillterModel.h"
#import "SearchTagViews.h"
#import "ExploreModel.h"

@interface SearchResultViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,
                                        GoodsItemCollectionViewCellDelegate,
                                        KeyWordSearchViewControllerDelegate,TagSearchViewControllerDelegate>

@property(nonatomic,strong)SearchInPutView * inputView;
@property(nonatomic,strong)SearchTagViews * headView;
@property(nonatomic,strong)RefreshCollectionView * collectionView;

@property(nonatomic,strong)NSMutableArray * goodsItemArray;
@property(nonatomic,assign)BOOL isNeedRefresh;
@property(nonatomic,assign)BOOL isNeedHiddeFactory; //是否隐藏商品的厂家信息，默认不隐藏
@end

@implementation SearchResultViewController

- (instancetype)initWithSwich:(BOOL)isNeedHiddenFactory
{
    self = [super init];
    if (self) {
        self.isNeedHiddeFactory = isNeedHiddenFactory;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0xf5/255.f green:0xf5/255.f blue:0xf5/255.f alpha:1];
    [self initCollectionView];
    [self initRefreshView];
    self.isNeedRefresh = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBarItem];
    if (self.isNeedRefresh)
        [self.collectionView.refreshHeader beginRefreshing];
    self.isNeedRefresh  = NO;
}

- (void)initNavBarItem
{
    [self resetNavBar];
    self.myNavigationItem.leftBarButtonItems = @[[self barSpaingItem],[self createBackButton]];
    
    SearchInPutView * inputView = [[SearchInPutView alloc] initWithFrame:CGRectMake(60, 5, self.view.width - 120, 34)];
    [inputView.textButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.myNavigationItem.titleView = inputView;
    
    UIButton * buttonRight = [self getBarButtonWithTitle:@"筛选"];
    [buttonRight addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.myNavigationItem.rightBarButtonItems = @[[self barSpaingItem],item];
}

- (TagFillterModel *)tagModel
{
    if (!_tagModel) {
        _tagModel = [[TagFillterModel alloc] init];
    }
    return _tagModel;
}

-(UIBarButtonItem*) createBackButton
{
    
    CGRect backframe= CGRectMake(0, 0, 40, 30);
    
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame = backframe;
    
    [backButton setImage:[UIImage imageNamed:@"icon_back_page"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon_back_page"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    //定制自己的风格的  UIBarButtonItem
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return someBarButtonItem;
    
}

- (void)popself
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initCollectionView
{
    UICollectionGoodsItemLayout *layout = [[UICollectionGoodsItemLayout alloc] init];
//    if (self.isNeedHiddeFactory) {
//        layout.itemSize = CGSizeMake(layout.itemSize.width, layout.itemSize.width);
//    }
    _collectionView = [[RefreshCollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) collectionViewLayout:layout];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.clipsToBounds = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[GoodsItemCollectionViewCell class] forCellWithReuseIdentifier:@"GOODITEMCELL"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
}

- (void)initRefreshView
{
  
    WS(ws);
    self.collectionView.refreshHeader.beginRefreshingBlock=^(){
        [ws reloadDataSrouce];
    };
    self.collectionView.refreshFooter.beginRefreshingBlock=^(){
        [ws loadDataWithStart:ws.goodsItemArray.count count:LOADMOREDATACOUNT Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                NSArray * norList = [responseObject objectForKey:@"list"];
                if (norList.count) {
                    [ws.goodsItemArray addObjectsFromArray:[BaseModelMethod getGoodsArrayFromDicInfo:norList]];
                    [ws.collectionView reloadData];
                }else{
                    [ws showTotasViewWithMes:@"已经加载所有数据"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ws.collectionView reloadData];
                    [ws.collectionView.refreshFooter endRefreshing];
                });
            }else {
                [ws dealErrorResponse:responseObject];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ws netError];
        }];
    };
}

- (void)dealErrorResponse:(NSDictionary *)dic
{
    [self showTotasViewWithMes:[dic objectForKey:@"result"]];
    [self.collectionView.refreshHeader endRefreshing];
    [self.collectionView.refreshFooter endRefreshing];
}

- (void)netError
{
    [self showTotasViewWithMes:@"网络异常，稍后重试"];
    [self.collectionView.refreshHeader endRefreshing];
    [self.collectionView.refreshFooter endRefreshing];
}

- (void)reloadDataSrouce
{
    [self loadDataWithStart:0 count:RELOADDATACOUNT Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1000) {
            self.goodsItemArray = [[BaseModelMethod getGoodsArrayFromDicInfo:[responseObject objectForKey:@"list"]] mutableCopy];
            [self.collectionView reloadData];
            [self.collectionView.refreshHeader endRefreshing];
        }else{
            [self dealErrorResponse:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self netError];
    }];
}

- (void)loadDataWithStart:(NSInteger)start count:(NSInteger)count
                   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure

{
    
    NSMutableArray * catIDs = [NSMutableArray arrayWithCapacity:0];
    for (GoodsCategoryModel * model in self.tagModel.categorySeletedIndexs) {
        [catIDs addObject:model.categoryID];
    }
    [NetWorkEntiry searchGoodsWithCategoryID:catIDs
                                  goodsState:self.tagModel.seletedGoodState
                               priceSecction:self.tagModel.seletedPriceArray
                                    keyWorld:self.keyWorld
                             isSpecial_param:self.tagModel.seletedRecomendType
                                   factoryID:self.tagModel.factoryID ? self.tagModel.factoryID : self.factoryID
                                       start:start count:count
                                     Success:success
                                     failure:failure];
}

#pragma mark - Delegate | DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return self.goodsItemArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [self.tagModel allSeletedTagsArray].count) {
        return CGSizeMake(collectionView.width, 50.f);
    }
    return CGSizeMake(collectionView.width, 5.f);;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UICollectionReusableView * reusView  =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
        if ([self.tagModel allSeletedTagsArray].count) {
            if (!self.headView) {
                self.headView = [[SearchTagViews alloc] initWithFrame:reusView.bounds];
                self.headView.imageSize =  CGSizeMake(98,24);
                self.headView.backgroundColor = [UIColor colorWithRed:0xf5/255.f green:0xf5/255.f blue:0xf5/255.f alpha:1.f];
                self.headView.frame = CGRectMake(-10, self.headView.top, self.headView.width + 20, self.headView.height);
                self.headView.collectionView.backgroundColor = [UIColor whiteColor];
                self.headView.collectionView.frame = CGRectMake(0, 0, self.headView.width, self.headView.height - 10);
                self.headView.collectionView.contentInset = UIEdgeInsetsMake(8, 10, 8, 10);
                reusView.clipsToBounds = NO;
            }
        }
        if (self.headView.superview != reusView) {
            [reusView addSubview:self.headView];
        }
        [self.headView setDataSourceArray:[self.tagModel allSeletedTagsArray]];
        return reusView;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsItemCollectionViewCell * goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GOODITEMCELL" forIndexPath:indexPath];
    goodsCell.delegate = self;
    if (self.goodsItemArray.count > indexPath.row) {
        [goodsCell setGoodsModel:self.goodsItemArray[indexPath.row]];
    }
    return goodsCell;
}

#pragma mark - Action
#pragma mark tagFillter
- (void)rightBarButtonClick:(UIButton *)button
{
    TagSearchViewController * tagSeracch = [[TagSearchViewController alloc] init];
    [tagSeracch setModel:self.tagModel];
    tagSeracch.delegate = self;
    [self.navigationController pushViewController:tagSeracch animated:YES];
}

- (void)tagSearchViewControllerDidClickCancel:(TagSearchViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tagSearchViewController:(TagSearchViewController *)controller DidSeleted:(TagFillterModel *)model
{
    self.tagModel = model;
    [[self.collectionView refreshHeader] beginRefreshing];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Search
- (void)searchButtonClick:(UIButton *)button
{
    KeyWordSearchViewController * kSearch = [[KeyWordSearchViewController alloc] init];
    kSearch.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:kSearch];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)keyWordSearchViewControllerDidClickCancel:(KeyWordSearchViewController *)controller
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)keyWordSearchViewController:(KeyWordSearchViewController *)controller DidSeletedSearchKeyWorld:(NSString *)keyWorld
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
    self.keyWorld = keyWorld;
    [self.collectionView.refreshHeader beginRefreshing];

}

#pragma mark goodsItem
//商品点击
- (void)goodsItemCollectionViewCellDidClickGoodDetailInfo:(GoodsModel *)goodModel
{
    GoodsDetailController * detailC = [[GoodsDetailController alloc] init];
    detailC.goodsID = goodModel.goodsID;
    [self.navigationController pushViewController:detailC animated:YES];
}

- (void)goodsItemCollectionViewCellDidClickFactoryDetailInfo:(GoodsModel *)goodModel
{
    FactoryViewController * fac = [[FactoryViewController alloc] initWithFactoryId:goodModel.goodsFactoryID facoryCode:goodModel.goddsFactoryCode];
    [self.navigationController pushViewController:fac animated:YES];
}
@end
