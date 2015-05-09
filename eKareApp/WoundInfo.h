//
//  WoundInfo.h
//  eKareApp
//
//  Created by 澪 月神 on 4/23/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WoundInfo : UIViewController 

@property (strong, nonatomic) NSString *patientMRN;

@property (strong, nonatomic) NSString *patientAgeSex;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *photoName;

@property (nonatomic) int photoIndex;

@property (nonatomic) int count;

@property (strong, nonatomic) IBOutlet UILabel *patientName;

@property (strong, nonatomic) IBOutlet UILabel *ageSex;

@property (strong, nonatomic) IBOutlet UILabel *MRN;

@property (strong, nonatomic) IBOutlet UILabel *doctor;

@property (strong, nonatomic) IBOutlet UILabel *woundLocation;

@property (strong, nonatomic) IBOutlet UILabel *onset;

@property (strong, nonatomic) IBOutlet UILabel *woundType;

@property (strong, nonatomic) IBOutlet UILabel *woundArea;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


- (IBAction)deleteWound:(id)sender;

- (IBAction)viewNextRecord:(id)sender;


@end
