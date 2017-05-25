//
//  DAHomeVC.m
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAHomeVC.h"
#import "DAAppointmentListVC.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "DAHomeCCell.h"
#import "DAReminderVC.h"
#import "DAReminderDetailVC.h"
#import "DAChatVC.h"
#import "Utils.h"

@interface DAHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray              *slideImageSetArray;
    NSMutableArray              *docallimgarr;
    NSMutableArray              *docalltextarr;
    __weak IBOutlet UIView      *sospopupview;
    __weak IBOutlet UIView      *sosfirstpopup;
    
}
@property (nonatomic) IBOutlet UIButton* revealButtonItem;
@property (weak, nonatomic) IBOutlet UICollectionView *apCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *blockcollectionview;
@property (weak, nonatomic) IBOutlet UICollectionView *maincollectionview;
@property (weak, nonatomic) IBOutlet UIPageControl *apPageControll;
@end

@implementation DAHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self customSetup];
    sospopupview.hidden = YES;
    sosfirstpopup.hidden = YES;
    slideImageSetArray = [[NSMutableArray alloc]initWithObjects:@"image1",@"image2",@"image3",nil];
    docallimgarr = [[NSMutableArray alloc]initWithObjects:@"appointment_home_icon",@"doc_chat_icon",@"token_icon",@"reminder_icon",nil];
    docalltextarr = [[NSMutableArray alloc]initWithObjects:@"Appointment",@"Chat With Doctor",@"Token",@"Reminder",nil];
    //---------------------------------------------------------------
    [self setchat];
    //-----------------------------------------------
}
-(void)viewWillAppear:(BOOL)animated
{
    [Utils setshadowoffset:nobtn];
    [Utils setshadowoffset:askquesbtn];
    [Utils setshadowoffset:sosfirstpopuonobtn];
    [Utils setshadowoffset:sosfirstpopupyesbtn];
    //--------------------------------------------------------------
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userUpdate:) name:@"userUpdate" object:nil];
    
    //////////////////////////   SET AUTHENTICATION-TYPE-ID FOR INTERNAL USAGE ONLY ////////////////////////
    //    [ALUserDefaultsHandler setUserAuthenticationTypeId:(short)APPLOZIC];
    ////////////////////////// ////////////////////////// ////////////////////////// ///////////////////////
    
    //[self.unreadCountLabel setBackgroundColor:[UIColor grayColor]];
    //[self.unreadCountLabel setTextColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageHandler) name:NEW_MESSAGE_NOTIFICATION  object:nil];
    [self newMessageHandler];
    if([ALUserDefaultsHandler isLoggedIn]){
        [self insertInitialContacts];
    }

 //-------------------------------------------------------------------------
    self.navigationController.navigationBar.hidden = YES;
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"HOme Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


// TODO: collection view data source methods
#pragma Mark:-
#pragma Mark forRevel button:-
- (IBAction)slidemenubuttonAction:(id)sender
{
    NSLog(@"hello");
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
       [_revealButtonItem addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

#pragma Mark collectionview datasourse:-
#pragma Mark:-

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (collectionView == _maincollectionview)
    {
        return 5;
    }
    else if (collectionView == _blockcollectionview)
    {
        return 4;
    }
    else if (collectionView == _apCollectionView)
    {
    NSInteger count = slideImageSetArray.count;
    _apPageControll.numberOfPages = count;
    return count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DAHomeCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DAHomeCCell" forIndexPath:indexPath];
    if (collectionView == _maincollectionview)
    {
        return cell;
    }else if (collectionView == _blockcollectionview)
    {
        //cell._backview.layer.cornerRadius = 15.0;
//        cell._backview.layer.shadowColor = [UIColor blackColor].CGColor;
//        cell._backview.layer.shadowOffset = CGSizeMake(2, 2);
//        cell._backview.layer.shadowRadius = 5;
//        cell._backview.layer.shadowOpacity = 0.3;
        cell.appointmentimg.image = [UIImage imageNamed:docallimgarr[indexPath.row]];
        cell.applbl.text = [docalltextarr objectAtIndex:indexPath.row];
        return cell;
    }else
    {
    cell.slideImageView.image = [UIImage imageNamed:slideImageSetArray[indexPath.row]];
    return cell;
  }
}

// TODO: collection view delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _blockcollectionview)
    {
        switch (indexPath.item) {
            case 0:
            {
            DAAppointmentListVC *bokApVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DAAppointmentListVC"];
            [self.navigationController showViewController:bokApVc sender:self];
                break;
            }
            case 1:
            {
//            DAChatVC *chatvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
//            [self.navigationController showViewController:chatvc sender:self];
                
                [self openchatscreen];
                break;
            }
            case 2:
            {
//                DAChatVC *chatvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
//                [self.navigationController showViewController:chatvc sender:self];
                break;
            }
            case 3:
            {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Reminder" bundle:nil];
                DAReminderDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"DAReminderListVC"];
                //    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self.navigationController showViewController:vc sender:self];
                break;
            }

                
            default:
                break;
        }
    }
}


