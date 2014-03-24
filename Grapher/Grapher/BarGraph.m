//
//  BarGraph.m
//  Grapher
//
//  Created by Jordan Cheney on 3/23/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import "BarGraph.h"

@implementation BarGraph

@synthesize hostView = _hostView;

- (id)initWithFrame:(CGRect)aRect data:(NSArray *)data
{
    self = [super initWithFrame:aRect];
    if (self) {
        _data = data;
        [self initPlot];
    }
    return self;
}

#pragma mark - Chart behavior
-(void)initPlot
{
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

- (void)configureHost
{
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.bounds];
    self.hostView.allowPinchScaling = YES;
    [self addSubview:self.hostView];
}

- (void)configureGraph
{
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = graph;
    
    // 2 - Set graph title
    NSString *title = @"Graph";
    graph.title = title;
    
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 20.0f);
    
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

- (void)configurePlots
{
    // 1 - Set up the three plots
    CPTBarPlot *plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];

    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.5;
    // 3 - Add plots to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    CGFloat barX = 10.0f;
    
    CGFloat barWidth = self.hostView.bounds.size.width/[_data count];
    
    plot.dataSource = self;
    plot.delegate = self;
    plot.barWidth = CPTDecimalFromDouble(barWidth);
    plot.barOffset = CPTDecimalFromDouble(barX);
    plot.lineStyle = barLineStyle;
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
    barX += barWidth;
}

- (void)configureAxes
{
    
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [_data count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if (fieldEnum == CPTBarPlotFieldBarTip) {
        return [[_data objectAtIndex:index] objectAtIndex:1];
    }
    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
}

@end
