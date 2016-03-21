//
//  MainContentController.m
//  Goddess
//
//  Created by wangyan on 2016－03－18.
//  Copyright © 2016年 Goddess. All rights reserved.
//

#import "MainContentController.h"
#import "TopTabBarView.h"
@interface MainContentController ()<TopTabBarViewDelegate>
@property (nonatomic,strong) TopTabBarView * tabBar;
@property (nonatomic,strong) UIScrollView * scrollContentView;
@property (nonatomic,strong) NSArray *configArray;
@end

@implementation MainContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"GANK.IO";
    self.configArray = @[@{@"class":@"GanhuoController",
                                @"name":@"all"},
                              @{@"class":@"GanhuoController",
                                @"name":@"iOS"},
                              @{@"class":@"GanhuoController",
                                @"name":@"Android"},
                              @{@"class":@"GirlsViewController",
                                @"name":@"福利"},
                              @{@"class":@"GanhuoController",
                                @"name":@"休息视频"},
                              @{@"class":@"GanhuoController",
                                @"name":@"拓展资源"},
                              @{@"class":@"GanhuoController",
                                @"name":@"前端"}
                                        ];
    [self.view addSubview:self.tabBar];
    [self.view addSubview:self.scrollContentView];
    
    [self addConstraints];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addConstraints
{
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
        make.height.equalTo(@30);
    }];
    
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.tabBar.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (TopTabBarView *)tabBar
{
    if (!_tabBar) {
        _tabBar = [[TopTabBarView alloc] initWithItems:@"干货",@"iOS",@"Android",@"福利",@"休息视频",@"拓展资源",@"前端", nil];
        _tabBar.delegate = self;
    }
    return _tabBar;
}
- (UIScrollView *)scrollContentView
{
    if (!_scrollContentView) {
        _scrollContentView = [[UIScrollView alloc]init];
        _scrollContentView.scrollEnabled = NO;
        for (int i = 0; i < self.configArray.count; i++) {
            NSDictionary * configItem = self.configArray[i];
            NSString * className = configItem[@"class"];
            Class vClass = NSClassFromString(className);
            UIViewController * vc = [[vClass alloc]init];
            vc.view.frame = CGRectMake(i * ScreenW, 0, ScreenW, ScreenH - 110);
            [self addChildViewController:vc];
            [self.scrollContentView addSubview:vc.view];
        }
        _scrollContentView.contentSize = CGSizeMake(ScreenW * self.configArray.count, 0);
    }
    return _scrollContentView;
}
- (void)tabBarDidClickDuplicate:(TopTabBarView *)tabBarView index:(NSInteger)index
{
    
}
- (void)tabBarDidSelect:(TopTabBarView *)tabBarView index:(NSInteger)index
{
    [self.scrollContentView setContentOffset:CGPointMake(ScreenW * index, 0) animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
