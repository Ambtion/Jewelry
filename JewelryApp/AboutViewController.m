//
//  AboutViewController.m
//  JewelryApp
//
//  Created by kequ on 15/5/5.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavBarItem];
    [self initContentView];
}


- (void)initNavBarItem
{
    self.myNavigationItem.title = @"关于";
    
}

- (void)initContentView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    CGFloat width = 750.f;
    CGFloat heignt = 1334.f;
    CGFloat scale = self.view.width / width;
    

    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, -66, self.view.width, heignt * scale)];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 66)];
    view.backgroundColor = [UIColor whiteColor];
    [image addSubview:view];
    image.image = [UIImage imageNamed:@"about_"];
    [image setUserInteractionEnabled:YES];
    [self.scrollView addSubview:image];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, image.height - 66 );
    
    CGFloat buttonWidth = 140.f * 2;
    CGFloat buttonHeight = 26.f * 2;
    CGFloat buttonOffsetX  =  90.f * 2;
    CGFloat buttonOffsetY = 332.f * 2;
    CGFloat buttonSpacingY = 0.f * 2;
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(buttonOffsetX * scale, buttonOffsetY * scale, buttonWidth * scale, buttonHeight * scale)];
//    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 100;
    [image addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectOffset(button.frame, 0, buttonSpacingY * scale + button.height)];
//    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 200;
    [image addSubview:button];
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100){
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"呼叫 4006928800" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alertView.tag = 100;
//        [alertView show];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4006928800"]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://06928880999"]];
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"呼叫 06928880999" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSString *num  = @"";
        if (alertView.tag == 100) {
            num = @"telprompt://4006928800";
        }else{
            num = @"telprompt://06928880999";
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];

    }
}

@end
