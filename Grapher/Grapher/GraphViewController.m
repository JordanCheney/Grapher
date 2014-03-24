//
//  GraphViewController.m
//  Grapher
//
//  Created by Jordan Cheney on 3/23/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import "GraphViewController.h"
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

- (void)viewWillAppear:(BOOL)animated
{
    NSNumber *min = nil;
    NSNumber *max = nil;
    NSMutableArray *xIntercepts = [[NSMutableArray alloc] init];
    NSMutableArray *yIntercepts = [[NSMutableArray alloc] init];
    
    for (NSArray *point in _data) {
        NSNumber *x = [point objectAtIndex:0];
        NSNumber *y = [point objectAtIndex:1];
        
        if (!min) { y = min; }
        else if (y < min) { y = min;}
        if (!max) { y = max; }
        else if (y > max) { y = max; }
        
        if (x == 0) { [yIntercepts addObject:point]; }
        if (y == 0) { [xIntercepts addObject:point]; }
    }
    
    _graphInfo = [[NSArray alloc] initWithObjects:min, max, xIntercepts, yIntercepts, nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIView *graph = nil;
    
    CGFloat width = self.view.bounds.size.width;
    CGRect graphBounds = CGRectMake(10, 40, width-20, width-20);
    
    if ([_graphType isEqualToString:@"scatter"]) {
        graph = [[ScatterPlotGraph alloc] initWithFrame:graphBounds data:_data];
    } else if ([_graphType isEqualToString:@"bar"]) {
        graph = [[BarGraph alloc] initWithFrame:graphBounds data:_data];
    } else if ([_graphType isEqualToString:@"pie"]) {
        graph = [[PieGraph alloc] initWithFrame:graphBounds data:_data];
    }
    
    NSString *inputSound  = [[NSBundle mainBundle] pathForResource:  @"song2" ofType: @"caf"];
	NSURL *inUrl = [NSURL fileURLWithPath:inputSound];
    
    NSError *error = nil;
	_mDiracAudioPlayer = [[DiracAudioPlayer alloc] initWithContentsOfURL:inUrl channels:1 error:&error];		// LE only supports 1 channel!
	[_mDiracAudioPlayer setDelegate:self];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerSwipe:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRight setNumberOfTouchesRequired:2];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeft setNumberOfTouchesRequired:2];
    
    [self.view addGestureRecognizer:swipeRight];
    [self.view addGestureRecognizer:swipeLeft];
    
    [self.view addSubview:graph];
}

- (void)diracPlayerDidFinishPlaying:(DiracAudioPlayerBase *)player successfully:(BOOL)flag
{
	NSLog(@"Dirac player instance (0x%lx) is done playing", (long)player);
}

- (void)handleTwoFingerSwipe:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"in swipe state");
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [_mDiracAudioPlayer stop];
    } else {
        CGPoint location = [recognizer locationInView:self.view];
        CGFloat xValue = location.x;
    
        CGFloat xStep = self.view.bounds.size.width-40/[_data count];
        CGFloat initX = 20;
    
        CGFloat xpoint = (xValue - initX)/xStep;
    
        if (xpoint < 0) { xpoint = 0; }
        else if (xpoint > [_data count]) { xpoint = [_data count]; }
        xpoint = floorf(xpoint);
    
        NSNumber *amplitude = [[_data objectAtIndex:xpoint] objectAtIndex:1];
        NSNumber *max = [_graphInfo objectAtIndex:1];
        [_mDiracAudioPlayer changePitch:powf(2.f, [amplitude intValue]/ [max floatValue])];
        [_mDiracAudioPlayer play];
    }
}

@end
