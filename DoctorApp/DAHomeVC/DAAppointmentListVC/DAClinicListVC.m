//
//  DAClinicListVC.m
//  DoctorApp
//
//  Created by macbook pro on 28/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAClinicListVC.h"
#import "DABookAppointmentVC.h"
@interface DAClinicTableViewcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *clicnicImgView;
@property (weak, nonatomic) IBOutlet UILabel *clicnicNamelbl;
@property (weak, nonatomic) IBOutlet UILabel *clinicAddressLbl;



@end
@implementation DAClinicTableViewcell



@end
@interface DAClinicListVC ()
{
    NSMutableArray *clinicArray;
}
@property (weak, nonatomic) IBOutlet UITableView *clinicListTableView;
- (IBAction)backBtnTapped:(id)sender;
@end

@implementation DAClinicListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    clinicArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self getClinicList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO: GET APPOINTMENT LIST

-(void)getClinicList
{
    
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?api_token=%@",BASE_URL,DOCTOR_CLINIC_LIST,@"PUmvc65KlvuVskKZYUzBFxYxkHe4G7TbRHOWGW5E8NtopgqZIACkeDIGaRqK"];
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
            if (![[responseDict objectForKey:@"error"] intValue])
            {
                clinicArray = [DAGlobal checkNullArray:[responseDict objectForKey:@"data"]];
                [_clinicListTableView reloadData];
            }
        }
        else if (error)
        {
            NSLog(@"the error is %@",[error localizedDescription]);
        }
    }];
}
//TODO: TABLE VIEW DATA SOURCE METHODS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return clinicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAClinicTableViewcell *cell = [tableView dequeueReusableCellWithIdentifier:@"DACicnicTableViewcell"];
    [cell.clicnicNamelbl setText:[[clinicArray  objectAtIndex:indexPath.row] objectForKey:@"clinicName"] ];

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath  *)indexPath
{
    
    DABookAppointmentVC *bokApVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DABookAppointmentVC"];
    bokApVc.arrayClinicData = [clinicArray  objectAtIndex:indexPath.row];
    [self.navigationController showViewController:bokApVc sender:self];
    NSLog(@"%@",[[clinicArray  objectAtIndex:indexPath.row] objectForKey:@"clinicName"]);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//TODO:Outlets
- (IBAction)backBtnTapped:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}
@end
