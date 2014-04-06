//
//  GraphViewController.m
//  Grapher
//
//  Created by Jordan Cheney on 3/23/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "GraphViewController.h"
#import "VoiceOverHelper.h"
#import "ScatterPlotGraph.h"
#import "BarGraph.h"
#import "PieGraph.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

- (id)initWithData:(NSArray *)data
{
    self = [super init];
    if (self){
        _data = data;
        _graphType = @"scatter";
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIView *graph = nil;
    
    //Create a visual graph within the larger graph controller, this currently does not adjust for different device orientations
    //and needs to be fixed
    CGFloat width = self.view.bounds.size.width;
    CGRect graphBounds = CGRectMake(10, 40, width-20, width-20);
    
    //Create a graph based on the graph type. Currently the default is scatter
    if ([_graphType isEqualToString:@"scatter"]) {
        graph = [[ScatterPlotGraph alloc] initWithFrame:graphBounds data:_data];
    } else if ([_graphType isEqualToString:@"bar"]) {
        graph = [[BarGraph alloc] initWithFrame:graphBounds data:_data];
    } else if ([_graphType isEqualToString:@"pie"]) {
        graph = [[PieGraph alloc] initWithFrame:graphBounds data:_data];
    }
    
    //Add the graph subview to the ViewController
    [graph setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:graph];
    
    BOOL voiceOver = UIAccessibilityIsVoiceOverRunning();
    if (voiceOver) {
        VoiceOverHelper *vHelper = [[VoiceOverHelper alloc] initWithFrame:self.view.bounds Data:_data];
        vHelper.accessibilityTraits = vHelper.accessibilityTraits | UIAccessibilityTraitAdjustable | UIAccessibilityTraitPlaysSound;
        [vHelper setAccessibilityHint:@"Graph"];
        [vHelper setDisplayGraph:graph];
        [self.view addSubview:vHelper];
    }
    else {
        [self initGestureControl];
    }
}

#pragma mark - Gesture behavior
//Non VoiceOver gesture initilization
- (void)initGestureControl
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipe setNumberOfTouchesRequired:3];
    [swipe setDirection:(UISwipeGestureRecognizerDirectionLeft || UISwipeGestureRecognizerDirectionRight)];
    
    [self.view addGestureRecognizer:swipe];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
    }
}

@end
