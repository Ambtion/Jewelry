//
//  UploadGoodsController.m
//  JewelryApp
//
//  Created by kequ on 15/5/7.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "UploadGoodsController.h"
#import "GoodsDesInPutCell.h"
#import "UploadImageCell.h"
#import "GoodsCategoryViewCell.h"
#import "GoodsModel+UploadorModify.h"
#import "NetWorkEntiry.h"
#import "TagFillterModel.h"
#import "BaseModelMethod.h"
#import "TagLabelCell.h"
#import "GoodsCountInputCell.h"

@interface UploadGoodsController ()<UICollectionViewDataSource,UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout,GoodsDesInPutCellDelegate,
                                    UIActionSheetDelegate,UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate,UIAlertViewDelegate,GoodsCountInputCellDelegate>
{
    CGFloat _scrollViewOffset;
}
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)GoodsModel * goodsModel;
@property(nonatomic,assign)BOOL isUploadController;
@property(nonatomic,assign)BOOL isMofidy;
@property(nonatomic,assign)GoodsDesInPutCell * desInputCell;
@property(nonatomic,assign)GoodsCountInputCell * countInputCell;
@end

@implementation UploadGoodsController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //默认上传页面
        self.isUploadController = YES;
    }
    return self;
}

- (instancetype)initWithModel:(GoodsModel *)goodsModel
{
    self = [self init];
    if (self) {
        if (goodsModel) {
            self.isUploadController = NO;
            self.isMofidy = NO;
            self.goodsModel = goodsModel;
        }else{
            self.isUploadController = YES;
            self.goodsModel = [[GoodsModel alloc] init];
        }
    }
    return self;
}

- (void)loadModelDataWithCallBack:(void (^)(BOOL isSucess))callBack
{
        [NetWorkEntiry getGoodsDetailInfo:self.goodsModel.goodsID Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 1000) {
            GoodsModel * goodsModel = [GoodsModel coverDicToGoodsModel:[responseObject objectForKey:@"result"]];
            self.goodsModel = goodsModel;
        }
        if (callBack) {
            callBack(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (callBack) {
            callBack(NO);
        }
    }];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initCollectionView];
    [self addKeyBoradNotificaiton];
    
    if(!self.isUploadController){
        WS(ws);
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self loadModelDataWithCallBack:^(BOOL isSucess) {
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            [ws initUploadGoodsModel];
        }];
    }else{
        [self initUploadGoodsModel];
    }
    
    
}

- (void)initUploadGoodsModel
{
    TagFillterModel * tagModel = [[TagFillterModel alloc] init];
    self.goodsModel.goodsPriceSectionArrays = tagModel.priceSectionArray;
    WS(ws);
    [NetWorkEntiry getAllCategoryTypeWith:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 1000) {
            ws.goodsModel.goodsCategoryArrays = [BaseModelMethod getCatergoryIntoWithInfo:[responseObject objectForKey:@"result"]];
            [ws.collectionView reloadData];
        }else{
            [ws.navigationController popViewControllerAnimated:YES];
            [ws showTotasViewWithMes:@"网络加载失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ws.navigationController popViewControllerAnimated:YES];
        [ws showTotasViewWithMes:@"网络加载失败"];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initBavBar];
}

- (void)initBavBar
{
    [self resetNavBar];
    self.myNavigationItem.title = self.isUploadController ? @"上传货品" : @"修改货品";

    UIButton * buttonRight = [self getBarButtonWithTitle:@"完成"];
    [buttonRight addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * ritem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.myNavigationItem.rightBarButtonItems = @[[self barSpaingItem],ritem];
    
    
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) collectionViewLayout:layout];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.clipsToBounds = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[TagLabelCell class] forCellWithReuseIdentifier:@"GOODITEMCELL"];
    [_collectionView registerClass:[GoodsDesInPutCell class] forCellWithReuseIdentifier:@"GoodDesCell"];
    [_collectionView registerClass:[UploadImageCell class] forCellWithReuseIdentifier:@"UpLoadImageCell"];
    [_collectionView registerClass:[UploadImageCellADD class] forCellWithReuseIdentifier:@"UpLoadImageCellADD"];

    [_collectionView registerClass:[GoodsCountInputCell class] forCellWithReuseIdentifier:@"GoodsCountCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootView"];
}

