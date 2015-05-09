//
//  AddPatientViewController.h
//  eKareApp
//
//  Created by 澪 月神 on 4/9/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPatientViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;

@property (weak, nonatomic) IBOutlet UITextField *txtLastname;

@property (weak, nonatomic) IBOutlet UITextField *txtDOB;

@property (weak, nonatomic) IBOutlet UITextField *txtSEX;

@property (weak, nonatomic) IBOutlet UITextField *txtMRN;

@property (weak, nonatomic) IBOutlet UITextField *txtAddress;

@property (weak, nonatomic) IBOutlet UITextField *txtZip;

@property (weak, nonatomic) IBOutlet UITextField *txtPhone;

- (IBAction)createInfo:(id)sender;

@end
