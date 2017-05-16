//
//  UIWebVC.m
//  demo
//
//  Created by 刘永生 on 2017/5/13.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import "UIWebVC.h"

#import <Masonry.h>

#import "LYSWebManager.h"


@interface UIWebVC () <UIWebViewDelegate,LYSWebManagerDelegate>

@property (nonatomic, strong) UIWebView *mWebview;/**<  */

@end

@implementation UIWebVC

- (void)dealloc {
    NSLog(@"释放---UIWebVC");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [LYSWebManager lys_Web_Delegate:self];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [LYSWebManager lys_Web_Delegate:nil];
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
    
    self.title = @"UIWebview";
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mrliuys.github.io/2017/05/13/APP-web-and-JS/js.html"]];
    
    [self.mWebview loadRequest:request];
    
}



#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [LYSWebManager lys_Web_Set:webView];
    
    
    
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    
    
}


#pragma mark - LYSWebManagerDelegate

- (void)lys_Web_handleToast:(NSString *)toast {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"toast"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                
                                                NSLog(@"点击了确定按钮");
                                                
                                            }]];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


#pragma mark - proprety


- (UIWebView *)mWebview {
    
    if(!_mWebview){
        _mWebview = [[UIWebView alloc]init];
        _mWebview.delegate = self;
    }
    return _mWebview;
    
}



@end
