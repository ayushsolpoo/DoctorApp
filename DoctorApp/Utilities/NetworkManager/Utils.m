//
//  Utils.m
//  QR Reader
//
//  Created by JAYANT SAXENA on 31/01/12.
//  Copyright 2012 LSquare Technologies. All rights reserved.
//

#import "Utils.h"
#import "Reachability.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVPlayer.h>
//#import "QR_ReaderViewController.h"

@implementation Utils

+ (void)init
{
	if([[NSUserDefaults standardUserDefaults] integerForKey:@"Version"] != 1)
	{
		[[NSUserDefaults standardUserDefaults] setBool:NO	forKey:@"FBLogin"];
		[[NSUserDefaults standardUserDefaults] setBool:NO	forKey:@"TwitterLogin"];
		[[NSUserDefaults standardUserDefaults] setBool:YES	forKey:@"LocationServiceActive"];
		[[NSUserDefaults standardUserDefaults] setBool:YES	forKey:@"soundEnabled"];
		[[NSUserDefaults standardUserDefaults] setBool:NO	forKey:@"LoggedIntoFloost"];
		[[NSUserDefaults standardUserDefaults] setInteger:1	forKey:@"Version"];
	}
}

//+ (BOOL)isUserNeedsFBLogin
//{
//	return [[NSUserDefaults standardUserDefaults] boolForKey:@"FBLogin"];
//}
//+ (void)setFBLogin:(BOOL)val
//{
//	return [[NSUserDefaults standardUserDefaults] setBool:val forKey:@"FBLogin"];
//}
//
//
//+ (BOOL)isUserNeedsTwitterLogin
//{
//	return [[NSUserDefaults standardUserDefaults] boolForKey:@"TwitterLogin"];
//}
//+ (void)setTwitterLogin:(BOOL)val
//{
//	return [[NSUserDefaults standardUserDefaults] setBool:val forKey:@"TwitterLogin"];
//}
//

+ (BOOL)isUserLoggedIntoFloost
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"LoggedIntoFloost"];
}
+ (void)setLoggedIntoFloost:(BOOL)val
{
	return [[NSUserDefaults standardUserDefaults] setBool:val forKey:@"LoggedIntoFloost"];
}

+(NSString*)userNameForFloost
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
}
+(NSString*)passwordForFloost
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
}


+(void)setPassword:(NSString*)password
{
	return [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
}

+(void)setUserName:(NSString*)userName
{
	return [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
}


+ (BOOL)connected
{
	//return NO; // force for offline testing
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	NetworkStatus netStatus = [hostReach currentReachabilityStatus];
	return !(netStatus == NotReachable);
}

+(void)setshadowoffset:(UIView *)backview
{
    CALayer *iconlayer = backview.layer;
    iconlayer.masksToBounds = NO;
    iconlayer.cornerRadius = 8.0;
    iconlayer.shadowOffset = CGSizeMake(-5.0, 5.0);
    iconlayer.shadowRadius = 5.0;
    iconlayer.shadowOpacity = 0.6;
}

@end



