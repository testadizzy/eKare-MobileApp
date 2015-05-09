//
//  addWound.h
//  eKareApp
//
//  Created by 澪 月神 on 4/23/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addWound : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *onset;


@property (strong, nonatomic) IBOutlet UITextField *woundType;


@property (strong, nonatomic) IBOutlet UITextField *doctor;


@property (strong, nonatomic) IBOutlet UITextField *location;


@property (strong, nonatomic) NSString *patientMRN;



@end
