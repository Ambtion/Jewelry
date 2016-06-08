//
//  SearchResultViewController.h
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TagFillterModel.h"
#import "RefreshCollectionView.h"

@interface SearchResultViewController : UIViewController

@property(nonatomic,strong)NSString * keyWorld;
@property(nonatomic,strong)NSString * factoryID;
@property(nonatomic,strong)TagFillterModel * tagModel;

- (instancetype)initWithSwich:(BOOL)isNeedHiddenFactory;

@end
