//
//  PatientDirectoryControllerTableViewController.h
//  eKareApp
//
//  Created by 澪 月神 on 4/14/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientDirectoryControllerTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblPatient;

- (IBAction)addNewPatient:(id)sender;

@end
