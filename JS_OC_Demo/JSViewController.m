//
//  JSViewController.m
//  JS_OC_Demo
//
//  Created by Mjwon on 2017/1/13.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "JSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ManObject.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN [UIScreen mainScreen].bounds

@interface JSViewController ()<UIWebViewDelegate>

@property (nonatomic ,strong) UIWebView *webView;

@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _webView.delegate = self;
    [_webView loadRequest:[self isLocal:YES]];
    [self.view addSubview:_webView];
    [self createJSContext];
    
    [self createItem];

}
-(NSURLRequest *)isLocal:(BOOL)b{
    
    NSString *string = b?@"http://192.168.31.27:8099/#!/keypoint":@"http://www.baidu.com";
    /**
     
     NSURLRequestUseProtocolCachePolicy
     默认的缓存策略，其行为是由协议指定的针对该协议最好的实现方式。
     
     NSURLRequestReloadIgnoringCacheData
     从服务端加载数据，完全忽略缓存。
     
     NSURLRequestReturnCacheDataElseLoad
     使用缓存数据，忽略其过期时间；只有在没有缓存版本的时候才从源端加载数据。
     
     NSURLRequestReturnCacheDataDontLoad
     只使用cache数据，如果不存在cache，请求失败；用于没有建立网络连接离线模式
     
     */
    NSURL *url = [NSURL URLWithString:string];
    return [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
}
-(void)createJSContext{
    
    // 通过UIWebView获得网页中的JavaScript执行环境
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 设置处理异常的block回调
    [context setExceptionHandler:^(JSContext *ctx, JSValue *value) {
        NSLog(@"error: %@", value);
    }];
    ManObject *man = [[ManObject alloc] init];
    context[@"iOS"] = man;
    
}

-(void)createItem{
    
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftbtn.frame = CGRectMake(0, 0, 50, 23);
    [leftbtn setTitle:@"< 返回" forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightbtn.frame = CGRectMake(0, 0, 50, 23);
    [rightbtn setTitle:@"刷新" forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = rightItem;

}
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)action{

//    [_webView loadRequest:[self isLocal:YES]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.31.27:82/#!/keypoint"]]];
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
    NSLog(@"URL:%@",address);
    
    
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"请求失败：%@",error);
}

-(void)dealloc{
    //清除请求
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    [_webView stopLoading];
    _webView.delegate = nil;
    _webView = nil;
    
    NSLog(@"我被释放了!");
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
