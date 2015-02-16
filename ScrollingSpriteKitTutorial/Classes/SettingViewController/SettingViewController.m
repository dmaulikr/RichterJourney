//
//  SettingViewController.m
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 13/01/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import "SettingViewController.h"

@implementation SettingViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;

    isBtnOn = YES;
}

- (IBAction)audioBtnTapped:(id)sender {

    if (isBtnOn == YES) {

        isBtnOn = NO;
        [self.btnOnOff setImage:[UIImage imageNamed:@"offButton"] forState:UIControlStateNormal];
    } else {

        isBtnOn = YES;
        [self.btnOnOff setImage:[UIImage imageNamed:@"onButton"] forState:UIControlStateNormal];
    }
}

@end