- (IBAction)bookAnAppointmentBtnPressed:(id)sender
{
    DAAppointmentListVC *bokApVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DAAppointmentListVC"];
    [self.navigationController showViewController:bokApVc sender:self];
}

- (IBAction)sieBarBtnPressed:(id)sender
{
    [self.revealViewController revealToggle:self];
}
- (IBAction)leftBtnPressed:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)rightBtnPressed:(id)sender {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

//TODO:method for page control
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index=   scrollView.contentOffset.x / scrollView.frame.size.width;
    _apPageControll.currentPage = index;
}

// TODO: ALL BUTTON ACTION

- (IBAction)submitBtnPresed:(id)sender
{
    
}
- (IBAction)blogBtnPresed:(id)sender
{
    
}

- (IBAction)reminderBtnPressed:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Reminder" bundle:nil];
    DAReminderDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"DAReminderListVC"];
//    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
   [self.navigationController showViewController:vc sender:self];
}
- (IBAction)sosBtnPressed:(id)sender
{
    
}
- (IBAction)tokenBtnPressed:(id)sender
{
    
}
- (IBAction)chatBtnPressed:(id)sender
{
    
    DAChatVC *chatvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
    [self.navigationController showViewController:chatvc sender:self];
}

//////
#pragma Mark::::-----
#pragma Mark::::-----for chat

-(void)setchat
{
    
[ALApplozicSettings setColorForNavigation: [UIColor colorWithRed:66.0/255 green:173.0/255 blue:247.0/255 alpha:1]];
    if([ALUserDefaultsHandler isLoggedIn])
    {
        ALRegisterUserClientService *registerUserClientService = [[ALRegisterUserClientService alloc] init];
        [registerUserClientService logoutWithCompletionHandler:^(ALAPIResponse *response, NSError *error) {
            
        }];
    }
    ALUser * user = [[ALUser alloc] init];
    [user setUserId:@"rajat"];
    [user setEmail:@"rajat@gmail.com"];
    [user setPassword:@"9936511593"];
    
    [ALUserDefaultsHandler setUserId:user.userId];
    [ALUserDefaultsHandler setEmailId:user.email];
    [ALUserDefaultsHandler setPassword:user.password];
    ALChatManager * chatManager = [[ALChatManager alloc] initWithApplicationKey:@"ebf0c93861f3349ed3f748d3c198cd92"];
    [chatManager registerUserWithCompletion:user withHandler:^(ALRegistrationResponse *rResponse, NSError *error) {
        
        if (!error)
        {
            NSLog(@"jkkjkjkj");
        }
        
        else
        {
            NSLog(@"Error in Applozic registration : %@",error.description);
        }
    }];

}

#pragma mark:-
#pragma Mark openpopup:::---
- (IBAction)popupbuttonaction:(UIButton *)sender
{
    popint = sender.tag;
    [self showPopupWithStyle:CNPPopupStyleCentered];
}

