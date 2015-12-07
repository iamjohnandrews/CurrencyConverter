//
//  ViewController.h
//  CurrencyConverter
//
//  Created by John Andrews on 12/6/15.
//  Copyright © 2015 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryPickerViewController.h"

@interface ViewController : UIViewController <NSURLConnectionDelegate, CountryPickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *conversionRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *convertedToLabel;
@property (weak, nonatomic) IBOutlet UILabel *convertFromLabel;
@property (weak, nonatomic) IBOutlet UIButton *convertedToButton;
@property (weak, nonatomic) IBOutlet UIImageView *convertedToFlag;
@property (weak, nonatomic) IBOutlet UIImageView *convertFromFlag;
@property (strong, nonatomic) CountryPickerViewController *countryPickerVC;

- (IBAction)convertedToButtonPressed:(UIButton *)sender;

//might need to connect decimal to digit
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)clearPressed:(UIButton *)sender;


@end

