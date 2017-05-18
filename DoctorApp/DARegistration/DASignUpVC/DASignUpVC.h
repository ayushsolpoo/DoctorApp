//
//  DASignUpVC.h
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DASignUpVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    __weak IBOutlet UIButton *signupbtn;
    __weak IBOutlet UIButton *facebookbtn;
    
}
@end
