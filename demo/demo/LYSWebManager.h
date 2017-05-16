//
//  LYSWebManager.h
//  demo
//
//  Created by 刘永生 on 2017/5/15.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol LYSJSExport <JSExport>

JSExportAs
(openView  /** handleOpenView 作为js方法的别名 */,
 - (void)handleOpenView:(NSString *)aType
 );

@end



@interface LYSWebManager : NSObject






@end
