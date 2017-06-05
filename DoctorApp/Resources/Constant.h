//
//  Constant.h
//  DoctorApp
//
//  Created by MacPro on 21/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

/* Web Services */
//URLS
 
#define BASE_URL                     @"http://182.73.229.226/api/v1/"

#define LOGIN                        @"patient/login"
#define REGISTRATION                 @"patient/register"
#define OTP_VERIFICATION             @"patient/otp/verification"
#define SAVE_EMERGENCY_CONTACTS      @"patient/register/emergency-contact"
#define GET_APPOINTMENT_LIST         @"patient/appointment-list"
#define DOCTOR_CLINIC_LIST           @"doctor/clinic-list"
#define TIME_SLOT                    @"doctor/time-slot"
#define BOOK_APPOINTMENT             @"patient/book-appointment"
#define REMINDER_LIST                @"patient/get-reminder-list"

/* alert view constants */

#define SORRY                 @"Sorry!"
#define INFO                  @"Information!"
#define CONGRATULATION        @"Congratulation"
#define SAVED_CONTACTS        @"You have successfully saved the selected contacts."
#define kAppName              @"DoctorApp"


#define   bgcolor                 [UIColor colorWithRed:0/255.0 green:140/255.0 blue:207/255.0 alpha:1]

#endif /* Constant_h */
