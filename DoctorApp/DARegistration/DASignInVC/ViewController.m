//
//  ViewController.m
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "ViewController.h"
#import "DASignUpVC.h"
#import "DASignUpVC.h"
#import "DAEmergencyContactsVC.h"
#import "FacebookHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pasTextField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark : Log in with facebook
-(void)fbButtonClicked{
   //  [SVProgressHUD show];
    [[FacebookHelper sharedInstance] loginFacebookFromSettings:@"id,email,name,gender,picture.type(large)" Completion:^(NSDictionary *response, BOOL isCancelled)
     {
       //  [SVProgressHUD dismiss];
         if (response)
         {
             NSLog(@"%@",response);
//             self.fbDict = response;
//             NSUserDefaults* save = [NSUserDefaults standardUserDefaults];
//             [save setObject:[response objectForKey:@"name"] forKey:@"name"];
//             [save setObject:[response objectForKey:@"email"]?[response objectForKey:@"email"]:@"" forKey:@"email"];
//            [save synchronize];
            // [self loginApi];
         }
     }];
    
    
}
#pragma mark textfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)submitBtnPressed:(id)sender

{
    
    UIButton *button = (UIButton *)sender;
    button.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.enabled = YES;
    });
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,25}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if([_emailTextField.text isEqualToString:@""] || [_pasTextField.text isEqualToString:@""])
    {
    }
    else if (![emailTest evaluateWithObject:_emailTextField.text]) {
        
        
        
    }
    
    else
    {
        [self signIn];
        
    }

//    DASignUpVC *signUp = [self.storyboard instantiateViewControllerWithIdentifier:@"DASignUpVC"];
//    [self.navigationController showViewController:signUp sender:self];

/*
 [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodGET postData:nil callBackBlock:^(id response, NSError *error)
 {

 */
}

-(void)signIn
{
    [SVProgressHUD show];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN];
    NSDictionary * paramDict = @{@"email":[NSString stringWithFormat:@"%@",_emailTextField.text],@"password":[NSString stringWithFormat:@"%@",_pasTextField.text],@"device_token":@"78374646",@"registration_token":@"4345455"};
    //device_token,registration_token
    
    [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodPOST postData:paramDict callBackBlock:^(id response, NSError *error)
     {
         NSDictionary *dictionary = nil;;
         if (response)
         {
             dictionary = [[NSDictionary alloc] initWithDictionary:response];
         }
         [SVProgressHUD show];
         if (!error)
         {
             
             if (dictionary)
             {
              
                 [SVProgressHUD dismiss];
                 if ([[dictionary objectForKey:@"message"] isEqualToString:@"Email does not found."])
                 {
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Email id! " message:[dictionary objectForKey:@"reason"] preferredStyle:UIAlertControllerStyleAlert];
                     [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                         // action 1
                     }]];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
             }
             else
             {
                 [SVProgressHUD dismiss];
                 [self showErrorMessage];
             }
         }
         else
         {
             [SVProgressHUD dismiss];
             [self showErrorMessage:error];
         }
     }];
}

#pragma mark - Error Methods
- (void)showErrorMessage:(NSError *)error
{
    NSString *header;
    
    NSString *text;
    
    if (error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorNotConnectedToInternet) {
        
        header = @"No Internet!";
        
        text = @"You don’t seem to be connected to the internet.";
        
    }
    else
    {
        
        header =@"Sorry!";
        
        text = @"We are unable to process your request. Please try again.";
        
    }
    

    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:header message:text preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // action 1
    }]];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)showErrorMessage
{
    
    NSString *header;
    
    NSString *text;
    
    header =@"Sorry!";
    
    text = @"We are unable to process your request. Please try again.";
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:header message:text preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // action 1
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)cancelBtnPressed:(id)sender {
}

- (IBAction)loginWithFbBtnPressed:(id)sender {
    [self fbButtonClicked];
}

- (IBAction)newUserBtnPressed:(id)sender
{
    DASignUpVC *signUp = [self.storyboard instantiateViewControllerWithIdentifier:@"DASignUpVC"];
    [self.navigationController showViewController:signUp sender:self];
    
//    DAEmergencyContactsVC *signUp = [self.storyboard instantiateViewControllerWithIdentifier:@"DAEmergencyContactsVC"];
//    [self.navigationController showViewController:signUp sender:self];

}

- (IBAction)forgotPwdBtnPressed:(id)sender
{
    
}


@end
