//
//  PatientInfoControllerTableViewController.h
//  eKareApp
//
//  Created by 澪 月神 on 4/16/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientInfoControllerTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblPatientInfo;

@property (strong, nonatomic) NSString *patientMRN;

- (IBAction)deletePatient:(id)sender;


@end
