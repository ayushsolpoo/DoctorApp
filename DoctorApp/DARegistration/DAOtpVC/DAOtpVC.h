//
//  DAOtpVC.h
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAOtpVC : UIViewController

{
    
    __weak IBOutlet UIButton *varifybtn;
}
@property (strong, nonatomic) NSString *otpstr;
@property (strong, nonatomic) NSString *paisentIDstr;
@end
