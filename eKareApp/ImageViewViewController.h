//
//  ImageViewViewController.h
//  eKareApp
//
//  Created by 澪 月神 on 4/19/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *ImageView;

@property (strong, nonatomic) NSString *patientMRN;

@property (strong, nonatomic) NSString *doctor;

@property (strong, nonatomic) NSString *woundType;

@property (strong, nonatomic) NSString *woundLocation;

@property (strong, nonatomic) NSString *onset;


- (IBAction)addWound:(UIButton *)sender;

- (IBAction)measureWound:(id)sender;



@end
