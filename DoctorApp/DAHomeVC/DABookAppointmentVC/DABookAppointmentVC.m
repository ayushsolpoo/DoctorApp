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
    NSString *appointmentDateforPatient;
    NSDictionary *dictSelected;
    NSString *selectedDate;
}
@property(strong,nonatomic) NSMutableArray *arrayDataToShow;
@property(strong,nonatomic)NSMutableArray *arrayOfData;
@property(strong,nonatomic)NSDictionary *dictOfData;
@property (weak, nonatomic) IBOutlet UIWebView *webViewpayment;
@property (weak, nonatomic) IBOutlet UIView *viewCalender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewTimeSlot;
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
    _dateSelected = [NSDate date];
    dictSelected = [[NSDictionary alloc] init];
    appointmentDateforPatient = [[NSString alloc] init];
    [self getClinicList];
    NSDateFormatter *dateFormat;
    _webViewpayment.hidden = YES;
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *finalDate = [NSString stringWithFormat:@"%@",_todayDate];
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
    return _arrayDataToShow.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *lblTimeSlot = (UILabel*)[cell.contentView viewWithTag:100];
    
    NSInteger iDofSlot = [[_arrayDataToShow objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSArray *arrayofBookedAppointment = [_dictOfData objectForKey:@"BookedAppointment"];
    NSLog(@"%@",_dateSelected);
 //   dateFormatter.dateFormat = @"dd-MM-yyyy";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *selectedDate = [dateFormatter stringFromDate:_dateSelected];
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
   
    

    lblTimeSlot.textColor = [UIColor grayColor];
    for (int i = 0; i < arrayofBookedAppointment.count; i++)
    {
        NSInteger bookedID =[[arrayofBookedAppointment objectAtIndex:i] objectForKey:@"slot_Id"];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:s"];
        NSDate *dateForAppointment = [dateFormat dateFromString:[[arrayofBookedAppointment objectAtIndex:i] objectForKey:@"appt_date"]];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        NSString *appointmentDate = [dateFormat stringFromDate:dateForAppointment];

        if (bookedID == iDofSlot)
        {
            if ([appointmentDate isEqualToString:selectedDate])
            {
                lblTimeSlot.textColor = [UIColor greenColor];
            }
        }
        
    }

   
    [lblTimeSlot setText:[[_arrayDataToShow objectAtIndex:indexPath.row] objectForKey:@"slot_name"]];
    
    return  cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *lblTimeSlot = (UILabel*)[cell.contentView viewWithTag:100];
    selectedDate = [[NSString alloc] init];
    NSInteger iDofSlot = [[_arrayDataToShow objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSArray *arrayofBookedAppointment = [_dictOfData objectForKey:@"BookedAppointment"];
    NSLog(@"%@",_dateSelected);
    //   dateFormatter.dateFormat = @"dd-MM-yyyy";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    selectedDate = [dateFormatter stringFromDate:_dateSelected];
     dictSelected = [[NSDictionary alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    lblTimeSlot.textColor = [UIColor grayColor];
    for (int i = 0; i < arrayofBookedAppointment.count; i++)
    {
        NSInteger bookedID =[[arrayofBookedAppointment objectAtIndex:i] objectForKey:@"slot_Id"];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:s"];
        NSDate *dateForAppointment = [dateFormat dateFromString:[[arrayofBookedAppointment objectAtIndex:i] objectForKey:@"appt_date"]];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        appointmentDateforPatient = [dateFormat stringFromDate:dateForAppointment];
        
        if (bookedID == iDofSlot)
        {
            if ([appointmentDateforPatient isEqualToString:selectedDate])
            {
                //green color
                [[[UIAlertView alloc] initWithTitle:kAppName message:@"Slot not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
            
            
        }
        else
        {
            dictSelected = [_arrayDataToShow objectAtIndex:i];
            _webViewpayment.hidden = NO;
            [self makePayment];
        }
        
    }

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
//    NSString *text = [NSString stringWithFormat:@"header #%ld", (long)indexPath.section];
//    header.headerLabel.text = text;
}

//TODO: GET CLINIC LIST TIME SLOT
-(void)sortDataAccordingToDayId:(NSInteger)dayId
{
    _arrayDataToShow = [[NSMutableArray alloc] init];
    NSString *strID = [NSString stringWithFormat:@"%ld",(long)dayId];
    NSArray *arrayOfData = [_dictOfData objectForKey:@"DoctorTimeSlot"];
    NSInteger count = arrayOfData.count;
    for (int i = 0; i < count ; i++)
    {
        NSString *strDayidSlot = [NSString stringWithFormat:@"%@",[[arrayOfData objectAtIndex:i] objectForKey:@"dayId"]];
        if ([strID isEqualToString:strDayidSlot])
        {
            [_arrayDataToShow addObject:[arrayOfData objectAtIndex:i]];
        }
    }
    [_collectionViewTimeSlot reloadData];
    NSLog(@"%@",_arrayDataToShow);
    
}
//TODO:webview delegates
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request);
    NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
    if ([strUrl isEqualToString:@"http://182.73.229.226/payment?status=success"])
    {
        self.webViewpayment.hidden = YES;
        [self bookAppointment];
        return NO;
    }
    
    
//    else if ([strUrl isEqualToString:@"http://182.73.229.226/payment?status=fail"])
//    {
//        self.webViewpayment.hidden = YES;
//        return NO;
//    }
//    else
//    {
//         return YES;
//    }
    return YES;
}

//TODO:web service integration
-(void)bookAppointment
{
//patient/book-appointment
    //api_token,doctor_Id,patient_Id,clinic_Id,slot_Id,token_Id,appt_date
    [SVProgressHUD show];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:s"];
    selectedDate = [dateFormatter stringFromDate:_dateSelected];
    _dateSelected = [dateFormatter dateFromString:selectedDate];
    NSInteger slotID = [[dictSelected objectForKey:@"id"] integerValue];
  
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?api_token=%@&clinic_Id=%d&doctor_Id=%d&patient_Id=%d&slot_Id=%ld&token_Id=%ldappt_date=%@",BASE_URL,BOOK_APPOINTMENT,@"PUmvc65KlvuVskKZYUzBFxYxkHe4G7TbRHOWGW5E8NtopgqZIACkeDIGaRqK",1,1,1,(long)slotID,(long)slotID,_dateSelected];
   
    [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodPOST postData:nil callBackBlock:^(id response, NSError *error) {
        
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
                [self getClinicList];
            }
            
            NSDictionary *responseDict = [[NSMutableDictionary alloc]initWithDictionary:response];
            
        }
        else if (error)
        {
            NSLog(@"the error is %@",[error localizedDescription]);
        }
    }];

}
-(void)makePayment
{
    //self.view.hidden = YES;
    NSString *urlString = [NSString stringWithFormat:@"http://182.73.229.226/make-payment"];
    [_webViewpayment loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
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
