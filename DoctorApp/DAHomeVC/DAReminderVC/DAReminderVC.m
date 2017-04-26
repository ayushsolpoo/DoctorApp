//
//  DAReminderVC.m
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAReminderVC.h"

@interface DAReminderVC ()

@end

@implementation DAReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//– (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [tableData count];
//}

//– (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @”SimpleTableItem”;
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    
//    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
//    return cell;
//}

//Custom cell

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)



//using storyBoard

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellProfile"];
    
 //   UIImageView *imageprofile =  (UIImageView *) [cell.contentView viewWithTag:150];
    
//    imageprofile.layer.cornerRadius = imageprofile.frame.size.width / 2;
//    
//    imageprofile.clipsToBounds = YES;
//    
//    [imageprofile setImageWithURL:[NSURL URLWithString:strProfileImage]];
//    
//    UILabel *lblCategory =  (UILabel *) [cell.contentView viewWithTag:151];
//    
//    NSString *strCategory = [[arrayDataResponse objectAtIndex:indexPath.row] valueForKey:@"category_name"];
//    
//    NSString *stringCategory=[NSString stringWithFormat:@"You Posted in %@",strCategory];//    @”You Posted in Science”;
//    
//    //creating attributed string
//    
//    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:stringCategory];
//    
//    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1.0] range:NSMakeRange(0,3)];
//    
//    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1.0] range:NSMakeRange(4,10)];
//    
//    lblCategory. attributedText = string;
//    
//    UILabel *lblTitle =  (UILabel *) [cell.contentView viewWithTag:153];
//    
//    NSString *strTitle = [[arrayDataResponse objectAtIndex:indexPath.row] valueForKey:@”title”];
//    
//    lblTitle.text = strTitle;
//    
//    UILabel *lblTime =  (UILabel *) [cell.contentView viewWithTag:152];
//    
//    NSString *strTime = [[arrayDataResponse objectAtIndex:indexPath.row] valueForKey:@”time”];
//    
//    lblTime.text = strTime;
    return cell;
    
}

//TODO:Web Service functions
-(void)callMedicineRemindersWebService
{
//    [SVProgressHUD show];
//    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN];
//    NSDictionary * paramDict = @{@"email":[NSString stringWithFormat:@"%@",_emailTextField.text],@"password":[NSString stringWithFormat:@"%@",_pasTextField.text]};
//    
//    [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodPOST postData:paramDict callBackBlock:^(id response, NSError *error)
//     {
//         NSDictionary *dictionary = nil;;
//         if (response)
//         {
//             dictionary = [[NSDictionary alloc] initWithDictionary:response];
//         }
//         [SVProgressHUD show];
//         if (!error)
//         {
//             
//             if (dictionary)
//             {
//                 
//                 [SVProgressHUD dismiss];
//                 if ([[dictionary objectForKey:@"message"] isEqualToString:@"Email does not found."])
//                 {
//                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Email id! " message:[dictionary objectForKey:@"reason"] preferredStyle:UIAlertControllerStyleAlert];
//                     [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                         // action 1
//                     }]];
//                     [self presentViewController:alertController animated:YES completion:nil];
//                 }
//             }
//             else
//             {
//                 [SVProgressHUD dismiss];
//                 [self showErrorMessage];
//             }
//         }
//         else
//         {
//             [SVProgressHUD dismiss];
//             [self showErrorMessage:error];
//         }
//     }];

}
@end
