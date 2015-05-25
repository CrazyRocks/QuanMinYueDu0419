//
//  PwdModifyController.m
//  ZhangShangZhongYuan
//
//  Created by grenlight on 14/7/3.
//  Copyright (c) 2014年 grenlight. All rights reserved.
//

#import "PwdModifyController.h"
#import <LYService/LYAccountManager.h> 


@interface PwdModifyController () {
    CGPoint oriPoint;
    CGPoint flowPoint;
    CGPoint rePoint;
}

@end

@implementation PwdModifyController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
//

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat height = appHeight/2.0f;
    if (!isPad) {
        height -= CGRectGetHeight(panel.bounds)/2.0f - 50;
    }
    panel.center = CGPointMake(appWidth/2.0f, height);
    panel.layer.cornerRadius = 8.0f;
    oriPoint = panel.center;
    rePoint = CGPointMake(oriPoint.x, oriPoint.y - 40);
   // NSLog(@"\r\n rey:%f", rePoint.y);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    firstTF.delegate = self;
    secondTF.delegate = self;
    thirdTF.delegate = self;
    [secondTF addTarget:self action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.5];
    [nc addObserver:self
           selector:@selector(handleKeyboardDidHidden)
               name:UIKeyboardWillHideNotification
             object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    tap.numberOfTapsRequired = 1;
    //[self.view addGestureRecognizer:tap];
}

- (void)showKeyboard
{
    //[firstTF becomeFirstResponder];
    firstTF.returnKeyType = UIReturnKeyNext;
    secondTF.returnKeyType = UIReturnKeyNext;
    thirdTF.returnKeyType = UIReturnKeyDone;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == firstTF) {
        [secondTF becomeFirstResponder];
    }
    else if (textField == secondTF) {
        [thirdTF becomeFirstResponder];
    } else {
        NSString *pwd = secondTF.text;

        NSString *oldPwd = [LYAccountManager getValueByKey:LONGYUAN_PWD];
        if (![firstTF.text isEqualToString:oldPwd]) {
            [firstTF becomeFirstResponder];
            [msgLabel setText: @"输入的原始密码错误"];
        }
        else if (pwd.length < 6) {
            [msgLabel setText: @"密码长度不足6位"];
            //[secondTF becomeFirstResponder];
        }
        else if (![pwd isEqualToString:thirdTF.text]) {
            [msgLabel setText: @"两次输入的密码不一致"];
        }
        else {
            closeButton.enabled = NO;
            [firstTF resignFirstResponder];
            [secondTF resignFirstResponder];
            [thirdTF resignFirstResponder];

            [msgLabel setText: @"正在修改..."];
            
            __weak typeof (self) weakSelf = self;
            [LYAccountManager modifyPwd:secondTF.text completion:^{
                [weakSelf success];
            } fault:^(NSString *msg) {
                [weakSelf modifyFault:msg];
            }];
  
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)sender
{
    if (sender.text.length < 1) {
        indicatorView.status = PasswordStrengthIndicatorViewStatusNone;
        return;
    }
    
    if (sender.text.length < 4) {
        indicatorView.status = PasswordStrengthIndicatorViewStatusWeak;
        return;
    }
    
    if (sender.text.length < 6) {
        indicatorView.status = PasswordStrengthIndicatorViewStatusFair;
        return;
    }
    
    indicatorView.status = PasswordStrengthIndicatorViewStatusStrong;
}

- (void)success
{
    [msgLabel setText: @"密码修改成功"];
    [self performSelector:@selector(close:) withObject:nil afterDelay:0.5];
}

- (void)modifyFault:(NSString *)msg
{
    [msgLabel setText: msg];
    [firstTF becomeFirstResponder];
    closeButton.enabled = YES;
}

- (void)close:(id)sender
{
    [firstTF resignFirstResponder];
    [secondTF resignFirstResponder];
    [thirdTF resignFirstResponder];

    [[OWModalViewAnimator animator] dismissing];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //NSLog(@"\r\n ori:%f,fl:%f,re:%F", oriPoint.y, flowPoint.y, rePoint.y);
    if (flowPoint.y != rePoint.y) {
        flowPoint = rePoint;
        [UIView beginAnimations:@"showBoard" context:nil];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.view.center = flowPoint;
        //[self.view layoutIfNeeded];
        [UIView commitAnimations];
    }
    
}

- (void)handleKeyboardDidHidden {
    [UIView animateWithDuration:0.2f animations:^{
        self.view.center = oriPoint;
        flowPoint = oriPoint;
        [self.view layoutIfNeeded];
    }];
}

- (void)endEditing
{
    [firstTF resignFirstResponder];
    [secondTF resignFirstResponder];
    [thirdTF resignFirstResponder];
}

@end
