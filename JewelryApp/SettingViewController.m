//
//  SettingViewController.m
//  JewelryApp
//
//  Created by kequ on 15/5/5.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "SettingViewController.h"
#import "UserInfoModel.h"
#import "AboutViewController.h"
#import "CacheManager.h"
#import "PassWordViewController.h"
#import "NetWorkEntiry.h"

typedef enum : NSUInteger {
    KSettingModelUnKnow = 0,
    KSettingModelAction = 1,
    KSettingModelTitle,
} KSettingModelType;

@interface SettingModel : NSObject
@property(nonatomic,strong)NSString * key;
@property(nonatomic,strong)NSString * value;
@property(nonatomic,assign)KSettingModelType type;
@property(nonatomic,strong)UIImage * iconImage;

@end

@implementation SettingModel
@end

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSourceArray;
@property(nonatomic,strong)UIButton * loginView;
@property(nonatomic,strong)NSString * downLoadUrl;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initDataSource];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBar];
}

- (void)initNavBar
{
    [self resetNavBar];
    self.myNavigationItem.title = @"设置";
    self.myNavigationItem.leftBarButtonItems = nil;
}

- (void)initTableView
{
    UIView * view = [[UIView alloc] init];
    [self.view addSubview:view];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64 - 49 - 62) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self initLogButtonView];
    [self.tableView setScrollEnabled:NO];

//    if (self.view.height > 500) {
//    }
}

- (void)initLogButtonView
{
    self.loginView = [[UIButton alloc] initWithFrame:CGRectMake(25, self.tableView.bottom, self.view.width - 50, 42)];
    self.loginView.backgroundColor = RGB_Color(236, 88, 87);
    [self.loginView setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.loginView setTitle:@"退出登录" forState:UIControlStateHighlighted];
    self.loginView.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.loginView.layer.cornerRadius = 3.f;
    [self.loginView addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginView];
}

- (void)initDataSource
{
    //账号，类型，联系电话，修改密码，清除缓存，关羽，检查更新，推出登陆
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    UserInfoModel * userModel = [UserInfoModel defaultUserInfo];
    
    NSMutableArray * sectionArray  =[NSMutableArray arrayWithCapacity:0];
    SettingModel * setModel = [[SettingModel alloc] init];
    setModel.key = @"当前账号";
    setModel.value = userModel.name;
    setModel.iconImage = [UIImage imageNamed:@"setting_por"];
    setModel.type = KSettingModelTitle;
    [sectionArray addObject:setModel];
    
    
    setModel = [[SettingModel alloc] init];
    setModel.key = @"账号类型";
    setModel.iconImage = [UIImage imageNamed:@"setting_type"];
    setModel.value = [self nameOfRole:userModel.role];
    setModel.type = KSettingModelTitle;
    [sectionArray addObject:setModel];
    
    
    setModel = [[SettingModel alloc] init];
    setModel.iconImage = [UIImage imageNamed:@"setting_tel"];
    setModel.key = @"联系电话";
    setModel.value = userModel.tel;
    setModel.type = KSettingModelTitle;
    [sectionArray addObject:setModel];
    
    
    setModel = [[SettingModel alloc] init];
    setModel.iconImage = [UIImage imageNamed:@"setting_pas"];
    setModel.key = @"修改密码";
    setModel.value = nil;
    setModel.type = KSettingModelAction;
    [sectionArray addObject:setModel];
    
    setModel = [[SettingModel alloc] init];
    setModel.iconImage = [UIImage imageNamed:@"setting_about"];
    setModel.key = @"关于翠源";
    setModel.value = nil;
    setModel.type = KSettingModelAction;
    [sectionArray addObject:setModel];
    
    NSMutableArray * sectionArray2  =[NSMutableArray arrayWithCapacity:0];
 
    
//    setModel = [[SettingModel alloc] init];
//    setModel.key = @"关于";
//    setModel.value = nil;
//    setModel.type = KSettingModelAction;
//    [sectionArray2 addObject:setModel];
    
    setModel = [[SettingModel alloc] init];
    setModel.iconImage = [UIImage imageNamed:@"setting_ver"];
    setModel.key = @"检查更新";
    setModel.value = nil;
    setModel.type = KSettingModelAction;
    [sectionArray2 addObject:setModel];

    
    [_dataSourceArray addObject:sectionArray];
    [_dataSourceArray addObject:sectionArray2];
}

