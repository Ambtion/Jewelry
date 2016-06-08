//
//  FeedListController.m
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "FeedListController.h"
#import "FeedsModel.h"
#import "RefreshTableView.h"
#import "GoodsFeedViewCell.h"
#import "FacrotyFeedViewCell.h"
#import "GoodsDetailController.h"
#import "FactoryViewController.h"
#import "RFSegmentView.h"
@interface FeedListController ()<UITableViewDataSource,UITableViewDelegate,FacrotyFeedViewCellDelegate,GoodsFeedViewCellDelegate,RFSegmentViewDelegate>

@property(nonatomic,strong)UISegmentedControl * segController;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)RefreshTableView * goodsTableView;
@property(nonatomic,strong)RefreshTableView * factoryTableView;
@property(nonatomic,strong)FeedsModel * goodsFeedsModel;
@property(nonatomic,strong)FeedsModel * factoryFeedsModel;
@end

@implementation FeedListController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isNeedRefresh = YES;
    [self initUI];
}


#pragma mark Life Sycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.isNeedRefresh){
        [self.goodsTableView.refreshHeader beginRefreshing];
        [self.factoryTableView.refreshHeader beginRefreshing];
    }
    self.isNeedRefresh = NO;
}

#pragma mark - initUI

- (void)initNavBar
{
    [self resetNavBar];
    RFSegmentView * segController = [[RFSegmentView alloc] initWithFrame:CGRectMake(0, 0, 184, 27.f) items:@[@"货品",@"厂方"]];
    segController.delegate = self;
    [segController setSeltedIndex:self.scrollView.contentOffset.x / self.scrollView.width];
    self.myNavigationItem.titleView = segController;
}

-(void)initUI
{
    UIView * view = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    self.scrollView.contentSize = CGSizeMake(self.view.width * 2, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    self.goodsTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
    self.goodsTableView.delegate = self;
    self.goodsTableView.dataSource = self;
    [self.scrollView addSubview:self.goodsTableView];
    
    self.factoryTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
    self.factoryTableView.delegate = self;
    self.factoryTableView.dataSource = self;
    [self.scrollView addSubview:self.factoryTableView];
    [self initRefreshView];
    
    if (self.tabBarController) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.goodsTableView.width, 48)];
        view.backgroundColor = [UIColor clearColor];
        self.goodsTableView.tableFooterView = view;
        self.factoryTableView.tableFooterView = view;
    }
}


#pragma mark Load Data
- (void)dealErrorResponseWithTableView:(RefreshTableView *)tableview info:(NSDictionary *)dic
{
    [self showTotasViewWithMes:[dic objectForKey:@"result"]];
    [tableview.refreshHeader endRefreshing];
    [tableview.refreshFooter endRefreshing];
}

- (void)netErrorWithTableView:(RefreshTableView*)tableView
{
    [self showTotasViewWithMes:@"网络异常，稍后重试"];
    [tableView.refreshHeader endRefreshing];
    [tableView.refreshFooter endRefreshing];

}

- (void)initRefreshView
{
    WS(ws);
    self.goodsTableView.refreshHeader.beginRefreshingBlock = ^(){
        [NetWorkEntiry getgoodsFeedListStart:0 count:RELOADDATACOUNT Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                ws.goodsFeedsModel = [[FeedsModel alloc] init];
                ws.goodsFeedsModel.feedsList = [[BaseModelMethod getGoodsArrayFromDicInfo:[responseObject objectForKey:@"list"]] mutableCopy];
                ws.goodsFeedsModel.maxFeedCount = [[responseObject objectForKey:@"total_num"] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ws.goodsTableView.refreshHeader endRefreshing];
                    [ws.goodsTableView reloadData];
                });
            }else{
                [ws dealErrorResponseWithTableView:ws.goodsTableView info:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ws netErrorWithTableView:ws.goodsTableView];
        }];
        
    };
    
    self.goodsTableView.refreshFooter.beginRefreshingBlock = ^(){
        [NetWorkEntiry getgoodsFeedListStart:ws.goodsFeedsModel.feedsList.count count:LOADMOREDATACOUNT Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                NSArray * listArray = [BaseModelMethod getFactoryArrayFromDicInfo:[responseObject objectForKey:@"list"]];
                if (listArray.count) {
                    [ws.goodsFeedsModel.feedsList addObjectsFromArray:listArray];
                    [ws.goodsTableView reloadData];
                }else{
                    [ws showTotasViewWithMes:@"已经加载所有数据"];
                }
                [ws.goodsTableView.refreshFooter endRefreshing];
            }else{
                [ws dealErrorResponseWithTableView:ws.goodsTableView info:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ws netErrorWithTableView:ws.goodsTableView];
        }];
    };
    
    self.factoryTableView.refreshHeader.beginRefreshingBlock = ^(){
        [NetWorkEntiry getFactroyFeedListStart:0 count:RELOADDATACOUNT Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                
                ws.factoryFeedsModel = [[FeedsModel alloc] init];
                ws.factoryFeedsModel.feedsList = [[BaseModelMethod getFactoryArrayFromDicInfo:[responseObject objectForKey:@"list"]] mutableCopy];
                ws.factoryFeedsModel.maxFeedCount = [[responseObject objectForKey:@"total_num"] integerValue];
                [ws.factoryTableView.refreshHeader endRefreshing];
                [ws.factoryTableView reloadData];
            }else{
                [ws dealErrorResponseWithTableView:ws.factoryTableView info:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ws netErrorWithTableView:ws.factoryTableView];
        }];
    };
    
    self.factoryTableView.refreshFooter.beginRefreshingBlock = ^(){
        
        [NetWorkEntiry getFactroyFeedListStart:ws.goodsFeedsModel.feedsList.count count:LOADMOREDATACOUNT Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                NSArray * listArray = [BaseModelMethod getFactoryArrayFromDicInfo:[responseObject objectForKey:@"list"]];
                if (listArray.count) {
                    [ws.factoryFeedsModel.feedsList addObjectsFromArray:listArray];
                    [ws.factoryTableView reloadData];
                }else{
                    [ws showTotasViewWithMes:@"已经加载所有数据"];
                }
                [ws.factoryTableView.refreshFooter endRefreshing];
            }else{
                [ws netErrorWithTableView:ws.factoryTableView];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ws netErrorWithTableView:ws.goodsTableView];
        }];
    };
}


