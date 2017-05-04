//
//  DAAppointmentListVC.m
//  DoctorApp
//
//  Created by MacPro on 25/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAAppointmentListVC.h"
#import "DAClinicListVC.h"


@interface DAAppointmentTableViewcell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDoctorName;
@property (strong, nonatomic) IBOutlet UILabel *lblDiesesName;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeSlot;


@end
@implementation DAAppointmentTableViewcell



@end

@interface DAAppointmentListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *appointmentArray;
}

@property (weak, nonatomic) IBOutlet UITableView *appointmentListTableView;

@property (weak, nonatomic) IBOutlet UIButton *backBtnTapped;
- (IBAction)BackBtnTapped:(id)sender;
- (IBAction)addBtnTapped:(id)sender;

@end

@implementation DAAppointmentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    appointmentArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self performSelector:@selector(getAppointmentList) withObject:nil afterDelay:0.0];
    
}

//TODO: GET APPOINTMENT LIST

-(void)getAppointmentList
{
  
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?api_token=%@",BASE_URL,GET_APPOINTMENT_LIST,@"PUmvc65KlvuVskKZYUzBFxYxkHe4G7TbRHOWGW5E8NtopgqZIACkeDIGaRqK"];
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
                appointmentArray = [DAGlobal checkNullArray:[[[responseDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"appoint_ment_list"]];
                                   [_appointmentListTableView reloadData];
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
    return appointmentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAAppointmentTableViewcell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentTableViewCell"];
    [cell.lblDoctorName setText:[[[[appointmentArray  objectAtIndex:indexPath.row] objectForKey:@"patient_appoint_ment_slot"] objectForKey:@"patient_appointment_clinic"] objectForKey:@"clinicName"]];

    [cell.lblDiesesName setText:[[[[appointmentArray  objectAtIndex:indexPath.row] objectForKey:@"patient_appoint_ment_slot"] objectForKey:@"patient_appointment_clinic"] objectForKey:@"landMark"]];
    [cell.lblTimeSlot setText:[[[[appointmentArray  objectAtIndex:indexPath.row] objectForKey:@"patient_appoint_ment_slot"] objectForKey:@"patient_appointment_clinic"] objectForKey:@"landMark"]];
    return cell;
    
}
//TODO:Outlets
- (IBAction)BackBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addBtnTapped:(id)sender
{
    DAClinicListVC *bokApVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DAClinicListVC"];
    [self.navigationController showViewController:bokApVc sender:self];
}
@end
