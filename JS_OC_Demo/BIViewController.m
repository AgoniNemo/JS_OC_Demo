//
//  BIViewController.m
//  JS_OC_Demo
//
//  Created by Mjwon on 2017/1/2.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "BIViewController.h"
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WeakScriptMessageDelegate.h"
#import "JSExportDelegate.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN [UIScreen mainScreen].bounds

@interface BIViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,JSExportDelegate>

@property (nonatomic ,strong) UIWebView *webView;
@property (nonatomic ,strong) WKWebView *webview;

@end

@implementation BIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self isUIWebView:YES];
    
    [self createItem];
    
    [self createJSContext];
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
    return @"fejislajflajifjeilsanf";
}
-(void)run
{
    NSLog(@"%s",__func__);
}

-(void)isUIWebView:(BOOL)is{

    if (is) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _webView.delegate = self;
        [_webView loadRequest:[self isLocal:NO]];
        
        [self.view addSubview:_webView];
    }else{
    
        _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        [_webview loadRequest:[self isLocal:YES]];
        
        [[_webview configuration].userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"AppModel"];
        
        [self.view addSubview:_webView];
    }
    

}
-(NSURLRequest *)isLocal:(BOOL)is{
    
    if (is) {
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"text"ofType:@"html"];
        NSURL *rul = [NSURL fileURLWithPath:htmlPath];
        return [NSURLRequest requestWithURL:rul];
    }else{
        NSURL *url = [NSURL URLWithString:@"http://192.168.31.27:82/#!/cb"];
        return [NSURLRequest requestWithURL:url];
    }
}

-(void)createItem{
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightbtn.frame = CGRectMake(0, 0, 50, 23);
    [rightbtn setTitle:@"点击" forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftbtn.frame = CGRectMake(0, 0, 50, 23);
    [leftbtn setTitle:@"点击" forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)backAction{
    
//    [_webView goBack];

//    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)action{
    
//    NSString *jsToGetHTMLSource = @"document.documentElement.innerHTML";
//    
//    [_webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable string, NSError * _Nullable error) {
//        
//        //js返回值
//        NSLog(@"%@  error:%@",string,error);
//    }];
}

#pragma mark - UIWebView

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s",__func__);
//    NSString *jsToGetHTMLSource = @"click(\"这是第一个鬼!\")";
//    
//    NSString *html =  [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
//    
//    NSLog(@"html:%@",html);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
//    NSString *jsToGetHTMLSource = @"click(\"这是什么鬼!\")";
//    
//    NSString *html =  [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
//    
//    NSLog(@"html:%@",html);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSString * address = request.URL.absoluteString;
    NSLog(@"jScript:%@",address);
    
//    NSString * jsPath = @"index.js";
//                         
//    NSString *jScript = [NSString stringWithFormat:@"var script = document.createElement('script'); \
//                                                  script.type = 'text/javascript'; \
//                                                  script.src = '%@';\
//                                                  var head = document.getElementsByTagName('head')[0];\
//                                                  head.appendChild(script);",jsPath];
//    
//    NSString *html =  [webView stringByEvaluatingJavaScriptFromString:jScript];
//    
//    NSLog(@"jScript:%@",html);
    
    return YES;
}
#pragma mark WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"%@", message);   //js的alert框的message
}

#pragma mark- WKNavigationDelegate

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    
    //如果需要回调，直接调用OC调用JS的方法
}

//开始
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__func__);
    
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    NSLog(@"%s",__func__);
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSLog(@"%s",__func__);
    
    NSString *jsToGetHTMLSource = @"document.documentElement.innerHTML";
    
    [webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        //js返回值
        NSLog(@"%@  error:%@",string,error);
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
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
