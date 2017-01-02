//
//  ViewController.m
//  JS_OC_Demo
//
//  Created by Nemo on 2016/11/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "ViewController.h"
#import "test2ViewController.h"
#import "Test1ViewController.h"
#import "UrlViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSorce;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSorce.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataSorce[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        test2ViewController *vc = [[test2ViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1)
    {
        Test1ViewController *vc = [[Test1ViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.row == 2){
        UrlViewController *vc = [[UrlViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(NSMutableArray *)dataSorce
{
    if (_dataSorce == nil) {
        _dataSorce = [NSMutableArray arrayWithArray:@[@"JSContext方式",@"Url方式",@"Url"]];
    }
    return _dataSorce;
}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
