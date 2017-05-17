//
//  Test3ViewController.m
//  JS_OC_Demo
//
//  Created by Mjwon on 2017/1/23.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "Test3ViewController.h"
#import "InputLable.h"
#import "TextLable.h"

@interface Test3ViewController ()

@end

@implementation Test3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    CGRect rect = [UIScreen mainScreen].bounds;
    TextLable *nextUserLable = [[TextLable alloc] initWithFrame:CGRectMake(0, 100, rect.size.width-20, 35) type:TextLableTypeShow];
    
    nextUserLable.title = @"下级审批人";
    nextUserLable.subTitle = @"fjiamnviejwalgnmeiwalfjaesnjgifawl";
    nextUserLable.subTitleFont = 16;
    nextUserLable.subTitleBgColor = [UIColor clearColor];
    
    nextUserLable.beginEditingAction = ^{
       
        NSLog(@"%s",__func__);
    };
    [self.view addSubview:nextUserLable];
    
    
    CGFloat width = 50;
    CGFloat lableW = (rect.size.width-20-10)/2;
    TextLable *t2 = [[TextLable alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nextUserLable.frame)+5, lableW, 30) type:TextLableTypeShow];
    t2.title = @"缺陷定义";
    t2.subTitleFont = 12;
    t2.titleFont = 10;
    t2.titleWidth = width;
    t2.subTitleBgColor = [UIColor whiteColor];
    t2.subTitle = @"外观不良";
    [self.view addSubview:t2];
    
    TextLable *t3 = [[TextLable alloc] initWithFrame:CGRectMake(CGRectGetMaxX(t2.frame)+10, CGRectGetMaxY(nextUserLable.frame)+5, (rect.size.width-20-10)/2, 30) type:TextLableTypeShow];
    t3.title = @"缺陷名称";
    t3.subTitleFont = 12;
    t3.titleFont = 10;
    t3.titleWidth = 50;
    t3.subTitle = @"凹点";
    t3.subTitleBgColor = [UIColor whiteColor];
    
    [self.view addSubview:t3];
}
-(void)text1{

    CGRect rect = [UIScreen mainScreen].bounds;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, rect.size.width-20, 140)];
    lable.text = @"品质审批任务-客诉管理改善方案审批-20170207-166";
    lable.numberOfLines = 2;
    lable.font = [UIFont systemFontOfSize:15];
    lable.backgroundColor = [UIColor redColor];
    [self.view addSubview:lable];
}
-(void)test1{

    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    InputLable *lable = [[InputLable alloc] initWithFrame:CGRectMake(10, 100, rect.size.width-20, 140)];
    lable.title = @"MRB确认意见";
    lable.bgColor = [UIColor whiteColor];
    lable.placeholder = @"请填写";
    [self.view addSubview:lable];

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
