//
//  KeyWordSearchViewController.h
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchInPutView.h"

@class KeyWordSearchViewController;
@protocol KeyWordSearchViewControllerDelegate <NSObject>
- (void)keyWordSearchViewControllerDidClickCancel:(KeyWordSearchViewController *)controller;
- (void)keyWordSearchViewController:(KeyWordSearchViewController *)controller DidSeletedSearchKeyWorld:(NSString *)keyWorld;
@end

@interface KeyWordSearchViewController : UIViewController
@property(nonatomic,weak)id<KeyWordSearchViewControllerDelegate>delegate;
@property(nonatomic,strong)SearchInPutView * inputView;
@end
