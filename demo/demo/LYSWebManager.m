//
//  LYSWebManager.m
//  demo
//
//  Created by 刘永生 on 2017/5/15.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import "LYSWebManager.h"

@implementation LYSWebManager

+ (LYSWebManager *)sharedManager
{
    static LYSWebManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (!sharedInstance) {
            sharedInstance = [[LYSWebManager alloc] init];
        }
    });
    return sharedInstance;
}


+ (void)lys_Web_Delegate:(id)delegate {
    
    [LYSWebManager sharedManager].webDelegate = delegate;
    
}

+ (void)lys_Web_Set:(UIWebView *)webView {
    
    [LYSWebManager sharedManager].context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [LYSWebManager sharedManager].context[@"native"] = [LYSWebManager sharedManager];
    
}


- (void)handleToast:(NSString *)toast {
    
    NSLog(@"web回调:%@",toast);
    
    if ([_webDelegate respondsToSelector:@selector(lys_Web_handleToast:)]) {
        [_webDelegate lys_Web_handleToast:toast];
    }
    
}





@end
