//
//  VoiceOverLabel.h
//  Grapher
//
//  Created by Jordan Cheney on 4/3/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoundBankPlayer;
@class AVSpeechSynthesizer;

@interface VoiceOverHelper : UIButton
{
    NSInteger lastSelectedPointIndex;
}

@property (strong, nonatomic) NSArray *data;
@property (retain, nonatomic) NSString *graphType;
@property (retain, nonatomic) NSArray *graphInfo;
@property (retain, nonatomic) UIView *graph;

//Audio properties
@property (strong, nonatomic) SoundBankPlayer *pianoPlayer;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

- (id)initWithFrame:(CGRect)frame Data:(NSArray *)data;
- (void)setDisplayGraph:(UIView *)graph;
@end
