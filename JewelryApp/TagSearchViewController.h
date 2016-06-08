//
//  TagSearchViewController.h
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagFillterModel.h"

@class TagSearchViewController;
@protocol TagSearchViewControllerDelegate <NSObject>
- (void)tagSearchViewControllerDidClickCancel:(TagSearchViewController *)controller;
- (void)tagSearchViewController:(TagSearchViewController *)controller DidSeleted:(TagFillterModel *)model;
@end

@interface TagSearchViewController : UIViewController
@property(nonatomic,weak)id<TagSearchViewControllerDelegate>delegate;
@property(nonatomic,strong)TagFillterModel * model;

@end
