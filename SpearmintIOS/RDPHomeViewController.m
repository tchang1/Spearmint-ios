//
//  RDPHomeViewController.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/29/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPHomeViewController.h"
#import "RDPImageBlur.h"
#import "RDPHTTPClient.h"
#import "RDPStrings.h"
#import "RDPSavingEvent.h"
#import "RDPUser.h"
#import "RDPUserService.h"
#import "RDPAnalyticsModule.h"
#import "RDPProgressHeader.h"

#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kScreenWidth 320
#define kTextInputHeight 60
#define kContentHeight  (kScreenHeight * 2) + kTextInputHeight

#define kIndentAmount 10
#define kBorderRadius 5

#define kSuggestionDisplayDuration 4
#define kShowCongratsDuration 2500

#define kMinimumPressDuration 0.2

#define kFadeLabelsTime 0.75
#define kFadeImagesTime 0.75

#define kImageTransitionTime 3.0f

@implementation RDPHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the minimum press duration to be short so it seems more responsive
    self.pressAndHoldGestureRecognizer.minimumPressDuration = kMinimumPressDuration;
    
    // Get the clear and blurred image from the image fetcher
    self.imageFetcher = [RDPImageFetcher getImageFetcher];
    int index = self.imageFetcher.indexOfImageArray;
    self.clearImageView.image = self.imageFetcher.clearImagesArray[index];
    self.blurredImageView.image = self.imageFetcher.blurredImagesArray[index];
    
    // Setup the scroll view
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, kContentHeight)];
    CGPoint point = CGPointMake(0, kTextInputHeight);
    [self.scrollView setContentOffset:point];
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.screenMode = OnSaveScreen;
    self.scrollView.delegate = self;
    
    // Setup the cut out view with text field
    self.savingsTextField.indentAmount = kIndentAmount;
    self.cutOutView.innerView = self.savingsTextField;
    self.savingsTextField.borderRadius = kBorderRadius;
    self.savingsTextField.parentColor = self.cutOutView.backgroundColor;
    NSString *savedBy = @"I saved by...";
    self.savingsTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                   initWithString:savedBy
                                                   attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,
                                                                NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
    
    // Setup the progress view within scroll view
    CGRect  viewRect = CGRectMake(0, kScreenHeight+kTextInputHeight, kScreenWidth, 100);
    UIView *containerView = [[UIView alloc] initWithFrame:viewRect];
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RDPProgressHeader" owner:self options:nil];
    RDPProgressHeader *progressHeader = [topLevelObjects objectAtIndex:0];
    progressHeader.goalTitleLabel.text = [[[RDPUserService getUser] getGoal] getGoalName];
    
    NSString *targetAmount = [[RDPConfig numberFormatter] stringFromNumber:[[[RDPUserService getUser] getGoal] getTargetAmount]];
    NSString *keptAmount = [[RDPConfig numberFormatter] stringFromNumber:[[[RDPUserService getUser] getGoal] getCurrentAmount]];
    progressHeader.goalAmountLabel.text = [@"GOAL " stringByAppendingString:targetAmount];
    progressHeader.keptAmountLabel.text = [@"KEPT " stringByAppendingString:keptAmount];
    
    [containerView addSubview:progressHeader];
    [self.scrollView addSubview:containerView];
    
    // Hide the counter
    self.counterView.hidden = YES;
    
    self.pressAndHoldLabel.text = [RDPStrings stringForID:sPressAndHold];
    
    // Prepare the congratulations message
    self.congratulations = [[RDPCongratulations alloc] init];
    [self.congratulations getNextCongratsMessage];
    self.congratsLabel.text = self.congratulations.congratsMessage;
    self.congratsView.hidden = YES;
    
    self.suggestionIndex = 0;
    self.suggestions = [[RDPSavingSuggestions alloc] init];
    [self.suggestions getNextSuggestionMessages];
    self.suggestionLabel.text = self.suggestions.suggestionMessages[self.suggestionIndex];
    [self startSuggestionsTimer];
}

- (void)startSuggestionsTimer
{
    self.suggestionTimer = [NSTimer scheduledTimerWithTimeInterval:kSuggestionDisplayDuration target:self selector:@selector(displayNextSuggestion) userInfo:nil repeats:YES];
}

- (void)stopSuggestionsTimer
{
    [self.suggestionTimer invalidate];
    self.suggestionTimer = nil;
}

