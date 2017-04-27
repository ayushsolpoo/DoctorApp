//
//  FacebookHelper.m
//  SampleApp
//
//  Created by kraftly on 1/21/16.
//  Copyright © 2016 Kraftly. All rights reserved.
//



#import "FacebookHelper.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#define kFaceBookAppID @"1194298470697111"

@interface FacebookHelper()

@property (nonatomic, strong) ACAccountStore *facebookACAccountStore;

@end

@implementation FacebookHelper

+ (FacebookHelper *)sharedInstance
{
    static FacebookHelper *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      instance = [[FacebookHelper alloc] init];
                  });
    return instance;
}



// Code provided by Teena
- (void)isFacebookConfigured:(void(^)(ACAccount *account))block
{
    self.facebookACAccountStore = [[ACAccountStore alloc] init];
    NSArray *permissionsArray = [[NSArray alloc] initWithObjects:
                                 @"email",
                                 nil];
    
    ACAccountType *facebookTypeAccount = [self.facebookACAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [self.facebookACAccountStore requestAccessToAccountsWithType:facebookTypeAccount
                                                         options:@{ACFacebookAppIdKey:kFaceBookAppID, ACFacebookPermissionsKey:permissionsArray,ACFacebookAudienceKey : ACFacebookAudienceEveryone}
                                                      completion:^(BOOL granted, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if(granted)
                            {
                                NSArray *accounts = [self.facebookACAccountStore accountsWithAccountType:facebookTypeAccount];
                                if(accounts.count==0)
                                {
                                    block(nil);
                                }
                                else
                                {
                                    ACAccount *faceBookAccount=[accounts objectAtIndex:0];
                                    block(faceBookAccount);
                                }
                            }
                            else
                            {
                                block(nil);
                            }
                            
                        });
     }];
}

/**
 *  Called to login with facebook. Checks if the user is logged in the settings menu then it logs him in otherwise uses facebook SDK for logging in
 *
 *  @param block completeHandler Returns nsdictionary of desired values
 */
- (void)loginFacebookFromSettings:(NSString*)fields Completion:(void(^)(NSDictionary *response,BOOL isCancelled))block
{
//    [self isFacebookConfigured:^(ACAccount *account)
//     {
//         if (account)
//         {
//             ACAccount *faceBookAccount = account;
//             
//             NSDictionary *params = @{@"fields": fields};
//             NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
//             
//             SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
//                                                       requestMethod:SLRequestMethodGET
//                                                                 URL:meurl
//                                                          parameters:params];
//             merequest.account = faceBookAccount;
//             
//             [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
//              {
//                  NSError* e;
//                  if (responseData)
//                  {
//                      NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
//                                                                           options:kNilOptions
//                                                                             error:&e];
//                      block(json,NO);
//                  }
//                  else
//                  {
//                      block(nil,YES);
//                  }
//                  
//              }];
//         }
//         else
//         {
//             
             NSString *params = @"id,email,picture.width(640),gender,work,first_name,last_name,location";
             [FacebookHelper loginWithParameters:params completetion:^(id result, NSError *err, BOOL cancelled) {
                 
                 if (result)
                 {
                     block(result, NO);
                 }
                 else
                 {
                     if ([[err localizedFailureReason] isEqualToString:@"com.facebook.sdk:UserLoginCancelled"])
                     {
                         block(nil,YES);
                     }
                     else
                     {
                         block(result, NO);
                     }
                 }
             }];
//         }
//     }];
}


+ (void)login:(void (^)(id result, NSError *err, BOOL cancelled))completetion
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorBrowser;
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"error");
             completetion(nil,error,NO);
         }
         else if (result.isCancelled)
         {
             completetion(nil,nil,YES);
         }
         else
         {
             // If you ask for multiple permissions at once, you
             // should check if specific permissions missing
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 if ([FBSDKAccessToken currentAccessToken])
                 {
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                      {
                          if (!error)
                          {
                              completetion(result,nil,NO);
                          }
                          
                      }];
                 }
                 else
                 {
                     completetion(nil,error,NO);
                 }
             }
         }
     }];
}

+ (void)loginWithParameters:(NSString*)params completetion:(void (^)(id result, NSError *err, BOOL cancelled))completetion
{
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"email"])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":params}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error)
             {
                 completetion(result,nil,NO);
             }
             
         }];
    }
    else
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorBrowser;
        [login logInWithReadPermissions:@[@"email"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
            if (error)
            {
                NSLog(@"error");
                completetion(nil,error,NO);
            }
            else if (result.isCancelled)
            {
                completetion(nil,nil,YES);
            }
            else
            {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if ([result.grantedPermissions containsObject:@"email"])
                {
                    if ([FBSDKAccessToken currentAccessToken])
                    {
                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":params}]
                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                         {
                             if (!error)
                             {
                                 completetion(result,nil,NO);
                             }
                             
                         }];
                    }
                    else
                    {
                        completetion(nil,error,NO);
                    }
                }
                else
                {
                    [[[UIAlertView alloc] initWithTitle:kAppName message:@"Your email permissions are not authenticated. Please retry again after 1 minute." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    completetion(nil,nil,NO);
                    
                }
            }
        }];
    }
}

- (void)fetchFriendInfoWithParams:(NSString*)params completetion:(void(^)(id result, NSError *error))completionBlock
{
    
}

