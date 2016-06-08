//
//  PassWordViewController.m
//  JewelryApp
//
//  Created by kequ on 15/5/5.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "PassWordViewController.h"

@interface PassWordViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITextField *oldpwd;
    UITextField *newpwd;
    UITextField *rnewpwd;
    UITableView *tableview;
    NSString * _tempPassword;
}
@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initContentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBarItem];
}

- (void)initNavBarItem
{
    [self resetNavBar];
    self.myNavigationItem.title = @"修改密码";
    UIButton * button = [self getBarButtonWithTitle:@"保存"];
    [button addTarget:self action:@selector(sumbitChangPassWorld) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.myNavigationItem.rightBarButtonItems = @[[self barSpaingItem],saveItem];
}

- (void)initContentView
{
    tableview=[[UITableView alloc] initWithFrame:CGRectMake(5, 5, 310, 280) style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    [tableview setRowHeight:50];
    tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableview.backgroundColor=[UIColor clearColor];
    tableview.scrollEnabled=NO;
    [self.view addSubview:tableview];
}

#pragma mark - DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 30)];
        label.tag=1;
        label.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:label];
        UITextField *tf=[[UITextField alloc] initWithFrame:CGRectMake(120, 15, 150, 30)];
        tf.tag=2;
        tf.borderStyle=UITextBorderStyleNone;
        tf.secureTextEntry=YES;
        [cell.contentView addSubview:tf];
    }
    UILabel *label=(UILabel *)[cell.contentView viewWithTag:1];
    UITextField *tf=(UITextField *)[cell.contentView viewWithTag:2];
    NSInteger row=[indexPath row];

    if (row==0) {
        label.text=@"新密码";
        tf.placeholder=@"至少6位";
        newpwd=tf;
    }
    if (row==1){
        label.text=@"重复密码";
        tf.placeholder=@"请再重复一次";
        rnewpwd=tf;
    }
    return cell;
}

#pragma mark - 
-(void)sumbitChangPassWorld
{
//    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *c2=newpwd.text;
    NSString *c3=rnewpwd.text;
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self resignAllFirstResponder];
    [oldpwd resignFirstResponder];
    if([c2 isEqualToString:@""] || [c3 isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"密码不能为空！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![c2 isEqualToString:c3]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"新密码前后不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if(c2.length<6||c3.length<6){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"新密码不能小于6位!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    _tempPassword = c2;
    
    if (NSClassFromString(@"UIAlertController")) {
        UIAlertController *  alerContr = [UIAlertController alertControllerWithTitle:nil message:@"确定修改密码" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertView * view = [[UIAlertView alloc] init];
        view.tag = 1000;
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            [self alertView:view clickedButtonAtIndex:0];
        }];
        
        [alerContr addAction:cancelAction];
        
        UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self alertView:view clickedButtonAtIndex:1];
        }];
        
        [alerContr addAction:ensureAction];
        
        [self presentViewController:alerContr animated:YES completion:nil];
        
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"确定修改密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    }
  

}

- (void)resignAllFirstResponder
{
    [oldpwd resignFirstResponder];
    [newpwd resignFirstResponder];
    [rnewpwd resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10) {
//        [[UserInfoModel defaultUserInfo] loginOut];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (alertView.tag == 1000 && buttonIndex) {
        [NetWorkEntiry mofifyPassWord:_tempPassword success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.tag = 10;
                [alertView show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showTotasViewWithMes:@"网络异常，稍后重试"];
        }];

    }
}

@end
