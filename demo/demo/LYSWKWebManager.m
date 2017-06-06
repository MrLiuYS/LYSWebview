//
//  LYSWKWebManager.m
//  demo
//
//  Created by 刘永生 on 2017/6/6.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import "LYSWKWebManager.h"

@implementation LYSWKWebManager

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([self.delegate respondsToSelector:@selector(lysWKWeb_userContentController:didReceiveScriptMessage:)]) {
        [self.delegate lysWKWeb_userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
