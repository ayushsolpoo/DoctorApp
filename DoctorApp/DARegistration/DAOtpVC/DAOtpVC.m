//
//  DAOtpVC.m
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAOtpVC.h"
#import "DAEmergencyContactsVC.h"



@interface DAOtpVC ()<UITextFieldDelegate>

- (IBAction)verifyBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *firstDigit;
@property (weak, nonatomic) IBOutlet UITextField *secondDigit;
@property (weak, nonatomic) IBOutlet UITextField *thirsDigit;
@property (weak, nonatomic) IBOutlet UITextField *forthDigit;

@end

@implementation DAOtpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}





//TODO:TEXTFIELD DELEGATE METHODS

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ((textField.text.length < 1) && (string.length > 0))
    {
        
        NSInteger nextTag = textField.tag + 1;
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (! nextResponder){
            [textField resignFirstResponder];
        }
        textField.text = string;
        if (nextResponder)
            [nextResponder becomeFirstResponder];
        
        return NO;
        
    }else if ((textField.text.length >= 1) && (string.length > 0)){
        //FOR MAXIMUM 1 TEXT
        
        NSInteger nextTag = textField.tag + 1;
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (! nextResponder){
            [textField resignFirstResponder];
        }
        textField.text = string;
        if (nextResponder)
            [nextResponder becomeFirstResponder];
        
        return NO;
    }
    else if ((textField.text.length >= 1) && (string.length == 0)){
        // on deleteing value from Textfield
        
        NSInteger prevTag = textField.tag - 1;
        // Try to find prev responder
        UIResponder* prevResponder = [textField.superview viewWithTag:prevTag];
        if (! prevResponder){
            [textField resignFirstResponder];
        }
        textField.text = string;
        if (prevResponder)
            // Found next responder, so set it.
            [prevResponder becomeFirstResponder];
        
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)verifyBtnPressed:(id)sender
{
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,OTP_VERIFICATION];
    NSString *otp = [NSString stringWithFormat:@"%@%@%@%@",_firstDigit.text,_secondDigit.text,_thirsDigit.text,_forthDigit.text];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"123",@"patient_id",[otp intValue],@"otp", nil];
    
    [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodPOST postData:paramDict callBackBlock:^(id response, NSError *error) {
        NSDictionary *dictionary = nil;
        [SVProgressHUD dismiss];
        
        if (response)
        {
            dictionary = [[NSDictionary alloc]initWithDictionary:response];
            
            if ([[dictionary objectForKey:@"error"] intValue])
            {
                [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"user_info"];
                
                DAEmergencyContactsVC *eVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DAEmergencyContactsVC"];
                [self.navigationController showViewController:eVC sender:self];
            }
        }
        else
        {
            NSLog(@"error is %@",[error localizedDescription]);
        }
        
    }];
    
    
}
@end
