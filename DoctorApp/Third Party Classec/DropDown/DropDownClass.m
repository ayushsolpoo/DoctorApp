//
//  DropDownClass.m
//  ProjectBabyVaccination1
//
//  Created by Anand on 30/10/14.
//  Copyright (c) 2014 strick. All rights reserved.
//

#import "DropDownClass.h"
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
@interface DropDownClass()
@property(nonatomic,strong)UITableView *dropTable;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic, strong) UIButton *btnSender;
@end
@implementation DropDownClass
@synthesize animationDirection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)showDropDown:(UIButton *)b tableHeight:(CGFloat *)height tableArray:(NSArray *)arr imageArray:(NSArray *)imgArr tableDir:(NSString *)direction TableNo:(int)tableno
{
    _btnSender = b;
    self.animationDirection = direction;
    self.dropTable = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.array = [NSArray arrayWithArray:arr];
       // self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        _dropTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        _dropTable.delegate = self;
        _dropTable.dataSource = self;
        _dropTable.layer.cornerRadius = 5;
        _dropTable.backgroundColor = [UIColor whiteColor];
        _dropTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _dropTable.separatorColor = [UIColor blackColor];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            
        }
        else
        {
            [_dropTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        }
        _dropTable.frame = CGRectMake(0, 0, btn.size.width, *height);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:_dropTable];
        tableNo = tableno;
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b{
    
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    _dropTable.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.delegate dropdownSelectedIndex:indexPath.row tableNo:tableNo];
    
     [self hideDropDown:_btnSender];
    [self myDelegate];
    
}

-(void)myDelegate{
    
    [self.delegate dropDownDelegateMethod:self];
}

@end
