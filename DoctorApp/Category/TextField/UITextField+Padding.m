//
//  UITextField+Padding.m
//  DoctorApp
//
//  Created by MacPro on 24/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "UITextField+Padding.h"

@implementation UITextField(Padding)


-(void) setLeftPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setRightPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.rightView = paddingView;
    self.rightViewMode = UITextFieldViewModeAlways;
}


@end
