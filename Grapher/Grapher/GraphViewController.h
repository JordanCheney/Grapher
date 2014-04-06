//
//  GraphViewController.h
//  Grapher
//
//  Created by Jordan Cheney on 3/23/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToneEmitter;
@class AVSpeechSynthesizer;

@interface GraphViewController : UIViewController <UIGestureRecognizerDelegate>
{
    NSInteger lastSelectedPointIndex;
}

@property (strong, nonatomic) NSArray *data;
@property (retain, nonatomic) NSString *graphType;
@property (retain, nonatomic) NSArray *graphInfo;

- (id)initWithData:(NSArray *)data;

@end
