//
//  DAEmergencySelectedContactsVC.m
//  DoctorApp
//
//  Created by MacPro on 21/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAEmergencySelectedContactsVC.h"
#import "DAHomeVC.h"

@interface DAEmergencySelectedContactsVC ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIScrollView *rScrollView;
@property (weak, nonatomic) IBOutlet UITableView *cotactsTableView;
- (IBAction)BtnReselectPressed:(id)sender;
- (IBAction)saveBtnPressed:(id)sender;

@end

@implementation DAEmergencySelectedContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}



-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

//TODO: TABLEVIEW DATA SOURCE METHODS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contactsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *contactCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"solpoo"];
    [contactCell.textLabel       setText:[_contactsArray[indexPath.row] valueForKey:@"fullName"]];
    [contactCell.detailTextLabel setText:[[_contactsArray[indexPath.row] valueForKey:@"PhoneNumbers"] objectAtIndex:0]];
    
    return contactCell;

}


-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShown:) name:UIKeyboardWillShowNotification object:nil];
    
}
-(void)keyBoardShown:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(50, 0, kbSize.height, 0);
        [self.cotactsTableView setContentInset:edgeInsets];
    }];
}

- (IBAction)BtnReselectPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtnPressed:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,SAVE_EMERGENCY_CONTACTS];
    NSDictionary *paramDict = @{
                                @"contact1":[_contactsArray[0] valueForKey:@"fullName"],
                                @"number1":[[_contactsArray[0] valueForKey:@"PhoneNumbers"] objectAtIndex:0],
                                @"contact2":[_contactsArray[1] valueForKey:@"fullName"],
                                @"number2":[[_contactsArray[1] valueForKey:@"PhoneNumbers"] objectAtIndex:0],
                                @"contact3":[_contactsArray[2] valueForKey:@"fullName"],
                                @"number3":[[_contactsArray[2] valueForKey:@"PhoneNumbers"] objectAtIndex:0],
                                @"id":@"12345"};
    
    [[NetworkManager sharedManager] requestApiWithName:urlString requestType:kHTTPMethodPOST postData:paramDict callBackBlock:^(id response, NSError *error) {
        if (response) {
            NSDictionary *responseDict = [[NSDictionary alloc]initWithDictionary:response];
            
            if ([[responseDict objectForKey:@"error"] intValue] == 0)
            {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:CONGRATULATION message:SAVED_CONTACTS preferredStyle:UIAlertControllerStyleAlert];
                
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CONGRATULATION message:SAVED_CONTACTS delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                alert.delegate = self;
                [alert show];
                
        }
        else if(error)
        {
            NSLog(@"the error is %@",[error localizedDescription]);
        }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
    }else{
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Appointment" bundle:nil];
        DAHomeVC *initialViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"DAHomeVC"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:initialViewController];
        self.view.window.rootViewController = nav;

        
    }
}
@end
