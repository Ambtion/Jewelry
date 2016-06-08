//
//  UploadedGoodsListController.m
//  JewelryApp
//
//  Created by kequ on 15/5/7.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "UploadedGoodsListController.h"
#import "RefreshTableView.h"
#import "FactoryModel.h"
#import "UploadGoodsCell.h"
#import "UploadGoodsController.h"
#import "UpLoadFactoryHead.h"
#import "BaseModelMethod.h"
#import "TagFillterModel.h"
#import "TagSearchViewController.h"
#import "SearchResultViewController.h"
#import "GoodsModel+UploadorModify.h"
#import "GoodsDetailController.h"
#import "BMJWNagationController.h"

@interface UploadedGoodsListController ()<UITableViewDelegate,UITableViewDataSource,
                                        UploadGoodsCellDelegate,UIAlertViewDelegate,TagSearchViewControllerDelegate,UploadGoodsControllerDeleteate,UINavigationControllerDelegate>

@property(nonatomic,strong)RefreshTableView * tableView;
@property(nonatomic,strong)FactoryModel * factoryInfo;
@property(nonatomic,strong)UpLoadFactoryHead * factoryHeadView;
@property(nonatomic,strong)NSMutableArray * normalList;
@property(nonatomic,assign)NSInteger normalListMaxCount;
@property(nonatomic,strong)TagFillterModel * tagFillModel;
@property(nonatomic,assign)BOOL needRefresh;
@end

@implementation UploadedGoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.normalList = [NSMutableArray arrayWithCapacity:0];
    self.normalListMaxCount = 0;
    self.needRefresh = YES;
    self.factoryID = [[UserInfoModel defaultUserInfo] factoryID];
    [self initContentView];
    [self initHeadView];
    [self initRefreshView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBar];
    if (self.needRefresh) {
        [self.tableView.refreshHeader beginRefreshing];
    }
    self.needRefresh = NO;
}

- (void)initNavBar
{
    [self resetNavBar];
    self.myNavigationItem.title = @"厂方";
    UIButton * buttonLeft = [self getBarButtonWithTitle:@"上传"];;
    [buttonLeft addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * litem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.myNavigationItem.leftBarButtonItems = @[[self barSpaingItem],litem];
    
    UIButton * buttonRight = [self getBarButtonWithTitle:@"筛选"];
    [buttonRight addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.myNavigationItem.rightBarButtonItems = @[[self barSpaingItem],item];
}

- (void)initContentView
{
    UIView * view = [[UIView alloc] init];
    [self.view addSubview:view];
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    if (self.tabBarController) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 48)];
        view.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = view;
    }
}

