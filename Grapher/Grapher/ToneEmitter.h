//
//  ToneEmitter.h
//  Grapher
//
//  Created by Jordan Cheney on 3/25/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioUnit/AudioUnit.h>

@interface ToneEmitter : NSObject
{
    AudioComponentInstance toneUnit;
    
@public
	double frequency;
	double sampleRate;
	double theta;
}

- (id)initWithFrequency:(CGFloat)hertz;
- (void)setFrequency:(CGFloat)hertz;
- (void)play;
- (void)stop;

@end
