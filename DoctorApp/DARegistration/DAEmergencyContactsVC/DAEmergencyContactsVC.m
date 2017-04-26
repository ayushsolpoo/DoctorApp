//
//  DAEmergencyContactsVC.m
//  DoctorApp
//
//  Created by MacPro on 20/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAEmergencyContactsVC.h"
#import "DAEmergencySelectedContactsVC.h"


@interface DAEmergencyContactsVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *contactList;
    NSMutableArray *selectedContactList;
}

@property (weak, nonatomic) IBOutlet UIScrollView *rScrollView;
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *contactSearchBar;
- (IBAction)btnReselectPressed:(id)sender;
- (IBAction)btnSvaePressed:(id)sender;






@end

@implementation DAEmergencyContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // NSString *str = namesdsfsfds;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    contactList         = [[NSMutableArray alloc]initWithCapacity:0];
    selectedContactList = [[NSMutableArray alloc]initWithCapacity:0];
    [self contactsFromAddressBook];
 }

-(void)viewWillAppear:(BOOL)animated
{
    [self addObserver];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"selected contact list is %@",selectedContactList);
    
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
        [self.contactTableView setContentInset:edgeInsets];
    }];
}

-(void)contactsFromAddressBook{
    //ios 9+
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSString *phone;
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
                UIImage *profileImage;
                NSMutableArray *contactNumbersArray = [[NSMutableArray alloc]initWithCapacity:0];
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    if (lastName == nil) {
                        fullName=[NSString stringWithFormat:@"%@",firstName];
                    }else if (firstName == nil){
                        fullName=[NSString stringWithFormat:@"%@",lastName];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                    }
                    UIImage *image = [UIImage imageWithData:contact.imageData];
                    if (image != nil) {
                        profileImage = image;
                    }else{
                        profileImage = [UIImage imageNamed:@"person-icon.png"];
                    }
                    contactNumbersArray = [[NSMutableArray alloc]initWithCapacity:0];
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            [contactNumbersArray addObject:phone];
                        }
                    }
                    NSMutableDictionary* personDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: fullName,@"fullName",contactNumbersArray, @"PhoneNumbers",profileImage,@"userImage", nil];
                    [contactList addObject:personDict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.contactTableView reloadData];
                });
            }
        }
    }];
}

- (IBAction)btnSavedPressed:(id)sender
{
    DAEmergencySelectedContactsVC *emergenceContactVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DAEmergencySelectedContactsVC"];
    emergenceContactVC.contactsArray = selectedContactList;
    [self.navigationController showViewController:emergenceContactVC sender:self];
}

//TODO: TABLE VIEW DATASOURCE METHODS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *contactCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"solpoo"];
    [contactCell.textLabel       setText:[contactList[indexPath.row] valueForKey:@"fullName"]];
    [contactCell.detailTextLabel setText:[[contactList[indexPath.row] valueForKey:@"PhoneNumbers"] objectAtIndex:0]];
    
    return contactCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath  *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([selectedContactList containsObject:[contactList objectAtIndex:indexPath.row]])
        {
            [selectedContactList removeObject:[contactList objectAtIndex:indexPath.row]];
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedContactList addObject:[contactList objectAtIndex:indexPath.row]];
    }
}


//TODO: SEARCH BAR DELEGATE METHODS

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [self searchTerm:searchText];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Cancel clicked");
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];
    
    [self showAllData];// to show all data
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
    
    [self searchTerm:searchBar.text];
}

-(void)showAllData {
    //load all data in _tableViewDataSourceArray, and reload table
}

-(void)searchTerm : (NSString*)searchText
{
    if (searchText == nil) return;
    
    NSString *searchString = _contactSearchBar.text;
    
    for (int i=0; i<contactList.count; i++) {
        NSString *tempStr=[contactList objectAtIndex:i];
        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame)
        {
//            [filteredContentList addObject:tempStr];
//            [filteredImgArray addObject:[imagearray objectAtIndex:i]];
        }
    }
    
//  //  self.contactTableView = //YOUR SEARCH LOGIC
//    [self.contactTableView reloadData];
}

@end
