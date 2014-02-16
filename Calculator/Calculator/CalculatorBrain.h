//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Weiwei Shi on 2/15/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;

- (double)performOperation:(NSString *) operation;

@property (readonly) id program;

+ (double) runProgram:(id)program;

+ (NSString *) descriptionOfProgram:(id)program;

@end
