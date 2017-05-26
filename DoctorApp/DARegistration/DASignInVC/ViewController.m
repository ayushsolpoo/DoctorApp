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
#import "DAHomeVC.h"
#import "SWRevealViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pasTextField;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setleftimages];
    _textFieldEmail.text = @"wang@gmail.com";
    _textFieldPas.text = @"123456789";
}

-(void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBar.hidden = YES;
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

//#pragmaMark:- leftimages:-

-(void)setleftimages
{
//    _emailTextField.leftViewMode = UITextFieldViewModeAlways;
//    _emailTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email_icon.png"]];
//    
//    _pasTextField.leftViewMode = UITextFieldViewModeAlways;
//    _pasTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_icon.png"]];
     _emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
     _pasTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
    
    submitbutton.layer.cornerRadius = 15.0;
    submitbutton.layer.shadowColor = [UIColor blackColor].CGColor;
    submitbutton.layer.shadowOffset = CGSizeMake(3, 3);
    submitbutton.layer.shadowRadius = 5;
    submitbutton.layer.shadowOpacity = 0.3;
    
    facebookbtn.layer.cornerRadius = 15.0;
    facebookbtn.layer.shadowColor = [UIColor blackColor].CGColor;
    facebookbtn.layer.shadowOffset = CGSizeMake(3, 3);
    facebookbtn.layer.shadowRadius = 5;
    facebookbtn.layer.shadowOpacity = 0.3;
}
#pragma mark textfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)submitBtnPressed:(id)sender
{
    NSString *errorMessage = [self validateForm];
    if (errorMessage)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Meassage" message:errorMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else
    {
        [self signIn];
    }
}
#pragma Mark:
#pragma Mark AllTextField Validations:-
    
- (NSString *)validateForm {
    NSString *errorMessage = nil;
    NSString *regex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![emailPredicate evaluateWithObject:_emailTextField.text] == YES)
    {
       errorMessage = @"Please Enter Your Valid Email ID";
    }
    
   else if (!(_emailTextField.text.length >= 1)){
        errorMessage = @"Please Enter Your Email ID";
    }
    
    else if (!(_pasTextField.text.length >= 1)){
        errorMessage = @"Please enter Your Password";
    }
    
    return errorMessage;
}


-(void)signIn
{
    NSLog(@"jjj%@",[[NSUserDefaults standardUserDefaults]
                    stringForKey:@"APITOCKEN"]);
    
    [SVProgressHUD show];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN];
    
    NSDictionary * paramDict = @{@"email":[NSString stringWithFormat:@"%@",_emailTextField.text],@"password":[NSString stringWithFormat:@"%@",_pasTextField.text],@"device_token":@"78374646",@"registration_token":
                                     [[NSUserDefaults standardUserDefaults]
                                                                                                                                                                                                        stringForKey:@"APITOCKEN"]};
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
             else
                 {
             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Appointment" bundle:nil];
             SWRevealViewController *initialViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"revel"];
                 [self.navigationController pushViewController:initialViewController animated:YES];
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

- (IBAction)loginWithFbBtnPressed:(id)sender {
    [self fbButtonClicked];
}

- (IBAction)newUserBtnPressed:(id)sender
{
    DASignUpVC *signUp = [self.storyboard instantiateViewControllerWithIdentifier:@"DASignUpVC"];
    [self.navigationController showViewController:signUp sender:self];
}

- (IBAction)forgotPwdBtnPressed:(id)sender
{
    
}
@end
