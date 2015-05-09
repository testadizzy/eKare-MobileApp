//
//  ImageViewViewController.m
//  eKareApp
//
//  Created by 澪 月神 on 4/19/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "ImageViewViewController.h"
#import "MobileCoreServices/MobileCoreServices.h"
#import "DBManager.h"
#import "WoundInfo.h"
#import <QuartzCore/QuartzCore.h>

#define REF_WIDTH 4.6
#define REF_HEIGHT 2.6


@interface ImageViewViewController ()

@property (nonatomic, strong) NSMutableArray *myPoint;

@property (nonatomic) int count;

@property (nonatomic) int index;

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSString *photoName;

@end

@implementation ImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // If the device does not have a camera
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    self.index = 0;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"patientInfo.sql"];
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


- (IBAction)addWound:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];

}

- (IBAction)measureWound:(id)sender {
    if (!self.myPoint || !self.myPoint.count){
        self.myPoint = [[NSMutableArray alloc] init];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Measurement Instruction." message:@"Please mark points at left, right, top, bottom edge for the wound and for the reference card." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self.myPoint removeAllObjects];
    }
    self.count = 0;
    self.ImageView.userInteractionEnabled = YES;
    for (UIView *view in [self.ImageView subviews]) {
        [view removeFromSuperview];
    }

    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.ImageView];
        UIView *touchView = [[UIView alloc] init];
        [touchView setBackgroundColor:[UIColor redColor]];
        touchView.frame = CGRectMake(currentPoint.x, currentPoint.y, 15, 15);
        touchView.layer.cornerRadius = 15;
        [self.ImageView addSubview:touchView];
    
    
        [self.myPoint addObject:[NSValue valueWithCGPoint:currentPoint]];
        self.count++;
        
        if(self.count >= 8) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Measurement complete!" message:@"If you want to save the measurement, click Done. Otherwise click Measure Size again to start over." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [self calculateWoundArea];
            self.ImageView.userInteractionEnabled = NO;
            [self.myPoint removeAllObjects];
            self.count = 0;
        }
   
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.ImageView.image = chosenImage;
    self.ImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        int count = 0;
        self.photoName = [NSString stringWithFormat:@"%@%d.png", self.patientMRN, count];
        NSURL *urlSave = [[self getDocumentsPathURL] URLByAppendingPathComponent:self.photoName];
        
        
        while ([[NSFileManager defaultManager] fileExistsAtPath:urlSave.path] ) {
            count++;
            self.photoName = [NSString stringWithFormat:@"%@%d.png", self.patientMRN, count];
            urlSave = [[self getDocumentsPathURL] URLByAppendingPathComponent:self.photoName];
        }
        
        self.index = count;
        
        [UIImagePNGRepresentation(chosenImage) writeToFile:urlSave.path atomically:YES];
        
         UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);

    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)calculateWoundArea {
    
    NSValue *objectFirst = [self.myPoint objectAtIndex:0];
    NSValue *objectSecond = [self.myPoint objectAtIndex:1];
    NSValue *objectThird = [self.myPoint objectAtIndex:2];
    NSValue *objectFourth = [self.myPoint objectAtIndex:3];
    
    NSValue *refFirst = [self.myPoint objectAtIndex:4];
    NSValue *refSecond = [self.myPoint objectAtIndex:5];
    NSValue *refThird = [self.myPoint objectAtIndex:6];
    NSValue *refFourth = [self.myPoint objectAtIndex:7];
    
    CGPoint firstPoint = [objectFirst CGPointValue];
    CGPoint secondPoint = [objectSecond CGPointValue];
    CGPoint thirdPoint = [objectThird CGPointValue];
    CGPoint fourthPoint = [objectFourth CGPointValue];
    
    CGPoint fifthPoint = [refFirst CGPointValue];
    CGPoint sixthPoint = [refSecond CGPointValue];
    CGPoint seventhPoint = [refThird CGPointValue];
    CGPoint eighthPoint = [refFourth CGPointValue];
    
    CGFloat xObjHorizDist = (secondPoint.x - firstPoint.x);
    CGFloat yObjHorizDist = (secondPoint.y - firstPoint.y);
    CGFloat objHorizDist = sqrt((xObjHorizDist * xObjHorizDist) + (yObjHorizDist * yObjHorizDist));
    
    CGFloat xObjVertDist = (fourthPoint.x - thirdPoint.x);
    CGFloat yObjVertDist = (fourthPoint.y - thirdPoint.y);
    CGFloat objVertDist = sqrt((xObjVertDist * xObjVertDist) + (yObjVertDist * yObjVertDist));
    
    CGFloat xRefHorizDist = (sixthPoint.x - fifthPoint.x);
    CGFloat yRefHorizDist = (sixthPoint.y - fifthPoint.y);
    CGFloat refHorizDist = sqrt((xRefHorizDist * xRefHorizDist) + (yRefHorizDist * yRefHorizDist));
    
    CGFloat xRefVertDist = (eighthPoint.x - seventhPoint.x);
    CGFloat yRefVertDist = (eighthPoint.y - seventhPoint.y);
    CGFloat refVertDist = sqrt((xRefVertDist * xRefVertDist) + (yRefVertDist * yRefVertDist));
    
    
    
    NSLog(@"wound width is %.2f", objHorizDist);
    NSLog(@"wound height is %.2f", objVertDist);
    NSLog(@"reference width is %.2f", refHorizDist);
    NSLog(@"reference height is %.2f", refVertDist);
    
    CGFloat woundWidth = (objHorizDist*REF_WIDTH)/refHorizDist;
    CGFloat woundHeight = (objVertDist*REF_HEIGHT)/refVertDist;
    
    NSString *woundSize = [NSString stringWithFormat:@"%.2f", woundWidth * woundHeight];
    NSLog(@"Wound size is %@", woundSize);
    
    
    
    NSString *query = [NSString stringWithFormat:@"insert into patientWound values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", self.photoName, self.patientMRN, self.doctor, self.onset, self.woundType, self.woundLocation, woundSize, self.onset];
        
    [self.dbManager executeQuery:query];
        
    if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
        
    else{
        NSLog(@"Could not execute the query.");
    }
        
    

}


 #pragma mark - Navigation
 

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.destinationViewController isKindOfClass:[WoundInfo class]]){
         WoundInfo *woundInfoController = segue.destinationViewController;
         woundInfoController.photoName = self.photoName;
         woundInfoController.photoIndex = self.index;
         woundInfoController.count++;
     }

 }



@end
