//
//  InputLable.m
//  JS_OC_Demo
//
//  Created by Mjwon on 2017/1/23.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "InputLable.h"

@interface InputLable ()<UITextViewDelegate>

@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UILabel *titleLabel;

@end

@implementation InputLable

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.textView];
        
        self.layer.borderColor = [UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1].CGColor;
        self.layer.borderWidth = .5;

    }
    return self;
}
-(void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}
-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    _textView.text = placeholder;
    _textView.textColor = [UIColor lightGrayColor];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.beginEditingAction) {
        self.beginEditingAction();
    }
    if (self.placeholder.length > 0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
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
    NSLog(@"text:%@ result:%@ resultlength:%ld",text,result,result.length);

    if ([text isEqualToString:@"\n"] ) {//行其不换行
        return false;
    }
    return YES;
}
-(UITextView *)textView
{
    if (_textView == nil) {
        CGFloat x = 10;
        CGFloat y = CGRectGetMaxY(self.titleLabel.frame);
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(x,y, self.bounds.size.width-2*x, self.bounds.size.height-y-10)];
        _textView.layer.borderColor = [UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1].CGColor;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.layer.borderWidth = .8;
        _textView.delegate = self;
    }
    return _textView;
}

-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,100, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}
@end
