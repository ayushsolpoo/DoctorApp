//
//  FacebookHelper.h
//  SampleApp
//
//  Created by kraftly on 1/21/16.
//  Copyright © 2016 Kraftly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface FacebookHelper : NSObject

+ (void)login:(void (^)(id result, NSError *err, BOOL cancelled))completetion;
+ (void)loginWithParameters:(NSString*)params completetion:(void (^)(id result, NSError *err, BOOL cancelled))completetion;
+ (void)shareLinkOnFacebook:(NSURL*)linkUrl withTitle:(NSString*)title imageUrl:(NSURL*)imgUrl withDescription:(NSString*)description onViewControlelr:(UIViewController*)viewC completetion:(void (^)(id result, NSError *err, BOOL cancelled))completetion;
+ (FacebookHelper *)sharedInstance;
/*
 Use this for settings login
 */
- (void)loginFacebookFromSettings:(NSString*)fields Completion:(void(^)(NSDictionary *response,BOOL isCancelled))block;

- (void)getPhotosforUser:(NSString*)userId completetion:(void (^)(id result, NSError *err, BOOL cancelled))completetion;

- (void)getUserAccountsCompletetion:(void (^)(id result, NSError *err, BOOL cancelled))completetion;
- (void)hasRequiredPermissions:(void(^)(BOOL hasRequiredPremissions))completion;
- (void)loginForPromoteOnViewController:(UIViewController *)viewC completion:(void(^)(BOOL hasRequiredPremissions, NSString *token, NSString *userId))completion;
@end





