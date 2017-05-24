//
//  DAReminderVC.m
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAReminderVC.h"
#import "DAReminderDetailVC.h"
@interface DAReminderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblReminderName;
@end
@implementation DAReminderTableViewCell

@end
@interface DAReminderVC ()
{
    NSDictionary *dictOfData;
    NSMutableArray *arrayDataToLoad;
}
- (IBAction)backBtnTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentmediLab;
@property (weak, nonatomic) IBOutlet UITableView *tableViewReminderList;

- (IBAction)segmentValueChanged:(id)sender;

@end

@implementation DAReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayDataToLoad = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.hidden = YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self callMedicineRemindersWebService];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


//Custom cell

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayDataToLoad.count;
}
//using storyBoard

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    DAReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DAReminderTableViewCell"];
    if (self.segmentmediLab.selectedSegmentIndex == 0)
    {
        cell.lblReminderName.text = [[arrayDataToLoad objectAtIndex:indexPath.row] objectForKey:@"medicineName"];
        
    }
    else
    {
         cell.lblReminderName.text = [[arrayDataToLoad objectAtIndex:indexPath.row] objectForKey:@"testName"];
    }
     return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//TODO:Web Service functions
-(void)callMedicineRemindersWebService
{
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?api_token=%@",BASE_URL,REMINDER_LIST,@"PUmvc65KlvuVskKZYUzBFxYxkHe4G7TbRHOWGW5E8NtopgqZIACkeDIGaRqK"];

    
    [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodGET postData:nil callBackBlock:^(id response, NSError *error)
     {
         NSDictionary *dictionary = nil;;
         if (response)
         {
             dictionary = [[NSDictionary alloc] initWithDictionary:response];
         }
         [SVProgressHUD show];
         if (!error)
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

             
             if (dictionary)
             {
                
                 
                 if ([dictionary objectForKey:@"data"])
                 {
                     dictOfData = [dictionary objectForKey:@"data"];
                    [self callParticularSegment:0];
                 
                 [SVProgressHUD dismiss];
                 }
             }
             else
             {
                 [SVProgressHUD dismiss];
             }
         }
     }
   ];
}
//Segment Controller
#pragma mark - segment control

-(void)callParticularSegment:(NSInteger)mySelectedSegment
{
    arrayDataToLoad = [[NSMutableArray alloc] init];
    if (mySelectedSegment == 0)
    {
        arrayDataToLoad = [dictOfData objectForKey:@"madicineList"];
        
    }
    else if (mySelectedSegment == 1)
    {
        arrayDataToLoad = [dictOfData objectForKey:@"testList"];
    }
    [_tableViewReminderList reloadData];
    
}
- (IBAction)segmentValueChanged:(id)sender
{
    NSInteger selectedIndex = self.segmentmediLab.selectedSegmentIndex;
    [self callParticularSegment:selectedIndex];
}
- (IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)_addreminderbtnaction:(id)sender
{
    DAReminderDetailVC *bokApVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DAReminderDetailVC"];
    [self.navigationController showViewController:bokApVc sender:self];
}
@end
