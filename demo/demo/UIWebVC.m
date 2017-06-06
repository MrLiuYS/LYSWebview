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

@property (nonatomic, assign) BOOL isFirst;/**< 首次加载 */

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
    
    self.isFirst = YES;
    

    
    if (self.urlString && self.urlString.length > 0) {
        
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        
        [self.mWebview loadRequest:request];
        
    }else {
        
        
        
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:4000/2017/05/13/APP-web-and-JS/demo.html"]];
        
//            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mrliuys.github.io/2017/05/13/APP-web-and-JS/demo.html"]];
       
//        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
        
        [self.mWebview loadRequest:request];
        
    }
    
    

    
}



#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"%s",__func__);
    
    NSLog(@"请求接口:%@",request.URL);
 
    NSURL *URL = request.URL;
    
    
    /**
     url接口拦截
     */
    if ([URL.scheme isEqualToString:@"native"]) {
        
        if ([URL.host isEqualToString:@"toast"]) {
            
            NSLog(@"toast 的参数:%@",URL.query);
            
            return NO;
        }
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"%s",__func__);
    
    
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    /**
     初始化context
     */
    [LYSWebManager lys_Web_Set:webView];
    
    /**
     执行js脚本
     */
    [LYSWebManager lys_Web_EvaluateScript:@"document.getElementById(\"lcfarmlogo\").style.visibility=\"hidden\";"];

    
    NSLog(@"%s",__func__);
    
}

//OC直接调用js.隐藏H5的属性
//stringByEvaluatingJavaScriptFromString ,进行OC调用js
//    [webView stringByEvaluatingJavaScriptFromString:@"$(\"#logo\").hide();"];


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"%s",__func__);
    
}


#pragma mark - LYSWebManagerDelegate

- (void)lys_Web_handleToast:(NSString *)toast {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:toast
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
