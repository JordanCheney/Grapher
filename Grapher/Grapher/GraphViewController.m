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

#import "ToneEmitter.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

- (id)initWithData:(NSArray *)data
{
    self = [super init];
    if (self){
        _data = data;
        _graphType = @"scatter";
        _graphInfo = [self getGraphInfo];
    }
    return self;
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
    
    //Init audio player
    _emitter = [[ToneEmitter alloc] initWithFrequency:200.0f];
    
    [self initGestureControl];
    [self.view addSubview:graph];
}

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

#pragma mark - Gesture behavior
- (void)initGestureControl
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    //[pan setMaximumNumberOfTouches:2];
    //[pan setMinimumNumberOfTouches:2];
    
    [self.view addGestureRecognizer:pan];
}

- (CGFloat)frequencyAtLocation:(CGPoint)point {
    if ([_graphType isEqualToString:@"scatter"]) {
        CGFloat center = self.view.bounds.size.width/2;
        CGFloat offset = point.x - center;
        CGFloat graphWidth = (self.view.bounds.size.width - 40)/1.1;
        
        CGFloat pointOffset = graphWidth/[_data count];
        CGFloat roughPointVal = offset/pointOffset;
        NSInteger pointVal = floorf(roughPointVal);

        pointVal = [_data count]/2 + pointVal;
        
        if (pointVal < 0) { pointVal = 0; }
        else if (pointVal > [_data count] - 1) { pointVal = [_data count] - 1; }
        
        return ((([[[_data objectAtIndex:pointVal] objectAtIndex:1] floatValue]/[[_graphInfo objectAtIndex:1] floatValue]) * 1300) + 200);
    }
    return 0.0f;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    //frequency currently normalized between 200 and 1500
    CGFloat frequency = [self frequencyAtLocation:[recognizer locationInView:self.view]];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [_emitter setFrequency:frequency];
        [_emitter play];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [_emitter stop];
    } else {
        [_emitter setFrequency:frequency];
    }
}

@end
