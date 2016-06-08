//
//  JWLoginViewController.h
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWLoginViewController;
@protocol JWLoginViewControllerDelegate <NSObject>
- (void)jwLoginViewControllerDidLoginSucess:(JWLoginViewController *)loginViewController;
@end

@interface JWLoginViewController : UIViewController

@property(nonatomic,weak)id<JWLoginViewControllerDelegate>delegate;

@end
