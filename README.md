## UIWebview的基本用法

UIWebview提供的方法不多.

加载页面的方法有这三个.

```
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;
```

提供的一些基本的方法有

```
- (void)reload;
- (void)stopLoading;

- (void)goBack;
- (void)goForward;
```

如果需要监听网页加载的结果.需要设置webview的delegate

```
__TVOS_PROHIBITED @protocol UIWebViewDelegate <NSObject>

@optional
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end
```

## UIWebview中OC调用js

### 1.stringByEvaluatingJavaScriptFromString

通过`stringByEvaluatingJavaScriptFromString`可以让OC调用js的函数方法

```
NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    
[self.mWebview loadRequest:request];
```

```
[webView stringByEvaluatingJavaScriptFromString:@"$(\"#logo\").hide();"];
```

当调用以上方法.可以直接隐藏掉百度首页的logo

### 2.JavaScriptCore


```
#pragma mark - 初始化context
+ (void)lys_Web_Set:(UIWebView *)webView {
    
    [LYSWebManager sharedManager].context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
}

#pragma mark - 调用js的方法
+ (void)lys_Web_EvaluateScript:(NSString *)script {
    
    if ([LYSWebManager sharedManager].context) {
        
        [[LYSWebManager sharedManager].context evaluateScript:script];
        
    }else {
        
        NSLog(@"不存在context对象,执行lys_Web_Set");
    }
    
}
```

```
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    /**
     初始化context
     */
    [LYSWebManager lys_Web_Set:webView];
    
    /**
     执行js脚本
     */
    [LYSWebManager lys_Web_EvaluateScript:@"$(\"#logo\").hide();"];
    
}
```

## UIWebview中js调用OC

### 1.url拦截

每次url连接调转都会调用

```
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:
```

比如:

```
<a href=native://toast?message="我是气泡">测试</a>
```

H5页面点击跳转native://toast?message="我是气泡"


```
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"%s",__func__);
    
    NSLog(@"请求接口:%@",request.URL);
 
    NSURL *URL = request.URL;
    if ([URL.scheme isEqualToString:@"native"]) {
        
        if ([URL.host isEqualToString:@"toast"]) {
            
            NSLog(@"toast 的参数:%@",URL.query);
            
            return NO;
        }
    }
    
    return YES;
}
```

通过url接口拦截到native://toast?message="我是气泡,然后解析数据

### 2.JavaScriptCore

js的方法映射

```
JSExportAs
(toast  /** handleToast 作为js方法的别名 */,
 - (void)handleToast:(NSString *)toast
 );
```
将js的toast方法映射为OC方法handleToast


```
#pragma mark - 初始化context
+ (void)lys_Web_Set:(UIWebView *)webView {
    
    [LYSWebManager sharedManager].context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [LYSWebManager sharedManager].context[@"native"] = [LYSWebManager sharedManager];
    
    [[LYSWebManager sharedManager].context setExceptionHandler:^(JSContext *context, JSValue *exception){
        NSLog(@"oc->js 异常: %@", exception);
    }];
}
```

```
- (void)handleToast:(NSString *)toast {
    
    NSLog(@"js->OC回调:%@",toast);
}
```

当H5调用

```
native.toast('我是气泡');
```

就会进入OC里面的handleToast方法


## WKWebview(iOS 8+)的基本用法

WKWebview比UIWebview的优势有

*   更多的支持HTML5的特性
*   官方宣称的高达60fps的滚动刷新率以及内置手势
*   将UIWebViewDelegate与UIWebView拆分成了14类与3个协议,以前很多不方便实现的功能得以实现。
*   Safari相同的JavaScript引擎
*   占用更少的内存
*   可以获取加载进度：estimatedProgress（UIWebView需要调用私有Api）


创建WKWebview

```
/*! @abstract Returns a web view initialized with a specified frame and
 configuration.
 @param frame The frame for the new web view.
 @param configuration The configuration for the new web view.
 @result An initialized web view, or nil if the object could not be
 initialized.
 @discussion This is a designated initializer. You can use
 @link -initWithFrame: @/link to initialize an instance with the default
 configuration. The initializer copies the specified configuration, so
 mutating the configuration after invoking the initializer has no effect
 on the web view.
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
```

加载方法

```
- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request;

- (nullable WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL API_AVAILABLE(macosx(10.11), ios(9.0));

- (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

- (nullable WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL API_AVAILABLE(macosx(10.11), ios(9.0));
```

跟UIWebview基本一致.在iOS 9新增加了两个方法

## WKWebview中OC调用js

通过实现oc调用js

```
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;
```

```
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.getElementById(\"lcfarmlogo\").style.visibility=\"hidden\";" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
    }];
    
    NSLog(@"%s",__func__);
    
}
```
当调用以上方法.可以直接隐藏掉百度首页的logo

## UIWebview中js调用OC

### 1.url拦截



```
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
```

比如:

```
<a href=native://toast?message="我是气泡">测试</a>
```

H5页面点击跳转native://toast?message="我是气泡"

通过url接口拦截到native://toast?message="我是气泡,然后解析数据


### 2.scriptMessageHandler

```
/*! @abstract Adds a script message handler.
 @param scriptMessageHandler The message handler to add.
 @param name The name of the message handler.
 @discussion Adding a scriptMessageHandler adds a function
 window.webkit.messageHandlers.<name>.postMessage(<messageBody>) for all
 frames.
 */
- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;

/*! @abstract Removes a script message handler.
 @param name The name of the message handler to remove.
 */
- (void)removeScriptMessageHandlerForName:(NSString *)name;
```

```
window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
```


创建WKWebView时,注册方法

```
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
```

配置回调方法


```
#import "LYSWKWebManager.h"

@implementation LYSWKWebManager

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([self.delegate respondsToSelector:@selector(lysWKWeb_userContentController:didReceiveScriptMessage:)]) {
        [self.delegate lysWKWeb_userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
```

H5调用以下方法就能实现js->OC的调用

```
window.webkit.messageHandlers.toast.postMessage({body: '我是气泡'});
```


-------

总结

本文主要简单说明UIWebview和WKWebview的基本用法,OC->JS,JS->OC 的方法使用.
 WKWebview没有找到获取document的方法.感觉上会比UIWebview加载快速,检查内存也会比UIWebview占用少.如果已经放弃iOS 7,建议还是使用WKWebview.


