//
//  ALChatManager.h
//  DoctorApp
//
//  Created by macbook pro on 15/05/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <Applozic/ALChatLauncher.h>
#import <Applozic/ALUser.h>
#import <Applozic/ALConversationService.h>
#import <Applozic/ALRegisterUserClientService.h>

#define APPLICATION_ID @"55d1fa0a71ea32034dddc38cf94cda1e"


@interface ALChatManager : NSObject

@property(nonatomic,strong) ALChatLauncher * chatLauncher;

@property(nonatomic,strong) NSArray * permissableVCList;

-(instancetype)initWithApplicationKey:(NSString *)applicationKey;

-(void)registerUser:(ALUser * )alUser;

-(void)registerUserWithCompletion:(ALUser *)alUser withHandler:(void(^)(ALRegistrationResponse *rResponse, NSError *error))completion;

@property (nonatomic,retain) NSString * userID;

-(void)launchChat: (UIViewController *)fromViewController;

-(void)launchChatForUserWithDefaultText:(NSString * )userId andFromViewController:(UIViewController*)viewController;

-(void)registerUserAndLaunchChat:(ALUser *)alUser andFromController:(UIViewController*)viewController forUser:(NSString*)userId withGroupId:(NSNumber*)groupID;

-(void)launchChatForUserWithDisplayName:(NSString * )userId withGroupId:(NSNumber*)groupID andwithDisplayName:(NSString*)displayName andFromViewController:(UIViewController*)fromViewController;

-(void)createAndLaunchChatWithSellerWithConversationProxy:(ALConversationProxy*)alConversationProxy fromViewController:(UIViewController*)fromViewController;

-(void)launchListWithUserORGroup: (NSString *)userId ORWithGroupID: (NSNumber *)groupId andFromViewController:(UIViewController*)fromViewController;

-(void)launchOpenGroupWithKey:(NSNumber *)channelKey fromViewController:(UIViewController *)viewController;

-(BOOL)isUserHaveMessages:(NSString *)userId;

-(void) launchContactScreenWithMessage:(ALMessage *)alMessage andFromViewController:(UIViewController*)viewController;

-(NSString *)getApplicationKey;

-(void)launchChatListWithParentKey:(NSNumber *)parentGroupKey andFromViewController:(UIViewController *)viewController;

@end
