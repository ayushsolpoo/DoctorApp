//
//  DAReminderDetailVC.h
//  DoctorApp
//
//  Created by macbook pro on 28/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
#import "DropDownClass.h"
#import "AppDelegate.h"
#import "SACalendar.h"

@interface DAReminderDetailVC : UIViewController<DropDownDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
{
    DropDownClass                    *_duratioDropDown;
    NSArray                          *_durationtimeArray;
    NSMutableArray                   *_addtimearray;
    NSString                         *datestring;
    NSString                         *timeslotstring;
    NSMutableArray                   *a;
    NSString *date1;
    NSString                         *currentdatestring;
    NSString *savedatabasedate;
    NSString *newsavedate ;
    NSString *currdate;
    NSString *getnoofdays;
    SACalendar *calendar;
    
    __weak IBOutlet UICollectionView *_timecollectionview;
    __weak IBOutlet UITextField      *_timeslotfield;
    __weak IBOutlet UITextField      *textfielddate;
    __weak IBOutlet UITextField      *textfieldmonths;

}
@property (weak, nonatomic) IBOutlet UIView *_alldate_timeview;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UIView *viewCalender;
-(void)myTimerTick;
@end
