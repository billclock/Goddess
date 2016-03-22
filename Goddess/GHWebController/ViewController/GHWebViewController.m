//
//  APNSWebViewController.m
//  KuaiJiZP
//
//  Created by CHEN on 14-8-20.
//  Copyright (c) 2014年 CHEN. All rights reserved.
//
#define THEMEBLUE COLOR(4,138,229,1)

#define TINTBARCOLOR COLOR(25,90,204,1)
#define BACKCOLOR [UIColor whiteColor]

#define FONTCOLOR [UIColor whiteColor]
#define BORDERCOLOR [UIColor clearColor]
#define BUTTONTITLECOLOR [UIColor colorWithRed:4/255.0 green:138/255.0 blue:229/255.0 alpha:1]
#define BUTTONCOLOR [UIColor whiteColor]

#define FONTSIZE SC(19.0)

#define INPUTVIEW_HEIGHT 150


#import "GHWebViewController.h"

@interface GHWebViewController()<UIWebViewDelegate>{
    NSURL * weburl;
}
@property (nonatomic , strong) UIWebView * webView;
@end
@implementation GHWebViewController
-(id)initWithURLToLoad:(NSURL *)url
{
    self = [self init];
    if (self) {
        weburl = url;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKCOLOR;
//    self.navigationBar.barTintColor = TINTBARCOLOR;
//    self.navigationBar.translucent = NO;
//    self.title = @"网页";
//    UILabel * label = (UILabel * )self.titleView;
//    label.textColor = [UIColor whiteColor];
//    
//    UIButton * leftBtn = [UIButton buttonWithImageName:@"account_cancle"];
//    [leftBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    self.leftBarBtn = leftItem;
    
    [self addViewsConstraint];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:weburl]];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addViewsConstraint
{
    UIView * superView = self.view;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).with.offset(0);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.bottom.equalTo(superView);
    }];
    
}
#pragma mark getter and setter
- (UIWebView *)webView
{
    if (!_webView ) {
        _webView  = [[UIWebView  alloc]init];
        _webView.delegate = self;
    }
    return _webView ;
}
#pragma mark Method
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UIWEBViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
}
@end
