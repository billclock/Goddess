//
//  GanhuoController.m
//  Goddess
//
//  Created by wangyan on 2016－03－21.
//  Copyright © 2016年 Goddess. All rights reserved.
//

#import "GanhuoController.h"
#import "GanhuoModel.h"

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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
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
    GanhuoModel * item = self.dataSource[indexPath.row];
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

}
#pragma mark -- TableView datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    GanhuoModel * item = self.dataSource[indexPath.row];
    cell.textLabel.text = item.desc;
    return cell;
}
#pragma mark - NetWork
- (void)getData{
    NSInteger num = 21;
    NSString * categ = @"all";
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
