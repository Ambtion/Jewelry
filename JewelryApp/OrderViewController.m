//
//  OrderController.m
//  JewelryApp
//
//  Created by kequ on 15/5/10.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "OrderViewController.h"
#import "RefreshTableView.h"
#import "OrderTableViewCell.h"
#import "OrderListModel.h"
#import "RFSegmentView.h"
#import "BaseModelMethod.h"
#import "FactoryViewController.h"
#import "GoodsDetailController.h"
#import "WaitingForDealView.h"
#import "OrderStateSumNumberView.h"
#import "KeyWordSearchViewController.h"


@interface CusAlertView : UIAlertView
@property(nonatomic,strong)NSArray * ordersArray;
@property(nonatomic,strong)NSArray * goodsArray;
@end

@implementation CusAlertView
@end

@interface OrderViewController()<UITableViewDataSource,UITableViewDelegate,RFSegmentViewDelegate,OrderTableViewCellDelegate,OrderStateSumNumberViewDelegate,KeyWordSearchViewControllerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)NSString * keyWorld;

@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)RefreshTableView * waitTableView;
@property(nonatomic,strong)WaitingForDealView * waitHeadView;
@property(nonatomic,strong)OrderListModel * waitModel;

@property(nonatomic,strong)RefreshTableView * progressTableView;
@property(nonatomic,strong)OrderStateSumNumberView * progressHeadView;
@property(nonatomic,strong)OrderListModel * progressModel;

@property(nonatomic,strong)RefreshTableView * finishTableView;
@property(nonatomic,strong)OrderStateSumNumberView * finishHeadView;
@property(nonatomic,strong)OrderListModel * finishModel;

//区别boss和普通订单
@property(nonatomic,assign)BOOL isNormalOrder;
@property(nonatomic,strong)GoodsModel * tempgoodsDeleteModel;
@property(nonatomic,strong)OrderModel * temporderDeleteModel;
@end

@implementation OrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isNeedRefresh = YES;
    self.isNormalOrder = [[UserInfoModel defaultUserInfo] role] != KUserBuyBossEnsture;
    [self initUI];
}

#pragma mark - Life Sycle
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBar];
    if (self.isNeedRefresh){
        [self.waitTableView.refreshHeader beginRefreshing];
        [self.progressTableView.refreshHeader beginRefreshing];
        [self.finishTableView.refreshHeader beginRefreshing];
    }
    self.isNeedRefresh = NO;
}

#pragma mark -
#pragma mark - Delegate
#pragma mark -
#pragma mark   SegDelegate
- (void)segmentViewSelectIndex:(NSInteger)index
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.width, 0) animated:YES];
    [self refreshRightBarButton:index * self.scrollView.width == self.finishTableView.left];
    self.seletedIndex = index;
}

#pragma mark RightBar 关键字筛选

- (void)refreshRightBarButton:(BOOL)isNeedShowRightButton
{
    if (isNeedShowRightButton) {
        UIButton * buttonRight = [self getBarButtonWithTitle:@"搜索"];
        [buttonRight addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
        self.myNavigationItem.rightBarButtonItems = @[[self barSpaingItem],item];
    }else{
        self.myNavigationItem.rightBarButtonItems = nil;
    }

}


- (void)rightBarButtonClick:(UIButton *)button
{
    KeyWordSearchViewController * kSearch = [[KeyWordSearchViewController alloc] init];
    kSearch.inputView.textFiled.placeholder = @"输入订单号查询";
    kSearch.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:kSearch];
    [self.navigationController presentViewController:nav animated:YES completion:^{
    }];
}

- (void)keyWordSearchViewController:(KeyWordSearchViewController *)controller DidSeletedSearchKeyWorld:(NSString *)keyWorld
{
    self.keyWorld = keyWorld;
    [[self finishTableView].refreshHeader beginRefreshing];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)keyWordSearchViewControllerDidClickCancel:(KeyWordSearchViewController *)controller
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];

}

