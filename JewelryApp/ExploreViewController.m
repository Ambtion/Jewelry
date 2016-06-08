//
//  ExploreViewController.m
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "ExploreViewController.h"
#import "GoodsItemCollectionViewCell.h"
#import "ExploreModel.h"
#import "ExPloreHeadView.h"
#import "GoodsDetailController.h"
#import "FactoryViewController.h"
#import "KeyWordSearchViewController.h"
#import "SearchInPutView.h"
#import "SearchResultViewController.h"
#import "RefreshCollectionView.h"

@interface ExploreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ExPloreHeadViewDelegate,GoodsItemCollectionViewCellDelegate,KeyWordSearchViewControllerDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)ExPloreHeadView * headView;
@property(nonatomic,strong)RefreshCollectionView * collectionView;
@property(nonatomic,strong)ExploreModel * model;
@property(nonatomic,assign)BOOL isNeedRefresh;
@end

@implementation ExploreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isNeedRefresh = YES;
    [self initAllSubViews];
}

- (void)initAllSubViews
{
    [self initNavBarItem];
    [self initCollectionView];
    [self initRefreshView];
    [self initHeadView];
    self.model = [[ExploreModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBarItem];
}

- (void)initNavBarItem
{
    [self resetNavBar];
    SearchInPutView * inputView = [[SearchInPutView alloc] initWithFrame:CGRectMake(20, 44 - 32 - 8, self.view.width - 20, 32)];
    [inputView.textButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.myNavigationItem.titleView = inputView;
    
}

- (void)initCollectionView
{
    
    UIView * view = [UIView new];
    [self.view addSubview:view];
    
    UICollectionGoodsItemLayout *layout = [[UICollectionGoodsItemLayout alloc] init];
    _collectionView = [[RefreshCollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _collectionView.clipsToBounds = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[GoodsItemCollectionViewCell class] forCellWithReuseIdentifier:@"GOODITEMCELL"];
    [_collectionView registerClass:[ExPloreHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootView"];
}

- (void)initHeadView
{
    self.headView  = [[ExPloreHeadView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right, 0)];
}

- (void)initRefreshView
{
  
    WS(ws);
    
    self.collectionView.refreshHeader.beginRefreshingBlock=^(){
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //请求分类
            [NetWorkEntiry getAllCategoryTypeWith:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                    ws.model.tagsArray = [BaseModelMethod getCatergoryIntoWithInfo:[responseObject objectForKey:@"result"]];
                    //请求推荐商品
                    [NetWorkEntiry getRecomendGoodsListWith:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                            ws.model.qualityGoodsList = [BaseModelMethod getGoodsArrayFromDicInfo:[responseObject objectForKey:@"result"]];
                            
                            //请求最新商品
                            [NetWorkEntiry getNewsGoodsListWith:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                                    ws.model.newsGoodsList = [BaseModelMethod getGoodsArrayFromDicInfo:[responseObject objectForKey:@"result"]];
                                    
                                    //请求商品列表
                                    [NetWorkEntiry getExploreGoodsListWithStart:0 count:RELOADDATACOUNT catergory:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                                            ws.model.normalList = [[BaseModelMethod getGoodsArrayFromDicInfo:[responseObject objectForKey:@"list"]] mutableCopy];
                                            ws.model.normalListMaxCount = [[responseObject objectForKey:@"total_num"] intValue];
                                            [ws.headView setQgoodsImage:[ws.model getArrayForRecomendArray:ws.model.qualityGoodsList]
                                                                   nArray:[ws.model getArrayForRecomendArray:ws.model.newsGoodsList]
                                                                 TagArray:ws.model.tagsArray];

                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [ws.headView sizeToFit];
                                                [ws.collectionView.refreshHeader endRefreshing];
                                                [ws.collectionView reloadData];
                                            });
                                            
                                        }else{
                                            [ws dealErrorResponse:responseObject];
                                        }
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [ws netError];
                                    }];
                                }else{
                                    [ws dealErrorResponse:responseObject];
                                }
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                [ws netError];
                            }];
                            
                        }else{
                            [ws dealErrorResponse:responseObject];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [ws netError];
                    }];

                }else{
                    [ws dealErrorResponse:responseObject];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [ws netError];
            }];
        });
    };
    
    self.collectionView.refreshFooter.beginRefreshingBlock =^(){
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [NetWorkEntiry getExploreGoodsListWithStart:ws.model.normalList.count count:LOADMOREDATACOUNT catergory:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
                if (code == 1000) {
                    NSArray * norList = [responseObject objectForKey:@"list"];
                    if (norList.count) {
                        [ws.model.normalList addObjectsFromArray:[BaseModelMethod getGoodsArrayFromDicInfo:norList]];
                        
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
                [ws.collectionView.refreshFooter endRefreshing];
            }];
        });
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
#pragma mark - LoadData
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isNeedRefresh)
        [self.collectionView.refreshHeader beginRefreshing];
    self.isNeedRefresh = NO;
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
    return self.model.normalList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.model.normalList.count) {
        return self.headView.frame.size;
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 1 && self.tabBarController) {
        return CGSizeMake(self.collectionView.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right, 48);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
            if (self.model) {
                [self.headView setQgoodsImage:[self.model getArrayForRecomendArray:self.model.qualityGoodsList]
                                       nArray:[self.model getArrayForRecomendArray:self.model.newsGoodsList]
                                     TagArray:self.model.tagsArray];
                self.headView.delegate = self;
                [self.headView sizeToFit];
            }
            return self.headView;
        }
    }
    
    UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootView" forIndexPath:indexPath];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsItemCollectionViewCell * goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GOODITEMCELL" forIndexPath:indexPath];
    goodsCell.delegate = self;
    if (self.model.normalList.count > indexPath.row) {
        [goodsCell setGoodsModel:self.model.normalList[indexPath.row]];
    }
    return goodsCell;
}


