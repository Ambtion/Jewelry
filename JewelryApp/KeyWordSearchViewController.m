//
//  KeyWordSearchViewController.m
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "KeyWordSearchViewController.h"
#define MAXSEARCHCOUNT   20

@interface KeyWordSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITableView  * tableView;
@property(nonatomic,assign)CGFloat keyboardHeight;
@property(nonatomic,strong)NSMutableArray * dataSourceArray;

@end

@implementation KeyWordSearchViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.keyboardHeight = 0;
    [self initNavBarItem];
    [self initTableView];
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBarItem];
    [self.inputView.textFiled becomeFirstResponder];
}

- (void)initNavBarItem
{
    [self resetNavBar];
    
    
    self.myNavigationItem.leftBarButtonItems = @[[self barSpaingItem],[self createBackButton]];
    self.myNavigationItem.titleView = self.inputView;
    
    UIButton * buttonRight = [self getBarButtonWithTitle:@"完成"];
    [buttonRight addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.myNavigationItem.rightBarButtonItems = @[[self barSpaingItem],item];
}

- (SearchInPutView *)inputView
{
    if (!_inputView) {
        _inputView = [[SearchInPutView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        [_inputView.textButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _inputView.textFiled.delegate = self;
    }
    return _inputView;
}

- (void)rightBarButtonClick:(id)sender
{
    [self seletedKeyWorld:self.inputView.textFiled.text];

}

-(UIBarButtonItem*) createBackButton
{
    
    CGRect backframe= CGRectMake(0, 0, 40, 30);
    
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    
    backButton.frame = backframe;
    
    [backButton setImage:[UIImage imageNamed:@"icon_back_page"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon_back_page"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //定制自己的风格的  UIBarButtonItem
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return someBarButtonItem;
    
}


- (void)initTableView
{
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.tableView];
}

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

#pragma mark - Search
- (void)searchButtonClick:(UIButton *)button
{
    [self.inputView textBecomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    if (newtxt.length > MAXSEARCHCOUNT ) {
        textField.text = [newtxt substringWithRange:NSMakeRange(0,MAXSEARCHCOUNT)];
        return NO;
    }
    
    return ([newtxt length] <= MAXSEARCHCOUNT);
}

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    [self loadDataSource];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self seletedKeyWorld:textField.text];
    return [[self inputView] textResignFirstResponder];
}


#pragma mark keyBoard show/hide
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    self.keyboardHeight = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.tableView reloadData];
//    CGRect rect = self.tableView.frame;
//    rect.size.height = self.view.bounds.size.height - heigth - rect.origin.y - 8;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.tableView.frame = rect;
//    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardHeight = 0;
    [self.tableView reloadData];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.tableView.frame = self.view.bounds;
//    }];
}


#pragma mark - LoadDataSource
- (void)loadDataSource
{
    //暂时不支持该功能
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < 10; i++) {
//        [self.dataSourceArray addObject:[NSString stringWithFormat:@"%d",i]];
//    }
    [self.tableView reloadData];
}

#pragma mark DataSource
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.inputView textResignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.keyboardHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    tableViewCell.textLabel.text = self.dataSourceArray[indexPath.row];
    return tableViewCell;
}


#pragma mark Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row < self.dataSourceArray.count) {
        [self seletedKeyWorld:self.dataSourceArray[indexPath.row]];
    }
}

- (void)backButtonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(keyWordSearchViewControllerDidClickCancel:)]) {
        [_delegate keyWordSearchViewControllerDidClickCancel:self];
    }
}

- (void)seletedKeyWorld:(NSString *)keyworld
{
    if (!keyworld || !keyworld.length) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(keyWordSearchViewController:DidSeletedSearchKeyWorld:)]) {
        [_delegate keyWordSearchViewController:self DidSeletedSearchKeyWorld:keyworld];
    }
}

@end
