//
//  UrlViewController.m
//  JS_OC_Demo
//
//  Created by Mjwon on 2016/12/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "UrlViewController.h"

@interface UrlViewController ()<UIWebViewDelegate>

@end

@implementation UrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createWebView];
    
//    [self createWebViewForUrl:@"https://www.baidu.com/"];
}

-(void)createWebViewForUrl:(NSString *)url{
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    NSURL *rul = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:rul];
    
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
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
    
    NSString *jsToGetHTMLSource = @"document.documentElement.innerHTML";
    
    NSString *allHtml = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    
    NSLog(@"%@",allHtml);
    
    [self addScriptForWebView:webView];
    
}

-(void)addScriptForWebView:(UIWebView *)webView{
    
    NSString *injectionJSString = @"var s = document.createElement('script');"
    "s.name = 'scriptAction';"
    "s.setAttribute('type', 'text/javascript');"
    "s.onload = function() {"
    "var lis = document.getElementsByClassName(\"list-link\");"
    "for (var i = 0; i < lis.length; i++) {"
    "lis[i].addEventListener('click', function(){"
    "alert(this.innerHTML);"
    "});"
    "}"
    "};";
    
    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('head')[0].appendChild(s);"];
    
}

-(void)addjsForWebView:(UIWebView *)webView{
    
    //如果是加载的URL,可以通过WebView的在webViewDidFinishLoad的加载完成的代理方法中,通过stringByEvaluatingJavaScriptFromString方法来动态添加js代码：
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
    
    //标签里的scale 值就是页面的初始化页面大小< initial-scale >和可伸缩放大最大< maximum-scale >和最小< minimum-scale >的的倍数。如果还有别的需求可自行设置,如果都为1表示初始化的时候显示为原来大小,可缩放的大小都为原来的大小<即不可缩放>。
    
}
-(void)addLocaljscssfileForWebView:(UIWebView *)webView{
    
    //如果文件类型为 .js ,则创建 script 标签，并设置相应属性，如果文件类型为 .css ,则创建 script 标签，并设置相应属性
    
    NSString *jsString =@"function loadjscssfile(filename, filetype){\
    if (filetype==\"js\"){\
    var fileref=document.createElement('script');\
    fileref.setAttribute(\"type\",\"text/javascript\");\
    fileref.setAttribute(\"src\", filename);\
    }\
    else if (filetype==\"css\"){\
    var fileref=document.createElement(\"link\");\
    fileref.setAttribute(\"rel\", \"stylesheet\");\
    fileref.setAttribute(\"type\", \"text/css\");\
    fileref.setAttribute(\"href\", filename);\
    } \
    if (typeof fileref!=\"undefined\")\
    document.getElementsByTagName(\"head\")[0].appendChild(fileref);\
    }";
    
    [webView stringByEvaluatingJavaScriptFromString:jsString];//注入js方法
    
    [webView stringByEvaluatingJavaScriptFromString:@"loadjscssfile(\"myscript.js\", \"js\");"];
    
}

-(void)removeWithWebView:(UIWebView *)webView{
    
    NSString *jsString =@"function removejscssfile(filename, filetype){\
    var targetelement=(filetype==\"js\")? \"script\" : (filetype==\"css\")? \"link\" : \"none\";\
    var targetattr=(filetype==\"js\")? \"src\" : (filetype==\"css\")? \"href\" : \"none\";\
    var allsuspects=document.getElementsByTagName(targetelement);\
    for (var i=allsuspects.length; i>=0; i--){\
    if (allsuspects[i] && allsuspects[i].getAttribute(targetattr)!=null && allsuspects[i].getAttribute(targetattr).indexOf(filename)!=-1)\
    allsuspects[i].parentNode.removeChild(allsuspects[i]);\
    }\
    }";
    
    [webView stringByEvaluatingJavaScriptFromString:jsString];//注入js方法
    
    [webView stringByEvaluatingJavaScriptFromString:@"removejscssfile(\"somescript.js\", \"js\");"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
