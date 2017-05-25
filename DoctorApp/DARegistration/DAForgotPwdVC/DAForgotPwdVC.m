//
//  DAForgotPwdVC.m
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAForgotPwdVC.h"

@interface DAForgotPwdVC ()

@end

@implementation DAForgotPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    _sendbtn.layer.cornerRadius = 15.0;
    _sendbtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _sendbtn.layer.shadowOffset = CGSizeMake(3, 3);
    _sendbtn.layer.shadowRadius = 5;
    _sendbtn.layer.shadowOpacity = 0.3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backbuttonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendbuttonaction:(id)sender
{
    NSLog(@"jvj");
}

@end
