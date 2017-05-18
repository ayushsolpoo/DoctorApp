//
//  DAReminderDetailVC.m
//  DoctorApp
//
//  Created by macbook pro on 28/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAReminderDetailVC.h"
#import "Customcollectioncell.h"
#import "SACalendar.h"
#import "DateUtil.h"

@interface DAReminderDetailVC ()<SACalendarDelegate>
{
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSDate *_dateSelected;
    NSMutableDictionary      *_eventsByDate;
    __weak IBOutlet UIButton *timeformatdropdown;
    NSArray *items;
}
@property (weak, nonatomic) IBOutlet UITextField *txtFieldMedicineName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldChooseDate;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldNumberofTimes;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldNumberOfDays;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
- (IBAction)backBtnTapped:(id)sender;
- (IBAction)btnChangeDateTapped:(id)sender;

@end

@implementation DAReminderDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _todayDate = [NSDate date];
    _addtimearray = [[NSMutableArray alloc]init];
     a   = [[NSMutableArray alloc]init];
   // _viewCalender.hidden = YES;
    [self createRandomEvents];
    //[_btnDate setTitle:[NSString stringWithFormat:@"%@",_todayDate] forState:UIControlStateNormal];
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    [self setshadow];
    [self setUpTextFieldDatePicker];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];

    // Do any additional setup after loading the view.
}

-(void)setshadow
{
    _timeslotfield.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _timeslotfield.layer.borderWidth=1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//TODO:Textfield delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
//TODO:Webservice methods
-(void)webserviceMedicineList
{
    
}
//TODO:CALENDER DELEGATES
#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate];
}

- (IBAction)didChangeModeTouch
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 300;
    if(_calendarManager.settings.weekModeEnabled)
    {
        newHeight = 85.;
    }
    
    // self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    //testing
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: _dateSelected options:0];
    NSString *finalDate = [NSString stringWithFormat:@"%@",nextDate];
    [_btnDate setTitle:finalDate forState:UIControlStateNormal];
    
    
    //get day of the week
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *selectedDate = [dateFormatter stringFromDate:_dateSelected];
   
    
    //get day of the week
    _viewCalender.hidden = YES;
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement
- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_todayDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Calender data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:0];
    //  _minDate = [NSDate date];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:3];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//TODO:Button outlets
