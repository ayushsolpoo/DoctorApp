//
//  DABookAppointmentVC.h
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
@interface DABookAppointmentVC : UIViewController
{
    
    __weak IBOutlet UIView *mainview;
}

@property(strong,nonatomic) NSMutableArray *arrayClinicData;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@end
