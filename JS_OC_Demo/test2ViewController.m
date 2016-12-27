//
//  test2ViewController.m
//  JS_OC_Demo
//
//  Created by Nemo on 2016/12/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "test2ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSExportDelegate.h"

@interface test2ViewController ()<UIWebViewDelegate,JSExportDelegate>

@end

@implementation test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"ImageHtml"
                                                          ofType:@"html"];
    
    NSURL *rul = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:rul];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
    /**
    NSString *jsToGetHTMLSource = @"document.documentElement.innerHTML";
    
    NSString *allHtml = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    
    NSLog(@"%@",allHtml);
     */
    
    [self injectionjsWithWebView:webView];
    
//    [self addClickActionForWebView:webView];
}

-(void)addClickActionForWebView:(UIWebView *)webView{
    
    NSString *jsString = @"function addOnlick(){\
    var objs = document.getElementsByClassName(\"news-container\")[0].childNodes;\
    for(var i=0;i<objs.length;i++){\
        if(i % 2 != 0){\
            console.log(objs[i]);\
            objs[i].childNodes[0].onclick = function () {\
                alert(this.currentSrc);\
            }\
        }\
    };\
    };";
    
//    NSString *jsString =@"function addOnlick(){\
    var objs = document.getElementsByClassName(\"news-container\");\
    for(var i=0;i<objs.length;i++){\
    var obs = objs[i].childNodes;\
    console.log(obs);\
    for (var j = 0;j < obs.length;j++){\
    if (j %2 != 0){\
    var ob = obs[j].childNodes[0];\
    alert(ob.currentSrc);\
    var string = ob.href+\".myweb:click:\" + j;\
    ob.href = string;\
    ob.onclick = function () {\
    alert(this.currentSrc + \"这是一个点\");\
    }\
    }\
    }\
    };";
    [webView stringByEvaluatingJavaScriptFromString:jsString];//注入js方法
    
    [webView stringByEvaluatingJavaScriptFromString:@"addOnlick()"];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
//        NSLog(@"requestString is %@",requestString);
    
    // 判断url内容是否以包含字符.myweb:click:
    if ([requestString rangeOfString:@".myweb:click:"].location != NSNotFound) {
        
        
        NSLog(@"监听到点击事件");
        
        
        return NO;
    }
    return YES;
}
-(void)injectionjsWithWebView:(UIWebView *)webView{

    // 通过UIWebView获得网页中的JavaScript执行环境
    JSContext *context = [webView valueForKeyPath:
                          @"documentView.webView.mainFrame.javaScriptContext"];
    // 设置处理异常的block回调
    [context setExceptionHandler:^(JSContext *ctx, JSValue *value) {
        NSLog(@"error: %@", value);
    }];
    
    context[@"callBackObj"] = self;
    
#warning 一定要定义一个协议
    NSString *jsString = @"function addOnlick(){\
    var objs = document.getElementsByClassName(\"news-container\")[0].childNodes;\
    for(var i=0;i<objs.length;i++){\
    if(i % 2 != 0){\
    console.log(objs[i]);\
    objs[i].childNodes[0].onclick = function () {\
    alert(this.currentSrc);\
    callBackObj.run();\
    }\
    }\
    };\
    };";
    
    NSString *js = @"\
    var objs = document.getElementsByClassName(\"news-container\");\
    for(var i=0;i<objs.length;i++){\
    var obs = objs[i].childNodes;\
    console.log(obs);\
    for (var j = 0;j < obs.length;j++){\
    if (j %2 != 0){\
    alert(obs[j])\
    var ob = obs[j].childNodes[0];\
    obs[j].childNodes[0].onclick = function () {\
    alert(this.currentSrc + \"这是一个点\");\
    callBackObj.run();\
    }\
    }\
    }\
    };";
    
    
    [context evaluateScript:jsString];

}

-(void)run{

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
