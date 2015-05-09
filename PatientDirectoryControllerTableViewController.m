//
//  PatientDirectoryControllerTableViewController.m
//  eKareApp
//
//  Created by 澪 月神 on 4/14/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "PatientDirectoryControllerTableViewController.h"
#import "DBManager.h"
#import "PatientInfoControllerTableViewController.h"


@interface PatientDirectoryControllerTableViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrPatientInfo;


-(void)loadData;


@end

@implementation PatientDirectoryControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tblPatient.delegate = self;
    self.tblPatient.dataSource = self;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"patientInfo.sql"];

    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewPatient:(id)sender {
    [self performSegueWithIdentifier:@"idSegueAddPatient" sender:self];
}

-(void)loadData{
 
  /*
    NSString *temp = @"delete from patientInfo where MRN = '001'";
    [self.dbManager executeQuery:temp];
 
    
    NSString *createTable = @"create table patientWound (photoName text primary key, MRN text, doctor text, onset text, woundType text, woundLocation text, woundSize text, lastAssessment text)";
    [self.dbManager executeQuery:createTable];
    
     */

    // Form the query.
    NSString *query = @"select * from patientInfo";
    
    // Get the results.
    if (self.arrPatientInfo != nil) {
        self.arrPatientInfo = nil;
    }
    self.arrPatientInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblPatient reloadData];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrPatientInfo.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0){
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"idTitleCell" forIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
        NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
        NSInteger indexOfLastname = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
        NSInteger indexOfMRN = [self.dbManager.arrColumnNames indexOfObject:@"MRN"];
        NSInteger indexOfDOB = [self.dbManager.arrColumnNames indexOfObject:@"dob"];
        NSInteger indexOfSex = [self.dbManager.arrColumnNames indexOfObject:@"sex"];
        
        NSString *dateOfBirth = [[self.arrPatientInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfDOB];
        NSString *age;
        if([dateOfBirth length] == 0){
            age = @" ";
        }
        else {
            NSString *yearOfBirth = [dateOfBirth substringWithRange:NSMakeRange(4, 4)];
            age = [NSString stringWithFormat:@"%d", 2015 - [yearOfBirth intValue]];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@\t\t %@\t\t%@%@", [[self.arrPatientInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname], [[self.arrPatientInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfLastname], [[self.arrPatientInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfMRN], age, [[self.arrPatientInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfSex]];
    
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPatientInfo"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        PatientInfoControllerTableViewController *destViewController = [segue destinationViewController];
        
        destViewController.patientMRN = [[self.arrPatientInfo objectAtIndex:indexPath.row] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"MRN"]];
        
    }
}


- (IBAction)unwindToPatientDirectory: (UIStoryboardSegue *)segue {
    
    UIViewController* sourceViewClass = segue.sourceViewController;
    
    if([sourceViewClass isKindOfClass:[PatientInfoControllerTableViewController class]]){
        
        [self loadData];
    }
    
}


@end
