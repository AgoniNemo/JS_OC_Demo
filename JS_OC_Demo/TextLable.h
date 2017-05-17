//
//  TextLable.h
//  ExcelViewDemo
//
//  Created by Mjwon on 2016/12/17.
//  Copyright © 2016年 Yahui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TextLableTypeTop,
    TextLableTypeEdit,
    TextLableTypeLeft,
    TextLableTypeShow,
} TextLableType;

typedef void(^InputAction)(NSString *text);
typedef void(^BeginEditingAction)();

@interface TextLable : UIView

@property (nonatomic ,strong) NSString *title;

@property (nonatomic ,strong) NSString *subTitle;
@property (nonatomic ,assign) BOOL isChangeFrame;
@property (nonatomic ,assign) CGFloat titleFont;
@property (nonatomic ,assign) CGFloat subTitleFont;
@property (nonatomic ,assign) CGFloat height;
@property (nonatomic ,assign) CGFloat titleWidth;
@property (nonatomic ,strong) UIColor *subTitleBgColor;
@property (nonatomic ,assign) TextLableType type;

@property (nonatomic, copy) InputAction inputAction;
@property (nonatomic, copy) BeginEditingAction beginEditingAction;

-(instancetype)initWithFrame:(CGRect)frame type:(TextLableType)type;
@end