#pragma Mark:-
#pragma MArk open popupview:-

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle
{
    if (popint == 1)
    {
        sospopupview.hidden = NO;
   self.popupController = [[CNPPopupController alloc] initWithContents:@[sospopupview]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
    }
    else if(popint == 0)
    {
    [self.popupController dismissPopupControllerAnimated:YES];
    sosfirstpopup.hidden = NO;
    self.popupController = [[CNPPopupController alloc] initWithContents:@[sosfirstpopup]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
    }
}


-(void)openchatscreen
{
    [_activityView startAnimating];
    
    ALUser *user1 = [[ALUser alloc] init];
    [user1 setUserId:[ALUserDefaultsHandler getUserId]];
    [user1 setEmail:[ALUserDefaultsHandler getEmailId]];
    [user1 setPassword:@""];
    
    ALChatManager * chatManager1 = [[ALChatManager alloc] initWithApplicationKey:@"ebf0c93861f3349ed3f748d3c198cd92"];
    [chatManager1 launchChatForUserWithDisplayName:@"rajat" withGroupId:nil andwithDisplayName:@"rajat" andFromViewController:self];

}

//ADD THIS METHOD :

-(void)newMessageHandler
{
    ALContactService * contactService = [ALContactService new];
    NSNumber * count = [contactService getOverallUnreadCountForContact];
    NSLog(@"ICON_COUNT :: %@",count); // UPDATE YOUR VIEW
    //[self.unreadCountLabel setText:[NSString stringWithFormat:@"UNREAD COUNT #%@",count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)checkUserContact:(NSString *)userId displayName:(NSString *)displayName withCompletion:(void(^)(ALContact * contact))completion
{
    ALContactService *contactService = [ALContactService new];
    ALContactDBService *contacDB = [ALContactDBService new];
    ALContact * contact = [contactService loadOrAddContactByKeyWithDisplayName:userId value: displayName];
    
    if(![contacDB getContactByKey:@"userId" value:userId])
    {
        [ALUserService userDetailServerCall:userId withCompletion:^(ALUserDetail *alUserDetail) {
            
            [contacDB updateUserDetail:alUserDetail];
            ALContact * alContact = [contacDB loadContactByKey:@"userId" value:userId];
            completion(alContact);
        }];
    }
    else
    {
        completion(contact);
    }
}

//===============================================================================
// Multi-Reciever API
//===============================================================================
-(void)sendMessageToMulti
{
    
    ALMessage * multiSendMessage = [[ALMessage alloc] init];
    multiSendMessage.message = @"Broadcasted Message";
    multiSendMessage.contactIds = nil;
    
    NSMutableArray * contactIDsARRAY = [[NSMutableArray alloc] initWithObjects:@"iosdev1",@"iosdev2",@"iosdev3", nil];
    NSMutableArray * groupIDsARRAY = [[NSMutableArray alloc] initWithObjects:@"",nil];
    [ALMessageService multiUserSendMessage:multiSendMessage toContacts:contactIDsARRAY toGroups:groupIDsARRAY withCompletion:^(NSString *json, NSError *error) {
        if(error){
            NSLog(@"Multi User Error: %@", error);
        }
    }];
}

//===============================================================================
// Custom Message Sending API
//===============================================================================

-(void)sendCustomMessageTo:(NSString *)to WithText:(NSString *)text
{
    ALMessage * customMessage = [ALMessageService createCustomTextMessageEntitySendTo:to withText:text];
    
    [ALMessageService sendMessages:customMessage withCompletion:^(NSString *message, NSError *error) {
        if(error)
        {
            NSLog(@"Custom Message Send Error: %@", error);
        }
    }];
}

//===============================================================================
// TO LAUNCH SELLER CHAT....
//
//===============================================================================

- (IBAction)launchSeller:(id)sender
{
    if(![ALDataNetworkConnection noInternetConnectionNotification])
    {
        [self.activityView startAnimating];
        ALConversationProxy * newProxy = [[ALConversationProxy alloc] init];
        newProxy = [self makeupConversationDetails];
        
        ALChatManager * chatManager = [[ALChatManager alloc] initWithApplicationKey:@"ebf0c93861f3349ed3f748d3c198cd92"];
        [chatManager createAndLaunchChatWithSellerWithConversationProxy:newProxy fromViewController:self];
    }
    else
    {
        [ALDataNetworkConnection checkDataNetworkAvailable];
    }
}

//===============================================================================
//  TEXT MESSAGE With META-DATA Sending
//===============================================================================

-(void)sendMessageWithMetaData      // EXAMPLE FOR META DATA
{
    NSMutableDictionary * dictionary = [self getNewMetaDataDictionary];                                    // ADD RECEIVER ID HERE
    ALMessage * messageWithMetaData = [ALMessageService createMessageWithMetaData:dictionary andReceiverId:@"receiverId" andMessageText:@"MESG WITH META DATA"];
    
    [ALMessageService sendMessages:messageWithMetaData withCompletion:^(NSString *message, NSError *error) {
        
        if(error)
        {
            NSLog(@"ERROR IN SENDING MSG WITH META-DATA : %@", error);
            return ;
        }
        // DO ACTION HERE...
        NSLog(@"MSG_RESPONSE :: %@",message);
    }];
}

-(NSMutableDictionary *)getNewMetaDataDictionary      // EXAMPLE FOR META DATA
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"VALUE" forKey:@"KEY"];
    return dict;
}

//===============================================================================
// Creating Conversation Details
//===============================================================================

-(ALConversationProxy *)makeupConversationDetails
{
    ALConversationProxy * alConversationProxy = [[ALConversationProxy alloc] init];
    alConversationProxy.topicId = @"laptop01";
    alConversationProxy.userId = @"rajat";
    
    // Note : Uncomment following two lines to set SMS fallback's format.
    /*
     [alConversationProxy setSenderSMSFormat:@"SENDER SMS FORMAT"];
     [alConversationProxy setReceiverSMSFormat:@"RECEIVER SMS FORMAT"];
     */
    ALTopicDetail * alTopicDetail = [[ALTopicDetail alloc] init];
    alTopicDetail.title     = @"Mac Book Pro";
    alTopicDetail.subtitle  = @"13' Retina";
    alTopicDetail.link      = @"https://raw.githubusercontent.com/AppLozic/Applozic-iOS-SDK/master/macbookpro.jpg";
    alTopicDetail.key1      = @"Product ID";
    alTopicDetail.value1    = @"mac-pro-r-13";
    alTopicDetail.key2      = @"Price";
    alTopicDetail.value2    = @"Rs.1,04,999.00";
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:alTopicDetail.dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *resultTopicDetails = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    alConversationProxy.topicDetailJson = resultTopicDetails;
    
    return alConversationProxy;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NEW_MESSAGE_NOTIFICATION  object:nil];
}


