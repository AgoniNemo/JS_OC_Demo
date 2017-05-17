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
#import "ManObject.h"


#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN [UIScreen mainScreen].bounds

@interface BIViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic ,strong) UIWebView *webView;
@property (nonatomic ,strong) WKWebView *webview;

@property (nonatomic ,assign) ManObject *obj;

@end

@implementation BIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self isUIWebView:NO];
    
    [self createItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}
-(void)createJSContext{

    // 通过UIWebView获得网页中的JavaScript执行环境
    JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 设置处理异常的block回调
    [context setExceptionHandler:^(JSContext *ctx, JSValue *value) {
        NSLog(@"error: %@", value);
    }];
    ManObject *man = [[ManObject alloc] init];
    context[@"iOS"] = man;
    
}
-(NSString *)getAccessToken
{
    return @"bbe30cfa-34cf-4bd9-a31b-7bf58affaa6b";
}

-(void)isUIWebView:(BOOL)is{

    if (is) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _webView.delegate = self;
        [_webView loadRequest:[self isLocal:YES isUIWebView:is]];
        
        [self.view addSubview:_webView];
        [self createJSContext];
    }else{

        /**
         等同
         <script>
         window.webkit.messageHandlers.iOS.postMessage(null);
         </script>
         
         NSString *jScript = @"var spt = document.createElement('script'); \
         spt.value = window.webkit.messageHandlers.iOS.postMessage(null); \
         var head = document.getElementsByTagName('head')[0];\
         head.appendChild(spt);";
         localStorage.setItem("accessToken",'6e1afff7-7a99-4ef7-9719-0401ed98f5db');
         window.iosORandroid.getAccessToken(\"%@\");
         */
        
         NSString *sendToken = [NSString stringWithFormat:@"localStorage.setItem(\"accessToken\",'%@');",@"74851c23358c"];
        
        //WKUserScriptInjectionTimeAtDocumentStart：js加载前执行。
        //WKUserScriptInjectionTimeAtDocumentEnd：js加载后执行。
        //下面的injectionTime配置不要写错了
        //forMainFrameOnly:NO(全局窗口)，yes（只限主窗口）
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:sendToken injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        //配置js(这个很重要，不配置的话，下面注入的js是不起作用的)
        //WeakScriptMessageDelegate这个类是用来避免循环引用的
        [config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"iOS"];
        //注入js
        [config.userContentController addUserScript:wkUScript];
        
        _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) configuration:config];
        
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        [_webview loadRequest:[self isLocal:NO isUIWebView:is]];
        
        _webview.allowsBackForwardNavigationGestures = true;
        [self.view addSubview:_webview];
    }

}
-(NSURLRequest *)isLocal:(BOOL)is isUIWebView:(BOOL)b{
    
    if (is) {
        NSString *resouce = b?@"text":@"WKWebView";
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:resouce ofType:@"html"];
        NSURL *rul = [NSURL fileURLWithPath:htmlPath];
        return [NSURLRequest requestWithURL:rul];
    }else{
        NSURL *url = [NSURL URLWithString:@"http://192.168.31.27:8099/#!/cb"];
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
    [leftbtn setTitle:@"< 返回" forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)backAction{
    
//    [_webView goBack];

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)action{

    [self.webview reload];
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
    
    NSLog(@"提示信息：%@", message);   //js的alert框的message
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark- WKNavigationDelegate

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    
    //如果需要回调，直接调用OC调用JS的方法 window.
    NSString *sendToken = [NSString stringWithFormat:@"window.iosORandroid.getAccessToken(\"%@\");",[self getAccessToken]];
    NSLog(@"send:%@",sendToken);
    
//    [self.webview evaluateJavaScript:sendToken completionHandler:^(id _Nullable string, NSError * _Nullable error) {
//        //js返回值
//        NSLog(@"执行结果：%@  error:%@",string,error);
//    }];
    
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
    
    /**
    NSString *jsToGetHTMLSource = @"document.documentElement.innerHTML";
    
    [webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        //js返回值
        NSLog(@"%@  error:%@",string,error);
    }];
     */
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"%s",__func__);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    
    _webview.UIDelegate = nil;
    _webview.navigationDelegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    _webView = nil;
    [[_webview configuration].userContentController removeScriptMessageHandlerForName:@"iOS"];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSLog(@"我被释放了");
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
