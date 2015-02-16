//
//  SettingViewController.h
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 13/01/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController {

    BOOL isBtnOn;
}

@property (nonatomic, strong) IBOutlet UIButton *btnOnOff;

@end
