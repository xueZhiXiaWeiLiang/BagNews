//
//  JWWebViewController.m
//  BagNews
//
//  Created by 微凉 on 16/4/26.
//  Copyright © 2016年 微凉. All rights reserved.
//

#import "JWWebViewController.h"
#import <WebKit/WebKit.h>

@interface JWWebViewController ()

@end

@implementation JWWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *web = [[WKWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.view addSubview:web];
    [web loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
@end
