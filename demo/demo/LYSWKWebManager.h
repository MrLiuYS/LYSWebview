//
//  LYSWKWebManager.h
//  demo
//
//  Created by 刘永生 on 2017/6/6.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <WebKit/WebKit.h>

@protocol LYSWKWebDelegate <NSObject>

- (void)lysWKWeb_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end


@interface LYSWKWebManager : NSObject <WKScriptMessageHandler>


@property (weak , nonatomic) id<LYSWKWebDelegate> delegate;

@end
