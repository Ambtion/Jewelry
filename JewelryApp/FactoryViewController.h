//
//  FactoryViewController.h
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FactoryModel.h"

@interface FactoryViewController : UIViewController

- (instancetype)initWithFactoryId:(NSString *)facId facoryCode:(NSString *)factortCode;

@end
