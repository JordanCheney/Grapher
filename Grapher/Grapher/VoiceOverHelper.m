//
//  VoiceOverLabel.m
//  Grapher
//
//  Created by Jordan Cheney on 4/3/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "VoiceOverHelper.h"
#import "ScatterPlotGraph.h"
#import "BarGraph.h"
#import "PieGraph.h"

#import "SoundBankPlayer.h"

@implementation VoiceOverHelper

- (id)initWithFrame:(CGRect)frame Data:(NSArray *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        _data = data;
        lastSelectedPointIndex = 0;
        _graphType = @"Scatter";
        _graphInfo = [self getGraphInfo];
        
        [self initAudio];
    }
    return self;
}

- (void)initAudio {
    //Init audio player
    _pianoPlayer = [[SoundBankPlayer alloc] init];
    [_pianoPlayer setSoundBank:@"Piano"];
    
    //Init speech player
    _synthesizer = [[AVSpeechSynthesizer alloc] init];
}

- (void)setDisplayGraph:(UIView *)graph
{
    _graph = graph;
    [(ScatterPlotGraph *)_graph selectPointAtIndex:lastSelectedPointIndex];
}

//Gets max and min of graph for use with frequency normalization, also could be nice to read to user as graph data
- (NSArray *)getGraphInfo
{
    NSNumber *max = nil;
    NSNumber *min = nil;
    for (NSArray *point in _data) {
        NSNumber *y = [point objectAtIndex:1];
        if (!max || y > max) { max = y; }
        else if (!min || y < min) { min = y; }
    }
    
    return [[NSArray alloc] initWithObjects:min, max, nil];
}

- (int)MIDINote:(CGFloat)frequency
{
    //MIDI note range is normalized between 56 and 89 (~200 Hz to ~1300 Hz)
    frequency = frequency*35 + 20;
    return floorf(frequency);
}

#pragma mark - Speech control

//convienience speach function that reads last selected point data. Is called from both VoiceOver and non VoiceOver gesture recognizer
- (void)speak
{
    NSInteger x = [[[_data objectAtIndex:lastSelectedPointIndex] objectAtIndex:0] integerValue];
    NSInteger y = [[[_data objectAtIndex:lastSelectedPointIndex] objectAtIndex:1] integerValue];
    
    NSString *speechString = [NSString stringWithFormat:@"%ld, %ld", (long)x, (long)y];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:speechString];
    
    [_synthesizer speakUtterance:utterance];
}


#pragma mark - Accessibility Functions

//Custom VoiceOver three finger scroll command to dismiss graph view and return to dropbox selector
- (BOOL)accessibilityScroll:(UIAccessibilityScrollDirection)direction
{
    if (direction == UIAccessibilityScrollDirectionRight) {
        NSLog(@"Should return to dropbox controller");
        return YES;
    }
    return NO;
}

//Custom VoiceOver MagicTap command. MagicTap is a two finger double tap anywhere on the screen with VoiceOver on
//Right now first MagicTap starts frequency emitter. Second MagicTap stops emitter and reads point coordinates
- (BOOL)accessibilityPerformMagicTap
{
    if (_synthesizer.speaking) {
        [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    
    [_pianoPlayer allNotesOff];
    [self speak];
    return YES;
}

//Custom VoiceOver one finger up swipe that selects the next point and sets the emitter frequency to that point
- (void)accessibilityIncrement
{
    if (lastSelectedPointIndex == [_data count] - 1) {
        lastSelectedPointIndex = [_data count] - 1;
    } else {
        lastSelectedPointIndex++;
    }
    
    [(ScatterPlotGraph *)_graph selectPointAtIndex:lastSelectedPointIndex];
    
    CGFloat frequency = [[[_data objectAtIndex:lastSelectedPointIndex] objectAtIndex:1] floatValue];
    CGFloat normFrequency = frequency/[[_graphInfo objectAtIndex:1] floatValue];
    [_pianoPlayer noteOn:[self MIDINote:normFrequency] gain:0.5f];
}

//Custom VoiceOver one finger down swipe that selects the previous point and sets the emitter frequency to that point
- (void)accessibilityDecrement
{
    if (lastSelectedPointIndex == 0) {
        lastSelectedPointIndex = 0;
    } else {
        lastSelectedPointIndex--;
    }
    
    [(ScatterPlotGraph *)_graph selectPointAtIndex:lastSelectedPointIndex];
    
    CGFloat frequency = [[[_data objectAtIndex:lastSelectedPointIndex] objectAtIndex:1] floatValue];
    CGFloat normFrequency = frequency/[[_graphInfo objectAtIndex:1] floatValue];
    [_pianoPlayer noteOn:[self MIDINote:normFrequency] gain:0.5f];
}

@end
