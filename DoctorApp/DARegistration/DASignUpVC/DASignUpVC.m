//
//  DASignUpVC.m
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DASignUpVC.h"
#import "DAOtpVC.h"
#import "DAEmergencyContactsVC.h"

@interface DASignUpVC ()<UITextFieldDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPas;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMobileNo;
@property (weak, nonatomic) IBOutlet UIScrollView *dScrollView;

- (IBAction)submitBtnPressed:(id)sender;

@end

@implementation DASignUpVC

bool keyboardIsShown = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [_profileImageView setImage:[UIImage imageNamed:@"profile1.png"]];
    _profileImageView.layer.cornerRadius  = _profileImageView.frame.size.height /2;
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.borderWidth   = 0;
    
    

}


//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self animateTextField:textField up:YES];
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self animateTextField:textField up:NO];
//}
//
//-(void)animateTextField:(UITextField*)textField up:(BOOL)up
//{
//    const int movementDistance = -130; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    int movement = (up ? movementDistance : -movementDistance);
//    
//    [UIView beginAnimations: @"animateTextField" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.dScrollView setFrame:CGRectMake(0,-110,self.dScrollView.frame.size.width,self.dScrollView.frame.size.height)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.dScrollView setFrame:CGRectMake(0,0,self.dScrollView.frame.size.width,self.dScrollView.frame.size.height)];
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
    
    if([_textFieldName.text isEqualToString:@""] || [_textFieldEmail.text isEqualToString:@""]|| [_textFieldPas.text isEqualToString:@""]|| [_textFieldMobileNo.text isEqualToString:@""])
    {
    }
    else if (![emailTest evaluateWithObject:_textFieldEmail.text]) {
        
    }
    else
    {
        [self signUp];
    }
}

-(void)signUp
{
    [SVProgressHUD show];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,REGISTRATION];
    NSDictionary * paramDict = @{@"email":[NSString stringWithFormat:@"%@",_textFieldEmail.text],@"password":[NSString stringWithFormat:@"%@",_textFieldName.text],@"name":[NSString stringWithFormat:@"%@",_textFieldPas.text],@"number":[NSString stringWithFormat:@"%@",_textFieldMobileNo.text],@"doctor_id":@"123456789"};
    
    [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodPOST postData:paramDict callBackBlock:^(id response, NSError *error)
     {
         NSDictionary *dictionary = nil;;
         if (response)
         {
             dictionary = [[NSDictionary alloc] initWithDictionary:response];
         }
         [SVProgressHUD dismiss];
         if (!error)
         {
             
             if (dictionary)
             {
                 
                 if ([dictionary objectForKey:@"OTP"])
                 {
                     DAOtpVC *otp = [self.storyboard instantiateViewControllerWithIdentifier:@"DAOtpVC"];
                     [self.navigationController showViewController:otp sender:self];
                 }
                 else
                 {
                     
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:SORRY message:[dictionary objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                     [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                         // action 1
                     }]];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
             }
             else
             {
                 [self showErrorMessage];
             }
         }
         else
         {
             [self showErrorMessage:[dictionary objectForKey:@"message"]];
         }
     }];
}

//TODO: textField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
@end
