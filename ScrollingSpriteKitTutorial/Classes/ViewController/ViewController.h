//
//  ViewController.h
//  ScrollingSpriteKitTutorial
//

//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController : UIViewController {

    IBOutlet UIButton *btnCharacter;
    IBOutlet UIButton *btnSetting;
    IBOutlet UIButton *btnQuit;
    IBOutlet UIButton *btnPlay;
    IBOutlet UIImageView *imgVwBg;

    UIView *vwCharacter;
}

@end