- (void)addKeyBoradNotificaiton
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - 
#pragma mark - Delegate | DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return  1;
            break;
        case 1:
        {
            NSInteger imageCount = self.goodsModel.goodsImageArry.count + self.goodsModel.uploadImagesArray.count;
            if (imageCount < 9) {
                return imageCount + 1;
            }else{
                return imageCount;
            }
        }
           
        case 2:
            return self.goodsModel.goodsCategoryArrays.count;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return self.goodsModel.goodsPriceSectionArrays.count;
            break;
        default:
            break;
    }
    return 0;
}

#define PriceWidth 98

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(collectionView.width  - collectionView.contentInset.right - collectionView.contentInset.left, 42);
            break;
        case 1:
            return CGSizeMake(80, 80);
            break;
        case 2:
            return CGSizeMake(66,24);
            break;
        case 3:
            return CGSizeMake(collectionView.width  - collectionView.contentInset.right - collectionView.contentInset.left, 25);
            break;
        case 4:
            return CGSizeMake(PriceWidth,24);
            break;
        default:
            break;
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return [self getLineSpacingWithIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 11.f;
}

- (CGFloat)getLineSpacingWithIndex:(NSInteger)section
{
    if (section == 4) {
        return (self.collectionView.width - 20 - PriceWidth * 3)/2.f;
    }
    return 11.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width - collectionView.contentInset.right - collectionView.contentInset.left , 52);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGFloat width = self.collectionView.width - 20;
    CGFloat heigth = 0;
    switch (section) {
        case 0:
            heigth = 10.f;
            break;
        case 1:
            heigth = 12.f;
            break;
        case 2:
            heigth = 12.f;
            break;
        case 3:
            heigth = 12.f;
            break;
        case 4:
            heigth = 12.f;
            break;
        default:
            break;
    }
    return CGSizeMake(width, heigth);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * view  = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeadView"  forIndexPath:indexPath];
        view.backgroundColor  = [UIColor whiteColor];
        view.clipsToBounds = YES;
        UILabel * label = (UILabel *)[view viewWithTag:1000];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, view.width, view.height - 22 - 14)];
            label.tag = 1000;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:13.f];
            label.textColor = RGB_Color(51, 51, 51);
            [view addSubview:label];
        }
        [self refreshheadView:view WithIndexPath:indexPath];
        return view;
    }else{
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FootView"  forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
        if (![view viewWithTag:100]) {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(-10, view.height - 1, view.width + 20, 1)];
            lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            lineView.backgroundColor = RGB_Color(229, 229, 229);
            lineView.tag = 100;
            [view addSubview:lineView];
        }
    }
    return view;
}