+ (void)shareLinkOnFacebook:(NSURL*)linkUrl withTitle:(NSString*)title imageUrl:(NSURL*)imgUrl withDescription:(NSString*)description onViewControlelr:(UIViewController*)viewC completetion:(void (^)(id result, NSError *err, BOOL cancelled))completetion
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = linkUrl;
    content.contentTitle = title;
    content.imageURL = imgUrl;
    content.contentDescription = description;
    [FBSDKShareDialog showFromViewController:viewC
                                 withContent:content
                                    delegate:nil];
}


- (void)getPhotosforUser:(NSString*)userId completetion:(void (^)(id result, NSError *err, BOOL cancelled))completetion
{
    
    [self isFacebookConfigured:^(ACAccount *account)
     {
         if (account)
         {
             ACAccount *faceBookAccount = account;
             
             NSDictionary *params = @{@"fields": @"picture.width(640)", @"type":@"uploaded"};
             NSURL *meurl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/photos",userId]];
             
             SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                       requestMethod:SLRequestMethodGET
                                                                 URL:meurl
                                                          parameters:params];
             merequest.account = faceBookAccount;
             
             [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
              {
                  NSError* e;
                  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                                       options:kNilOptions
                                                                         error:&e];
                  completetion(json,nil,NO);
              }];
         }
         else
         {
             if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_photos"])
             {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@/photos",userId] parameters:@{@"type":@"uploaded",@"fields":@"picture.width(640)",@"type":@"large"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                  {
                      if (error)
                      {
                          NSLog(@"error");
                          completetion(nil,error,NO);
                      }
                      else
                      {
                          completetion(result,nil,NO);
                      }
                      
                  }];
             }
             else
             {
                 FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                 loginManager.loginBehavior = FBSDKLoginBehaviorBrowser;
                 [loginManager logInWithReadPermissions:@[@"user_photos"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
                  {
                      if (error)
                      {
                          NSLog(@"error");
                          completetion(nil,error,NO);
                      }
                      else if (result.isCancelled)
                      {
                          completetion(nil,nil,YES);
                      }
                      else
                      {
                          [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@/photos",userId] parameters:@{@"type":@"uploaded",@"fields":@"picture.width(640)",@"type":@"large"}]
                           startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                           {
                               if (!error)
                               {
                                   completetion(result,nil,NO);
                               }
                               else
                               {
                                   completetion(nil,error,NO);
                               }
                           }];
                      }
                  }];
             }
         }
     }];
}

- (void)getUserAccountsCompletetion:(void (^)(id result, NSError *err, BOOL cancelled))completetion
{
    
    [self isFacebookConfigured:^(ACAccount *account)
     {
         if (account)
         {
             ACAccount *faceBookAccount = account;
             
             NSDictionary *params = nil;
             NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me/accounts"];
             
             SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                       requestMethod:SLRequestMethodGET
                                                                 URL:meurl
                                                          parameters:params];
             merequest.account = faceBookAccount;
             
             [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
              {
                  NSError* e;
                  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                                       options:kNilOptions
                                                                         error:&e];
                  completetion(json,nil,NO);
              }];
         }
         else
         {
             if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"pages_show_list"])
             {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/accounts" parameters:nil]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                  {
                      if (error)
                      {
                          NSLog(@"error");
                          completetion(nil,error,NO);
                      }
                      else
                      {
                          completetion(result,nil,NO);
                      }
                      
                  }];
             }
             else
             {
                 FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                 loginManager.loginBehavior = FBSDKLoginBehaviorBrowser;
                 [loginManager logInWithReadPermissions:@[@"pages_show_list"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
                  {
                      if (error)
                      {
                          NSLog(@"error");
                          completetion(nil,error,NO);
                      }
                      else if (result.isCancelled)
                      {
                          completetion(nil,nil,YES);
                      }
                      else
                      {
                          [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/accounts" parameters:nil]
                           startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                           {
                               if (!error)
                               {
                                   completetion(result,nil,NO);
                               }
                               else
                               {
                                   completetion(nil,error,NO);
                               }
                           }];
                      }
                  }];
             }
         }
     }];
}

- (void)hasRequiredPermissions:(void(^)(BOOL hasRequiredPremissions))completion
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"manage_pages"] && [[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_pages"] && [[FBSDKAccessToken currentAccessToken] hasGranted:@"user_photos"])
    {
        completion(YES);
    }
    else
    {
        completion(NO);
    }
}

- (void)loginForPromoteOnViewController:(UIViewController *)viewC completion:(void(^)(BOOL hasRequiredPremissions, NSString *token, NSString *userId))completion
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"manage_pages"] && [[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_pages"] && [[FBSDKAccessToken currentAccessToken] hasGranted:@"user_photos"])
    {
        completion(YES,[[FBSDKAccessToken currentAccessToken] tokenString],[[FBSDKAccessToken currentAccessToken] userID]);
    }
    else
    {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        loginManager.loginBehavior = FBSDKLoginBehaviorBrowser;
        [loginManager logInWithPublishPermissions:@[@"manage_pages",@"publish_pages"] fromViewController:viewC handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (!error)
            {
                completion(YES,[[FBSDKAccessToken currentAccessToken] tokenString],[[FBSDKAccessToken currentAccessToken] userID]);
            }
            else
            {
                completion(NO,nil,nil);
            }
        }];
    }
}

@end
