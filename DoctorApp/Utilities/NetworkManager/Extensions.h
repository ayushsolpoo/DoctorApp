//
//  Colors.h
//  KartRocketMarketPlace
//
//  Created by Naren on 04/06/15.
//  Copyright (c) 2015 KartRocket. All rights reserved.
//

#ifndef KartRocketMarketPlace_Colors_h
#define KartRocketMarketPlace_Colors_h


#pragma mark -
#pragma mark Sign In Colors

#define kShareAppdelegate               (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define BarColor                      [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1.000]

//#define appBlueColor                    [UIColor colorWithRed:2.0/255.0 green:136.0/255.0 blue:209.0/255.0 alpha:1.000]

//#define appBlueColor                    [UIColor colorWithRed:252.0/255.0 green:51.0/255.0 blue:11.0/255.0 alpha:1.000]
#define appBlueColor                    [UIColor colorWithRed:80.0/255.0 green:163.0/255.0 blue:197.0/255.0 alpha:1.000]

#define appLightBlueColor               [UIColor colorWithRed:80.0/255.0 green:163.0/255.0 blue:197.0/255.0 alpha:1.000]



//#define appBrownColor                    [UIColor colorWithRed:130.0/255.0 green:80.0/255.0 blue:60.0/255.0 alpha:1.000]
#define appBrownColor                    [UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.000]

#define appGreyColor                    [UIColor colorWithRed:158.0/255.0 green:158.0/255.0 blue:158.0/255.0 alpha:1.000]

#define appDarkGreyColor                [UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.000]
#define appLineColor                    [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.000]
#define appGreenColor                    [UIColor colorWithRed:130.0/255.0 green:181.0/255.0 blue:63.0/255.0 alpha:1.000]
#define appLightGreenColor                    [UIColor colorWithRed:243.0/255.0 green:250.0/255.0 blue:236.0/255.0 alpha:1.000]


#define RightBarButtonFrame                  CGRectMake(0, 0, 20, 20)

// PROD
#define ApiHost                             "http://x.kraftly.com"
#define ApiHost2                            "http://network.kraftly.com"
#define PaymentAPI                          @"https://kraftly.com"

// DEV
//#define ApiHost                         "http://dev.kraftly.com"
//#define ApiHost2                        "http://ndev.kraftly.com"
//#define PaymentAPI                      @"https://mdev.kraftly.com"

// BETA
//#define ApiHost                             "http://beta.kraftly.com"
//#define ApiHost2                            "http://ndev.kraftly.com"

// ALPHA78
//#define ApiHost                             "http://alpha.kraftly.com"
//#define ApiHost2                            "http://ndev.kraftly.com"

#define ProductShareUrl                 "https://kraft.ly/new?url=https://m.kraftly.com/product/"

//#define ProductShareUrl                 "https://kraftly.com/product/"

#define WebUrl                          "https://kraftly.com"

#define kAppName                        @"Kraftly"

#define kDeviceWidth                            [[UIScreen mainScreen] bounds].size.width
#define kDeviceHeight                           [[UIScreen mainScreen] bounds].size.height

#define kUserDefaults               [NSUserDefaults standardUserDefaults]
#define kSessionId                  @"session_id"
#define kUserPhone                  @"userPhone"
#define kUserGender                 @"gender"
#define kUserDob                    @"dob"

#define kGAEcommereceId             @"UA-64912882-5"

#endif
