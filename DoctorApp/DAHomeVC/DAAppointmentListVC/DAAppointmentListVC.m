//
//  DAAppointmentListVC.m
//  DoctorApp
//
//  Created by MacPro on 25/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAAppointmentListVC.h"



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


@end

@implementation DAAppointmentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appointmentArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self performSelector:@selector(getAppointmentList) withObject:nil afterDelay:0.0];
    
}

//TODO: GET APPOINTMENT LIST

-(void)getAppointmentList{
  
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,GET_APPOINTMENT_LIST];
    [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodGET postData:nil callBackBlock:^(id response, NSError *error) {
        
        [SVProgressHUD dismiss];
        if (response)
        {
            
            NSDictionary *responseDict = [[NSMutableDictionary alloc]initWithDictionary:response];
            if (![[responseDict objectForKey:@"error"] intValue])
            {
                appointmentArray = [DAGlobal checkNullArray:[responseDict objectForKey:@"appoint_ment_list"]];
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
    
    [cell.lblDoctorName setText:[[[appointmentArray  valueForKey:@"data"] objectAtIndex:indexPath.row]valueForKey:@"name"]];
    [cell.lblDiesesName setText:[[[appointmentArray  valueForKey:@"data"]objectAtIndex:indexPath.row] valueForKey:@"number"]];
    [cell.lblTimeSlot setText:[[[[[appointmentArray  valueForKey:@"data"]objectAtIndex:indexPath.row] valueForKey:@"appoint_ment_list"] objectAtIndex:0] valueForKey:@"appt_date"]];
    return cell;
    
}

@end
