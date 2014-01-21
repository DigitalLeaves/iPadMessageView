//
//  MVViewController.m
//  iPadMessageView
//
//  Created by Nacho on 20/01/14.
//  Copyright (c) 2014 Ignacio Nieto Carvajal. All rights reserved.
//

#import "MVViewController.h"
#import "iPadMessageView.h"

@interface MVViewController ()

@property (weak, nonatomic) IBOutlet UIButton *questionButton;

@property (nonatomic, strong) iPadMessageView * messageView;

@end

@implementation MVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouched:(UIButton *)sender {
    NSString * title = @"Book tickets?";
    NSString * message = @"I was planning your holidays and noticed you haven't visited this forest yet. Would you like me to book some tickets for it now? It looks fantastic!";
    
    if (self.messageView) { [self.messageView removeFromSuperview]; self.messageView = nil; }
    
    self.messageView = [iPadMessageView iPadPromptViewWithMessage:message title:title andResponseBlock:^(iPadMessageViewResponse response) {
        if (response == iPadMessageViewResponseAccept) {
            [self.questionButton setTitle:@"tickets booked!" forState:UIControlStateNormal];
        } else if (response == iPadMessageViewResponseCancel) {
            [self.questionButton setTitle:@"Ok, maybe another time." forState:UIControlStateNormal];
        }
    }];

    [self.view addSubview:self.messageView];
}

@end
