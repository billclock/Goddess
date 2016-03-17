//
//  GirlsViewController.m
//  Goddess
//
//  Created by wangyan on 2016－03－17.
//  Copyright © 2016年 Goddess. All rights reserved.
//

#import "GirlsViewController.h"
#import "PhotoBrowerThumbCell.h"
#import "PhotoBrowerOriginCell.h"
#import "FuliModel.h"

@interface GirlsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UICollectionView * originCollectionView;
@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,strong) UICollectionViewFlowLayout * thumbLayout;
@property (nonatomic,strong) UICollectionViewFlowLayout * originLayout;

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIView * backView;

@property (nonatomic,assign) NSInteger page;
@end

@implementation GirlsViewController

static NSString * const XMGPhotoId = @"photo";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"相册查看";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.page = 0;
    
    self.collectionView.frame = self.view.frame;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.originCollectionView];
    [self.view addSubview:self.imageView];
    self.originCollectionView.hidden = YES;
    self.originCollectionView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    
    
    UIBarButtonItem * backBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backBar;
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.thumbLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(64+ 5, 0, 0, 0);
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setAlwaysBounceVertical:YES];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[PhotoBrowerThumbCell class] forCellWithReuseIdentifier:@"PhotoBrowerThumbCell"];
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)thumbLayout
{
    if (!_thumbLayout) {
        _thumbLayout = [[UICollectionViewFlowLayout alloc]init];
        _thumbLayout.itemSize = CGSizeMake((ScreenW -5*4)/3,150);
        _thumbLayout.minimumLineSpacing = 5.0;
        _thumbLayout.minimumInteritemSpacing = 5.0;
        _thumbLayout.sectionInset= UIEdgeInsetsMake(0, 5, 10, 5);
        [_thumbLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }
    return _thumbLayout;
}
- (UICollectionView *)originCollectionView
{
    if (!_originCollectionView) {
        _originCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.originLayout];
        
        [_originCollectionView setDelegate:self];
        [_originCollectionView setDataSource:self];
        
        [_originCollectionView setAlwaysBounceHorizontal:NO];
        [_originCollectionView setShowsVerticalScrollIndicator:NO];
        [_originCollectionView setShowsHorizontalScrollIndicator:NO];
        [_originCollectionView setScrollEnabled:YES];
        [_originCollectionView setPagingEnabled:YES];
        [_originCollectionView setBackgroundColor:[UIColor clearColor]];
        [_originCollectionView registerClass:[PhotoBrowerOriginCell class] forCellWithReuseIdentifier:@"PhotoBrowerOriginCell"];
    }
    return _originCollectionView;
}
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.0;
    }
    return _backView;
}
- (UICollectionViewFlowLayout *)originLayout
{
    if (!_originLayout) {
        _originLayout = [[UICollectionViewFlowLayout alloc]init];
        _originLayout.itemSize = CGSizeMake(ScreenW,ScreenH);
        _originLayout.minimumLineSpacing = 0.0;
        _originLayout.minimumInteritemSpacing = 0.0;
        [_originLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _originLayout;
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark -- UICollectionViewDataSource
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger num = self.dataSource.count;
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FuliModel * item = self.dataSource[indexPath.item];
    NSURL * url = [NSURL URLWithString:item.url];
    
    if (collectionView == self.collectionView) {
        PhotoBrowerBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoBrowerThumbCell" forIndexPath:indexPath];
        [cell.imageView setImageWithURL:url];
        return cell;
    } else {
        PhotoBrowerBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoBrowerOriginCell" forIndexPath:indexPath];
        NSArray <NSIndexPath *>* indexpaths = [self.collectionView indexPathsForVisibleItems];
        BOOL exits = false;
        NSEnumerator * enu = [indexpaths objectEnumerator];
        NSIndexPath * index;
        while ((index = [enu nextObject])) {
            if ((index.section == indexPath.section)&&(index.row == indexPath.row)) {
                exits = true;
                break;
            }
        }
        if (!exits) {
            if (indexPath.item < [indexpaths firstObject].item) {
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            } else {
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            }
        }
        [cell.imageView setImageWithURL:url];
        [(PhotoBrowerOriginCell*)cell reuse];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.originCollectionView reloadData];
    [self imageWillAppearWithIndex:indexPath];
}

- (void)imageWillAppearWithIndex:(NSIndexPath*)indexPath
{
    PhotoBrowerBaseCell * cell = (PhotoBrowerBaseCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell.imageView.image == nil) {
        return;
    }
    CGRect rect = [self.collectionView convertRect:cell.frame toView:self.view];
    self.imageView.image = cell.imageView.image;
    self.imageView.frame = rect;
    self.imageView.hidden = NO;
    self.backView.alpha = 0.0;
    
    [self.originCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = CGRectMake(0, (ScreenH - ScreenW * self.imageView.image.size.height / self.imageView.image.size.width ) / 2, ScreenW, ScreenW * self.imageView.image.size.height / self.imageView.image.size.width );
        self.backView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.imageView.hidden = YES;
        self.backView.alpha = 0.0;
        self.originCollectionView.hidden = NO;
    }];
}
- (void)imageWillDisappear:(NSIndexPath*)indexPath
{
    PhotoBrowerBaseCell * cell = (PhotoBrowerBaseCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = [self.collectionView convertRect:cell.frame toView:self.view];
    self.imageView.image = cell.imageView.image;
    self.imageView.frame = CGRectMake(0, (ScreenH - ScreenW * self.imageView.image.size.height / self.imageView.image.size.width ) / 2, ScreenW, ScreenW * self.imageView.image.size.height / self.imageView.image.size.width );
    self.imageView.hidden = NO;
    
    self.backView.alpha = 1.0;
    
    self.originCollectionView.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = rect;
        self.backView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.imageView.hidden = YES;
        self.backView.alpha = 0.0;
        
    }];
}
#pragma mark - private
- (void)backClick{
    if (self.originCollectionView.hidden) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self imageWillDisappear:self.originCollectionView.indexPathsForVisibleItems.lastObject];
}
#pragma mark - NetWork
- (void)getData{
    NSInteger num = 21;
    NSString * categ = [@"福利"stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLHostAllowedCharacterSet];
    NSString * url = [NSString stringWithFormat:@"http://gank.io/api/data/%@/%zd/%zd",categ,num,(self.page + 1)];
    if (!self.page) {
        [SVProgressHUD showWithStatus:@"一大波美女正在袭来..."];
    }
    [[HttpProcessEngine shareHttpEngine] sendURLString:url processMethod:HTTPSendMethodType_GET parameters:nil successJsonRequestBlocks:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:@"error"] integerValue] == 0) {
            NSArray * arr = [FuliModel jl_modelsWithDictionaryArray:[responseObject valueForKey:@"results"]];
            [self.dataSource addObjectsFromArray:arr];
            
            [self.collectionView reloadData];

     
            if (!self.page) {
                [SVProgressHUD dismiss];
            }
            self.page++;
            [self.collectionView.mj_footer endRefreshing];
        }
    } failedJsonRequestBlocks:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}
@end
