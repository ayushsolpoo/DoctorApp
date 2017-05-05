//
//  DAReminderDetailVC.h
//  DoctorApp
//
//  Created by macbook pro on 28/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
@interface DAReminderDetailVC : UIViewController
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UIView *viewCalender;
@end
