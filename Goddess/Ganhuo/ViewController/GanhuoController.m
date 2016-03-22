//
//  GanhuoController.m
//  Goddess
//
//  Created by wangyan on 2016－03－21.
//  Copyright © 2016年 Goddess. All rights reserved.
//

#import "GanhuoController.h"
#import "GanhuoModel.h"
#import "GanhuoNormalCell.h"
#import "GHWebViewController.h"

@interface GanhuoController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,assign) NSInteger page;
@end

@implementation GanhuoController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self addConstraints];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark -- getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"GanhuoNormalCell" bundle:nil] forCellReuseIdentifier:@"GanhuoNormalCell"];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
#pragma mark -- TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GanhuoModel * item = self.dataSource[indexPath.row];
    GHWebViewController * gwc = [[GHWebViewController alloc]initWithURLToLoad:[NSURL URLWithString:item.url]];
    [self.parentViewController.navigationController pushViewController:gwc animated:YES];
}
#pragma mark -- TableView datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GanhuoNormalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GanhuoNormalCell" forIndexPath:indexPath];
    GanhuoModel * item = self.dataSource[indexPath.row];
    cell.titleLabel.text = item.desc;
    cell.nickNameLabel.text = item.who;
    return cell;
}
#pragma mark - NetWork
- (void)getData{
    NSInteger num = 21;
    NSString * categ = [self.attributes[@"name"] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLHostAllowedCharacterSet];
    NSString * url = [NSString stringWithFormat:@"http://gank.io/api/data/%@/%zd/%zd",categ,num,(self.page + 1)];
    if (!self.page) {

    }
    [[HttpProcessEngine shareHttpEngine] sendURLString:url processMethod:HTTPSendMethodType_GET parameters:nil successJsonRequestBlocks:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:@"error"] integerValue] == 0) {
            NSArray * arr = [GanhuoModel jl_modelsWithDictionaryArray:[responseObject valueForKey:@"results"]];
            [self.dataSource addObjectsFromArray:arr];
            
            [self.tableView reloadData];
            
            if (!self.page) {
                [SVProgressHUD dismiss];
            }
            self.page++;
            [self.tableView.mj_footer endRefreshing];
        }
    } failedJsonRequestBlocks:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}
@end