- (NSString *)nameOfRole:(KUserRole )role
{
    switch (role) {
        case KUserSaleUploadGoods:
            return @"厂方小二";
            break;
        case KUserSaleEnsureGoods:
            return @"厂方负责人";
            break;
        case KUserBuyInShopping:                      //采购
            return @"选货人员";
            break;
        case KUserBuyInShoppingEnsure:                            //确定订单
            return @"定约人员";
            break;
        case KUserBuyAboutGoods:                          //联系翠源平台方确定可约货品及看货的时间地点
            return @"约货人员";
            break;
        case KUserBuyAboutPrice:                            //看到货品后通过400电话与供货厂方取得联系，议价
            return @"议价人员";
            break;
        case KUserBuyOrderEnsure:                            //负责定货操作
            return @"定货人员";
            break;
        case KUserBuyBossEnsture:
            return @"终选人员";
            break;
        default:
            break;
    }
    return @"";
}

#pragma mark - Action
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataSourceArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingModel * setModel = nil;
    UITableViewCell * tableViewCell = nil;
    
    if (indexPath.section < self.dataSourceArray.count) {
        NSArray * secArray = [self.dataSourceArray objectAtIndex:indexPath.section];
        if (indexPath.row < secArray.count) {
            setModel = [secArray objectAtIndex:indexPath.row];
        }
    }

    if (setModel.type == KSettingModelTitle) {
        tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        if (!tableViewCell) {
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TitleCell"];
            [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UIView * lineView = [self lineView];
            lineView.frame = CGRectMake(60, tableViewCell.height - 1, tableView.width, 1);
            [tableViewCell  addSubview:lineView];
        }
    }
    
    if(setModel.type == KSettingModelAction){
        tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
        if (!tableViewCell) {
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ActionCell"];
            [tableViewCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        UIView * lineView = [self lineView];
        lineView.frame = CGRectMake(60, tableViewCell.height - 1, tableView.width, 1);
        [tableViewCell  addSubview:lineView];
    }
    
    tableViewCell.textLabel.text = setModel.key;
    tableViewCell.detailTextLabel.text = setModel.value;
    tableViewCell.imageView.image = setModel.iconImage;
    return tableViewCell ? tableViewCell : [UITableViewCell new];
}

- (UIView *)lineView
{
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor  = [UIColor colorWithRed:0xf7/255.f green:0xf7/255.f blue:0xf7/255.f alpha:1];
    lineView.layer.borderColor = [UIColor colorWithRed:0xea/255.f green:0xea/255.f blue:0xea/255.f alpha:1.f].CGColor;
    lineView.layer.borderWidth = 0.5;
    lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    return lineView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 3:
                //修改密码
                [self.navigationController pushViewController:[[PassWordViewController alloc] init] animated:YES];
                break;
            case 4:
                //关于
                [self.navigationController pushViewController:[[AboutViewController alloc] init] animated:YES];
                break;
                
            default:
                break;
        }
    }else{
        [self onCheckVersion];
    }
}


- (void)loginButtonClick:(UIButton *)button
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 200;
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100 && buttonIndex == 1) {
        //清除缓存
        [CacheManager removeAllCache];
        ToastAlertView * alertView = [[ToastAlertView alloc] initWithTitle:@"清除缓存完成" controller:self];
        [alertView show];

    }
    if(alertView.tag == 200 && buttonIndex == 1){
        //退出登陆
        [[UserInfoModel defaultUserInfo] loginOut];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (alertView.tag == 300 && buttonIndex == 1) {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:self.downLoadUrl]];
    }
}


-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CGFloat  currentVersion = [[infoDic objectForKey:@"VersionCode"] floatValue];
    NSDictionary * dicNinfo = [self getAppInfoFromNetWithVersion:currentVersion];
    CGFloat nVersion = [[dicNinfo objectForKey:@"version"] floatValue];
    self.downLoadUrl = [dicNinfo objectForKey:@"url"];
    if (self.downLoadUrl && nVersion > currentVersion) {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"有版本更新，是否现在进行更新" delegate:self cancelButtonTitle:@"暂不下载" otherButtonTitles:@"现在下载", nil];
        alter.tag = 300;
        [alter show];
      
    }else{
        [self showPopAlerViewWithMes:@"当前已是最新版本" withDelegate:self cancelButton:@"确定" otherButtonTitles:nil];
    }
}

- (NSDictionary *)getAppInfoFromNetWithVersion:(CGFloat )curVersion
{
    NSString *URL =[NSString stringWithFormat:@"%@/version/get_version?version=%f&type=ios",KNETBASEURL,curVersion];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError * error = nil;
    NSData * recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSDictionary * dic = [recervedData objectFromJSONData];
    return [dic objectInfoForKey:@"result"];
}

@end
