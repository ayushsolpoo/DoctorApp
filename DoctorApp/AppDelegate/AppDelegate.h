//
//  AppDelegate.h
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MMDrawerController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Google/Analytics.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property(nonatomic, strong)MMDrawerController *drawerController;
- (void)saveContext;


@end

