//
//  DALeftSubVC1.m
//  DoctorApp
//
//  Created by Ranjit Singh on 23/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DALeftSubVC1.h"

@interface DALeftSubVC1 ()

@end

@implementation DALeftSubVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    arr = [[NSArray alloc]initWithObjects:@"PROFILE",@"SEARCH PHARMACY STORE",@"INVITE FRIEND AND FAMILY",@"PAYMENT",@"ABOUT APP",@"HELP",@"SETTINGS", nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:@"mobile_icon.png"];
    return cell;
}

@end
