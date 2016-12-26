//
//  Test1ViewController.m
//  JS_OC_Demo
//
//  Created by Mjwon on 2016/12/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "Test1ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSExportDelegate.h"

@interface Test1ViewController ()<UIWebViewDelegate,JSExportDelegate>

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    
    NSURL *rul = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:rul];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    /**
     * 通过协议去调js
     
     JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
     
     ManObject *m = [[ManObject alloc] init];
     
     context[@"ManObject"] = m;
     [context evaluateScript:@"ManObject.run()"];
     
     context[@"log"] = ^{
     NSArray *args = [JSContext currentArguments];
     for (JSValue *jsVal in args) {
     NSLog(@"js:%@", jsVal);
     }
     
     };
     
     [context evaluateScript:@"log('hello,i am js side')"];*/
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    // 通过UIWebView获得网页中的JavaScript执行环境
    JSContext *context = [webView valueForKeyPath:
                          @"documentView.webView.mainFrame.javaScriptContext"];
    // 设置处理异常的block回调
    [context setExceptionHandler:^(JSContext *ctx, JSValue *value) {
        NSLog(@"error: %@", value);
    }];
    
    /**
     // 下面的代码移除了按钮原先绑定的事件回调重新绑定返回上一个视图控制器的代码
     NSString *code =
     @"var btn = document.getElementById('backButton');"
     "btn.removeEventListener('click', cb);"
     "btn.addEventListener('click', function() {"
     "   callBackObj.letsGoBack();"
     "});";
     */
    
#warning 一定要定义一个协议
    
    context[@"callBackObj"] = self;
    
    NSString *js = @"\
    var lis = document.getElementsByClassName(\"list-link\");\
    for(var i= 0;i<lis.length;i++){\
    var  list = lis[i];\
    list.addEventListener('click', function(){\
    callBackObj.run(this.innerHTML);\
    });\
    };";
    
    [context evaluateScript:js];
    
    
    NSString *jsToGetHTMLSource = @"document.documentElement.innerHTML";
    
    NSString *allHtml = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    
    NSLog(@"%@",allHtml);
    
}

-(void)run:(NSString *)string{
    
    NSLog(@"%@",string);
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
