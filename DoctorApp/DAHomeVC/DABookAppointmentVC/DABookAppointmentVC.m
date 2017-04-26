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

@interface DABookAppointmentVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *headerArray;
    NSArray *sectionArray;
    NSArray *cellArray;
}



@end



@implementation DABookAppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerArray  = [[NSArray alloc]initWithObjects:@"12 Mar 2017",@"13 Mar 2017",@"14 Mar 2017", nil];
    sectionArray = [[NSArray alloc]initWithObjects:@"Morning",@"Afernoon",@"Evening", nil];
    cellArray    = [[NSArray alloc]initWithObjects:@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30", nil];
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return sectionArray.count;
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



@end
