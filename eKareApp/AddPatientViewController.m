//
//  AddPatientViewController.m
//  eKareApp
//
//  Created by 澪 月神 on 4/9/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "AddPatientViewController.h"
#import "DBManager.h"
#import "ConsentViewController.h"

@interface AddPatientViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation AddPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.txtFirstname.delegate = self;
    self.txtLastname.delegate = self;
    self.txtDOB.delegate = self;
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"patientInfo.sql"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}


-(IBAction)createInfo:(id)sender {
    
    if([self.txtMRN.text length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Patient MRN cannot be empty!" message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    else if ([self.txtMRN.text length] != 8){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Patient MRN must contain exactly 8 digits!" message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Obtain Patient Consent?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:nil];
    
        [alert addButtonWithTitle:@"Yes"];
        [alert show];
    }
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // Prepare the query string.
        NSString *query = [NSString stringWithFormat:@"insert into patientInfo values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", self.txtMRN.text, self.txtFirstname.text, self.txtLastname.text, self.txtDOB.text, self.txtSEX.text, self.txtPhone.text, self.txtAddress.text, self.txtZip.text];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Push the view controller.
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            ConsentViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"ConsentController"];
            [self.navigationController pushViewController:cvc animated:YES];
            
        }
        else{
            NSLog(@"Could not execute the query.");
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
