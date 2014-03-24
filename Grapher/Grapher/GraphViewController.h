//
//  GraphViewController.h
//  Grapher
//
//  Created by Jordan Cheney on 3/23/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiracAudioPlayer.h"

@interface GraphViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *data;
@property (retain, nonatomic) NSString *graphType;
@property (strong, nonatomic) NSArray *graphInfo;
@property (strong, nonatomic) DiracAudioPlayer *mDiracAudioPlayer;

- (id)initWithData:(NSArray *)data;

@end
