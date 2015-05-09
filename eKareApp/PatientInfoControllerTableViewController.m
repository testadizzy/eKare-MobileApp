//
//  PatientInfoControllerTableViewController.m
//  eKareApp
//
//  Created by 澪 月神 on 4/16/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "PatientInfoControllerTableViewController.h"
#import "WoundInfo.h"
#import "DBManager.h"

@interface PatientInfoControllerTableViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrPatientInfo;

@property (nonatomic, strong) NSArray *patientData;

-(void)loadData;

@end

@implementation PatientInfoControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tblPatientInfo.delegate = self;
    self.tblPatientInfo.dataSource = self;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"patientInfo.sql"];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData{
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"select * from patientInfo where MRN = '%@'", self.patientMRN];
    
    // Get the results.
    if (self.arrPatientInfo != nil) {
        self.arrPatientInfo = nil;
    }
    self.arrPatientInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if (self.arrPatientInfo.count){
        self.patientData = [[NSArray alloc] init];
        self.patientData = [self.arrPatientInfo objectAtIndex:0];
    }

    // Reload the table view.
    [self.tblPatientInfo reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static int count = 0;
    
    if (indexPath.row == 8){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"idCellManage" forIndexPath:indexPath];
    }
    
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"idCellInfo" forIndexPath:indexPath];
    
    
        NSInteger indexOfFirstname;
        NSInteger indexOfLastname;
        NSInteger indexOfDOB;
        NSInteger indexOfMRN;
        NSInteger indexOfSex;
        NSInteger indexOfPhone;
        NSInteger indexOfAddress;
        NSInteger indexOfZip;
        
    
        switch (count) {
            case 0:
                indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
                cell.textLabel.text = [NSString stringWithFormat:@"First Name\t\t\t%@", [self.patientData objectAtIndex:indexOfFirstname]];
                count++;
            break;
            case 1:
                indexOfLastname = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
                cell.textLabel.text = [NSString stringWithFormat:@"Last Name\t\t\t%@", [self.patientData objectAtIndex:indexOfLastname]];
                count++;
            break;
            case 2:
                indexOfDOB = [self.dbManager.arrColumnNames indexOfObject:@"dob"];
                cell.textLabel.text = [NSString stringWithFormat:@"Date of Birth\t\t%@", [self.patientData objectAtIndex:indexOfDOB]];
                count++;
            break;
        case 3:
            indexOfMRN = [self.dbManager.arrColumnNames indexOfObject:@"MRN"];
            cell.textLabel.text = [NSString stringWithFormat:@"MRN\t\t\t\t%@", [self.patientData objectAtIndex:indexOfMRN]];
            count++;
            break;
        case 4:
            indexOfSex = [self.dbManager.arrColumnNames indexOfObject:@"sex"];
            cell.textLabel.text = [NSString stringWithFormat:@"SEX\t\t\t\t%@", [self.patientData objectAtIndex:indexOfSex]];
            count++;
            break;
        case 5:
            indexOfPhone = [self.dbManager.arrColumnNames indexOfObject:@"phone"];
            cell.textLabel.text = [NSString stringWithFormat:@"Phone\t\t\t\t%@", [self.patientData objectAtIndex:indexOfPhone]];
            count++;
            break;
        case 6:
            indexOfAddress = [self.dbManager.arrColumnNames indexOfObject:@"address"];
            cell.textLabel.text = [NSString stringWithFormat:@"Address\t\t\t%@", [self.patientData objectAtIndex:indexOfAddress]];
            count++;
            break;
        case 7:
            indexOfZip = [self.dbManager.arrColumnNames indexOfObject:@"zip"];
            cell.textLabel.text = [NSString stringWithFormat:@"Zip\t\t\t\t\t%@", [self.patientData objectAtIndex:indexOfZip]];
            count = 0;
            break;
        default:
            break;
    }
    
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
    if ([segue.identifier isEqualToString:@"showWound"]) {
        UINavigationController *navController = [segue destinationViewController];
        WoundInfo *woundInfoController = (WoundInfo *)[navController topViewController];
        woundInfoController.patientMRN = self.patientMRN;
        
        NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
        NSInteger indexOfLastname = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
        NSInteger indexOfDOB = [self.dbManager.arrColumnNames indexOfObject:@"dob"];
        NSInteger indexOfSex = [self.dbManager.arrColumnNames indexOfObject:@"sex"];
        
        NSString *dateOfBirth = [self.patientData objectAtIndex:indexOfDOB];
        NSString *age;
        if([dateOfBirth length] == 0){
            age = @" ";
        }
        else {
            NSString *yearOfBirth = [dateOfBirth substringWithRange:NSMakeRange(4, 4)];
            age = [NSString stringWithFormat:@"%d", 2015 - [yearOfBirth intValue]];
        }
        
        woundInfoController.patientAgeSex = [NSString stringWithFormat:@"%@%@", age, [self.patientData objectAtIndex:indexOfSex]];
        
        woundInfoController.name = [NSString stringWithFormat:@"%@ %@", [self.patientData objectAtIndex:indexOfFirstname], [self.patientData objectAtIndex:indexOfLastname]];
        
    }
}

- (IBAction)deletePatient:(id)sender {
    
    NSString *query = [NSString stringWithFormat:@"delete from patientInfo where MRN = '%@'", self.patientMRN];
    
    [self.dbManager executeQuery:query];
    
    NSLog(@"MRN is %@", self.patientMRN);
    
    if (self.dbManager.affectedRows != 0) {
    
        NSLog(@"delete data successful");
        
    }
    
    NSString *temp = [NSString stringWithFormat:@"delete from patientWound where MRN = '%@'", self.patientMRN];
    
    [self.dbManager executeQuery:temp];
    
    
}

@end
