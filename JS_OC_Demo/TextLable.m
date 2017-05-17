//
//  TextLable.m
//  ExcelViewDemo
//
//  Created by Mjwon on 2016/12/17.
//  Copyright © 2016年 Yahui. All rights reserved.
//

#import "TextLable.h"
#import "UIView+Extension.h"


@interface TextLable ()<UITextViewDelegate>
{
    BOOL uneditable;
}
@property (nonatomic ,strong) UITextView *textView;

@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *subTitleLabel;
@end

@implementation TextLable


-(instancetype)initWithFrame:(CGRect)frame type:(TextLableType)type{

    if (self == [super initWithFrame:frame]) {
        _type = type;
        [self addSubview:self.titleLabel];
        
        if (type == TextLableTypeShow) {
            [self addSubview:self.subTitleLabel];
        }else{
            [self addSubview:self.textView];
        }
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
                
        [self addSubview:self.titleLabel];
        [self addSubview:self.textView];
    }
    return self;
}
-(void)setHeight:(CGFloat)height
{
    _height = height;
    CGFloat x = CGRectGetMaxX(self.titleLabel.frame)+10;
    _textView.frame = CGRectMake(x, 0, self.bounds.size.width-x, height);
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    NSAssert((title != nil), @" title 不能为空！");
    
    if (title.length > 0) {
        _titleLabel.text = title;
    }else{
        [_titleLabel removeFromSuperview];
        self.textView.frame = self.frame;
    }
    
}
-(void)setSubTitleFont:(CGFloat)subTitleFont
{
    _subTitleFont = subTitleFont;
    UIFont *font = [UIFont systemFontOfSize:subTitleFont];
    if (self.type == TextLableTypeShow) {
        _subTitleLabel.font = font;
    }else{
        _textView.font = font;
    }
}
-(void)setTitleWidth:(CGFloat)titleWidth
{
    _titleWidth = titleWidth;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.width = titleWidth;
    CGFloat x = CGRectGetMaxX(self.titleLabel.frame)+10;
    CGRect frame = CGRectMake(x, 0, self.bounds.size.width-x, self.bounds.size.height);
    if (self.type == TextLableTypeShow) {
        _subTitleLabel.frame = frame;
    }else{
        _textView.frame = frame;
    }
}
-(void)setSubTitleBgColor:(UIColor *)subTitleBgColor
{
    _subTitleBgColor = subTitleBgColor;
    if (self.type == TextLableTypeShow) {
        self.subTitleLabel.backgroundColor = subTitleBgColor;
    }else{
        self.textView.backgroundColor = subTitleBgColor;
    }
    
}
-(void)setType:(TextLableType)type
{
    _type  = type;
    
    CGFloat y = CGRectGetMaxY(self.titleLabel.frame);
    if (type == TextLableTypeTop) {
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _textView.frame = CGRectMake(0, y, self.bounds.size.width, self.bounds.size.height-y);
    }
}

-(void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    NSAssert((subTitle != nil), @" subTitle 不能为空！");
    uneditable = YES;
    if (self.type == TextLableTypeShow) {
        _subTitleLabel.text = [NSString stringWithFormat:@" %@",subTitle];
    }else{
        _textView.text = subTitle;
    }
    
    if (self.isChangeFrame) {
        _titleLabel.frame = CGRectMake(0, (CGRectGetHeight(self.textView.frame)-30)/2,100, 30);
    }
}
-(void)tapClick{
    if (self.beginEditingAction) {
        self.beginEditingAction();
    }
}
-(void)setTitleFont:(CGFloat)titleFont
{
    _titleFont = titleFont;
    _titleLabel.font = [UIFont systemFontOfSize:titleFont];
}
-(UITextView *)textView
{
    if (_textView == nil) {
        CGFloat x = CGRectGetMaxX(self.titleLabel.frame)+10;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(x, 0, self.bounds.size.width-x, self.bounds.size.height)];
        _textView.layer.borderColor = [UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1].CGColor;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.layer.borderWidth = .8;
        _textView.layer.cornerRadius = 2.0;
        _textView.delegate = self;
    }
    return _textView;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if (self.beginEditingAction) {
        self.beginEditingAction();
    }
    if (uneditable) {
        return NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableString *result = [NSMutableString stringWithString:textView.text];
    if (text.length > 0) {
        [result appendString:text];
        
    }else if(result.length >= 1){
        
        NSString *lateStr = [result substringToIndex:([result length]-1)];
        result = [NSMutableString stringWithString:lateStr];
        
    }
    if (self.inputAction) {
        self.inputAction(result);
    }
    if ([text isEqualToString:@"\n"] ) {//行其不换行
        return false;
    }
    return YES;
}
-(UILabel *)subTitleLabel
{
    if (_subTitleLabel == nil) {
        CGFloat x = CGRectGetMaxX(self.titleLabel.frame)+10;
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, self.bounds.size.width-x, self.bounds.size.height)];
        _subTitleLabel.layer.borderColor = [UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1].CGColor;
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.userInteractionEnabled = YES;
        [_subTitleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)]];

    }
    return _subTitleLabel;
}
-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100, 30)];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}


@end
