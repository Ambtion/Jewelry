//
//  JWLoginViewController.m
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "JWLoginViewController.h"
#import "FeedListController.h"
#import "SettingViewController.h"
#import "UploadedGoodsListController.h"

#define TEXTLOLOR  [UIColor whiteColor]

@interface JWLoginViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIButton * loginButton;
@property(nonatomic,strong)UIButton * button;

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIControl *backgroundControl;
@property (strong, nonatomic) UITextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;

@end

@implementation JWLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    view.bounces = NO;
    view.scrollEnabled = NO;
    view.contentSize = view.frame.size;
    self.view = view;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addbgViews];
    [self addLoginText];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}



-(void)addbgViews
{
    //backGround

    CGRect bounds = self.view.bounds;
    _backgroundImageView = [[UIImageView alloc] initWithFrame:bounds];
    _backgroundImageView.image = [UIImage imageNamed:@"LoginBg"];
    [self.view addSubview:_backgroundImageView];
    _backgroundControl = [[UIControl alloc] initWithFrame:bounds];
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backgroundControl];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.myNavController.navigationBar setHidden:YES];
    [[self.myNavController navigationBar] setBarTintColor:[UIColor clearColor]];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)addLoginText
{
    
    UIView * bgmage1 = [[UIView alloc] initWithFrame:CGRectZero];
    bgmage1.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
    bgmage1.layer.borderWidth = 1;
    bgmage1.layer.cornerRadius = 6.f;
    [bgmage1 setUserInteractionEnabled:YES];
    bgmage1.clipsToBounds = YES;
    
    UIView * bgmage2 = [[UIView alloc] initWithFrame:CGRectZero];
    bgmage2.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
    bgmage2.layer.borderWidth = 1;
    [bgmage2 setUserInteractionEnabled:YES];
    bgmage2.layer.cornerRadius = 6.f;
    bgmage2.clipsToBounds = YES;
    
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = TEXTLOLOR;
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.keyboardType = UIKeyboardTypeNumberPad;
    NSDictionary * attribuDic = @{
                                  NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:223/255.f green:229/255.f blue:224/255.f alpha:1]
                                  };
    
    NSAttributedString * mutalStr = [[NSAttributedString alloc] initWithString:@"手机号"
                                                                    attributes:attribuDic];
    [_usernameTextField setAttributedPlaceholder:mutalStr];
    _usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameTextField.backgroundColor = [UIColor clearColor];
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _usernameTextField.textColor = [UIColor colorWithRed:223/255.f green:229/255.f blue:224/255.f alpha:1];
    _usernameTextField.font = [UIFont systemFontOfSize:14.f];
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    //输入密码
    mutalStr = [[NSAttributedString alloc] initWithString:@"请输入您的密码"
                                               attributes:attribuDic];
 
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(18 + 10, 39, 205, 35)];
    _passwordTextField.font = [UIFont systemFontOfSize:14];
    _passwordTextField.textColor = [UIColor colorWithRed:223/255.f green:229/255.f blue:224/255.f alpha:1];
    _passwordTextField.attributedPlaceholder = mutalStr;
    _passwordTextField.backgroundColor = [UIColor clearColor];
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;

    //登录按钮
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [UIColor colorWithRed:84/255.f green:172/255.f blue:61/255.f alpha:1];
    loginButton.layer.cornerRadius = 6.f;
    loginButton.clipsToBounds = YES;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    bgmage1.frame = CGRectMake(15, 260, self.view.width - 30, 38);
    bgmage2.frame = CGRectMake(15, bgmage1.bottom + 17, bgmage1.width, bgmage1.height);
    
    _usernameTextField.frame = CGRectMake( 10, 0, bgmage1.width - 20, bgmage1.height);
    _passwordTextField.frame = CGRectMake( 10, 0, bgmage1.width - 20, bgmage1.height);
    
    [bgmage1 addSubview:_usernameTextField];
    [bgmage2 addSubview:_passwordTextField];
    
    loginButton.frame = CGRectMake(bgmage1.left, bgmage2.bottom + 33, bgmage1.width, bgmage1.height);
    
    [self.view addSubview:bgmage1];
    [self.view addSubview:bgmage2];
    [self.view addSubview:loginButton];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![touch.view isKindOfClass:[UIButton class]];
}

#pragma mark keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    UIScrollView * view = (UIScrollView *) self.view;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize size = view.bounds.size;
    size.height += keyboardSize.height;
    view.contentSize = size;
    
    CGPoint point = view.contentOffset;
    point.y =  120;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIScrollView *view = (UIScrollView *) self.view;
    CGPoint point = view.contentOffset;
    point.y  =  0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
    
    CGSize size = view.bounds.size;
    view.contentSize = size;
}

#pragma mark -
- (void)allTextFieldsResignFirstResponder
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)usernameDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];
}

- (void)loginButtonClicked:(UIButton*)button
{
//    UIAlertView * login = [[UIAlertView alloc] initWithTitle:@"" message:@"登陆方式" delegate:self cancelButtonTitle:@"模拟登陆" otherButtonTitles:@"实际登陆", nil];
//    [login show];
    [self logginWithNet];
}

- (void)logginWithNet
{
    if (!_usernameTextField.text|| [_usernameTextField.text isEqualToString:@""]) {
        [self showPopAlerViewWithMes:@"您还没有填写用户名" withDelegate:nil cancelButton:@"确定" otherButtonTitles:nil];
        return;
    }
    if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""]) {
        [self showPopAlerViewWithMes:@"您还没有填写密码" withDelegate:nil cancelButton:@"确定" otherButtonTitles:nil];
        return;
    }
    NSString * useName = [NSString stringWithFormat:@"%@",[_usernameTextField.text lowercaseString]];
    NSString * passWord = [NSString stringWithFormat:@"%@",_passwordTextField.text];
    
    WS(ws);
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    [NetWorkEntiry loginWithUserName:useName password:passWord success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * content = (NSDictionary *)responseObject;
        NSInteger code = [[content objectForKey:@"code"] intValue];
        if (code == 1000) {
            [ws handleLoginInfo:[content objectForKey:@"result"]];
            
        }
        [self showTotasViewWithMes:@"用户名或密码错误"];
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws showTotasViewWithMes:@"提示服务器繁忙"];
        [hud hide:YES];
    }];
}

- (void)handleLoginInfo:(NSDictionary *)info
{
    if([[UserInfoModel defaultUserInfo] loginViewDic:info]){
        [self loginSucess];
    }else{
        [self showTotasViewWithMes:@"服务端用户缺少信息关键信息"];
    }
}

- (void)loginSucess
{
    
    if ([_delegate respondsToSelector:@selector(jwLoginViewControllerDidLoginSucess:)]) {
        [_delegate jwLoginViewControllerDidLoginSucess:self];
    }
}


#pragma mark - 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self logginWithNet];
    }else{
        [self loginDemon];
    }
}

- (void)loginDemon
{
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"" destructiveButtonTitle:@"取消" otherButtonTitles:@"选货",@"定约",@"约货",@"约价",@"定货",@"Boss",@"小二",@"卖家", nil];
    [action showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger userId = buttonIndex + 1;
    if (buttonIndex > 6) {
        buttonIndex = 70 + buttonIndex - 6;
    }
    
    if (buttonIndex <= 72) {
        UserInfoModel * infoModel = [UserInfoModel defaultUserInfo];
        infoModel.role = buttonIndex;
        infoModel.userID = [NSString stringWithFormat:@"%ld",(long)userId];
        infoModel.toke = infoModel.userID;
    }
    [self loginSucess];

}

@end
