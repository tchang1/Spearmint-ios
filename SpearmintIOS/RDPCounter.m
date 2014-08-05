//
//  RDPCounterView.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 7/24/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPCounter.h"
#import "RDPTimerManager.h"
#include <math.h>

#define kDefaultPadding             0
#define kDefaultLineWidth           5
#define kDefaultIncrementAmount     1
#define kDefaultRevsPerSec          1

#define kDefaultWidth               200
#define kDefaultHeight              200

#define kTrueMaxValue               99
#define kDefaultFontName            @"Helvetica-Light"
#define kDefaultCurrencySymbol      @"$"

#define kDefaultFontSize            32
#define kCurrencySymbolFontScale    0.3
#define kTextOffsetX                0
#define kTextOffsetY                8
#define kNumberOffsetX              6
#define kNumberOffsetY              -8

#define kCounterUpdateBlockName     @"counterUpdateBlock"


@interface RDPCounter()

@property CGRect frame;
@property (nonatomic, readonly) UIColor* currentColor;
@property (nonatomic, readonly) UIColor* previousColor;
@property (nonatomic) NSInteger currentColorIndex;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIFont* currencySymbolFont;
@property (nonatomic) double startAngle;
@property (nonatomic) double endAngle;
@property (nonatomic) double progress;
@property (nonatomic) double radius;
@property (nonatomic, assign) BOOL hidden;

@end


@implementation RDPCounter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(300.0f,300.0f,kDefaultWidth, kDefaultHeight)];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setDefaultParameters];
}

// Sets all the default parameters
- (void)setDefaultParameters
{
    self.colors = @[kColor_Green, kColor_Blue];
    self.startAngle = M_PI * 1.5;
    self.lineWidth = kDefaultLineWidth;
    self.padding = kDefaultPadding;
    self.incrementAmount = kDefaultIncrementAmount;
    self.backgroundColor = [UIColor redColor];
    self.rotationsPerSecond = kDefaultRevsPerSec;
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont fontWithName:kDefaultFontName size:kDefaultFontSize];
    self.currencySymbolFont = [UIFont fontWithName:kDefaultFontName size:kDefaultFontSize * kCurrencySymbolFontScale];
    self.currencySymbol = kDefaultCurrencySymbol;
    [self setOpaque:NO];
    self.hidden = NO;
    self.maxValue = kTrueMaxValue;
    self.currencyValue = [NSNumber numberWithDouble:0];
    [self calculateSize];
}

- (void)setFontName:(NSString *)fontName
{
    _fontName = fontName;
    self.font = [UIFont fontWithName:_fontName size:self.fontSize];
    self.currencySymbolFont = [UIFont fontWithName:_fontName size:self.fontSize * kCurrencySymbolFontScale];
}

- (void)setFontSize:(NSInteger)fontSize
{
    if (fontSize > 0) {
        _fontSize = fontSize;
        self.font = [UIFont fontWithName:self.fontName size:_fontSize];
        self.currencySymbolFont = [UIFont fontWithName:self.fontName size:_fontSize * kCurrencySymbolFontScale];
    }
}

- (void)setMaxValue:(double)maxValue
{
    if (maxValue < 1) {
        maxValue = 1;
    }
    else if (maxValue > kTrueMaxValue) {
        maxValue = kTrueMaxValue;
    }
    _maxValue = maxValue;
}

- (UIColor*)currentColor
{
    return [self.colors objectAtIndex:self.currentColorIndex];
}

- (UIColor*)previousColor
{
    NSInteger index = 0;
    if (self.currentColorIndex == 0)
    {
        index = [self.colors count] - 1;
    }
    else {
        index = self.currentColorIndex - 1;
    }
    return [self.colors objectAtIndex:index];
}

- (void)calculateSize
{
    self.radius = (self.frame.size.height / 2) - self.padding - (self.lineWidth/2);
}

- (void)setPadding:(double)padding
{
    _padding = padding;
    [self calculateSize];
}

- (void)start
{
    [RDPTimerManager registerUpdateBlock:^(NSInteger milliseconds){
        [self update:milliseconds];
    }
                                withName:kCounterUpdateBlockName];
}

- (void)stop
{
    [RDPTimerManager clearUpdateBlockWithName:kCounterUpdateBlockName];
}

- (void)hide
{
    self.hidden = YES;
    [self setNeedsDisplay];
}

- (void)show
{
    self.hidden = NO;
    [self setNeedsDisplay];
}

