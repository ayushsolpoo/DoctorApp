//
//  DAHomeVC.h
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALChatManager.h"
#import  <Applozic/ALChatViewController.h>
#import "ALChatManager.h"
//#import "ApplozicLoginViewController.h"
#import  <Applozic/ALUserDefaultsHandler.h>
#import  <Applozic/ALRegisterUserClientService.h>
#import  <Applozic/ALDBHandler.h>
#import  <Applozic/ALContact.h>
#import  <Applozic/ALDataNetworkConnection.h>
#import  <Applozic/ALMessageService.h>
#import  <Applozic/ALContactService.h>
#import  <Applozic/ALUserService.h>
#import <Applozic/ALImagePickerHandler.h>
#import "CNPPopupController.h"


@interface DAHomeVC : UIViewController<CNPPopupControllerDelegate>
{
    
    __weak IBOutlet UIView *mainview;
    __weak IBOutlet UIButton *nobtn;
    __weak IBOutlet UIButton *askquesbtn;
    __weak IBOutlet UIButton *sosfirstpopuonobtn;
    __weak IBOutlet UIButton *sosfirstpopupyesbtn;
    NSInteger popint;
}
@property(nonatomic,strong)
UIActivityIndicatorView *activityView;
@property (nonatomic, strong) CNPPopupController *popupController;
@end
