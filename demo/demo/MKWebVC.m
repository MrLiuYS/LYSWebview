//
//  MKWebVC.m
//  demo
//
//  Created by 刘永生 on 2017/5/13.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import "MKWebVC.h"


#import <Masonry.h>

#import <WebKit/WebKit.h>


@interface MKWebVC () <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>


@property (nonatomic, strong) WKWebView *mWebview;/**<  */

@end

@implementation MKWebVC


- (void)dealloc {
    NSLog(@"释放---MKWebVC");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
}


- (void)initUI {
    
    [self.view addSubview:self.mWebview];
    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    
    [self.mWebview mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
}

- (void)initData {
    
    self.title = @"WKWebview";
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mrliuys.github.io/2017/05/13/APP-web-and-JS/js.html"]];
    
    [self.mWebview loadRequest:request];
    
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    
    
    
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"%@-------%@",userContentController,message);
    
}



#pragma mark - proprety


- (WKWebView *)mWebview {
    
    if(!_mWebview){
        _mWebview = [[WKWebView alloc]init];
    }
    return _mWebview;
    
}


@end