#pragma mark  WaitHeadView Delegate
- (void)seleteAllButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    [self.waitModel setAllSeleted:button.selected];
    [self.waitTableView reloadData];
}

- (void)commitButtonClick:(UIButton *)commitbutton
{
    
    NSArray * goodsArray = [self.waitModel allSeletedGoodsModelArray];
    NSArray * orderArray = [self.waitModel allSeletedOrderModelArray];
    if(!goodsArray.count && [[UserInfoModel defaultUserInfo] role] == KUserBuyInShopping){
        [self showTotasViewWithMes:@"请选择提交货品"];
        return;
    }
    
    if (!orderArray.count && [[UserInfoModel defaultUserInfo] role] != KUserBuyInShopping) {
        [self showTotasViewWithMes:@"请选择提交订单"];
        return;
    }
    
    if ([[UserInfoModel defaultUserInfo] role] == KUserBuyAboutGoods) {
        //判断是否有约货时间和地点
        for (OrderModel * orderModl in orderArray) {
            if (![orderModl hasAboutPriceInfo]) {
                [self showTotasViewWithMes:@"订单货品需议定到货地点"];
                return;
            }
        }
    }
    
    if ([[UserInfoModel defaultUserInfo] role] == KUserSaleEnsureGoods || [[UserInfoModel defaultUserInfo] role] == KUserBuyAboutPrice) {
        //判断提交是否有价格
        for (OrderModel * orderModl in orderArray) {
            if (![orderModl isAllGoodsHasPrice]) {
                [self showTotasViewWithMes:@"订单所有货品需议定价格"];
                return;
            }
        }
    }
    
    CusAlertView * alertView = [[CusAlertView alloc] initWithTitle:nil message:@"确定提交订单" delegate:self cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
  

    alertView.ordersArray = orderArray;
    alertView.goodsArray = goodsArray;
    
    alertView.tag = 200;
    [alertView show];
    
}

#pragma mark finishe | progress HeadView
- (void)orderStateSumNumberViewDidSeletedProgressView:(OrderStateSumNumberView *)view
{
    if (self.finishHeadView == view) {
        [self.finishTableView.refreshHeader beginRefreshing];
    }
    if (self.progressHeadView == view) {
        [self.progressTableView.refreshHeader beginRefreshing];
    }
}
#pragma mark GoodsViewDelegate
- (void)orderGoodsViewTextViewDidBeginEdit:(OrderGoodsView *)goodsView
{
    CGRect goodsViewRect = [self.waitTableView convertRect:goodsView.frame fromView:goodsView.superview];
    [self.waitTableView setContentOffset:CGPointMake(self.waitTableView.contentOffset.x, goodsViewRect.origin.y) animated:YES];
}

- (void)orderGoodsViewDidFavGoods:(GoodsModel *)model button:(UIButton *)button
{
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntiry favGoods:model.goodsID :!button.selected Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1000){
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws showTotasViewWithMes:button.selected ? @"成功取消关注" : @"关注成功"];
                [button setSelected:!button.selected];
                model.isFaved = button.selected;
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

- (void)orderTableViewCellDidClickDeleteButton:(OrderTableViewCell *)cell model:(OrderModel *)orderModel goodModel:(GoodsModel *)goodsModel
{
    self.temporderDeleteModel = orderModel;
    self.tempgoodsDeleteModel = goodsModel;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除货品" delegate:self cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}


#pragma mark DeleteGoods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex && alertView.tag == 100) {
        [self deleteGoods];
    }
    
    if (alertView.tag == 200 && buttonIndex) {
        NSArray * goodsArray = [(CusAlertView *)alertView goodsArray];
        NSArray * orderArray = [(CusAlertView *)alertView ordersArray];
        WS(ws);
        [NetWorkEntiry commmitGoodsOrOrderToNextWithGoodsModels:goodsArray orderID:orderArray Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                [ws.waitTableView.refreshHeader beginRefreshing];
                [ws.finishTableView.refreshHeader beginRefreshing];
                [ws.progressTableView.refreshHeader beginRefreshing];
            }else{
                [ws dealErrorResponseWithTableView:ws.waitTableView info:responseObject];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ws netErrorWithTableView:ws.waitTableView];
        }];

        
    }
}

