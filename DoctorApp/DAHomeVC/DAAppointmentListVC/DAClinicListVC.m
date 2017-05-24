//
//  DAClinicListVC.m
//  DoctorApp
//
//  Created by macbook pro on 28/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAClinicListVC.h"
#import "DABookAppointmentVC.h"
#import "Utils.h"


@interface DAClinicTableViewcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *clicnicImgView;
@property (weak, nonatomic) IBOutlet UILabel *clicnicNamelbl;
@property (weak, nonatomic) IBOutlet UILabel *clinicAddressLbl;
@property (weak, nonatomic) IBOutlet UIView *clinicbackview;
@property (weak, nonatomic) IBOutlet UIButton *clinicbookbtn;
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
    [cell.clicnicNamelbl setText:[[clinicArray  objectAtIndex:indexPath.row] objectForKey:@"clinicName"]];
    cell.clinicbookbtn.tag = indexPath.row;
    [cell.clinicbookbtn addTarget:self action:@selector(bookbtnaction:) forControlEvents:UIControlEventTouchUpInside];
   // [Utils setshadowoffset:cell.clinicbackview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)bookbtnaction:(UIButton *)sender
{
    DABookAppointmentVC *bokApVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DABookAppointmentVC"];
    bokApVc.arrayClinicData = [clinicArray  objectAtIndex:sender.tag];
    [self.navigationController showViewController:bokApVc sender:self];
    NSLog(@"%@",[[clinicArray  objectAtIndex:sender.tag] objectForKey:@"clinicName"]);
}
//TODO:Outlets
- (IBAction)backBtnTapped:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}
@end
