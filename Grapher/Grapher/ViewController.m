//
//  ViewController.m
//  Grapher
//
//  Created by Jordan Cheney on 3/20/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <DBChooser/DBChooser.h>

#import "ViewController.h"
#import "CHCSVParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *dropboxButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 50, 200, 100)];
    
    [dropboxButton setBackgroundColor:[UIColor blueColor]];
    [dropboxButton setTitle:@"Add Files With Dropbox" forState:UIControlStateNormal];
    [dropboxButton addTarget:self action:@selector(dropboxHandler:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:dropboxButton];
}

- (IBAction)dropboxHandler:(id)sender
{
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypePreview
                                    fromViewController:self completion:^(NSArray *results)
     {
         if ([results count]) {
             if ([[[results objectAtIndex:0] name] hasSuffix:@".csv"]) {
                 _data = [NSArray arrayWithContentsOfCSVFile:[[[results objectAtIndex:0] link] absoluteString]];
                 NSLog(@"data:%@", _data);
             }
         } else {
             // User canceled the action
         }
     }];
}
@end