- (void)deleteGoods
{
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntiry deleteGoodsFromOrderListWithGoodsId:self.tempgoodsDeleteModel.goodsID orderID:self.temporderDeleteModel.orderId Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1000){
            [ws.waitTableView.refreshHeader beginRefreshing];
        }else{
            [ws showTotasViewWithMes:@"删除失败"];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws showTotasViewWithMes:@"删除失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)orderGoodsViewDidClickDetailInfoInView:(GoodsModel *)model
{
    GoodsDetailController * detailC = [[GoodsDetailController alloc] init];
    detailC.goodsID = model.goodsID;
    [self.navigationController pushViewController:detailC animated:YES];
}

- (void)orderTableViewCellDidClickDetailButton:(OrderTableViewCell *)cell model:(OrderModel *)model
{
    //只能打开，不能关闭
    model.isExpladDetail = YES;
    [cell.tableView reloadData];
}

#pragma mark OrderHeadView
- (void)orderHeadViewDidClick:(OrderHeadView *)headView
{
    FactoryViewController * fac = [[FactoryViewController alloc] initWithFactoryId:headView.headViewModel.factoryID facoryCode:headView.headViewModel.factoryCode];
    [self.navigationController pushViewController:fac animated:YES];
}

- (void)orderHeadViewSeletedButtonDidClick:(UIButton *)button
{
    [self.waitTableView reloadData];
}

#pragma mark - init UI
- (void)initNavBar
{
    [self resetNavBar];
    NSArray * itemArray = self.isNormalOrder ? @[@" 待处理 ",@" 已处理 "] : @[@"定货单", @"进行中", @"已完成"];
    RFSegmentView * segController = [[RFSegmentView alloc] initWithFrame:CGRectMake(0, 0, 184, 27.f) items:itemArray];
    segController.delegate = self;
    [segController setSeltedIndex:self.seletedIndex];
    [[self curTableView] reloadData];
    self.myNavigationItem.titleView = segController;
    if(self.tabBarController){
        self.myNavigationItem.leftBarButtonItems = nil;
    }
}

-(void)initUI
{
    
    UIView * view = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    self.scrollView.contentSize = CGSizeMake(self.view.width * 2, self.scrollView.height);
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    
    self.waitTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
    self.waitTableView.tag = KOrderCellTypeWait;
    self.waitTableView.delegate = self;
    self.waitTableView.dataSource = self;
    [self.scrollView addSubview:self.waitTableView];
    
    if (!self.isNormalOrder) {
        self.progressTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
        self.progressTableView.tag = KOrderCellTypeProgress;
        self.progressTableView.delegate = self;
        self.progressTableView.dataSource = self;
        [self.scrollView addSubview:self.progressTableView];
        self.scrollView.contentSize = CGSizeMake(self.view.width * 3, self.scrollView.height);
    }
    
    self.finishTableView = [[RefreshTableView alloc] initWithFrame:
                                 CGRectMake(self.scrollView.width + (!self.isNormalOrder ? self.scrollView.width : 0),
                                            0, self.scrollView.width, self.scrollView.height)
                                                                  style:UITableViewStylePlain];
    self.finishTableView.delegate = self;
    self.finishTableView.tag = KOrderCellTypeFinish;
    self.finishTableView.dataSource = self;
    [self.scrollView addSubview:self.finishTableView];
    
    if (self.tabBarController) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, 48)];
        view.backgroundColor = [UIColor clearColor];
        self.waitTableView.tableFooterView = view;
        self.finishTableView.tableFooterView = view;
        self.progressTableView.tableFooterView = view;
    }

    [self initRefreshView];
    [self initWaitingHeadView];
    [self initOrderStateView];
    
}