- (void)initHeadView
{
    self.factoryHeadView = [[UpLoadFactoryHead alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
}

- (void)dealErrorResponse:(NSDictionary *)dic
{
    [self showTotasViewWithMes:[dic objectForKey:@"result"]];
    [self.tableView.refreshHeader endRefreshing];
    [self.tableView.refreshFooter endRefreshing];
}

- (void)netError
{
    [self showTotasViewWithMes:@"服务异常"];
    [self.tableView.refreshHeader endRefreshing];
    [self.tableView.refreshFooter endRefreshing];
}

- (void)initRefreshView
{
    
    WS(ws);
    
    //请求所有的类比
    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
        [NetWorkEntiry getAllCategoryTypeWith:ws.factoryID Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                
                ws.tagFillModel = [[TagFillterModel alloc] init];
                ws.tagFillModel.tagType = KTagSearchTypeUploadGoods;
                ws.tagFillModel.seletedRecomendType = KGoodRecomendInvalid;
                ws.tagFillModel.categoryTagArray = [BaseModelMethod getCatergoryIntoWithInfo:[responseObject objectForKey:@"result"]];
                
                //获取厂家信息
                [NetWorkEntiry getFactroyDetailInfoWithFactroyId:ws.factoryID orFactoryCode:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                        ws.factoryInfo = [FactoryModel coverDicToModel:[responseObject objectForKey:@"result"]];
                        
                        //请求商品列表
                        [NetWorkEntiry searchGoodsWithCategoryID:nil goodsState:KGoodsStateInvalid priceSecction:nil keyWorld:nil isSpecial_param:KGoodRecomendInvalid factoryID:ws.factoryID start:0 count:RELOADDATACOUNT Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
                                ws.normalList = [[BaseModelMethod getGoodsArrayFromDicInfo:[responseObject objectForKey:@"list"]] mutableCopy];
                                ws.normalListMaxCount = [[responseObject objectForKey:@"total_num"] intValue];
                                [ws.factoryHeadView setFactoryMoedl:ws.factoryInfo];
                                [ws.factoryHeadView sizeToFit];
                                [ws.tableView.refreshHeader endRefreshing];
                                [ws.tableView reloadData];
                             
                                
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
    
    self.tableView.refreshFooter.beginRefreshingBlock = ^(){
        if ([ws.myNavController topViewController] != ws.tabBarController) {
            [ws.tableView.refreshFooter endRefreshing];
            return ;
        }
        //请求商品列表
        [NetWorkEntiry searchGoodsWithCategoryID:nil goodsState:KGoodsStateInvalid priceSecction:nil keyWorld:nil isSpecial_param:KGoodRecomendInvalid factoryID:ws.factoryID start:ws.normalList.count count:LOADMOREDATACOUNT Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                NSArray * norList = [responseObject objectForKey:@"list"];
                if (norList.count) {
                    [ws.normalList addObjectsFromArray:[BaseModelMethod getGoodsArrayFromDicInfo:norList]];
                }else{
                    [ws showTotasViewWithMes:@"已经加载所有数据"];
                }
                [ws.tableView reloadData];
                [ws.tableView.refreshFooter endRefreshing];
            }else{
                [ws dealErrorResponse:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ws netError];
        }];
    };
}

#pragma mark - DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return self.normalList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.factoryHeadView.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.factoryHeadView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.normalList.count > indexPath.row) {
       GoodsModel * model =  self.normalList[indexPath.row];
        return [UploadGoodsCell hegiWithModel:model];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return [UITableViewCell new];
//    }
    UploadGoodsCell * upCell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!upCell) {
        upCell = [[UploadGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        upCell.delegate = self;
    }
    if (self.normalList.count > indexPath.row) {
        [upCell setModel:self.normalList[indexPath.row]];
    }
    
    return upCell;
}
    
#pragma mark - Action
- (void)rightBarButtonClick:(UIButton *)button
{
    TagSearchViewController * tagSeracch = [[TagSearchViewController alloc] init];
    [tagSeracch setModel:self.tagFillModel];
    self.tagFillModel.factoryID = self.factoryID;
    tagSeracch.delegate = self;
    [self.navigationController pushViewController:tagSeracch animated:YES];
}

- (void)tagSearchViewControllerDidClickCancel:(TagSearchViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tagSearchViewController:(TagSearchViewController *)controller DidSeleted:(TagFillterModel *)model
{
    self.tagFillModel = model;
    self.tagFillModel.factoryID = self.factoryID;
    [self.navigationController popViewControllerAnimated:NO];
    SearchResultViewController * searchR = [[SearchResultViewController alloc] initWithSwich:YES];
    searchR.tagModel = self.tagFillModel;
    [self.navigationController pushViewController:searchR animated:YES];
}

- (void)leftButtonClick:(UIButton *)button
{
    UploadGoodsController * upController = [[UploadGoodsController alloc] initWithModel:nil];
    upController.delegate = self;
    [self.navigationController pushViewController:upController animated:YES];
}

- (void)uploadGoodsCell:(UploadGoodsCell *)cell DidDeleteClick:(GoodsModel *)model
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除货品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = [self.tableView indexPathForCell:cell].row;
    [alertView show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailController * detailC = [[GoodsDetailController alloc] init];
    GoodsModel * goodModel = self.normalList[indexPath.row];
    detailC.goodsID = goodModel.goodsID;
    [self.navigationController pushViewController:detailC animated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        if (self.normalList.count > alertView.tag) {
            WS(ws);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            GoodsModel * goodModel = [self.normalList objectAtIndex:alertView.tag];
            [NetWorkEntiry deleteuploadedGoodsWithGoodsID:goodModel.goodsID success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
                if(code == 1000){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ws showTotasViewWithMes:@"成功删除"];
//                        [ws.normalList removeObject:goodModel];
//                        [ws.tableView reloadData];
                        [ws.tableView.refreshHeader beginRefreshing];
                    });
                }else{
                    [ws showTotasViewWithMes:@"操作失败"];
                }
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [ws showTotasViewWithMes:@"操作失败"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            }];
        }
    }
}

- (void)uploadGoodsCell:(UploadGoodsCell *)cell DidMofityClick:(GoodsModel *)model
{
    UploadGoodsController * upC = [[UploadGoodsController alloc] initWithModel:model];
    upC.delegate = self;
    [self.navigationController pushViewController:upC animated:YES];
}

- (void)uploadGoodsControllerDidMofifySucess:(UploadGoodsController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView.refreshHeader beginRefreshing];
}

@end
