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
    titaleArray = [[NSArray alloc]initWithObjects:@"PROFILE",@"SEARCH PHARMACY STORE",@"INVITE FRIEND AND FAMILY",@"PAYMENT",@"ABOUT APP",@"HELP",@"SETTINGS", nil];
    
    imageArray = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"profile_icon.png"],[UIImage imageNamed:@"store_icon.png"],[UIImage imageNamed:@"invite_icon.png"],[UIImage imageNamed:@"payment_icon.png"],[UIImage imageNamed:@"about_icon.png"],[UIImage imageNamed:@"help_icon.png"],[UIImage imageNamed:@"setting_icon"], nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titaleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = [titaleArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [imageArray objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)logoutbuttonaction:(id)sender
{
    //[self resetDefaults];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)resetDefaults
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
@end
