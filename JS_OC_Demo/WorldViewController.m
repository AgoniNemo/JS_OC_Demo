//
//  WorldViewController.m
//  JS_OC_Demo
//
//  Created by Mjwon on 2017/1/4.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "WorldViewController.h"
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSExportDelegate.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN [UIScreen mainScreen].bounds

@interface WorldViewController ()<UIWebViewDelegate,JSExportDelegate>

@property (nonatomic ,strong) UIWebView *webView;

@end

@implementation WorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"text"ofType:@"html"];
    NSURL *rul = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:rul];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _webView.delegate = self;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    [self createJSContext];
    
    [self createItem];
    
}

#pragma mark - UIWebView

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s",__func__);
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s",__func__);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString * address = request.URL.absoluteString;
    NSLog(@"jScript:%@",address);
    
    return YES;
}

-(void)createItem{
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightbtn.frame = CGRectMake(0, 0, 50, 23);
    [rightbtn setTitle:@"右点击" forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftbtn.frame = CGRectMake(0, 0, 50, 23);
    [leftbtn setTitle:@"左点击" forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)backAction{
    
    NSLog(@"%s",__func__);
}

-(void)action{
    
    NSLog(@"%s",__func__);
}

-(void)createJSContext{
    
    // 通过UIWebView获得网页中的JavaScript执行环境
    JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 设置处理异常的block回调
    [context setExceptionHandler:^(JSContext *ctx, JSValue *value) {
        NSLog(@"error: %@", value);
    }];
    
    context[@"iOS"] = self;
    
}
-(NSString *)getAccessToken
{
    return @"这就是传说中的Token";
}
-(NSString *)getPath
{
    NSString * jsPath = [[NSBundle mainBundle] pathForResource:@"index"ofType:@"js"];
    NSLog(@"jsPath:%@",jsPath);
    return jsPath;
}
-(void)run
{
    NSLog(@"%s",__func__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
