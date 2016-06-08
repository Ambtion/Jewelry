//
//  UserInfoModel.h
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelDefine.h"


@interface UserInfoModel : NSObject
@property(nonatomic,strong)NSString * userID;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * tel;
@property(nonatomic,assign)KUserRole role;
@property(nonatomic,strong)NSString * toke;


@property(nonatomic,strong)NSString * factoryID;
@property(nonatomic,strong)NSString * factoryName;
+ (UserInfoModel *)defaultUserInfo;

+ (BOOL)isLogin;
- (void)loginOut;
- (BOOL)loginViewDic:(NSDictionary *)info;

@end
