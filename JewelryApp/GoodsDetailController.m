//
//  GoodsDetailController.m
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "GoodsDetailController.h"
#import "GoodsModel.h"
#import "PortraitView.h"
#import "FactoryViewController.h"
#import "OrderViewController.h"
#import "TabBarButton.h"

@interface GoodsDetailHeadView : UIView
@property(nonatomic,strong)PortraitView * iconView;
@property(nonatomic,strong)UILabel * desLaebl;
@property(nonatomic,strong)UIView * lineView;
@end

@implementation GoodsDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.iconView = [[PortraitView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    [self addSubview:self.iconView];
    
    self.desLaebl = [[UILabel alloc] init];
    self.desLaebl.textAlignment = NSTextAlignmentLeft;
    self.desLaebl.font = [UIFont systemFontOfSize:12.f];
    self.desLaebl.backgroundColor = [UIColor clearColor];
    self.desLaebl.numberOfLines = 0;
    self.desLaebl.textColor = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1];
    self.desLaebl.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.desLaebl];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithRed:0xe5/255.f green:0xe5/255.f blue:0xe5/255.f alpha:1];
//    [self addSubview:self.lineView];
    
}

- (void)autoSizeHeadViewByModel:(GoodsModel *)model block:(void (^)())callBack
{
    
    UIImage * defaultImage = [UIImage imageNamed:@"temp"];
    self.iconView.height = (defaultImage.size.height/defaultImage.size.width) * self.iconView.width;
    self.desLaebl.text = model.goodsDes;
    CGSize size =  [self.desLaebl sizeThatFits:CGSizeMake(self.width, 100000)];
    self.desLaebl.frame = CGRectMake(10, self.iconView.bottom + 20, self.width - 20, size.height);
    self.frame = CGRectMake(0, 0, self.width, self.desLaebl.bottom + 20);
    if (callBack) {
        callBack();
    }
    [self.iconView.imageView sd_setImageWithURL:[NSURL URLWithString:[model.goodsImageArry firstObject]] placeholderImage:defaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image){
            self.iconView.height = (image.size.height/image.size.width) * self.iconView.width;
            self.desLaebl.text = model.goodsDes;
            CGSize size =  [self.desLaebl sizeThatFits:CGSizeMake(self.width, 100000)];
            self.desLaebl.frame = CGRectMake(10, self.iconView.bottom + 20, self.width - 20, size.height);
            self.frame = CGRectMake(0, 0, self.width, self.desLaebl.bottom + 20);
            if (callBack) {
                callBack();
            }
        }
    }];
    //    self.lineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

@end

@interface GoodsDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)GoodsDetailHeadView * headView;
@property(nonatomic,strong)UIButton * rightbutton;
//Data
@property(nonatomic,strong)GoodsModel * goodsModel;
@property(nonatomic,strong)NSArray * goodPropertyArray;
@end

