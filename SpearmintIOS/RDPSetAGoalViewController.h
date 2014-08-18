//
//  RDPSetAGoalViewController.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPViewController.h"
#import "RDPUITextField.h"
#import "RDPCutOutView.h"
#import "RDPGoal.h"
#import "RDPSuggestionsView.h"
#import "RDPSuggestionSquare.h"

@interface RDPSetAGoalViewController : RDPViewController <UITextFieldDelegate>


// The text field input 
@property (weak, nonatomic) IBOutlet RDPCutOutView *cutOutView;
@property (weak, nonatomic) IBOutlet RDPUITextField *setAGoalTextField;

// The suggestions view
@property (weak, nonatomic) IBOutlet RDPSuggestionsView *suggestionsView;

@property (weak, nonatomic) IBOutlet RDPSuggestionSquare *suggestion1;
@property (weak, nonatomic) IBOutlet UIButton *suggestionButton1;

@property (weak, nonatomic) IBOutlet RDPSuggestionSquare *suggestion2;
@property (weak, nonatomic) IBOutlet UIButton *suggestionButton2;

@property (weak, nonatomic) IBOutlet RDPSuggestionSquare *suggestion3;
@property (weak, nonatomic) IBOutlet UIButton *suggestionButton3;

@property (weak, nonatomic) IBOutlet RDPSuggestionSquare *suggestion4;
@property (weak, nonatomic) IBOutlet UIButton *suggestionButton4;

@property (weak, nonatomic) IBOutlet RDPSuggestionSquare *suggestion5;
@property (weak, nonatomic) IBOutlet UIButton *suggestionButton5;

@property (weak, nonatomic) IBOutlet RDPSuggestionSquare *suggestion6;
@property (weak, nonatomic) IBOutlet UIButton *suggestionButton6;

// The goal
@property (strong, nonatomic) RDPGoal *userGoal; 

@end
