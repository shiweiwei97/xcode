//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Weiwei Shi on 2/15/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (atomic) BOOL isEnteringNewDigit;

@property (nonatomic, strong) CalculatorBrain* brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;

@synthesize isEnteringNewDigit = _isEnteringNewDigit;

@synthesize brain = _brain;

- (CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    
    if (self.isEnteringNewDigit)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else
    {
        self.display.text = digit;
        self.isEnteringNewDigit = YES;
    }
    
    NSLog(@"digit pressed = %@", digit);
}

- (IBAction)operatorPressed:(UIButton *)sender
{
    if (self.isEnteringNewDigit) [self enterPressed];
        
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;

    self.isEnteringNewDigit = NO;
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];

    self.isEnteringNewDigit = NO;
}

@end
