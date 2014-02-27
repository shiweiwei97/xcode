//
//  PsychologistViewController.m
//  Psychologist
//
//  Created by Weiwei Shi on 2/22/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import "PsychologistViewController.h"
#import "HappinessViewController.h"

@interface PsychologistViewController ()

@property (nonatomic) int diagnosis;

@end

@implementation PsychologistViewController

@synthesize diagnosis = _diagnosis;

- (HappinessViewController *) splitViewHappinessViewController
{
    id hvc = [self.splitViewController.viewControllers lastObject];
    if (![hvc isKindOfClass:[HappinessViewController class]]) {
        hvc = nil;
    }
    return hvc;
}

- (void)setAndShowDiagnosis:(int) diagnosis
{
    self.diagnosis = diagnosis;
    if ([self splitViewHappinessViewController]) {
        [self splitViewHappinessViewController].happiness = diagnosis;
    } else {
        [self performSegueWithIdentifier:@"ShowDiagnosis" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDiagnosis"]) {
        [segue.destinationViewController setHappiness:self.diagnosis];
    } else if ([segue.identifier isEqualToString:@"Celebrity"]) {
        [segue.destinationViewController setHappiness:100];
    } else if ([segue.identifier isEqualToString:@"Serious"]) {
        [segue.destinationViewController setHappiness:20];
    } else if ([segue.identifier isEqualToString:@"TV Kook"]) {
        [segue.destinationViewController setHappiness:50];
    }
}

- (IBAction)celebrity
{
    [self setAndShowDiagnosis:100];
}

- (IBAction)tv
{
    [self setAndShowDiagnosis:50];
}

- (IBAction)serious
{
    [self setAndShowDiagnosis:20];
}

- (IBAction)flying
{
    [self setAndShowDiagnosis:85];
}

- (IBAction)apple
{
    [self setAndShowDiagnosis:100];
}

- (IBAction)dragon
{
    [self setAndShowDiagnosis:20];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