#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.goodsTableView) {
        return self.goodsFeedsModel.feedsList.count;
    }else{
        return self.factoryFeedsModel.feedsList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.goodsTableView) {
        return [GoodsFeedViewCell cellHeight];
    }else{
        return [FacrotyFeedViewCell cellHeight];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.factoryTableView) {
        FacrotyFeedViewCell * faCell = [tableView dequeueReusableCellWithIdentifier:@"FCELL"];
        if (!faCell) {
            faCell = [[FacrotyFeedViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FCELL"];
            faCell.delegate  = self;
        }
        if (indexPath.row < self.factoryFeedsModel.feedsList.count)
            [faCell setModel:self.factoryFeedsModel.feedsList[indexPath.row]];
        return faCell;
    }else{
        GoodsFeedViewCell * gCell = [tableView dequeueReusableCellWithIdentifier:@"GCELL"];
        if (!gCell) {
            gCell = [[GoodsFeedViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GCELL"];
            gCell.delegate = self;
        }
        if (indexPath.row < self.goodsFeedsModel.feedsList.count)
            [gCell setModel:self.goodsFeedsModel.feedsList[indexPath.row]];

        return gCell;
    }
    return [UITableViewCell new];
}

#pragma mark - Action
- (void)segmentViewSelectIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.width, self.scrollView.contentOffset.y) animated:YES];
}

- (void)goodsFeedViewCell:(GoodsFeedViewCell *)cell DidClickFavedButton:(UIButton *)button
{
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntiry favGoods:cell.model.goodsID :!button.selected Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1000){
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws showTotasViewWithMes:button.selected ? @"成功取消关注" : @"关注成功"];
//                [button setSelected:!button.selected];
//                cell.model.isFaved = button.selected;
                [ws.goodsTableView.refreshHeader beginRefreshing];
            });
        }else{
            [ws showTotasViewWithMes:button.selected ? @"取消关注失败" : @"关注失败"];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws showTotasViewWithMes:button.selected ? @"取消关注失败" : @"关注失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}

- (void)goodsFeedViewCell:(GoodsFeedViewCell *)cell DidClickAddIntoOrder:(UIButton *)button
{
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntiry addGoodsInShopingWithGoodsId:cell.model.goodsID facyory_Code:cell.model.goddsFactoryCode Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1000 ){
            [ws showTotasViewWithMes: @"添加成功"];

        }else if(code == 2001){
           [ws showTotasViewWithMes: @"已在订单"];
        }else{
             [ws showTotasViewWithMes:[responseObject objectForKey:@"result"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws showTotasViewWithMes:@"操作失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)factoryFeedViewCell:(FacrotyFeedViewCell *)cell didClickFavButton:(UIButton *)button
{
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntiry favfactory:cell.model.factoryId :!button.selected Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1000){
            [ws showTotasViewWithMes:button.selected ? @"成功取消关注" : @"关注成功"];
            [ws.factoryTableView.refreshHeader beginRefreshing];
        }else{
            [ws showTotasViewWithMes:@"操作失败"];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws showTotasViewWithMes:@"操作失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.factoryTableView) {
        FactoryModel * model = [[[self factoryFeedsModel] feedsList] objectAtIndex:indexPath.row];
        FactoryViewController * fac = [[FactoryViewController alloc] initWithFactoryId:model.factoryId facoryCode:model.factoryName];
        [self.navigationController pushViewController:fac animated:YES];
    }else{
        GoodsModel * model = [[[self goodsFeedsModel] feedsList] objectAtIndex:indexPath.row];
        GoodsDetailController * detailC = [[GoodsDetailController alloc] init];
        detailC.goodsID = model.goodsID;
        [self.navigationController pushViewController:detailC animated:YES];
    }
}
@end
