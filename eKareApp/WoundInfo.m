//
//  WoundInfo.m
//  eKareApp
//
//  Created by 澪 月神 on 4/23/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "WoundInfo.h"
#import "DBManager.h"
#import "addWound.h"
#import "PatientInfoControllerTableViewController.h"
#import "ImageViewViewController.h"

@interface WoundInfo ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrWoundInfo;

@property (nonatomic, strong) NSArray *woundData;

@property (nonatomic) int previousIndex;

@property (nonatomic, strong) NSString *mode;

@end

@implementation WoundInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.patientName.text = self.name;
    self.ageSex.text = self.patientAgeSex;
    self.MRN.text = self.patientMRN;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"patientInfo.sql"];
    self.count = 0;
    self.photoIndex = 0;
    self.previousIndex = -1;
    self.mode = @"default";
    
    [self loadData:self.patientMRN];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSURL *)getDocumentsPathURL {
    //document directory of app
    return [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                  inDomain:NSUserDomainMask
                                         appropriateForURL:nil
                                                    create:YES
                                                     error:nil];
}

- (void)loadData:(NSString *)patientMRN  {
    

    NSString *photoNameWithIndex;
    NSString *query;
    
    if([patientMRN length] != 0 ){
        // called by deletewound method
        if([self.mode isEqualToString:@"reload"]){
            self.photoIndex = 0;
             photoNameWithIndex = [NSString stringWithFormat:@"%@%d.png", self.patientMRN, self.photoIndex];
            while(![self loadDefaultImage:photoNameWithIndex]){
                self.photoIndex++;
                 photoNameWithIndex = [NSString stringWithFormat:@"%@%d.png", self.patientMRN, self.photoIndex];
            }
            self.mode = @"default";
            query = [NSString stringWithFormat:@"select * from patientWound where photoName = '%@'", photoNameWithIndex];
        }
        else {
            photoNameWithIndex = [NSString stringWithFormat:@"%@%d.png", self.patientMRN, self.photoIndex];
            // call from patientInfo page, first time call
            if (self.photoIndex == 0 && self.previousIndex == -1){
                query = [NSString stringWithFormat:@"select * from patientWound where MRN = '%@'", self.patientMRN];
            }
            // triggered by next button to see more record
            else{
                query = [NSString stringWithFormat:@"select * from patientWound where photoName = '%@'", photoNameWithIndex];
            }
        }
    }
    // unwind call from imageViewController
    else {
        photoNameWithIndex = self.photoName;
        query = [NSString stringWithFormat:@"select * from patientWound where photoName = '%@'", photoNameWithIndex];
    }
    
    [self loadDefaultImage:photoNameWithIndex];

    
    if (self.arrWoundInfo != nil) {
        self.arrWoundInfo = nil;
    }
    
    self.arrWoundInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if (self.arrWoundInfo.count){
        
        self.woundData = [[NSArray alloc] init];
        self.woundData = [self.arrWoundInfo objectAtIndex:0];
    
        NSInteger indexOfDoctor = [self.dbManager.arrColumnNames indexOfObject:@"doctor"];
        NSInteger indexOfLocation = [self.dbManager.arrColumnNames indexOfObject:@"woundLocation"];
        NSInteger indexOfOnset = [self.dbManager.arrColumnNames indexOfObject:@"onset"];
        NSInteger indexOfArea = [self.dbManager.arrColumnNames indexOfObject:@"woundSize"];
        NSInteger indexofType = [self.dbManager.arrColumnNames indexOfObject:@"woundType"];
    
        self.doctor.text = [self.woundData objectAtIndex:indexOfDoctor];
        self.woundLocation.text = [self.woundData objectAtIndex:indexOfLocation];
        self.onset.text = [self.woundData objectAtIndex:indexOfOnset];
        self.woundType.text = [self.woundData objectAtIndex:indexofType];
        self.woundArea.text = [self.woundData objectAtIndex:indexOfArea];
    }
    
    else {
        NSLog(@"There is no such wound record");
    }

}


-(BOOL)loadDefaultImage:(NSString *)photoName
{
   // NSString *fileName = [NSString stringWithFormat:@"%@.png", self.patientMRN];
    NSURL *urlImage = [[self getDocumentsPathURL] URLByAppendingPathComponent:photoName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:urlImage.path]) {
        NSData *dataFile = [[NSFileManager defaultManager] contentsAtPath:urlImage.path];
        UIImage *image = [[UIImage alloc] initWithData:dataFile];

        self.imageView.clipsToBounds = YES;
        self.imageView.image = image;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        return true;
    }
    else {
        if(self.photoIndex > self.previousIndex && ![self.mode isEqualToString:@"reload"] && self.previousIndex != -1){
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"That's it!"
                                                                  message:@"No more wound record available right now."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            self.photoIndex = -1;
            self.previousIndex = -1;
        }
        NSLog(@"Image not found");
        return false;
    }
}


- (void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"Delete photo successful!");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

- (IBAction)deleteWound:(id)sender {
    
    
    NSString *fileName = [NSString stringWithFormat:@"%@%d.png", self.patientMRN, self.photoIndex];
    
    NSString *temp = [NSString stringWithFormat:@"delete from patientWound where photoName = '%@'", fileName];
    
    [self.dbManager executeQuery:temp];
    
    [self removeImage:fileName];
    
    self.count--;

    if(self.count > 0){
        self.mode = @"reload";
        [self loadData:self.patientMRN];
    }
    else {
        [self resetPage];
        self.imageView.image = nil;
    }
}


- (IBAction)viewNextRecord:(id)sender {
    // called when user first use this function
    if(self.photoIndex == 0 && self.previousIndex == -1) {
        self.photoIndex++;
        self.previousIndex++;
        [self loadData:self.patientMRN];
    }
    // After user views all records, go back to the 1st record
    else if(self.photoIndex == -1){
        self.photoIndex++;
        [self loadData:self.patientMRN];
    }
    else if(self.photoIndex != 0 && self.previousIndex == -1) {
        self.previousIndex = self.photoIndex;
        self.photoIndex--;
        [self loadData:self.patientMRN];
    }
    // following call
    else {
        if(self.photoIndex > self.previousIndex){
            self.photoIndex++;
            self.previousIndex++;
            [self loadData:self.patientMRN];
        }
        else {
            if(self.photoIndex == 0){
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"That's it!"
                                                                      message:@"No more wound record available right now."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                
                [myAlertView show];
                self.photoIndex = 0;
                self.previousIndex = -1;
            }
            else{
                self.photoIndex--;
                self.previousIndex--;
                [self loadData:self.patientMRN];
            }
        }
    }
}


- (void)resetPage {

    self.doctor.text = @"";
    self.woundLocation.text = @"";
    self.onset.text = @"";
    self.woundType.text = @"";
    self.woundArea.text = @"";

}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
       if ([segue.identifier isEqualToString:@"segueAddWound"]) {
           addWound *addWoundController = [segue destinationViewController];
           
           addWoundController.patientMRN = self.patientMRN;
           
       }
       if ([segue.identifier isEqualToString:@"backToPatientInfo"]){
       
           PatientInfoControllerTableViewController *patientInfoController = [segue destinationViewController];
           patientInfoController.patientMRN = self.patientMRN;
       }
}

- (IBAction)unwindToWoundInfo: (UIStoryboardSegue *)segue {
    
    UIViewController* sourceViewClass = segue.sourceViewController;
    
    if([sourceViewClass isKindOfClass:[ImageViewViewController class]]){
    
        [self loadData:@""];
    }

}


@end
