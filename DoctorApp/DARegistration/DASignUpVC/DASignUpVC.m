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
#import "BaseSixtyFour.h"

@interface DASignUpVC ()<UITextFieldDelegate>
{
    UIImagePickerController             *_pickerSelect;
 
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
    [self setleftimages];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_profileImageView setImage:[UIImage imageNamed:@"profile_bg.png"]];
    _profileImageView.layer.cornerRadius  = _profileImageView.frame.size.height /2;
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.borderWidth   = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

-(void)setleftimages
{
    _textFieldName.leftViewMode = UITextFieldViewModeAlways;
    _textFieldName
    .leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_icon.png"]];
    
    _textFieldEmail.leftViewMode = UITextFieldViewModeAlways;
    _textFieldEmail.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email_icon.png"]];
    
    _textFieldPas.leftViewMode = UITextFieldViewModeAlways;
    _textFieldPas.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_icon.png"]];
    
    _textFieldMobileNo.leftViewMode = UITextFieldViewModeAlways;
    _textFieldMobileNo.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mobile_icon"]];
    
    _textFieldName.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0);
    _textFieldEmail.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0);
    _textFieldPas.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0);
    _textFieldMobileNo.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0);
    
    signupbtn.layer.cornerRadius = 15.0;
    signupbtn.layer.shadowColor = [UIColor blackColor].CGColor;
    signupbtn.layer.shadowOffset = CGSizeMake(3, 3);
    signupbtn.layer.shadowRadius = 5;
    signupbtn.layer.shadowOpacity = 0.3;
    
    facebookbtn.layer.cornerRadius = 15.0;
    facebookbtn.layer.shadowColor = [UIColor blackColor].CGColor;
    facebookbtn.layer.shadowOffset = CGSizeMake(3, 3);
    facebookbtn.layer.shadowRadius = 5;
    facebookbtn.layer.shadowOpacity = 0.3;
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
    NSString *send;
    
    UIImage* abc = _profileImageView.image;//_imgView.image;
    NSData* imgData = [self getImageData:abc];//[_serverResponse getImageData:i.image];
    NSLog(@"Image Size: %lu", (unsigned long)imgData.length);
    NSString     *postimagestr  = [NSString stringWithFormat:@"%@",[BaseSixtyFour encode:imgData]];
    

    int ii = 1;
    NSDictionary * paramDict = @{
                                 @"email":[NSString stringWithFormat:@"%@",_textFieldEmail.text],
                                @"password":[NSString stringWithFormat:@"%@",_textFieldPas.text],
                                 @"name":[NSString stringWithFormat:@"%@",_textFieldName.text],
                                 @"number":[NSString stringWithFormat:@"%@",_textFieldMobileNo.text],
                                 @"doctor_id":[NSNumber numberWithInt:ii],
                                 @"ProfileImg":postimagestr
                                 };
    
    
//    NSString *paramDict = [NSString stringWithFormat:
//                        @"{\"email\": \"%@\",\"password\": \"%@\",\"name\": \"%@\",\"number\": \"%@\",\"doctor_id\": \"%d\",\"ProfileImg\": \"%@\"}",
//                        _textFieldEmail.text,
//                        _textFieldPas.text,
//                        _textFieldName.text,
//                        _textFieldMobileNo.text,
//                        123456,postimagestr
//                        ];
    
   // NSString *str = [log_in_string stringByAppendingString:@"]}"];
    
    [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodPOST postData:paramDict callBackBlock:^(id response, NSError *error)
     {
         NSDictionary *dictionary = nil;;
         if (response)
         {
             dictionary = [[NSDictionary alloc] initWithDictionary:response];
             NSLog(@"signuprespose===%@",dictionary);
         }
         [SVProgressHUD dismiss];
         if (!error)
         {
             if (dictionary)
             {
                 if ([dictionary objectForKey:@"OTP"])
                 {
                 DAOtpVC *otp = [self.storyboard instantiateViewControllerWithIdentifier:@"DAOtpVC"];
                 otp.otpstr = [[dictionary objectForKey:@"data"] objectForKey:@"otp"];
                 otp.paisentIDstr = [[dictionary objectForKey:@"data"] objectForKey:@"id"];
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

#pragma mark
#pragma mark OpenCameraFromGallery:-

#pragma mark Rohit:-
#pragma mark open picker on signup screen::--

-(void)opencamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Test on real device, camera is not available in simulator" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    if(_pickerSelect)
        _pickerSelect = nil;
    _pickerSelect = [[UIImagePickerController alloc] init];
    [_pickerSelect setAllowsEditing:YES];
    _pickerSelect.sourceType = UIImagePickerControllerSourceTypeCamera;
    [_pickerSelect setShowsCameraControls:YES];
    _pickerSelect.delegate = self;
    
    [self presentViewController:_pickerSelect animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    _profileImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

#pragma Mark:-
#pragma MArk Tap on AlertView Gallery:-

//- (IBAction)singleTapping:(id)sender
//{
//    [[[UIAlertView new] initWithTitle:nil message:@"From where do you want to select the picture?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Photo Library", @"Camera", nil] show];
//}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button clicked %ld", (long)buttonIndex);
    switch (buttonIndex) {
        case 2://
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Test on real device, camera is not available in simulator" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return;
            }
            if(_pickerSelect)
                _pickerSelect = nil;
            _pickerSelect = [[UIImagePickerController alloc] init];
            [_pickerSelect setAllowsEditing:YES];
            _pickerSelect.delegate = self;
            _pickerSelect.sourceType = UIImagePickerControllerSourceTypeCamera;
            [_pickerSelect setShowsCameraControls:YES];
            [self presentViewController:_pickerSelect animated:YES completion:nil];
            
        }
            break;
        case 1://
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Test on real device, camera is not available in simulator" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return;
            }
            if(_pickerSelect)
                _pickerSelect = nil;
            _pickerSelect = [[UIImagePickerController alloc] init];
            [_pickerSelect setAllowsEditing:YES];
            //[_pickerSelect setShowsCameraControls:YES];
            _pickerSelect.delegate = self;
            
            _pickerSelect.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_pickerSelect animated:YES completion:nil];
            
        }
            break;
        default:
            break;
    }
}

- (IBAction)profilebuttonAction:(id)sender
{
    [[[UIAlertView new] initWithTitle:nil message:@"From where do you want to select the picture?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Photo Library", @"Camera", nil] show];
}

-(NSData *)getImageData:(UIImage*)imag
{
    NSData* dt = UIImagePNGRepresentation(imag);
    
    if (dt.length > (1 * 1024 * 1024)) {
        double exp = 0.15;
        dt = UIImageJPEGRepresentation(imag, exp);
        while (dt.length > (0.15 * 1024 * 1024)) {
            dt = UIImageJPEGRepresentation(imag, exp);
            if (exp - 0.1 <= 0)
                return dt;
            exp = exp - 0.1;
        }
        return dt;
    }
    return dt;
}
- (IBAction)_backbuttonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
