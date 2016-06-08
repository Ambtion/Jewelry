//
//  FactoryViewController.m
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "FactoryViewController.h"
#import "FactoryHeadView.h"
#import "FactoryModel.h"
#import "SearchResultViewController.h"
#import "RefreshCollectionView.h"
#import "ExPloreHeadView.h"
#import "GoodsItemCollectionViewCell.h"
#import "FactoryControllerModel.h"
#import "GoodsDetailController.h"

@interface FactoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,FactoryHeadViewDelegate,
ExPloreHeadViewDelegate,GoodsItemCollectionViewCellDelegate>

@property(nonatomic,strong)RefreshCollectionView * collectionView;
@property(nonatomic,strong)FactoryHeadView * factoryHeadView;
@property(nonatomic,strong)ExPloreHeadView * expheadView;

@property(nonatomic,strong)NSString * factoryID;
@property(nonatomic,strong)NSString * factoryCode;
@property(nonatomic,strong)FactoryControllerModel * model;
@property(nonatomic,assign)BOOL isNeedRefresh;

@end

@implementation FactoryViewController

- (instancetype)initWithFactoryId:(NSString *)facId facoryCode:(NSString *)factortCode
{
    self = [super init];
    if (self) {
        self.factoryID = facId;
        self.factoryCode = factortCode;
        self.isNeedRefresh = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initAllSubViews];
}

- (void)initAllSubViews
{
    [self initCollectionView];
    [self initRefreshView];
    [self initHeadView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBar];
}
- (FactoryControllerModel * )model
{
    if (!_model) {
        _model = [[FactoryControllerModel alloc] init];
    }
    return _model;
}

- (void)initNavBar
{
    [self resetNavBar];
    self.myNavigationItem.title = @"厂商";
}

- (void)initCollectionView
{
    UICollectionGoodsItemLayout *layout = [[UICollectionGoodsItemLayout alloc] init];
    _collectionView = [[RefreshCollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) collectionViewLayout:layout];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.clipsToBounds = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[GoodsItemCollectionViewCell class] forCellWithReuseIdentifier:@"GOODITEMCELL"];
    [_collectionView registerClass:[ExPloreHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EXPHeadView"];
    [_collectionView registerClass:[FactoryHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FacHeadView"];
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

- (void)initHeadView
{
    self.expheadView  = [[ExPloreHeadView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right, 0)];
    self.factoryHeadView = [[FactoryHeadView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right, 0)];
}

- (void)initRefreshView
{
    
    WS(ws);
    
    self.collectionView.refreshHeader.beginRefreshingBlock=^(){
        
        //获取厂家信息
        [NetWorkEntiry getFactroyDetailInfoWithFactroyId:ws.factoryID orFactoryCode:ws.factoryCode Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                ws.model.factoryInfo = [FactoryModel coverDicToModel:[responseObject objectForKey:@"result"]];
                ws.factoryID = ws.model.factoryInfo.factoryId;
                ws.factoryCode = ws.model.factoryInfo.factoryName;
                
                //请求分类列表
                [NetWorkEntiry getAllCategoryTypeWith:ws.factoryID Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                        ws.model.tagsArray = [BaseModelMethod getCatergoryIntoWithInfo:[responseObject objectForKey:@"result"]];
                        
                        //请求推荐商品
                        [NetWorkEntiry getRecomendGoodsListWith:ws.factoryID Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                                ws.model.qualityGoodsList = [BaseModelMethod getGoodsArrayFromDicInfo:[responseObject objectForKey:@"result"]];
                                
                                //请求最新商品
                                [NetWorkEntiry getNewsGoodsListWith:ws.factoryID Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                                        ws.model.newsGoodsList = [BaseModelMethod getGoodsArrayFromDicInfo:[responseObject objectForKey:@"result"]];
                                        
                                        
                                        //请求商品列表
                                        [NetWorkEntiry searchGoodsWithCategoryID:nil goodsState:KGoodsStateInvalid priceSecction:nil keyWorld:nil isSpecial_param:KGoodRecomendInvalid factoryID:ws.factoryID start:0 count:RELOADDATACOUNT Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                                                ws.model.normalList = [[BaseModelMethod getGoodsArrayFromDicInfo:[responseObject objectForKey:@"list"]] mutableCopy];
                                                ws.model.normalListMaxCount = [[responseObject objectForKey:@"total_num"] intValue];
                                                
                                                [ws.expheadView setQgoodsImage:[ws.model getArrayForRecomendArray:ws.model.qualityGoodsList]
                                                                        nArray:[ws.model getArrayForRecomendArray:ws.model.newsGoodsList]
                                                                      TagArray:ws.model.tagsArray];
                                                [ws.factoryHeadView setFactoryMoedl:ws.model.factoryInfo];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [ws.expheadView sizeToFit];
                                                    [ws.factoryHeadView sizeToFit];
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
                
            }else{
                [ws dealErrorResponse:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ws netError];
        }];
    };
    
    self.collectionView.refreshFooter.beginRefreshingBlock =^(){
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            //请求商品列表
            [NetWorkEntiry searchGoodsWithCategoryID:nil goodsState:KGoodsStateInvalid priceSecction:nil keyWorld:nil isSpecial_param:KGoodRecomendInvalid factoryID:ws.factoryID start:ws.model.normalList.count count:LOADMOREDATACOUNT Success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                }else{
                    [ws dealErrorResponse:responseObject];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [ws netError];
            }];
        });
    };
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
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 0;
    }
    return self.model.normalList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.model.normalList.count) {
        return self.factoryHeadView.frame.size;
    }
    if (section == 1 && self.model.normalList.count) {
        return self.expheadView.frame.size;
    }
    return CGSizeZero;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        self.factoryHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FacHeadView" forIndexPath:indexPath];
        [self.factoryHeadView setFactoryMoedl:self.model.factoryInfo];
        self.factoryHeadView.delegate = self;
        [self.factoryHeadView sizeToFit];
        return self.factoryHeadView;
    }
    
    if (indexPath.section == 1) {
        
        self.expheadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EXPHeadView" forIndexPath:indexPath];
        if (self.model) {
            [self.expheadView setQgoodsImage:[self.model getArrayForRecomendArray:self.model.qualityGoodsList]
                                      nArray:[self.model getArrayForRecomendArray:self.model.newsGoodsList]
                                    TagArray:self.model.tagsArray];
            self.expheadView.delegate = self;
            [self.expheadView sizeToFit];
            self.expheadView.frame = CGRectMake(0, self.factoryHeadView.bottom, self.expheadView.width, self.expheadView.height);
        }
        return self.expheadView;
    }
   
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EXPHeadView" forIndexPath:indexPath];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsItemCollectionViewCell * goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GOODITEMCELL" forIndexPath:indexPath];
//    goodsCell.isNeedShowGoodsCounts = YES;
    goodsCell.delegate = self;
    if (self.model.normalList.count > indexPath.row) {
        [goodsCell setGoodsModel:self.model.normalList[indexPath.row]];
    }
    return goodsCell;
}

