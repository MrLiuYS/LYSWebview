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


## WKWebview的基本用法










# UIWebview/WKWebview原生跟JS的使用交互

混编是一直能抓老鼠的猫.这里就不讲混编的好处与缺点了.只讲Web怎么通过JS跟native进行交互.





## JavaScriptCore

JavaScriptCore是从iOS7引入的,通过JavaScriptCore,可以让JS调用native,让native调用JS. 实现混编的功能. 

### UIWebView和JS的交互

想要通过UIWebView实现web和native的交互,就要借助JavaScriptCore. 

## WKWebView的使用

### 二.WKWebView基本用法

### WKWebView和JS的交互

## UIWebView和WKWebView的比较

## Cookie的使用