@implementation GoodsDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavBar];
    [self initTableView];
    [self initTabBar];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBar];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    WS(ws);
    [NetWorkEntiry getGoodsDetailInfo:self.goodsID Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1000) {
            ws.goodsModel = [GoodsModel coverDicToGoodsModel:[responseObject objectForKey:@"result"]];
            [ws refreshRightState];
            [ws.tableView reloadData];
        }else{
            [ws showTotasViewWithMes:@"网络请求失败"];
            [ws.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws showTotasViewWithMes:@"网络请求失败"];
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)initNavBar
{
    [self resetNavBar];
    self.myNavigationItem.title = @"货品详情";
    if ([[UserInfoModel defaultUserInfo] role] != KUserSaleEnsureGoods &&
        [[UserInfoModel defaultUserInfo]role] != KUserSaleUploadGoods) {
        self.rightbutton = [self getBarButtonWithTitle:@"厂方"];
        [self.rightbutton addTarget:self action:@selector(rightButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.rightbutton];
        self.myNavigationItem.rightBarButtonItems = @[[self barSpaingItem],item];
    }
    [self refreshRightState];
}

- (void)refreshRightState
{
    if (self.goodsModel.goodsFactoryID) {
        [self.rightbutton setAlpha:1];
        [self.rightbutton setUserInteractionEnabled:YES];
    }else{
        [self.rightbutton setAlpha:0.6];
        [self.rightbutton setUserInteractionEnabled:NO];
    }
}

- (void)initTabBar
{
    if ([[UserInfoModel defaultUserInfo] role] == KUserSaleUploadGoods || [[UserInfoModel defaultUserInfo] role] == KUserSaleEnsureGoods) {
        return;
    }

    //添加订单入口
    //查询订单入口
    self.tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 48, self.view.width, 48)];
    self.tabBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIButton * inorderButton = [[UIButton alloc] initWithFrame:CGRectMake(self.tabBarView.width - 140.f, 0, 140.f, self.tabBarView.height)];
    inorderButton.backgroundColor = [UIColor colorWithRed:0x35/255.f green:0xb3/255.f blue:0x64/255.f alpha:1];
    inorderButton.tag = 102;
    [inorderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inorderButton setTitle:@"加入订单" forState:UIControlStateNormal];
    inorderButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [inorderButton addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarView addSubview:inorderButton];
    
    
    CGFloat width = (self.tabBarView.width - inorderButton.width)/2.f;
    TabBarButton * favButton = [[TabBarButton alloc] initWithFrame:CGRectMake(0, 0, width, self.tabBarView.height)];
    favButton.tag = 100;
    [favButton setImage:[UIImage imageNamed:@"like_1"] forState:UIControlStateNormal];
    [favButton setImage:[UIImage imageNamed:@"like_2"] forState:UIControlStateSelected];
    [favButton addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [favButton setTitle:@"关注" forState:UIControlStateNormal];
    [favButton setTitle:@"取消关注" forState:UIControlStateSelected];
    [self.tabBarView addSubview:favButton];
    
    
    TabBarButton * lorderButton = [[TabBarButton alloc] initWithFrame:CGRectMake(width, 0, width, self.tabBarView.height)];
    lorderButton.tag = 101;
    [lorderButton addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [lorderButton setImage:[UIImage imageNamed:@"look_1"] forState:UIControlStateNormal];
    [lorderButton setImage:[UIImage imageNamed:@"look_2"] forState:UIControlStateHighlighted];
    [lorderButton setTitle:@"查看订单" forState:UIControlStateNormal];
    [self.tabBarView addSubview:lorderButton];
    if([[UserInfoModel defaultUserInfo] role] == KUserBuyInShopping || [[UserInfoModel defaultUserInfo] role]  == KUserBuyInShoppingEnsure){
        
    }else{
        [inorderButton setUserInteractionEnabled:NO];
        [inorderButton setAlpha:0.6];
    }
    
    [self.view addSubview:self.tabBarView];
}


-(void)initTableView
{
    UIView * view = [UIView new];
    [self.view addSubview:view];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (GoodsDetailHeadView *)headView
{
    if (!_headView) {
        _headView = [[GoodsDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _headView;
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
    return self.goodPropertyArray.count ? self.goodPropertyArray.count + 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.headView.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.headView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.goodPropertyArray.count) {
        return 48.f;
    }
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [UITableViewCell new];
    }
    
    UITableViewCell * tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableViewCell.clipsToBounds = YES;
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableViewCell.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:0xe5/255.f green:0xe5/255.f blue:0xe5/255.f alpha:1];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [tableViewCell addSubview:lineView];
        UILabel * keyLabel = [self getoneTitleLabel];
        keyLabel.tag = 1000;
        [tableViewCell addSubview:keyLabel];
        UILabel * valueLabel = [self getOnesubLabel];
        valueLabel.tag = 1001;
        [tableViewCell addSubview:valueLabel];
    }
  
    UILabel * keyLabel =(UILabel *)[tableViewCell viewWithTag:1000];
    UILabel * valueLabel =(UILabel *)[tableViewCell viewWithTag:1001];
    
    if (self.goodPropertyArray.count > indexPath.row) {
        NSDictionary * property = [self.goodPropertyArray objectAtIndex:indexPath.row];
        if (property.allKeys.count) {
            NSString * key = [[property allKeys] firstObject];
            NSString * value = [property objectForKey:key];
            keyLabel.text = [NSString stringWithFormat:@"%@",key];
            valueLabel.text = [NSString stringWithFormat:@"%@",value];
        }else{
            keyLabel.text = nil;
            valueLabel.text = nil;
        }
    }else{
        keyLabel.text = nil;
        valueLabel.text = nil;
    }
    return tableViewCell;
}

- (UILabel *)getoneTitleLabel
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0x99/255.f green:0x99/255.f blue:0x99/255.f alpha:1];
    return label;
}

- (UILabel *)getOnesubLabel
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(77, 0, 240, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0x66/255.f green:0x66/255.f blue:0x66/255.f alpha:1];
    return label;
}

#pragma mark - 
- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    if (_goodsModel == goodsModel) {
        return;
    }
    _goodsModel = goodsModel;
    self.goodPropertyArray = [goodsModel getPeropertys];
    [self.headView autoSizeHeadViewByModel:_goodsModel block:^{
        [self.tableView reloadData];
    }];
    UIButton * fabButton  = (UIButton *)[self.tabBarView viewWithTag:100];
    if (fabButton) {
        [fabButton setSelected:_goodsModel.isFaved];
    }
    [self.tableView reloadData];
}


#pragma mark Ation


- (void)rightButtonCLick:(id)sender
{
    FactoryViewController * fac = [[FactoryViewController alloc] initWithFactoryId:self.goodsModel.goodsFactoryID facoryCode:self.goodsModel.goddsFactoryCode];
    [self.navigationController pushViewController:fac animated:YES];
}

- (void)tabbarButtonClick:(UIButton *)butotn
{
    switch (butotn.tag) {
        case 100:
            
            [self favDidCClick:butotn];
            break;
            
        case 101:
            [self lookAtOrder];
            break;
            
        case 102:
            [self putIntoOrder];
            break;
        default:
            break;
    }    
}

- (void)favDidCClick:(UIButton *)button
{
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntiry favGoods:self.goodsID :!button.selected Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1000){
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws showTotasViewWithMes:button.selected ? @"成功取消关注" : @"关注成功"];
                [button setSelected:!button.selected];
                ws.goodsModel.isFaved = button.isSelected;
            });
        }else{
            [ws showTotasViewWithMes:[responseObject objectForKey:@"result"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws showTotasViewWithMes:button.selected ? @"取消关注失败" : @"关注失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)lookAtOrder
{
    
    OrderViewController * order = [[OrderViewController alloc] init];
    [self.navigationController pushViewController:order animated:YES];
}


- (void)putIntoOrder
{
    
    if(self.goodsModel.state != KGoodsStateHaveSource){
        [self showTotasViewWithMes:@"货品已经约出，无法加入订单"];
        return;
    }
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntiry addGoodsInShopingWithGoodsId:self.goodsModel.goodsID facyory_Code:self.goodsModel.goddsFactoryCode Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if(code == 1000){
            [ws showTotasViewWithMes: @"添加成功"];
        }else if (code == 2001){
            [ws showTotasViewWithMes: @"已在订单"];
        }else{
            [ws showTotasViewWithMes:[responseObject objectForKey:@"result"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws showTotasViewWithMes:@"添加失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

@end

