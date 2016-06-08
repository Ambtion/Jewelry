//
//  CacheManager.m
//  JewelryApp
//
//  Created by kequ on 15/5/5.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager
+ (void)removeAllCache
{
    [self removeCacheOfImage];
}
+ (void)removeCacheOfImage
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}
@end
