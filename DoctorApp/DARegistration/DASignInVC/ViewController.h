//
//  ViewController.h
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPas;

- (IBAction)submitBtnPressed:(id)sender;

- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)loginWithFbBtnPressed:(id)sender;
- (IBAction)newUserBtnPressed:(id)sender;
- (IBAction)forgotPwdBtnPressed:(id)sender;







@end

