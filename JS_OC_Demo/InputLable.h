//
//  InputLable.h
//  JS_OC_Demo
//
//  Created by Mjwon on 2017/1/23.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputAction)(NSString *text);
typedef void(^BeginEditingAction)();

@interface InputLable : UIView

@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,assign) CGFloat titleFont;
@property (nonatomic ,assign) CGFloat subTitleFont;
@property (nonatomic ,strong) UIColor *bgColor;
@property (nonatomic ,strong) UIColor *subTitleBgColor;
@property (nonatomic ,strong) NSString *placeholder;

@property (nonatomic, copy) InputAction inputAction;
@property (nonatomic, copy) BeginEditingAction beginEditingAction;

@end