- (void)refreshheadView:(UIView *)view WithIndexPath:(NSIndexPath*)indexPath
{
    UILabel * label = (UILabel *)[view viewWithTag:1000];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        label.tag = 1000;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13.f];
        label.textColor = RGB_Color(51, 51, 51);
        [view addSubview:label];
    }
    switch (indexPath.section) {
        case 0:
            label.text = @"货品介绍";
            break;
        case 1:
            label.text = @"货品配图";
            break;
        case 2:
            label.text = @"货品分类";
            break;
        case 3:
            label.text = @"货品规格";
            break;
        case 4:
            label.text = @"价格区间";
            break;
        default:
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TagLabelCell * recomendCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GOODITEMCELL" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            self.desInputCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodDesCell" forIndexPath:indexPath];
            self.desInputCell.delegate = self;
            if(self.goodsModel.goodsDes)
                self.desInputCell.textView.text = self.goodsModel.goodsDes;
            
            return self.desInputCell;
        }
            
        case 1:
        {
            UploadImageCell * upCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UpLoadImageCell" forIndexPath:indexPath];

            if (indexPath.row < self.goodsModel.goodsImageArry.count) {
                //网络图片
                UIImage * defaultImage = [UIImage imageNamed:@"temp"];
            
                NSString * imageS = [[[self goodsModel] goodsImageArry] objectAtIndex:indexPath.row];
                if(imageS)
                    imageS = [imageS stringByAppendingString:@"_150*150"];
                [upCell.porView.imageView sd_setImageWithURL:[NSURL URLWithString:imageS] placeholderImage:defaultImage];

                [upCell.deleteButton setHidden:NO];
            }else if (indexPath.row - self.goodsModel.goodsImageArry.count < self.goodsModel.uploadImagesArray.count){
                upCell.porView.imageView.image = [[self.goodsModel uploadImagesArray] objectAtIndex:indexPath.row - self.goodsModel.goodsImageArry.count];
                [upCell.deleteButton setHidden:NO];
            }else{
                upCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UpLoadImageCellADD" forIndexPath:indexPath];
                upCell.porView.imageView.image = [UIImage imageNamed:@"add"];
                [upCell.deleteButton setHidden:YES];
            }
            
            return upCell;
        }
            break;

        case 2:
        {
            GoodsCategoryModel * categoryModel = [[self.goodsModel goodsCategoryArrays] objectAtIndex:indexPath.row];
            recomendCell.label.text = categoryModel.categoryKeyWorld;
            [recomendCell setselectedState:self.goodsModel.seletedCategory == indexPath.row];
            return recomendCell;
        }
            break;
        case 3:
        {
            self.countInputCell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCountCell" forIndexPath:indexPath];
            self.countInputCell.countTextField.text = [NSString stringWithFormat:@"%ld",(long)self.goodsModel.goodsCount];
            self.countInputCell.delegate = self;
            return self.countInputCell;
        }
            break;
        case 4:
        {
            NSNumber * number = [[self.goodsModel goodsPriceSectionArrays] objectAtIndex:indexPath.row];
            recomendCell.label.text = [NSString stringWithFormat:@"%@",[GoodsModel coverGoodPriceSectionToString:[number integerValue]]];
//            if ([number integerValue] == KGoodsPriceSection50000_) {
//                recomendCell.label.text = @"50000元以上";
//            }
            [recomendCell setselectedState:self.goodsModel.seletedPriceSetion == indexPath.row];
            return recomendCell;

        }
            break;
        default:
            break;
    }
    return [UICollectionViewCell new];
}

#pragma mark - Action
- (void)rightBarButtonClick:(UIButton *)button
{
    if (!self.isUploadController && self.isMofidy == NO) {
        [self showTotasViewWithMes:@"请修改后提交"];
        return;
    }
    
    if (!self.goodsModel.goodsDes || [self.goodsModel.goodsDes isEqualToString:@""]) {
        [self showTotasViewWithMes:@"货品描述不能为空"];
        return;
    }
    
    if (!self.goodsModel.goodsCatery) {
        [self showTotasViewWithMes:@"货品类别不能为空"];
        return;
    }
    
    if(self.goodsModel.goodsPriceSection < 1 || self.goodsModel.goodsPriceSection >= KGoodsPriceSectionCount)
    {
        [self showTotasViewWithMes:@"货品价格区间不能为空"];
        return;
    }

    if (self.goodsModel.uploadImagesArray.count + self.goodsModel.goodsImageArry.count <= 0) {
        [self showTotasViewWithMes:@"货品图片不能为空"];
        return;
    }
    
    NSString * caterGoryID = self.goodsModel.goodsCatery.categoryID;
    NSInteger  priceTag = self.goodsModel.goodsPriceSection;
    
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
   [NetWorkEntiry modifyGoodsWithGoodsId:self.goodsModel.goodsID Category:caterGoryID goodsDes:self.goodsModel.goodsDes price_range:priceTag spes:self.goodsModel.goodsCount netImages:self.goodsModel.goodsImageArry localImages:self.goodsModel.uploadImagesArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSInteger code = [[responseObject objectForKey:@"code"] intValue];
       if (code == 1000) {
           [ws showTotasViewWithMes:self.isUploadController? @"上传成功":@"修改成功"];
           [ws.goodsModel.uploadImagesArray removeAllObjects];
           if ([_delegate respondsToSelector:@selector(uploadGoodsControllerDidMofifySucess:)]) {
               [_delegate uploadGoodsControllerDidMofifySucess:self];
           }
       }else if (code == 2000){
           [ws showTotasViewWithMes:@"货品规格超过最大值"];
       }else{
           [ws showTotasViewWithMes:self.isUploadController? @"上传失败":@"修改失败"];
       }
       [MBProgressHUD hideHUDForView:ws.navigationController.view animated:YES];
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [MBProgressHUD hideHUDForView:ws.navigationController.view animated:YES];
       [ws showTotasViewWithMes:self.isUploadController? @"上传失败":@"修改失败"];
   }];
}

