//
//  TagLabelCell.h
//  JewelryApp
//
//  Created by kequ on 15/5/17.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagLabelCell : UICollectionViewCell
@property(nonatomic,strong)UILabel * label;

- (void)setselectedState:(BOOL)isSeletedState;

@end
