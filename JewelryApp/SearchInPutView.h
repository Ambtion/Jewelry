//
//  SearchInPutView.h
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchInPutView : UIView
@property(nonatomic,strong)UITextField * textFiled;
@property(nonatomic,strong)UIButton * textButton;

- (BOOL)textBecomeFirstResponder;
- (BOOL)textResignFirstResponder;

@end
