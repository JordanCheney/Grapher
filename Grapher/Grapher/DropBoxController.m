//
//  DropBoxController.m
//  Grapher
//
//  Created by Jordan Cheney on 3/24/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <DBChooser/DBChooser.h>

#import "DropBoxController.h"
#import "GraphViewController.h"
#import "CHCSVParser.h"

@interface DropBoxController ()

@end

@implementation DropBoxController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *dropboxButton = [[UIButton alloc] init];
    
    [dropboxButton setBounds:CGRectMake(0, 0, 200, 75)];
    [dropboxButton setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    UIImage *dropboxImg = [UIImage imageNamed:@"dropboxImage.png"];
    [dropboxButton setBackgroundImage:dropboxImg forState:UIControlStateNormal];
    
    [dropboxButton addTarget:self action:@selector(dropboxHandler:) forControlEvents:UIControlEventTouchDown];
    
    [dropboxButton setAccessibilityHint:@"Selects a file to add via dropbox"];
    
    [self.view addSubview:dropboxButton];
}

- (IBAction)dropboxHandler:(id)sender
{
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypeDirect
                                    fromViewController:self completion:^(NSArray *results)
     {
         if ([results count]) {
             if ([[[results objectAtIndex:0] name] hasSuffix:@".csv"]) {
                 NSError *error;
                 NSString *string = [NSString stringWithContentsOfURL:[[results objectAtIndex:0] link] encoding:NSUTF8StringEncoding error:&error];
                 
                 NSArray *data = [string CSVComponents];
                 
                 GraphViewController *graph = [[GraphViewController alloc] initWithData:data];
                 graph.accessibilityTraits = UIAccessibilityTraitAdjustable | UIAccessibilityTraitAllowsDirectInteraction;
                 [self presentViewController:graph animated:YES completion:nil];
             }
         } else {
             // User canceled the action
         }
     }];
}

//The dropbox app is available on the iOS simulator so this will let us test our graphing for the time being
- (IBAction)fakeDropboxHandler:(id)sender
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"TestParabola" ofType:@"csv"];
    NSArray *data = [NSArray arrayWithContentsOfCSVFile:file];
    GraphViewController *graph = [[GraphViewController alloc] initWithData:data];
    [self presentViewController:graph animated:YES completion:nil];
}
@end
