//
//  MainContentController.m
//  Goddess
//
//  Created by wangyan on 2016－03－18.
//  Copyright © 2016年 Goddess. All rights reserved.
//

#import "MainContentController.h"
#import "TopTabBarView.h"
@interface MainContentController ()

@end

@implementation MainContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:[[TopTabBarView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, 100)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