- (void)initWaitingHeadView
{
    self.waitHeadView = [[WaitingForDealView alloc] initWithFrame:CGRectMake(0, 0, self.waitHeadView.width, 44)];
    [self.waitHeadView.seletedButton addTarget:self action:@selector(seleteAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.waitHeadView.commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initOrderStateView
{
    
    if ([[UserInfoModel defaultUserInfo] role] != KUserBuyBossEnsture &&
        [[UserInfoModel defaultUserInfo] role] != KUserSaleEnsureGoods){
        return;
    }
    if([[UserInfoModel defaultUserInfo] role] == KUserBuyBossEnsture){
        self.progressHeadView = [[OrderStateSumNumberView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, 85)];
        self.progressHeadView.defaultProgressState = KOrderProgressStateInOrdering;
        self.progressHeadView.delegate = self;
        self.progressHeadView.dataSrouce = [self defoultArrayWithType:self.progressTableView.tag];
    }
    
    if ([[UserInfoModel defaultUserInfo] role] == KUserSaleEnsureGoods || [[UserInfoModel defaultUserInfo] role] == KUserBuyBossEnsture) {
        self.finishHeadView = [[OrderStateSumNumberView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, 85)];
        self.finishHeadView.defaultProgressState = KOrderProgressStateInWaitngPay;
        self.finishHeadView.delegate = self;
        self.finishHeadView.dataSrouce = [self defoultArrayWithType:self.finishTableView.tag];
    }
    
    WS(ws);
    
    [NetWorkEntiry getOrderCountInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        ws.progressHeadView.dataSrouce = [self getArrayWithDicInfo:responseObject WithType:self.progressTableView.tag];
        ws.finishHeadView.dataSrouce = [self getArrayWithDicInfo:responseObject WithType:self.finishTableView.tag];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSArray *)defoultArrayWithType:(KOrderCellType)cellType
{
    NSMutableArray * array  = [NSMutableArray arrayWithCapacity:0];
    KUserRole role = [[UserInfoModel defaultUserInfo] role];
    if (role == KUserBuyBossEnsture) {
        if (cellType  == KOrderCellTypeProgress) {
            for (int i = KOrderProgressStateInOrdering; i <= KOrderProgressStateInOrderEnsutre; i++) {
                //xuanhuo  dingyue yuehuo yijia
                OrderSateNumModel * model = [[OrderSateNumModel alloc] init];
                model.state = i;
                model.stateNumber  = -1;
                [array addObject:model];
            }
        }
        
        if (cellType == KOrderCellTypeFinish) {
            for (int i = KOrderProgressStateInWaitngPay; i <= KOrderProgressStateInCancel; i++) {
                // zhongxuan  finish  delete
                OrderSateNumModel * model = [[OrderSateNumModel alloc] init];
                model.state = i;
                model.stateNumber  = -1;
                [array addObject:model];
            }
        }
    }
    
    if (role == KUserSaleEnsureGoods) {
        for (int i = KOrderProgressStateSaleWaitEnsure; i <= KOrderProgressStateSaleInCancel; i++) {
            OrderSateNumModel * model = [[OrderSateNumModel alloc] init];
            model.state = i;
            model.stateNumber  = -1;
            [array addObject:model];
        }
    }
    
    return array;
}

- (NSArray *)getArrayWithDicInfo:(NSDictionary *)info WithType:(KOrderCellType)cellType
{
    NSMutableArray * array  = [NSMutableArray arrayWithCapacity:0];
    info = [info objectInfoForKey:@"result"];
    
    KUserRole role = [[UserInfoModel defaultUserInfo] role];
    if (role == KUserBuyBossEnsture) {
        if (cellType  == KOrderCellTypeProgress) {
            for (int i = KOrderProgressStateInOrdering; i <= KOrderProgressStateInOrderEnsutre; i++) {
                //xuanhuo  dingyue yuehuo yijia
                OrderSateNumModel * model = [[OrderSateNumModel alloc] init];
                model.state = i;
                model.stateNumber  = [self getCountNubStrWith:i dic:info];
                [array addObject:model];
            }
        }
        
        if (cellType == KOrderCellTypeFinish) {
            for (int i = KOrderProgressStateInWaitngPay; i <= KOrderProgressStateInCancel; i++) {
                // zhongxuan  finish  delete
                OrderSateNumModel * model = [[OrderSateNumModel alloc] init];
                model.state = i;
                model.stateNumber  = [self getCountNubStrWith:i dic:info];
                [array addObject:model];
            }
        }
    }
    
    if (role == KUserSaleEnsureGoods) {
        for (int i = KOrderProgressStateSaleWaitEnsure; i <= KOrderProgressStateSaleInCancel; i++) {
            OrderSateNumModel * model = [[OrderSateNumModel alloc] init];
            model.state = i;
            model.stateNumber  = [self getCountNubStrWith:i dic:info];
            [array addObject:model];
        }
    }
    
    return array;
}

- (NSInteger)getCountNubStrWith:(KOrderProgressState)state dic:(NSDictionary *)info
{
    switch (state) {
        case KOrderProgressStateInvalid:
            return -1;
            break;
        case KOrderProgressStateInOrdering:
            return [[info objectForKey:@"xuanhuo"] integerValue];
        case KOrderProgressStateInAboutGoods:
            return [[info objectForKey:@"dingyue"] integerValue];
        case KOrderProgressStateInAbutPrice:
            return [[info objectForKey:@"yuehuo"] integerValue];
        case KOrderProgressStateInOrderEnsutre:
            return [[info objectForKey:@"yijia"] integerValue];
            
        case KOrderProgressStateInWaitngPay:
            return [[info objectForKey:@"zhongxuan"] integerValue];
        case KOrderProgressStateInDone:
            return [[info objectForKey:@"finish"] integerValue];
        case KOrderProgressStateInCancel:
            return [[info objectForKey:@"delete"] integerValue];
            
        case KOrderProgressStateSaleWaitEnsure:
            return [[info objectForKey:@"daiqueren"] integerValue];
        case KOrderProgressStateSaleInWaitngPay:
            return [[info objectForKey:@"zhongxuan"] integerValue];
        case KOrderProgressStateSaleInDone:
            return [[info objectForKey:@"finish"] integerValue];
        case KOrderProgressStateSaleInCancel:
            return [[info objectForKey:@"delete"] integerValue];
        default:
            break;
    }
    return -1;
}

#pragma mark - Load Data
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
    self.waitTableView.refreshHeader.beginRefreshingBlock = ^(){
        
        [NetWorkEntiry getOrderListWithKeyWorld:ws.keyWorld orderCellType:ws.waitTableView.tag orderState:KOrderProgressStateInvalid PageNumber:0 Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                
                ws.keyWorld = nil;
                
                ws.waitModel = [[OrderListModel alloc] init];
                [ws.waitModel.orderList addObjectsFromArray:[BaseModelMethod getOrderListArrayFormDicInfo:[responseObject objectForKey:@"result"] cellType:ws.waitTableView.tag]];
                ws.waitModel.curPage = [[responseObject objectForKey:@"page_num"] integerValue];
                ws.waitModel.totalOrderCount = [[responseObject objectForKey:@"total_count"] integerValue];
                ws.waitModel.totalPage = [[responseObject objectForKey:@"total_page"] integerValue];
                [ws.waitTableView refreshFooter].scrollView = ws.waitModel.curPage == ws.waitModel.totalPage - 1 ? nil : ws.waitTableView;
                
                if([[UserInfoModel defaultUserInfo] role] == KUserBuyInShopping){
                    [ws.waitTableView refreshFooter].scrollView = nil;
                }
                
                [ws.waitModel setAllSeleted:NO];
                [ws.waitHeadView.seletedButton setSelected:NO];
                [ws.waitHeadView setOrderCount:[ws.waitModel orderList].count GoodsCount:[ws.waitModel allgoodsModelArray].count];
                [ws.waitTableView reloadData];
                
            }else{
                [ws dealErrorResponseWithTableView:ws.waitTableView info:responseObject];
            }
            [[ws.waitTableView refreshHeader] endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[ws.waitTableView refreshHeader] endRefreshing];
        }];
    };
    
    self.waitTableView.refreshFooter.beginRefreshingBlock = ^(){
        [NetWorkEntiry getOrderListWithKeyWorld:ws.keyWorld orderCellType:ws.waitTableView.tag orderState:KOrderProgressStateInvalid PageNumber:ws.waitModel.curPage + 1 Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                
                
                NSArray * resultArray = [responseObject objectArrayForKey:@"result"];
                if (resultArray) {
                    [ws.waitModel.orderList addObjectsFromArray:[BaseModelMethod getOrderListArrayFormDicInfo:resultArray cellType:ws.waitTableView.tag]];
                    ws.waitModel.curPage = [[responseObject objectForKey:@"page_num"] integerValue];
                    ws.waitModel.totalOrderCount = [[responseObject objectForKey:@"total_count"] integerValue];
                    ws.waitModel.totalPage = [[responseObject objectForKey:@"total_page"] integerValue];
                    [ws.waitHeadView setOrderCount:[ws.waitModel orderList].count GoodsCount:[ws.waitModel allgoodsModelArray].count];
                    [ws.waitTableView refreshFooter].scrollView = ws.waitModel.curPage == ws.waitModel.totalPage - 1 ? nil : ws.waitTableView;
                }else{
                    [ws showTotasViewWithMes:@"已经加载所有数据"];
                }
        
                [ws.waitTableView reloadData];
                
            }else{
                [ws dealErrorResponseWithTableView:ws.waitTableView info:responseObject];
            }
            [[ws.waitTableView refreshFooter] endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[ws.waitTableView refreshFooter] endRefreshing];
        }];
    };
    
    self.finishTableView.refreshHeader.beginRefreshingBlock = ^(){
        
        NSInteger proSeletedState = ws.progressHeadView.seletedIndex;
        NSInteger finSeletedState = ws.finishHeadView.seletedIndex;
        
        [NetWorkEntiry getOrderCountInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            ws.progressHeadView.dataSrouce = [ws getArrayWithDicInfo:responseObject WithType:ws.progressTableView.tag];
            [ws.progressHeadView setSeletedIndex:proSeletedState];
            ws.finishHeadView.dataSrouce = [ws getArrayWithDicInfo:responseObject WithType:ws.finishTableView.tag];
            [ws.finishHeadView setSeletedIndex:finSeletedState];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        [NetWorkEntiry getOrderListWithKeyWorld:ws.keyWorld orderCellType:ws.finishTableView.tag orderState:[ws.finishHeadView seletedProgessState] PageNumber:0 Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                
                ws.keyWorld = nil;
                
                ws.finishModel = [[OrderListModel alloc] init];
                [ws.finishModel.orderList addObjectsFromArray:[BaseModelMethod getOrderListArrayFormDicInfo:[responseObject objectForKey:@"result"] cellType:ws.finishTableView.tag]];
                
                ws.finishModel.curPage = [[responseObject objectForKey:@"page_num"] integerValue];
                ws.finishModel.totalOrderCount = [[responseObject objectForKey:@"total_count"] integerValue];
                ws.finishModel.totalPage = [[responseObject objectForKey:@"total_page"] integerValue];
                [ws.finishTableView refreshFooter].scrollView = ws.finishModel.curPage == ws.finishModel.totalPage - 1 ? nil : ws.finishTableView;
                
//                [ws.finishHeadView setProgressNumber:ws.finishModel.totalOrderCount withState:ws.finishHeadView.seletedProgessState];
                [ws.finishModel setAllSeleted:NO];
                
                [ws.finishTableView reloadData];
            }else{
                [ws dealErrorResponseWithTableView:ws.finishTableView info:responseObject];
            }
            [[ws.finishTableView refreshHeader] endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[ws.finishTableView refreshHeader] endRefreshing];
        }];
    };
    
    self.finishTableView.refreshFooter.beginRefreshingBlock = ^(){

        [NetWorkEntiry getOrderListWithKeyWorld:ws.keyWorld orderCellType:ws.finishTableView.tag orderState:[ws.finishHeadView seletedProgessState] PageNumber:ws.finishModel.curPage + 1 Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                NSArray * resultArray = [responseObject objectArrayForKey:@"result"];
                if (resultArray) {
                    [ws.finishModel.orderList addObjectsFromArray:[BaseModelMethod getOrderListArrayFormDicInfo:resultArray cellType:ws.finishTableView.tag]];
                    ws.finishModel.curPage = [[responseObject objectForKey:@"page_num"] integerValue];
                    ws.finishModel.totalOrderCount = [[responseObject objectForKey:@"total_count"] integerValue];
                    ws.finishModel.totalPage = [[responseObject objectForKey:@"total_page"] integerValue];
                    [ws.finishTableView refreshFooter].scrollView = ws.finishModel.curPage == ws.finishModel.totalPage - 1 ? nil : ws.finishTableView;
                    [[[ws.finishTableView refreshFooter] footerView] setHidden:ws.finishModel.curPage == ws.finishModel.totalPage - 1];
                    
                    [ws.finishTableView reloadData];
                }else{
                    [ws.finishTableView refreshFooter].scrollView = nil;
                    [[[ws.finishTableView refreshFooter] footerView] setHidden:YES];
                    [ws showTotasViewWithMes:@"已经加载所有数据"];
                }
            }else{
                [ws dealErrorResponseWithTableView:ws.finishTableView info:responseObject];
            }
            [[ws.finishTableView refreshFooter] endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[ws.finishTableView refreshFooter] endRefreshing];
        }];

    };
    
    self.progressTableView.refreshHeader.beginRefreshingBlock = ^(){
        
        NSInteger proSeletedState = ws.progressHeadView.seletedIndex;
        NSInteger finSeletedState = ws.finishHeadView.seletedIndex;
        
        [NetWorkEntiry getOrderCountInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            ws.progressHeadView.dataSrouce = [ws getArrayWithDicInfo:responseObject WithType:ws.progressTableView.tag];
            [ws.progressHeadView setSeletedIndex:proSeletedState];
            ws.finishHeadView.dataSrouce = [ws getArrayWithDicInfo:responseObject WithType:ws.finishTableView.tag];
            [ws.finishHeadView setSeletedIndex:finSeletedState];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        [NetWorkEntiry getOrderListWithKeyWorld:ws.keyWorld orderCellType:ws.progressTableView.tag orderState:[ws.progressHeadView seletedProgessState] PageNumber:0 Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                
                ws.keyWorld = nil;
                
                ws.progressModel = [[OrderListModel alloc] init];
                [ws.progressModel.orderList addObjectsFromArray:[BaseModelMethod getOrderListArrayFormDicInfo:[responseObject objectForKey:@"result"] cellType:ws.progressTableView.tag]];
                
                ws.progressModel.curPage = [[responseObject objectForKey:@"page_num"] integerValue];
                ws.progressModel.totalOrderCount = [[responseObject objectForKey:@"total_count"] integerValue];
                ws.progressModel.totalPage = [[responseObject objectForKey:@"total_page"] integerValue];
                [ws.progressTableView refreshFooter].scrollView = ws.progressModel.curPage == ws.progressModel.totalPage - 1 ? nil : ws.progressTableView;

                
//                [ws.progressHeadView setProgressNumber:ws.progressModel.totalOrderCount withState:ws.progressHeadView.seletedProgessState];
                
                [ws.progressTableView reloadData];
            }else{
                [ws dealErrorResponseWithTableView:ws.progressTableView info:responseObject];
            }
            [[ws.progressTableView refreshHeader] endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[ws.progressTableView refreshHeader] endRefreshing];
        }];

    };
    
    self.progressTableView.refreshFooter.beginRefreshingBlock = ^(){
        
        [NetWorkEntiry getOrderListWithKeyWorld:ws.keyWorld orderCellType:ws.progressTableView.tag orderState:[ws.progressHeadView seletedProgessState] PageNumber:ws.progressModel.curPage + 1 Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                NSArray * resultArray = [responseObject objectArrayForKey:@"result"];
                if (resultArray) {
                    [ws.progressModel.orderList addObjectsFromArray:[BaseModelMethod getOrderListArrayFormDicInfo:resultArray cellType:ws.progressTableView.tag]];
                    ws.progressModel.curPage = [[responseObject objectForKey:@"page_num"] integerValue];
                    ws.progressModel.totalOrderCount = [[responseObject objectForKey:@"total_count"] integerValue];
                    ws.progressModel.totalPage = [[responseObject objectForKey:@"total_page"] integerValue];
                    [ws.progressTableView refreshFooter].scrollView = ws.progressModel.curPage == ws.progressModel.totalPage  - 1? nil : ws.progressTableView;
                    
                    [ws.progressTableView reloadData];
                }else{
                    [ws showTotasViewWithMes:@"已经加载所有数据"];
                }
            }else{
                [ws dealErrorResponseWithTableView:ws.progressTableView info:responseObject];
            }
            [[ws.progressTableView refreshFooter] endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[ws.progressTableView refreshFooter] endRefreshing];
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
    OrderListModel * orderListModel = [self orderLisModelWithTableView:tableView];
    return orderListModel.orderList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.waitTableView && self.waitModel.orderList.count && section == 0) {
        return self.waitHeadView.height;
    }
    if(tableView == self.progressTableView && section == 0){
        return self.progressHeadView.height;
    }
    if (tableView == self.finishTableView && section == 0) {
        return self.finishHeadView.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.waitTableView && self.waitModel.orderList.count && section == 0) {
        return self.waitHeadView;
    }
    if(tableView == self.progressTableView && section == 0){
        return self.progressHeadView;
    }
    if (tableView == self.finishTableView && section == 0) {
        return self.finishHeadView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListModel * orderListModel = [self orderLisModelWithTableView:tableView];
    OrderModel * model = nil;
    if (orderListModel && orderListModel.orderList.count > indexPath.row) {
        model = orderListModel.orderList[indexPath.row];
    }
    return [OrderTableViewCell cellHeightWithModel:model withCellType:tableView.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strIdentiry = [NSString stringWithFormat:@"CELL_%p",tableView];
    
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strIdentiry];
    if (!cell) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentiry];
        cell.tableView = tableView;
        cell.delegate = self;
    }
    OrderListModel * orderListModel = [self orderLisModelWithTableView:tableView];
    if (orderListModel && orderListModel.orderList.count > indexPath.row) {
        OrderModel * model = orderListModel.orderList[indexPath.row];
        [cell setOrderModel:model cellType:tableView.tag];
    }
    [cell setIsLastView:indexPath.row == orderListModel.orderList.count - 1];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tracking)
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(OrderListModel *)orderLisModelWithTableView:(UITableView *)tableView
{
    if(self.waitTableView == tableView){
        return self.waitModel;
    }else if(self.progressTableView == tableView){
        return [self progressModel];
    }else{
        return [self finishModel];
    }
    return nil;
}

- (RefreshTableView *)curTableView
{
    if (self.seletedIndex == self.waitTableView.tag  - 1) {
        return self.waitTableView;
    }
    if (self.seletedIndex == self.progressTableView.tag  - 1) {
        return self.progressTableView;
    }
    if (self.seletedIndex == self.finishTableView.tag  - 1) {
        return self.finishTableView;
    }
    return self.waitTableView;
}


#pragma mark - 关键字筛选


@end
