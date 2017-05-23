//
//  DAHomeCCell.h
//  DoctorApp
//
//  Created by Ranjit Singh on 22/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAHomeCCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *slideImageView;
@property (weak, nonatomic) IBOutlet UIImageView *appointmentimg;
@property (weak, nonatomic) IBOutlet UILabel     *applbl;
@property (weak, nonatomic) IBOutlet UIView      *_backview;

@end
