//
//  ScatterPlotGraph.h
//  Grapher
//
//  Created by Jordan Cheney on 3/23/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScatterPlotGraph : UIView <CPTPlotDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) CPTGraphHostingView *hostView;
@property (strong, nonatomic) UIView *circleView;
- (id)initWithFrame:(CGRect)aRect data:(NSArray *)data;

- (void)setGraphTitle:(NSString *)title;
- (void)setXAxisLabel:(NSString *)label;
- (void)setYAxisLabel:(NSString *)label;
- (void)selectPointAtIndex:(NSUInteger)index;

@end
