//
//  MKWebVC.m
//  demo
//
//  Created by 刘永生 on 2017/5/13.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import "WKWebVC.h"


#import <Masonry.h>

#import "LYSWKWebManager.h"


@interface WKWebVC () <WKUIDelegate,WKNavigationDelegate,LYSWKWebDelegate> {
    
    WKUserContentController * _userContentController;;
    
}


@property (nonatomic, strong) WKWebView *mWebview;/**<  */

@end

@implementation WKWebVC


- (void)dealloc {
    NSLog(@"释放---MKWebVC");
    
    //这里需要注意，前面增加过的方法一定要remove掉。
    [_userContentController removeScriptMessageHandlerForName:@"toast"];
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
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:4000/2017/05/13/APP-web-and-JS/demo.html"]];
    
    [self.mWebview loadRequest:request];
    
}

#pragma mark - WKUIDelegate

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSLog(@"请求接口:%@",navigationResponse.response.URL);
    
    NSURL *URL = navigationResponse.response.URL;
    
    
    /**
     url接口拦截
     */
    if ([URL.scheme isEqualToString:@"native"]) {
        
        if ([URL.host isEqualToString:@"toast"]) {
            
            NSLog(@"toast 的参数:%@",URL.query);
            
            // 不允许跳转
            decisionHandler(WKNavigationResponsePolicyCancel);

        }
    }
    // 允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);

    
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"请求接口:%@",navigationAction.request.URL);
    
    NSURL *URL = navigationAction.request.URL;
    
    /**
     url接口拦截
     */
    if ([URL.scheme isEqualToString:@"native"]) {
        
        if ([URL.host isEqualToString:@"toast"]) {
            
            NSLog(@"toast 的参数:%@",URL.query);
            
            // 不允许跳转
            decisionHandler(WKNavigationActionPolicyCancel);
            
        }
    }
    // 允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    

    NSLog(@"%s",__func__);
    
    
    [webView evaluateJavaScript:@"document.getElementById(\"lcfarmlogo\").style.visibility=\"hidden\";" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
    }];
    
    
}

#pragma mark - LYSWKWebDelegate

- (void)lysWKWeb_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"%@-------%@",userContentController,message);
    
}



#pragma mark - proprety


- (WKWebView *)mWebview {
    
    if(!_mWebview){
        
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        _userContentController =[[WKUserContentController alloc]init];
        configuration.userContentController = _userContentController;
        _mWebview = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
        
        _mWebview.UIDelegate = self;
        _mWebview.navigationDelegate = self;
        
        //注册方法
        LYSWKWebManager * delegateController = [[LYSWKWebManager alloc]init];
        delegateController.delegate = self;
        
        [_userContentController addScriptMessageHandler:delegateController name:@"toast"];

        
    }
    return _mWebview;
    
}








@end