- (void)displayNextSuggestion
{
    NSArray *messages = self.suggestions.suggestionMessages;
    
    // Get next index for messages
    self.suggestionIndex += 1;
    if (self.suggestionIndex > ([messages count]-1)) {
        self.suggestionIndex = 0;
    }
    
    void (^fadeInBlock)(void) = ^{
        // animate the new label into view
        [UIView animateWithDuration:kFadeLabelsTime animations:^{
            self.suggestionLabel.alpha = 1.0;
        }];
    };
    
    [UIView animateWithDuration:kFadeLabelsTime animations:^{
        self.suggestionLabel.alpha = 0.0;
    }
                     completion:^(BOOL finished){
                         self.suggestionLabel.text = messages[self.suggestionIndex];
                         fadeInBlock();
                     }];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollToNextPoint];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollToNextPoint];
    }
}

- (void)scrollToNextPoint
{
    CGFloat breakPointTop = 0;
    CGFloat breakPointMiddle = kTextInputHeight + (kScreenHeight/4);
    CGFloat breakPointBottom = kTextInputHeight + (3*kScreenHeight/4);
    
    if (self.screenMode == OnRecordScreen && self.scrollView.contentOffset.y > 0) { // At record view any scroll should take us to saving screen
        [self goToSaveView];
    }
    else if (self.screenMode == OnSaveScreen) {
        if (self.scrollView.contentOffset.y <= breakPointTop) {
            [self goToRecordView];
        }
        else if (self.scrollView.contentOffset.y > breakPointTop && self.scrollView.contentOffset.y < breakPointMiddle) {
            [self goToSaveView];
        }
        else {
            [self goToProgressView];
        }
    }
    else if (self.screenMode == OnProgressView) {
        if (self.scrollView.contentOffset.y < breakPointBottom) {
            [self goToSaveView];
        }
        else {
            [self goToProgressView];
        }
    }
}

- (void)goToSaveView
{
    self.pressAndHoldGestureRecognizer.enabled = YES;
    [self.scrollView setContentOffset:CGPointMake(0, kTextInputHeight) animated:YES];
    [self.savingsTextField resignFirstResponder];
    if (self.suggestionTimer == nil) {
        [self startSuggestionsTimer];
    }
    self.settingsButtonView.hidden = NO;
    self.screenMode = OnSaveScreen;
}

- (void)goToRecordView
{
    self.pressAndHoldGestureRecognizer.enabled = NO;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.savingsTextField becomeFirstResponder];
    [self stopSuggestionsTimer];
    self.settingsButtonView.hidden = YES;
    self.screenMode = OnRecordScreen;
}

- (void)goToProgressView
{
    self.pressAndHoldGestureRecognizer.enabled = NO;
    [self.scrollView setContentOffset:CGPointMake(0, kScreenHeight + kTextInputHeight) animated:YES];
    self.screenMode = OnProgressView;
}

