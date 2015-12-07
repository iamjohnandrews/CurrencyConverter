//
//  ViewController.h
//  CurrencyConverter
//
//  Created by John Andrews on 12/6/15.
//  Copyright © 2015 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *conversionRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *convertedToLabel;
@property (weak, nonatomic) IBOutlet UILabel *convertFromLabel;
@property (weak, nonatomic) IBOutlet UIButton *convertedToButton;
@property (weak, nonatomic) IBOutlet UIImageView *convertedToFlag;
@property (weak, nonatomic) IBOutlet UIButton *convertFromButton;
@property (weak, nonatomic) IBOutlet UIImageView *convertFromFlag;

- (IBAction)convertedToButtonPressed:(UIButton *)sender;
- (IBAction)convertFromButtonPressed:(UIButton *)sender;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)switchPressed:(UIButton *)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)clearPressed:(UIButton *)sender;

@end

