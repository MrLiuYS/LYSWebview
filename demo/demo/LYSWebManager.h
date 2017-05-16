//
//  LYSWebManager.h
//  demo
//
//  Created by 刘永生 on 2017/5/15.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol LYSJSExport <JSExport>

JSExportAs
(toast  /** handleToast 作为js方法的别名 */,
 - (void)handleToast:(NSString *)toast
 );

@end

@protocol LYSWebManagerDelegate <NSObject>

@optional
- (void)lys_Web_handleToast:(NSString *)toast;


@end

@interface LYSWebManager : NSObject <LYSJSExport>


@property (nonatomic, assign) id <LYSWebManagerDelegate> webDelegate;


@property (strong, nonatomic) JSContext *context;


/**
 协议的配置
 */
+ (void)lys_Web_Delegate:(id)delegate;

/**
 配置webview的数据
 */
+ (void)lys_Web_Set:(UIWebView *)webView;






@end
