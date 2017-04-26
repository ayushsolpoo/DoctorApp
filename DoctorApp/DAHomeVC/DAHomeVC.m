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

@interface DAHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *slideImageSetArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *apCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *apPageControll;

@end

@implementation DAHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    slideImageSetArray = [[NSMutableArray alloc]initWithObjects:@"image1",@"image2",@"image3",nil];
    
    // TODO: SET PAGE CONTROL ATTRIBUTE
    NSLog(@"");

}
-(void)viewWillAppear:(BOOL)animated
{
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"HOme Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

// TODO: collection view data source methods


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    NSInteger count = slideImageSetArray.count;
    _apPageControll.numberOfPages = count;
    return count;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DAHomeCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DAHomeCCell" forIndexPath:indexPath];
    cell.slideImageView.image = [UIImage imageNamed:slideImageSetArray[indexPath.row]];
    return cell;
}
// TODO: collection view delegate methods


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
    
}
- (IBAction)sosBtnPressed:(id)sender
{
    
}
- (IBAction)tokenBtnPressed:(id)sender
{
    
}
- (IBAction)chatBtnPressed:(id)sender
{
    
}











@end
