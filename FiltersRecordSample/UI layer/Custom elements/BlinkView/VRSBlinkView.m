//
//  VRSBlinkView.m
//  Diddeo
//
//  Created by Ruslan Shevtsov on 9/19/13.
//  Copyright (c) 2013 Work. All rights reserved.
//

#import "VRSBlinkView.h"

// Definitions
#import "VRSBlinkViewDefinitions.h"

@interface VRSBlinkView () {}

@property (nonatomic, assign) BOOL blinkAnimating;
@property (nonatomic, assign) BOOL animationInProcess;

@end

@implementation VRSBlinkView {}

#pragma mark -
#pragma mark Initialize

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.alpha = 0.0f;
        _blinkAnimating = NO;
        _animationInProcess = NO;
    }
    return self;
}

#pragma mark -
#pragma mark Blink animation

- (void)startBlinkAnimation {
    if (self.blinkAnimating == YES) {
        return;
    }
    self.blinkAnimating = YES;
    if (self.animationInProcess == NO) {
        [self blinkAnimation];
    }
}

- (void)stopBlinkAnimation {
    self.blinkAnimating = NO;
    self.alpha = 0.0f;
}

#pragma mark -
#pragma mark @private

- (void)blinkAnimation {
    if (self.blinkAnimating == NO) {
        self.alpha = 0.0f;
    } else {
        self.alpha = !self.alpha;
    }
    if (self.blinkAnimating == YES) {
        self.animationInProcess = YES;
        double delayInSeconds = kBVAnimationDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (self.blinkAnimating == YES) {
                [self blinkAnimation];
            } else {
                self.animationInProcess = NO;
            }
        });
    }
}

@end
