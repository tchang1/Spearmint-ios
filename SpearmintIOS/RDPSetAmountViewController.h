//
//  RDPSetAmountViewController.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPViewController.h"
#import "RDPCutOutView.h"
#import "RDPUITextField.h"
#import "RDPGoal.h"
#import "RDPSuggestionSquare.h"
#import "RDPSuggestionsView.h"

@interface RDPSetAmountViewController : RDPViewController

// The input text field
@property (weak, nonatomic) IBOutlet RDPCutOutView *cutOutView;
@property (weak, nonatomic) IBOutlet RDPUITextField *setAmountTextField;


// The suggesitons view
@property (weak, nonatomic) IBOutlet RDPSuggestionsView *suggestionsView;
@property (weak, nonatomic) IBOutlet RDPSuggestionSquare *suggestion1;
@property (weak, nonatomic) IBOutlet RDPSuggestionSquare *suggestion2;
@property (weak, nonatomic) IBOutlet RDPSuggestionSquare *suggestion3;
@property (weak, nonatomic) IBOutlet RDPSuggestionSquare *suggestion4;


// The user goal
@property (strong, nonatomic) RDPGoal *userGoal;

@end
