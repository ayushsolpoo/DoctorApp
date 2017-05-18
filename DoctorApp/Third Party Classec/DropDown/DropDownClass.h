//
//  DropDownClass.h
//  ProjectBabyVaccination1
//
//  Created by Anand on 30/10/14.
//  Copyright (c) 2014 strick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropDownClass;
@protocol DropDownDelegate
-(void) dropDownDelegateMethod:(DropDownClass *) sender;
-(void)dropdownSelectedIndex:(int)index tableNo:(int)tableno;
@end
@interface DropDownClass : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSString *animationDirection;
//    UIImageView *imgView;
    int tableNo;
}
@property(nonatomic,assign)id<DropDownDelegate>delegate;
@property (nonatomic, strong) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b tableHeight:(CGFloat *)height tableArray:(NSArray *)arr imageArray:(NSArray *)imgArr tableDir:(NSString *)direction TableNo:(int)tableno;
@end