- (void)reset
{
    self.currencyValue = [NSNumber numberWithDouble:0];
    self.progress = 0;
    [self setNeedsDisplay];
}

- (void)update:(NSInteger)milliseconds
{
    self.progress += (self.rotationsPerSecond / 1000) * milliseconds;
    double value = [self.currencyValue doubleValue];
    
    if (self.progress >= 1) {
        if (value < self.maxValue) {
            
            value += self.incrementAmount;
            self.currencyValue = [NSNumber numberWithDouble:value];
            
            self.progress = 0.000001;
            
            self.currentColorIndex += 1;
            if (self.currentColorIndex >= [self.colors count]) {
                self.currentColorIndex = 0;
            }
            
        
        }
        else {
            self.progress = 1;
        }
    }
    
    if (self.progress < 0) {
        if (value > 0) {
            value -= self.incrementAmount;
            self.currencyValue = [NSNumber numberWithDouble:value];
            self.progress = 0.9999999;
            
            self.currentColorIndex -= 1;
            if (self.currentColorIndex < 0) {
                self.currentColorIndex = [self.colors count] -1;
            }
            
        }
        else {
            self.progress = 0;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    if (!self.hidden) {
        double endAngle = ((M_PI * 2) * self.progress) + self.startAngle;
        
        // Draws a filled in circle with the background color.
        CGContextSaveGState(context);
        CGColorRef aColorRef = CGColorRetain([kColor_CounterBackgroundColor CGColor] );
        CGContextSetFillColorWithColor(context, aColorRef);
        CGMutablePathRef path = CGPathCreateMutable();
        CGContextSetLineWidth(context, self.lineWidth);
        
        CGPathAddArc(path, NULL, self.frame.size.width/2, self.frame.size.height/2, self.radius + self.lineWidth/2, self.startAngle, self.startAngle - 0.0001, 0);
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        CGPathRelease(path);
        CGContextRestoreGState(context);
        
        // Only draw the previous circle if there was at least one revolution.
        if ([self.currencyValue doubleValue] >= self.incrementAmount) {
            // Only draw the part of the circle that would not be drawn by the main arc. Drawing a full cicle under the main arc will look bad
            // with transparent colors.
            [self drawArcInContext:context withStartAngle:endAngle andEndAngle:self.startAngle withColor:self.previousColor.CGColor];
        }
        // Draw main arc
        [self drawArcInContext:context withStartAngle:self.startAngle andEndAngle:endAngle withColor:self.currentColor.CGColor];
        // Draws the text e.g. "$12"
        [self drawText];
    }
}

// Draws an arc with the specified start angle, end angle, and color.
- (void)drawArcInContext:(CGContextRef)context withStartAngle:(double)start andEndAngle:(double)end withColor:(CGColorRef)color
{
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, color);
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, self.lineWidth);
    
    CGPathAddArc(path, NULL, self.frame.size.width/2, self.frame.size.height/2, self.radius, start, end, 0);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    CGContextRestoreGState(context);
}

// Draws the currency value inside the circle.
- (void)drawText
{
    // Get the size that the text will take on the screen in order to automatically center it.
    CGSize numberSize = [[self.currencyValue description] sizeWithAttributes:
                         @{NSFontAttributeName: self.font}];
    CGSize symbolSize = [self.currencySymbol sizeWithAttributes:
                         @{NSFontAttributeName: self.currencySymbolFont}];
    NSInteger currencySymbolXPos = self.frame.size.width / 2 - ((numberSize.width + symbolSize.width + kNumberOffsetX) / 2) + kTextOffsetX;
    NSInteger currencySymbolYPos = self.frame.size.height / 2 - (numberSize.height / 2) + kTextOffsetY;
    
    NSInteger numberXPos = currencySymbolXPos + kNumberOffsetX;
    NSInteger numberYPos = currencySymbolYPos + kNumberOffsetY;
    
    // Draws currency symbol
    [self.currencySymbol drawAtPoint:CGPointMake(currencySymbolXPos, currencySymbolYPos)
                      withAttributes:@{NSFontAttributeName: self.currencySymbolFont,
                                       NSForegroundColorAttributeName: kColor_CounterText}];
    // Draws currency value
    [[self.currencyValue description] drawAtPoint:CGPointMake(numberXPos, numberYPos)
                                   withAttributes:@{NSFontAttributeName: self.font,
                                                    NSForegroundColorAttributeName: kColor_CounterText}];
}

@end
