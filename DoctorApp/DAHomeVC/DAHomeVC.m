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

@interface DAHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *slideImageSetArray;
    NSMutableArray *docallimgarr;
    NSMutableArray *docalltextarr;
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
    slideImageSetArray = [[NSMutableArray alloc]initWithObjects:@"image1",@"image2",@"image3",nil];
    docallimgarr = [[NSMutableArray alloc]initWithObjects:@"appointment_icon",@"doc_chat_icon",@"token_icon",@"reminder_icon",nil];
    docalltextarr = [[NSMutableArray alloc]initWithObjects:@"Appointment",@"Chat With Doctor",@"Token",@"Reminder",nil];
}
-(void)viewWillAppear:(BOOL)animated
{
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
        cell._backview.layer.shadowColor = [UIColor blackColor].CGColor;
        cell._backview.layer.shadowOffset = CGSizeMake(2, 2);
        cell._backview.layer.shadowRadius = 5;
        cell._backview.layer.shadowOpacity = 0.3;
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
            DAChatVC *chatvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
            [self.navigationController showViewController:chatvc sender:self];
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
@end
