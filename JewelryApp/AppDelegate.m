//
//  AppDelegate.m
//  JewelryApp
//
//  Created by kequ on 15/4/28.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "AppDelegate.h"
#import "JWLoginViewController.h"
#import "ExploreViewController.h"
#import "PushTransition.h"
#import "UploadedGoodsListController.h"
#import "SettingViewController.h"
#import "OrderViewController.h"
#import "FeedListController.h"
#import "AFNetworkActivityLogger.h"
#import "BMJWNagationController.h"
#import "MobClick.h"

@interface AppDelegate ()<JWLoginViewControllerDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate>
@property(nonatomic,strong)BMJWNagationController * navController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [MobClick startWithAppkey:@"55a4d82f67e58eeece0038be" reportPolicy:BATCH   channelId:@"蒲公英"];
    
    [[AFNetworkActivityLogger sharedLogger] startLogging];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setDefoultNavBarStyle];

    JWLoginViewController * loginViewC = [[JWLoginViewController alloc] init];
    loginViewC.delegate = self;
    self.navController = [[BMJWNagationController alloc] initWithRootViewController:loginViewC];
    self.window.rootViewController =  self.navController;
    [self.window makeKeyAndVisible];
    if ([UserInfoModel isLogin]) {
        [self jwLoginViewControllerDidLoginSucess:nil];
    }
    return YES;
}

- (void)setDefoultNavBarStyle
{
 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0 green:172/255.f blue:87/255.f alpha:1]];
    NSDictionary *textAttributes1 = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f],
                                      NSForegroundColorAttributeName: [UIColor whiteColor]
                                      };
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes1];

}

#pragma mark - 登陆逻辑
- (void)jwLoginViewControllerDidLoginSucess:(JWLoginViewController *)loginViewController
{
    
    [self.navController.navigationBar setHidden:NO];
    UITabBarController * tab  = nil;
    UserInfoModel * model = [UserInfoModel defaultUserInfo];
    
    UIImage * nExp = [UIImage imageNamed:@"tab_explore"];
    UIImage * hExp = [UIImage imageNamed:@"tab_explore_press"];
    UIImage * nFeed = [UIImage imageNamed:@"tab_feed"];
    UIImage * hFeed = [UIImage imageNamed:@"tab_feed_press"];
    UIImage * nOrder = [UIImage imageNamed:@"tab_order"];
    UIImage * hORder = [UIImage imageNamed:@"tab_order_press"];
    UIImage * nSet = [UIImage imageNamed:@"tab_setting"];
    UIImage * hSet = [UIImage imageNamed:@"tab_setting_press"];
    UIImage * nGoods = [UIImage imageNamed:@"tab_upload_shopping"];
    UIImage * hGoods = [UIImage imageNamed:@"tab_upload_shopping_h"];
    switch ([model role]) {
        case KUserSaleUploadGoods:
            //店小二
        {
            UploadedGoodsListController * listC = [[UploadedGoodsListController alloc] init];
            listC.factoryID = [[UserInfoModel defaultUserInfo] factoryID];
            SettingViewController * setting = [[SettingViewController alloc] init];
            tab = [self getTabWithTitleArray:@[@"货品",@"设置"] nimagesArray:@[nGoods,nSet] himages:@[hGoods,hSet] andControllers:@[listC,setting]];
        }
            break;
        case KUserSaleEnsureGoods:
        {
            
            UploadedGoodsListController * listC = [[UploadedGoodsListController alloc] init];
            OrderViewController * order = [[OrderViewController alloc] init];
            SettingViewController * setting = [[SettingViewController alloc] init];
            tab = [self getTabWithTitleArray:@[@"货品",@"订单",@"设置"] nimagesArray:@[nGoods,nOrder,nSet] himages:@[hGoods,hORder,hSet]  andControllers:@[listC,order,setting]];
        }
            break;
        case KUserBuyInShopping:
        case KUserBuyInShoppingEnsure:
        case KUserBuyBossEnsture:
        {
            ExploreViewController * exp = [[ExploreViewController alloc] init];
            FeedListController * feList = [[FeedListController alloc] init];
            OrderViewController * order = [[OrderViewController alloc] init];
            SettingViewController * setting = [[SettingViewController alloc] init];
            tab = [self getTabWithTitleArray:@[@"市场",@"关注",@"订单",@"设置"] nimagesArray:@[nExp,nFeed,nOrder,nSet]
                                     himages:@[hExp,hFeed,hORder,hSet]  andControllers:@[exp,feList,order,setting]];
        }
            break;
        case KUserBuyAboutGoods:
        case KUserBuyAboutPrice:
        case KUserBuyOrderEnsure:
        {
            OrderViewController * order = [[OrderViewController alloc] init];
            SettingViewController * setting = [[SettingViewController alloc] init];
            tab = [self getTabWithTitleArray:@[@"订单",@"设置"]
                                nimagesArray:@[nOrder,nSet] himages:@[hORder,hSet]
                              andControllers:@[order,setting]];
        }
            break;
            break;
        default:
            break;
    }
    [self.navController pushViewController:tab animated:NO];
}

- (UITabBarController *)getTabWithTitleArray:(NSArray *)item
                                nimagesArray:(NSArray *)nImages
                                     himages:(NSArray *)himages
                              andControllers:(NSArray*)controllers
{
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    tabBarController.tabBar.selectedImageTintColor = [UIColor colorWithRed:0x35/255.f green:0xb3/255.f blue:0x64/255.f alpha:1];
    for (int i =0; i < controllers.count;i++) {
        UIViewController * controller = [controllers objectAtIndex:i];
        UIImage * nimage = [nImages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * himage = [himages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem * tabItem = [[UITabBarItem alloc] initWithTitle:item[i] image:nimage selectedImage:himage];
        tabItem.tag = i;
        controller.tabBarItem = tabItem;
    }
    [tabBarController setViewControllers:controllers];
    [tabBarController setHidesBottomBarWhenPushed:YES];
    return tabBarController;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[OrderViewController class]]) {
        [(OrderViewController *)viewController  setIsNeedRefresh:YES];
        [(OrderViewController *)viewController setSeletedIndex:0];
    }
    
    if([viewController isKindOfClass:[FeedListController class]]){
        [(FeedListController *)viewController  setIsNeedRefresh:YES];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    
    PushTransition* transition = [PushTransition new];
    transition.operation = operation;
    return transition;
}
@end
