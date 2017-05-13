//
//  UIWebVC.m
//  demo
//
//  Created by 刘永生 on 2017/5/13.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import "UIWebVC.h"

#import <Masonry.h>


@interface UIWebVC ()

@property (nonatomic, strong) UIWebView *mWebview;/**<  */

@end

@implementation UIWebVC

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
    
    
    self.title = @"UIWebview";
    
}


#pragma mark - proprety


- (UIWebView *)mWebview {
    
    if(!_mWebview){
        _mWebview = [[UIWebView alloc]init];
    }
    return _mWebview;
    
}



@end
