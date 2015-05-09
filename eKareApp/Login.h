//
//  Login.h
//  eKareApp
//
//  Created by 澪 月神 on 4/30/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Login : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *ClinicName;

@property (strong, nonatomic) IBOutlet UITextField *userName;

@property (strong, nonatomic) IBOutlet UITextField *passWord;


@end
