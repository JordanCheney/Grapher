//
//  GraphViewController.h
//  Grapher
//
//  Created by Jordan Cheney on 3/23/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController <CPTPlotDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) CPTGraphHostingView *hostView;

- (id)initWithData:(NSArray *)data;

@end