- (IBAction)logoutBtn:(id)sender
{
    ALRegisterUserClientService * alUserClientService = [[ALRegisterUserClientService alloc] init];
    
    if([ALUserDefaultsHandler getDeviceKeyString])
    {
        [alUserClientService logoutWithCompletionHandler:^(ALAPIResponse *response, NSError *error) {
            
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) insertInitialContacts
{
    
    ALContactService * contactService = [ALContactService new];
    NSMutableArray * conactArray = [NSMutableArray new];
    
    //contact 1
    ALContact *contact1 = [[ALContact alloc] init];
    contact1.userId = @"Prashant123";
    contact1.fullName = @"Prashant singh";
    contact1.displayName = @"Prashant123";
    contact1.email = @"github@applozic.com";
    contact1.contactImageUrl = @"https://avatars0.githubusercontent.com/u/5002214?v=3&s=400";
    contact1.contactType= [NSNumber numberWithInt:1];
    [conactArray addObject:contact1];
    
    
    // contact 2
    ALContact *contact2 = [[ALContact alloc] init];
    contact2.userId = @"marvel";
    contact2.fullName = @"abhishek thapliyal";
    contact2.displayName = @"Abhishek";
    contact2.email = @"abhishek@applozic.com";
    contact2.contactImageUrl = nil;
    contact2.localImageResourceName = @"abhishek.jpg";
    contact2.contactImageUrl = nil;
    contact2.contactType= [NSNumber numberWithInt:2];
    [conactArray addObject:contact2];
    
    //    Contact -------- Example with json
    
    
    NSString *jsonString =@"{\"userId\": \"applozic\",\"fullName\": \"Applozic\",\"contactNumber\": \"9535008745\",\"displayName\": \"Applozic Support\",\"contactImageUrl\": \"https://cdn-images-1.medium.com/max/800/1*RVmHoMkhO3yoRtocCRHSdw.png\",\"email\": \"devashish@applozic.com\",\"localImageResourceName\":\"sample.jpg\"}";
    ALContact *contact3 = [[ALContact alloc] initWithJSONString:jsonString];
    [conactArray addObject:contact3];
    
    //     Contact ------- Example with dictonary
    
    
    NSMutableDictionary *demodictionary = [[NSMutableDictionary alloc] init];
    [demodictionary setValue:@"rachel" forKey:@"userId"];
    [demodictionary setValue:@"Rachel Green" forKey:@"fullName"];
    [demodictionary setValue:@"75760462" forKey:@"contactNumber"];
    [demodictionary setValue:@"Rachel" forKey:@"displayName"];
    [demodictionary setValue:@"aman@applozic.com" forKey:@"email"];
    [demodictionary setValue:@"https://raw.githubusercontent.com/AppLozic/Applozic-Android-SDK/master/app/src/main/res/drawable-xxhdpi/girl.jpg" forKey:@"contactImageUrl"];
    [demodictionary setValue:nil forKey:@"localImageResourceName"];
    [demodictionary setValue:[ALUserDefaultsHandler getApplicationKey] forKey:@"applicationId"];
    ALContact *contact4 = [[ALContact alloc] initWithDict:demodictionary];
    [conactArray addObject:contact4];
    
    [contactService updateOrInsertListOfContacts:conactArray];
    
}
-(void)userUpdate:(NSNotification*)userDetails{
    ALUserDetail * user = userDetails.object;
    if(user.connected){
        //NSLog(@"USER_ONLINE:\nName%@\nID:%@",user.displayName,user.userId);
    }
    else{
        //        NSLog(@"USER_OFFLINE:\nName%@\nID:%@",user.displayName,user.userId);
    }
}

//- (IBAction)turnNotification:(id)sender
//{
//    //short mode = (self.notificationSwitch.on ? NOTIFICATION_ENABLE : NOTIFICATION_DISABLE);
//    //    [ALUserDefaultsHandler setNotificationMode:mode];
//    NSLog(@"NOTIFICATION MODE :: %hd",mode);
//    [ALRegisterUserClientService updateNotificationMode:mode withCompletion:^(ALRegistrationResponse *response, NSError *error) {
//
//        [ALUserDefaultsHandler setNotificationMode:mode] ;
//        NSLog(@"UPDATE Notification Mode Response :: %@ Error :: %@",response, error);
//    }];
//}

-(void)subGroupCODE:(ALChatManager *)chatManager
{
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"userUpdate"];
}
- (IBAction)sosyesbuttonAction:(UIButton *)sender
{
    popint = sender.tag;
    [self.popupController dismissPopupControllerAnimated:YES];
    [self showPopupWithStyle:CNPPopupStyleCentered];
}
- (IBAction)askquesbtnaction:(id)sender {
    [self.popupController dismissPopupControllerAnimated:YES];
}
@end
