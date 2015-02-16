//
//  GameOverScene.h
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol GameOverDelegate <NSObject>

- (void)gotoOtherSceneAfterWon;

@end

@interface GameOverScene : SKScene <UIGestureRecognizerDelegate, SKSceneDelegate> {

    BOOL isWon;
    SKScene *sceneName;
    UITapGestureRecognizer *recognizerTapGesture;
}

@property (unsafe_unretained)id <GameOverDelegate>gameOverdelegate;

- (id)initWithSize:(CGSize)size won:(BOOL)won withCurrentScene:(SKScene *)scene;
 
@end
