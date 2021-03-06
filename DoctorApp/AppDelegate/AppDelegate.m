//
//  AppDelegate.m
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "AppDelegate.h"
#import "DABookAppointmentVC.h"
#import "DASignUpVC.h"
#import "DALeftSideVC.h"
#import "DARighMenuVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
#pragma mark: localnotification:-
   //-----------------------------------------------------------------------------------------//
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];
    }

    //------------------------------------------------------------------------------------------//
    [Fabric with:@[[Crashlytics class]]];
     [FBSDKAppEvents activateApp];
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
//    [[GGLContext sharedInstance] configureWithError:&configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
//    
//    // Optional: configure GAI options.
//    GAI *gai = [GAI sharedInstance];
//    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
//    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
  //  [self showLogin];
  //  [self showHomeScreen];
  //  [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"DASignUpVC"];
    
    return YES;
}


- (void)showLogin
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *signUp  = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:signUp];
    [self.window setRootViewController:nav];
}

- (void) showHomeScreen
{
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Appointment" bundle:nil];
    UIViewController * leftSideDrawerViewController = [storyboard instantiateViewControllerWithIdentifier:@"DALeftSideVC"];
    
    UIViewController * centerViewController = [storyboard instantiateViewControllerWithIdentifier:@"DAHomeVC"];
    
    UIViewController * rightSideDrawerViewController = [storyboard instantiateViewControllerWithIdentifier:@"DARighMenuVC"];

    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    UINavigationController * rightSideNavController = [[UINavigationController alloc] initWithRootViewController:rightSideDrawerViewController];
    [rightSideNavController setRestorationIdentifier:@"MMExampleRightNavigationControllerRestorationKey"];
    UINavigationController * leftSideNavController = [[UINavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
    [leftSideNavController setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftSideNavController
                             rightDrawerViewController:rightSideNavController];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
    

//    UIViewController *tabBarcontroller  = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//    UINavigationController *navCenter = [[UINavigationController alloc]initWithRootViewController:navCenter];
//
    [self.window setRootViewController:self.drawerController];
    [_window makeKeyAndVisible];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
//    UIBackgroundTaskIdentifier bgTask =0;
//    UIApplication  *app = [UIApplication sharedApplication];
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        [app endBackgroundTask:bgTask];
//    }];
//    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                      target:self
//                                                    selector:@selector(timerCountDown:)
//                                                    userInfo:nil
//                                                     repeats:YES];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        //application.applicationIconBadgeNumber = 0;
    }
    application.applicationIconBadgeNumber = 0;
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"DoctorApp"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - Core Data stack

-(NSManagedObjectContext *)managedObjectContext{
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator !=nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"myMetaData.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unsolved error %@,%@",error,[error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

-(NSManagedObjectModel *)managedObjectModel{
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modeURL = [[NSBundle mainBundle]URLForResource:@"DoctorApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modeURL];
    return  _managedObjectModel;
}

-(NSURL *)applicationDocumentsDirectory{
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = [array objectAtIndex:0];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    //    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return url;
    
    
}


@end
