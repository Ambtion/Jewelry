//
//  UserInfoModel.m
//  JewelryApp
//
//  Created by kequ on 15/5/1.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "UserInfoModel.h"

#define USERINFO_IDENTIFY       @"USERINFO_IDENTIFY"

@implementation UserInfoModel (private)

#pragma mark - StoreDefaults
+ (void)storeData:(id)data forKey:(NSString *)key
{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    [defults setObject:data forKey:key];
    [defults synchronize];
}

+ (id)dataForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * data = [defaults objectForKey:key];
    return data;
}
+ (void)removeDataForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

@end

@implementation UserInfoModel

+ (UserInfoModel *)defaultUserInfo
{
    static UserInfoModel * userInfoModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!userInfoModel) {
            userInfoModel = [[self alloc] init];
        }
    });
    return userInfoModel;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        if ([[self class] isLogin]) {
            [self loginViewDic:[[self class] dataForKey:USERINFO_IDENTIFY]];
        }
    }
    return self;
}

+ (BOOL)isLogin
{
    return [[self class] dataForKey:USERINFO_IDENTIFY] != nil;
}
- (void)loginOut
{
    [[self class] removeDataForKey:USERINFO_IDENTIFY];
}

- (BOOL)loginViewDic:(NSDictionary *)info
{
    self.toke = [info objectForKey:@"token"];
    self.userID = [info objectForKey:@"user_id"];
    self.name =  [info objectForKey:@"user_name"];
    self.tel = [info objectForKey:@"phone"];
    self.role = [[info objectForKey:@"user_code"] intValue];
    if (!self.toke || !self.userID || !self.name || !self.tel || self.role <=0) {
        return NO;
    }
    self.factoryName = [NSString stringWithFormat:@"%@",[info objectForKey:@"supplier_name"]];
    self.factoryID = [NSString stringWithFormat:@"%@",[info objectForKey:@"supplier_id"]];
    
    if (![[self class] isLogin]) {
        [[self class] storeData:info forKey:USERINFO_IDENTIFY];
    }
    return YES;
}

@end
