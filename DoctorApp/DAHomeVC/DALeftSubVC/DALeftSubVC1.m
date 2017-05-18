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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = @"Solpoo";
    
    return cell;
}

@end