- (IBAction)pressAndHold:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [UIView animateWithDuration:kFadeImagesTime animations:^{
                
                self.blurredImageView.alpha = 0.0;
                
            }];
            self.counterView.hidden = NO;
            [self.counterView start];
            
            // Stop timer
            [self stopSuggestionsTimer];
            
            self.pressAndHoldView.hidden = YES;
            self.settingsButtonView.hidden = YES;
            self.suggestionView.hidden = YES;
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            self.blurredImageView.alpha = 0.0;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            // disable the gesture recognizer while animations and transitions occur
            self.pressAndHoldGestureRecognizer.enabled = NO;
            
            NSNumber *amountSaved = self.counterView.currencyValue;
            NSLog(@"GestureStateEnded amount: %@",amountSaved);
            BOOL amountHasBeenSaved = ![amountSaved isEqualToNumber:[NSNumber numberWithInt:0]];
            [RDPAnalyticsModule track:@"User saved" properties:@{@"amount" : amountSaved}];

            
            self.settingsButtonView.hidden = NO;
            self.settingsButtonView.duration = kFadeLabelsTime;
            self.settingsButtonView.type     = CSAnimationTypeFadeIn;
            
            // Kick start the animation immediately
            [self.settingsButtonView startCanvasAnimation];
            
            if (!amountHasBeenSaved) {
                self.pressAndHoldView.hidden = NO;
                self.pressAndHoldView.duration = kFadeLabelsTime;
                self.pressAndHoldView.type     = CSAnimationTypeFadeIn;
                [self.pressAndHoldView startCanvasAnimation];
                
                // Show suggestions
                self.suggestionView.hidden = NO;
                self.suggestionView.duration = kFadeLabelsTime;
                self.suggestionView.type     = CSAnimationTypeFadeIn;
                [self.suggestionView startCanvasAnimation];
                [self startSuggestionsTimer];
            } else {
                NSString *symbol = self.counterView.currencySymbol;
                NSString *justKept = [RDPStrings stringForID:sJustKept];
                NSString *amount = [symbol stringByAppendingString:[amountSaved stringValue]];
                self.amountKeptLabel.text = [justKept stringByAppendingString:amount];
                
                self.congratsLabel.text = self.congratulations.congratsMessage;
                [self.congratulations getNextCongratsMessage];
                
                self.congratsView.hidden = NO;
                
                self.congratsView.duration = kFadeLabelsTime;
                self.congratsView.type     = CSAnimationTypeFadeIn;
                [self.congratsView startCanvasAnimation];
            }
            
            [UIView animateWithDuration:kFadeImagesTime animations:^{
                
                self.blurredImageView.alpha = 1.0;
            }
                             completion:^(BOOL finished){
                                 if (amountHasBeenSaved) {
                                     [self createSavingEventForAmount:amountSaved];
                                     [self showCongratsMessage];
                                     
                                 } else {
                                     if (self.screenMode == OnSaveScreen) {
                                         self.pressAndHoldGestureRecognizer.enabled = YES;
                                     }
                                 }
                             }];
            
            [self.counterView stop];
            self.counterView.hidden = YES;
            // Reset the counter
            [self.counterView reset];
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default:
            break;
    }
}

- (void)showCongratsMessage
{
    void (^transitionBlock)(void) = ^{
        self.congratsView.duration = 1;
        self.congratsView.type     = CSAnimationTypeFadeOut;
        [self.congratsView startCanvasAnimation];
        
        [self transitionImagesWithSaveAmount];
    };
    
    [RDPTimerManager pauseFor:kShowCongratsDuration millisecondsThen:transitionBlock];
}

- (void)createSavingEventForAmount:(NSNumber *)amountSaved
{    
    RDPSavingEvent* savingEvent = [[RDPSavingEvent alloc] initWithAmount:amountSaved andReason:@"" andDate:[NSDate date] andLocation:@"" andID:nil];
    RDPUser* modifiedUser = [RDPUserService getUser];
    [[modifiedUser getGoal] addSavingEvent:savingEvent];
    double amountSavedDouble = [amountSaved doubleValue];
    double currentAmountDouble = [[[modifiedUser getGoal] getCurrentAmount] doubleValue];
    [[modifiedUser getGoal] setCurrentAmount:[NSNumber numberWithDouble:(amountSavedDouble + currentAmountDouble)]];
    [RDPUserService saveUser:modifiedUser withResponse:^(RDPResponseCode response) {
        NSLog(@"SavingEvent returned with response %i", response);
    }];
}

- (void)transitionImagesWithSaveAmount
{
    // Switch out the clear image that is behind the blurred image
    int nextIndex = (self.imageFetcher.indexOfImageArray + 1) % self.imageFetcher.numImages;
    self.clearImageView.image = self.imageFetcher.clearImagesArray[nextIndex];
    
    // Slowly transition to the next blurred image
    UIImage * toImage = self.imageFetcher.blurredImagesArray[nextIndex];
    [UIView transitionWithView:self.blurredImageView
                      duration:kImageTransitionTime
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.blurredImageView.image = toImage;
                    } completion:^(BOOL finished){
                        self.pressAndHoldView.hidden = NO;
                        self.pressAndHoldView.duration = kFadeLabelsTime;
                        self.pressAndHoldView.type     = CSAnimationTypeFadeIn;
                        [self.pressAndHoldView startCanvasAnimation];
                        
                        // Show suggestions
                        self.suggestionView.hidden = NO;
                        self.suggestionView.duration = kFadeLabelsTime;
                        self.suggestionView.type     = CSAnimationTypeFadeIn;
                        [self.suggestionView startCanvasAnimation];
                        [self startSuggestionsTimer];
                        
                        if (self.screenMode == OnSaveScreen) {
                            self.pressAndHoldGestureRecognizer.enabled = YES;
                        }
                    }];
    
    // Update the index for the images array
    self.imageFetcher.indexOfImageArray = nextIndex;
    
    // Get new images from the server
    [self.imageFetcher nextImage];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
