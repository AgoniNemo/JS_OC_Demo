//
//  ViewController.m
//  JS_OC_Demo
//
//  Created by Nemo on 2016/11/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "ViewController.h"
#import "ColorView.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self createWebView];
    
}
-(void)createWebView{

    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    
    NSURL *rul = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:rul];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    /**
   NSString *jsString = @"<script>var lis = document.getElementsByClassName(\"list-link\");for (var i = 0; i < lis.length; i++) {lis[i].addEventListener('click', function(){alert(this.innerHTML);});}</script>";
    */
    /**
        放大网页，没有用
        NSString *injectionJSString = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
        [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
    */
    
    
    NSString *jsToGetHTMLSource = @"document.documentElement.innerHTML";
    
    NSString *allHtml = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    
    NSLog(@"%@",allHtml);
    
    [self removeWithWebView:webView];
    
}
-(void)removeWithWebView:(UIWebView *)webView{

    NSString *jsString =@"function removeClick(){\
    var lis = document.getElementsByClassName(\"alert\");\
    for(var i= 0;i<lis.length;i++){\
    var  list = lis[i];\
    var  string = list.href+\".myweb:click:\" + i;\
    list.href = string;\
    lis[i].onclick = function(){\
    }\
    };\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsString];//注入js方法
    
    [webView stringByEvaluatingJavaScriptFromString:@"removeClick()"];

}
-(void)addClickActionForWebView:(UIWebView *)webView{

    NSString *jsString =@"function addOnlick(){\
    var lis = document.getElementsByClassName(\"list-link\");\
    for(var i= 0;i<lis.length;i++){\
    var  list = lis[i];\
    var  string = list.href+\".myweb:click:\" + i;\
    list.href = string;\
    lis[i].onclick = function(){\
    }\
    };\
    };";
    [webView stringByEvaluatingJavaScriptFromString:jsString];//注入js方法
    
    [webView stringByEvaluatingJavaScriptFromString:@"addOnlick()"];

}
    
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
//    NSLog(@"requestString is %@",requestString);
    
    // 判断url内容是否以包含字符.myweb:click:
    if ([requestString rangeOfString:@".myweb:click:"].location != NSNotFound) {
        
        
        NSLog(@"监听到点击事件");
        
        
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
