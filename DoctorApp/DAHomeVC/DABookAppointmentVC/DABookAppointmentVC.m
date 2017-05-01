//
//  DABookAppointmentVC.m
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DABookAppointmentVC.h"
#import "SWRevealViewController.h"
#import "DABookAppointmentCollectionReusableView.h"
#import "BasicViewController.h"
@interface DABookAppointmentVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *headerArray;
    NSArray *sectionArray;
    NSMutableArray *cellArray;
    //Calender functions
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSInteger dayId;
    NSDate *_dateSelected;
}
@property(strong,nonatomic)NSMutableArray *arrayOfData;
@property(strong,nonatomic)NSDictionary *dictOfData;
@property (weak, nonatomic) IBOutlet UIView *viewCalender;
@property (weak, nonatomic) IBOutlet UIButton *btnTodaysDate;
- (IBAction)backBtnTapped:(id)sender;
- (IBAction)calenderBtnTapped:(id)sender;




@end



@implementation DABookAppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayOfData = [[NSMutableArray alloc] init];
    headerArray  = [[NSArray alloc]initWithObjects:@"12 Mar 2017",@"13 Mar 2017",@"14 Mar 2017", nil];
    sectionArray = [[NSArray alloc]initWithObjects:@"Morning",@"Afernoon",@"Evening", nil];
    cellArray    = [[NSMutableArray alloc]initWithObjects:@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30", nil];
     _todayDate = [NSDate date];
    [self getClinicList];
    NSDateFormatter *dateFormat;
   
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    // again add the date format what the output u need
   // [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *finalDate = [NSString stringWithFormat:@"%@",_todayDate];
    
   // NSString *finalDate = [dateFormat stringFromDate:_todayDate];
    //[_btnTodaysDate setTintColor:[UIColor blackColor]];
    
    [_btnTodaysDate setTitle:finalDate forState:UIControlStateNormal];
    //calender functions
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    _viewCalender.hidden = YES;
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];

   // NSLog(@"%@",_arrayClinicData);
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return cellArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *lblTimeSlot = (UILabel*)[cell.contentView viewWithTag:100];
    [lblTimeSlot setText:cellArray[indexPath.row]];
    
    return  cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    
    DABookAppointmentCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                   UICollectionElementKindSectionHeader withReuseIdentifier:@"DABookAppointmentCollectionReusableView" forIndexPath:indexPath];
    [self updateSectionHeader:headerView forIndexPath:indexPath];
    
    return headerView;
}

- (void)updateSectionHeader:(DABookAppointmentCollectionReusableView *)header forIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [NSString stringWithFormat:@"header #%ld", (long)indexPath.section];
    header.headerLabel.text = text;
}

//TODO: GET CLINIC LIST TIME SLOT
-(void)sortDataAccordingToDayId:(NSInteger)dayId
{
//    for (int i = 0; i < [[_arrayOfData objectAtIndex:0] objectForKey:@"DoctorTimeSlot"] ; i++)
//    {
//        
//    }
}
-(void)getClinicList
{
    
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?api_token=%@&clinic_Id=%d",BASE_URL,TIME_SLOT,@"PUmvc65KlvuVskKZYUzBFxYxkHe4G7TbRHOWGW5E8NtopgqZIACkeDIGaRqK",1];
    [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodGET postData:nil callBackBlock:^(id response, NSError *error) {
        
        [SVProgressHUD dismiss];
        if (response)
        {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response options:0 error:&error];
            
            if (!jsonData)
            {
                
            }
            else
            {
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                NSLog(@"%@",JSONString);
            }
            
            NSDictionary *responseDict = [[NSMutableDictionary alloc]initWithDictionary:response];
            
                if ([responseDict objectForKey:@"data"])
                {
                    _dictOfData = [responseDict objectForKey:@"data"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
                    [dateFormatter setDateFormat:@"EEEE"];
                    NSString *selectedDate = [dateFormatter stringFromDate:[NSDate date]];
                    [self returnDayId:selectedDate];

                }
               
                
//                BasicViewController *ngView = [[BasicViewController alloc]initWithNibName:@"BasicViewController" bundle:Nil];
//                [self presentViewController:ngView animated:NO completion:nil];
                
//                BasicViewController *bokApVc = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicViewController"];
//                [self.navigationController showViewController:bokApVc sender:self];
//                clinicArray = [DAGlobal checkNullArray:[responseDict objectForKey:@"data"]];
//                [_clinicListTableView reloadData];
            
        }
        else if (error)
        {
            NSLog(@"the error is %@",[error localizedDescription]);
        }
    }];
}

//TODO: OUTLETS
- (IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if(_calendarManager.settings.weekModeEnabled){
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
    [_btnTodaysDate setTitle:finalDate forState:UIControlStateNormal];
    
    
    //get day of the week
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *selectedDate = [dateFormatter stringFromDate:_dateSelected];
    [self returnDayId:selectedDate];
    
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
-(void)returnDayId:(NSString*)strDate
{
    
    
    if ([strDate isEqualToString:@"Monday"])
    {
        dayId = 1;
    }
    else if ([strDate isEqualToString:@"Monday"])
    {
        dayId = 1;
    }
    else if ([strDate isEqualToString:@"Tuesday"])
    {
        dayId = 2;
    }
    else if ([strDate isEqualToString:@"Wednesday"])
    {
        dayId = 3;
    }
    else if ([strDate isEqualToString:@"Thursday"])
    {
        dayId = 4;
    }
    else if ([strDate isEqualToString:@"Friday"])
    {
        dayId = 5;
    }
    else if ([strDate isEqualToString:@"Saturday"])
    {
        dayId = 6;
    }
    else if ([strDate isEqualToString:@"Sunday"])
    {
        dayId = 7;
    }
    [self sortDataAccordingToDayId:dayId];
}
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

- (IBAction)calenderBtnTapped:(id)sender
{
   _viewCalender.hidden = NO;
}
@end
