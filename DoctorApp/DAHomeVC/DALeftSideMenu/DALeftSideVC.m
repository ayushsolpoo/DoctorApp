//
//  DALeftSideVC.m
//  DoctorApp
//
//  Created by Ranjit Singh on 22/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DALeftSideVC.h"


@interface DALeftSideVC ()<UITableViewDelegate, UITableViewDataSource>
{
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *rScrollView;
@property (weak, nonatomic) IBOutlet UITableView *rTableView;

@end

@implementation DALeftSideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}

//TODO: TABLEVIEW DATA SOURCE METHODS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"solpoo"];
    [cell.textLabel setText:@"Solpoo"];
    
    return cell;
}
//TODO: TABLEVIEW DELEGATE METHODS

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch (indexPath.section) {
//        case MMDrawerSectionViewSelection:{
//            MMExampleCenterTableViewController * center = [[MMExampleCenterTableViewController alloc] init];
//            
//            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:center];
//            
//            if(indexPath.row%2==0){
//                [self.mm_drawerController
//                 setCenterViewController:nav
//                 withCloseAnimation:YES
//                 completion:nil];
//            }
//            else {
//                [self.mm_drawerController
//                 setCenterViewController:nav
//                 withFullCloseAnimation:YES
//                 completion:nil];
//            }
//            break;
//        }
//}
//}


@end