- (IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma Mark:-
#pragma mark open calender :-

- (IBAction)btnChangeDateTapped:(id)sender
{
    _viewCalender.hidden = NO;
    SACalendar *calendar = [[SACalendar alloc]initWithFrame:CGRectMake(0, 384, 375, 284)
                                            scrollDirection:ScrollDirectionHorizontal
                                              pagingEnabled:YES];
    
    calendar.delegate = self;
    [self.view addSubview:calendar];
}

#pragma mark:-
#pragma mark calender delegate method:-
-(void) SACalendar:(SACalendar*)calendar didSelectDate:(int)day month:(int)month year:(int)year
{
    NSLog(@"Date Selected : %02i/%02i/%04i",day,month,year);
    datestring = [NSString stringWithFormat:@"%02i-%02i-%04i",day,month,year];
    [_btnDate setTitle:[NSString stringWithFormat:@"%@", datestring] forState:UIControlStateNormal];
}

/**
 *  Delegate method : get called user has scroll to a new month
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    //NSLog(@"Displaying : %@ %04i",[DateUtil getMonthString:month],year);
}



- (IBAction)_addtimebuttonAction:(id)sender
{
    int i = 0;
     NSString *st = [NSString stringWithFormat:@"%@",_timeslotfield.text];
    [_addtimearray addObject:st];
    i++;
      [_timecollectionview reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _addtimearray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Customcollectioncell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    timeslotstring = [NSString stringWithFormat:@"%@",_addtimearray];
    cell.timelabel.text = [_addtimearray objectAtIndex:indexPath.item];
    
    return cell;
}



#pragma Mark:-
#pragma  DropDownClass Delegate Method:-

-(void) dropDownDelegateMethod:(DropDownClass *)sender
{
    if (sender.tag == 1)
    {
        _duratioDropDown = nil;
        
    }
    else if (sender.tag == 2)
    {
        _duratioDropDown = nil;
        
    }
}
-(void)dropdownSelectedIndex:(int)index tableNo:(int)tableno
{
    if (tableno == 1)
    {
        _timeslotfield.text = [_durationtimeArray objectAtIndex:index];
        NSLog(@"index===%d",index);
        //_titleString = [NSString stringWithFormat:@"%d",index];
    }
  }


- (IBAction)addreminderbutton:(id)sender {
    
    // save record....
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"MedicineTime" inManagedObjectContext:context];
    //[newDevice setValue:st forKey:@"datetime"];
    [newDevice setValue:_txtFieldMedicineName.text forKey:@"namemedician"];
    [newDevice setValue:_txtFieldNumberOfDays.text forKey:@"datetime"];
    [newDevice setValue:datestring forKey:@"datestring"];
    [newDevice setValue:timeslotstring forKey:@"timeslot"];
    NSError *error = nil;
    [context save:&error];
    
    
    // fetch record....
    NSManagedObjectContext *contextfetch = [appDelegate managedObjectContext];
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"MedicineTime"];
    //request.predicate = [NSPredicate predicateWithFormat:@"userprofile.name== %@",self.title];
    NSError *errorfetch = nil;
    NSDictionary *dict = [[contextfetch executeFetchRequest:request error:&error] lastObject];
    getnoofdays= [dict  valueForKey:@"datetime"];
    savedatabasedate = [dict  valueForKey:@"datestring"];
    [self changedateformat];
    
    NSString *timeslotstring = [[[dict  valueForKey:@"timeslot"] componentsSeparatedByString:@""] objectAtIndex:0];
    NSString  *str2 = [timeslotstring stringByReplacingOccurrencesOfString:@"(" withString:@""];
    NSString  *str3 = [str2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSString *newString = [[str3 componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    items = [newString componentsSeparatedByString:@","];
    
    
    UIBackgroundTaskIdentifier bgTask =0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
     [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(myTimerTick) userInfo:nil repeats:YES]; // the interval is in seconds...
  }

#pragma mark:-
#pragma Mark change date format:-

-(void)changedateformat
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:savedatabasedate];
    
    NSDate *now = [NSDate date];
    int daysToAdd = getnoofdays.intValue;
    NSLog(@"Clean: %d", daysToAdd);// or 60 :-)
    
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:daysToAdd];
    
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *newDate2 = [gregorian dateByAddingComponents:components toDate:now options:0];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    newsavedate = [dateFormatter stringFromDate:newDate2];
    NSLog(@"Clean: %@", newsavedate);
}


-(void)myTimerTick
{

    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    currdate = [dateFormat stringFromDate:today];
    NSLog(@"date: %@", currdate);
    
    // get current time
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *currenttimestr =   [dateFormatter stringFromDate:now];
    NSString *newOutput = [NSString stringWithFormat:@"\"%@\"",currenttimestr];
    NSString *newOutput1 =  [newOutput stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%luttttt",(unsigned long)[items count]);
    
    for (int j= 0; j<=items.count-1; j++)
    {
        NSString *w = [NSString stringWithFormat:@"%@",[items objectAtIndex:j]];
        NSString *ss =  [w stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@finaltime value",ss);
        NSLog(@"%@ttttt",newOutput1);
        NSLog(@"%lu",(unsigned long)[ss length]);
        NSLog(@"%lu",(unsigned long)[newOutput1 length]);
        
        if ([newOutput1 isEqualToString: ss])
        {
            // if user change time slot than get
            // get all time slot and comapare the inserted value along with accending order.
            
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
            localNotification.alertBody = @"hello solpoo";
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.repeatInterval = NSCalendarUnitHour;
            localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
        }else if ([currdate isEqualToString:newsavedate])
        {
            [self deleteAllEntities];
//            NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores lastObject];
//            NSError *error = nil;
//            NSURL *storeURL = store.URL;
//            [self.persistentStoreCoordinator removePersistentStore:store error:&error];
//            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
//             NSLog(@"Data Reset");

            
        }
        
    }
}

#pragma Mark:-
#pragma Mark delete all record:-
- (void)deleteAllEntities
{
    NSPersistentStore *store = @"";
    NSError *error;
    NSURL *storeURL = store.URL;
    NSPersistentStoreCoordinator *storeCoordinator = @"";
    [storeCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
}

#pragma Mark:=-
#pragma Mark timeslot DropDown:-

- (IBAction)timeformatdropdown:(id)sender
{
    CGFloat tableHeight = 50;
    if (_duratioDropDown==nil) {
        _duratioDropDown = [[DropDownClass alloc]showDropDown:sender tableHeight:&tableHeight tableArray:@[@"AM",@"PM"]imageArray:nil tableDir:@"down" TableNo:1];
        _durationtimeArray = [NSArray arrayWithObjects:@"AM",@"PM", nil];
        _duratioDropDown.delegate = self;
        _duratioDropDown.tag = 1;
    }
    else
    {
        [_duratioDropDown hideDropDown:sender];
        _duratioDropDown = nil;
    }
}
#pragma Mark:-
#pragma mark open datepicker:-

-(void)setUpTextFieldDatePicker
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [_timeslotfield setInputView:datePicker];
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self->_timeslotfield.inputView;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm a"]; //24hr time format
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    _timeslotfield.text = [NSString stringWithFormat:@"%@",dateString];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    calendar.hidden = YES;
    return YES;
}
@end