- (void)leftButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark keyBoard
- (void)keyboardShow:(NSNotification*)notification
{
    if([self.countInputCell.countTextField isFirstResponder]){
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.countInputCell.top) animated:YES];
    }
}

- (void)keyboardHide:(NSNotification*)notification
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollViewOffset > scrollView.contentOffset.y) {
        [[self.desInputCell textView] resignFirstResponder];
        [self.countInputCell.countTextField resignFirstResponder];
    }
    _scrollViewOffset = scrollView.contentOffset.y;
}

- (void)goodsDesInPutCellDidTextFieldWillChangeToString:(NSString *)str
{
    self.isMofidy = YES;
    self.goodsModel.goodsCount = [str integerValue];
}
- (void)goodsDesInPutCellDidTextViewWillChangeToString:(NSString *)str
{
    self.isMofidy = YES;
    self.goodsModel.goodsDes = str;
}

#pragma mark - Selete
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            self.isMofidy = YES;
            if (indexPath.row < self.goodsModel.goodsImageArry.count + self.goodsModel.uploadImagesArray.count) {
                //删除图片
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除照片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = indexPath.row;
                [alertView show];
                
            }else{
                //添加图片
                UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
                [action showInView:self.view];
            }
            break;

        case 2:
            self.isMofidy = YES;
            self.goodsModel.seletedCategory = indexPath.row;
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
            [CATransaction commit];
            break;
        case 3:
            break;
        case 4:
            self.isMofidy = YES;
            self.goodsModel.seletedPriceSetion = indexPath.row;
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:4]];
            [CATransaction commit];
            break;
      
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self deleteImage:alertView.tag];
    }
}

- (void)deleteImage:(NSInteger )indexRow
{
    if (indexRow < self.goodsModel.goodsImageArry.count) {
        //网络图片
        [[self.goodsModel goodsImageArry] removeObjectAtIndex:indexRow];
    }else if (indexRow - self.goodsModel.goodsImageArry.count < self.goodsModel.uploadImagesArray.count){
        //本地图片
        [self.goodsModel.uploadImagesArray removeObjectAtIndex:indexRow - self.goodsModel.goodsImageArry.count];
    }
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //相机
            [self addImmagesFormCamera:YES];
            break;
        case 1:
            //相册
            [self addImmagesFormCamera:NO];
            break;
        default:
            break;
    }
}

- (void)addImmagesFormCamera:(BOOL)isFromCamera
{
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    if (isFromCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType =
            UIImagePickerControllerSourceTypeCamera;
        }

    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePickerController.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
        }

    }
    imagePickerController.allowsEditing = YES;
    //设置委托对象
    imagePickerController.delegate = self;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

    //获得编辑过的图片
    UIImage * editImage = [editingInfo objectForKey: @"UIImagePickerControllerEditedImage"];
    [[self.goodsModel uploadImagesArray] addObject:editImage];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    [CATransaction commit];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获得编辑过的图片
    UIImage * editImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    [[self.goodsModel uploadImagesArray] addObject:editImage];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    [CATransaction commit];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end