#pragma mark - Action

- (void)searchButtonClick:(UIButton *)button
{
    KeyWordSearchViewController * kSearch = [[KeyWordSearchViewController alloc] init];
    kSearch.delegate = self;
    self.isNeedRefresh = NO;
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
        SearchResultViewController * searchRe = [[SearchResultViewController alloc] init];
        searchRe.keyWorld = keyWorld;
        searchRe.tagModel.categoryTagArray = self.model.tagsArray;
        [self.navigationController pushViewController:searchRe animated:YES];
    }];
}

//赛选按钮
- (void)exPloreHeadViewDidClickImageScrollViewAdIndexPath:(NSIndexPath *)indexPath
{
    KGoodRecomendType type = KGoodRecomendInvalid;
    switch (indexPath.section) {
        case 0:
            type = KGoodRecomendNew;
            break;
        case 1:
            type = KGoodRecomendRecomend;
            break;
        default:
            break;
    }
    TagFillterModel * model = [[TagFillterModel alloc] init];
    model.seletedRecomendType = type;
    model.categoryTagArray = [self.model.tagsArray copy];
    SearchResultViewController * searchR = [[SearchResultViewController alloc] init];
    searchR.tagModel = model;
    [self.navigationController pushViewController:searchR animated:YES];

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

- (void)exPloreHeadViewDidClickTagAtIndex:(NSInteger)index
{
    TagFillterModel * model = [[TagFillterModel alloc] init];
    model.seletedRecomendType = KGoodRecomendInvalid;
    model.categoryTagArray = [self.model.tagsArray copy];
    [model.categorySeletedIndexs addObject:[model.categoryTagArray objectAtIndex:index]];
    SearchResultViewController * searchR = [[SearchResultViewController alloc] init];
    searchR.tagModel = model;
    [self.navigationController pushViewController:searchR animated:YES];

}

@end