#pragma mark - Action
- (void)factoryHeadViewDidClickFavButton:(UIButton *)favButton
{
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntiry favfactory:self.model.factoryInfo.factoryId :!favButton.selected Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1000){
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws showTotasViewWithMes:favButton.selected ? @"成功取消关注" : @"关注成功"];
                [favButton setSelected:!favButton.selected];
                self.model.factoryInfo.isFav = favButton.selected;
            });
        }else{
            [ws showTotasViewWithMes:favButton.selected ? @"取消关注失败" : @"关注失败"];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws showTotasViewWithMes:favButton.selected ? @"取消关注失败" : @"关注失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    searchR.factoryID = self.factoryID;
    [self.navigationController pushViewController:searchR animated:YES];
    
}

//商品点击
- (void)goodsItemCollectionViewCellDidClickGoodDetailInfo:(GoodsModel *)goodModel
{
    GoodsDetailController * detailC = [[GoodsDetailController alloc] init];
    detailC.goodsID = goodModel.goodsID;
    [self.navigationController pushViewController:detailC animated:YES];
}

- (void)goodsItemCollectionViewCellDidClickFactoryDetailInfo:(GoodsModel *)goodModel
{
//    return;
//    FactoryViewController * fac = [[FactoryViewController alloc] initWithFactoryId:goodModel.goodsFactoryID];
//    [self.navigationController pushViewController:fac animated:YES];
}

- (void)exPloreHeadViewDidClickTagAtIndex:(NSInteger)index
{
    TagFillterModel * model = [[TagFillterModel alloc] init];
    model.seletedRecomendType = KGoodRecomendInvalid;
    model.categoryTagArray = [self.model.tagsArray copy];
    [model.categorySeletedIndexs addObject:[model.categoryTagArray objectAtIndex:index]];
    SearchResultViewController * searchR = [[SearchResultViewController alloc] init];
    searchR.tagModel = model;
    searchR.factoryID = self.factoryID;
    [self.navigationController pushViewController:searchR animated:YES];
    
}

@end
