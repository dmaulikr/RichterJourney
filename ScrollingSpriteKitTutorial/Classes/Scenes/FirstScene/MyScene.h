//
//  MyScene.h
//  ScrollingSpriteKitTutorial
//

//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ScrollingBackground.h"
#import "RichterNode.h"
#import "BaseScene.h"
#import "GameOverScene.h"

@interface MyScene : BaseScene 

@property (nonatomic,strong) ScrollingBackground *scrollingBackground; // scrolling backgroung
@property (nonatomic, strong)RichterNode *hero;//hero of scene

//www.fixpicture.org/

#pragma mark - Essential and Change Restricted Function

/*
 This function is used to initialize scene with scrolling background, hero texture and obstacle.
 */
- (id)initWithSize:(CGSize)size;

/*
Called before each frame is rendered.
 */
- (void)update:(CFTimeInterval)currentTime;

#pragma mark - Hero's Action

/*
 Perform action on hero.
 */
- (void)initializeHeroTexture;
- (void)jumpDownFromUpOfHero;

#pragma mark - Changable

/*
 Fuction is override to apply swipping on scene.
 
 Changes:
 You can apply more changes according to requirement like swipe left or swipe right.
 */
- (void)didMoveToView:(SKView *)view;

/*
 Fuction is used to handle swipping on scene.

 Changes:
 Change functionlity on sweapping.
 */
- (void)handleSwipe:(UISwipeGestureRecognizer*)recognizer;

/*
 Fuction is used to add obstacle on scene.

 Changes:
 Change cordinate of obstacle
 */
- (void)addObstacleSprideNode;


/*
 Fuction is used to perform functionlity when node will be collides
 In this lost hero life when collide and again generate new hero.
 
 Changes:
 Changes functionlity when node collide with obstacle

 */
- (void)richer:(SKSpriteNode *)richer didCollideWithObstacle:(SKSpriteNode *)obstacle;

@end
