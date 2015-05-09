//
//  addWound.m
//  eKareApp
//
//  Created by 澪 月神 on 4/23/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "addWound.h"
#import "DBManager.h"
#import "ImageViewViewController.h"

@interface addWound ()

@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation addWound

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doctor.delegate = self;
    self.onset.delegate = self;
    self.woundType.delegate = self;
    self.location.delegate = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"patientInfo.sql"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"takePhoto"]) {
        ImageViewViewController *imageViewController = [segue destinationViewController];
        
        imageViewController.patientMRN = self.patientMRN;
        imageViewController.woundType = self.woundType.text;
        imageViewController.woundLocation = self.location.text;
        imageViewController.doctor = self.doctor.text;
        imageViewController.onset = self.onset.text;
    }
    
}


@end
