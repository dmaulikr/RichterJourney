//
//  ThirdScene.m
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 23/01/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import "ThirdScene.h"
#import "BaseAction.h"
#import "Coin.h"
#import "Obstacle.h"
#import "MonsterCollection.h"
#import "Monster.h"
#import "Dragon.h"
#import "BatMan.h"
#import <AVFoundation/AVFoundation.h>

#import "GameOverScene.h"
#import "sprites.h"
#import "GRModelOfLifeScore.h"

#define heroYAxisThirdVw ((IS_IPHONE_6P) ? 90 : 65)
#define heroXAxis 100

@interface ThirdScene () {

    BOOL isMonsterOrObstacle;
    BOOL isCoinShow;
    BOOL isPauseGame;
    BOOL isSplPower;
    BOOL isRichterFlying;
    BOOL isRichterWolf;
    BOOL isJumpUp;
    BOOL isIntersectFireArea;

    Obstacle *obstacle;
    Dragon *dragon;
    CGPoint touchLocation;

    int monsterCount;
    int obstacleCount;
    int coinCount;
    int powerCount;
    int gunStart;
    int batCount;
    int yAxisOfRichtrPower;

    SKSpriteNode *play;
    SKSpriteNode *powerGun;

    AVAudioPlayer * backgroundMusicPlayer;
}

@end

@implementation ThirdScene

#pragma mark - View life cycle

- (id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {

        NSString *imageName;
        if (IS_IPHONE_6P) {
            imageName = @"desert_iPhone6";
        } else {
            imageName = @"desert";
        }
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.scrollingBackground = [ScrollingBackground scrollingNodeWithImageNamed:imageName inContainerWidth:size.width withSpeed:8.0];
        self.scrollingBackground.delegate = self;
        [self addChild:self.scrollingBackground];

        [self initializeHeroTextureInThirdScene];
            //  [self powerBtnTapped:CGPointMake(heroXAxis, heroYAxis-30) withTextures:SPRITE_FIRE_POWER withPowerNumber:0];

        [self addGunIcon];
        [self repeatObstacleOntheWay];
        [self addPauseBtn];
        [self playBackgroundMusic];
        yAxisOfRichtrPower = 0;
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {

    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        recognizer.enabled = NO;
        [self.view removeGestureRecognizer:recognizer];
    }

    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnView:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:recognizer];

    UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnView:)];
    recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizerDown];

    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnView:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];

    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnView:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}

#pragma mark - Updation of scroll view

- (void)update:(CFTimeInterval)currentTime {

    if(isPauseGame == NO){
        [self.scrollingBackground update:currentTime];
    }
}

- (void)dealloc {

    [self.scrollingBackground removeFromParent];
    self.scrollingBackground = nil;

    [obstacle removeFromParent];
    obstacle = nil;

    [backgroundMusicPlayer pause];
    backgroundMusicPlayer = nil;
}

#pragma mark - Initialization of hero

- (void)initializeHeroTextureInThirdScene {

        //isPauseGame = YES;
    obstacle.paused = NO;
    self.view.userInteractionEnabled = YES;

    if (self.hero != nil) {
        [self.hero removeFromParent];
        self.hero = nil;
    }
    self.hero = [[RichterNode alloc]initWithPosition:CGPointMake(heroXAxis, heroYAxisThirdVw-30) withBackgroungTexture:nil];
    [self addChild:self.hero];
    self.hero.zPosition = 1.0;
    self.hero.speed = 2.0;  
    isPauseGame = NO;

    NSLog(@"!!!! %f %f",self.hero.position.x, self.hero.position.y);
    self.hero.physicsBody.dynamic = NO;
    self.hero.alpha = 0.5;

    [UIView animateWithDuration:4.0 animations:^{
        [self.hero runAction:[SKAction fadeInWithDuration:4.0]];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(setDyanamisBodyOfRichter) withObject:nil afterDelay:0.7];
    }];
}

- (void)setDyanamisBodyOfRichter {
    self.hero.physicsBody.dynamic = YES;
}

#pragma mark - Changable Function

#pragma mark - Handle swipe on view

- (void)handleSwipeOnView:(UISwipeGestureRecognizer*)recognizer {

    if (isIntersectFireArea == YES) {
        isIntersectFireArea = NO;
        return;
    }

    if(self.hero == nil) {
        return;
    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {

        if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
                // [self.hero runAction:[BaseAction jumpDownOfNode]];
            [self.hero turnLeftOfRichterWithLocation:self.hero.position];

        }

        if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
            
            if (isRichterFlying == NO && isPauseGame == NO) {

                isJumpUp = YES;
                self.view.userInteractionEnabled = NO;
                [self.hero richterRemoveRunAction];

                if(isRichterWolf == YES) {

                    [self.hero runAction: [BaseAction jumpUpOfRichterWolf:CGPointMake(heroXAxis, heroYAxisThirdVw-30) withTexture:@[[SKTexture textureWithImageNamed: RICHTER_WOLF_JUMP]] Duration:1.0]];
                    isRichterWolf = NO;
                    return;
                }

                if (isSplPower == YES) {
                    [self.hero jumpUpOfRichter:self.hero.position withUpTexture:SPRITES_ANIM_JUMP_UP_WITH_FIRE textureDown:SPRITES_ANIM_JUMP_DOWN_WITH_FIRE Duration:1.0];
                } else {
                    [self.hero jumpUpOfRichter:self.hero.position withUpTexture:SPRITES_ANIM_JUMP_UP textureDown:SPRITES_ANIM_JUMP_UP_DOWN Duration:1.0];
                }
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(jumpDownFromUpOfHeroInView) userInfo:nil repeats:NO];
            }
        } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            [self.hero turnRightOfRichterWithLocation:self.hero.position];
        } else {
                // [self.hero runAction:[BaseAction turnLeft:self.hero.position]];
        }
    }
}

#pragma mark - Hero's Action

//jump down
- (void)jumpDownFromUpOfHeroInView {

    isJumpUp = NO;

    if (isPauseGame == YES) {

        [self performSelector:@selector(enableUserInterface) withObject:nil afterDelay:0.9];
        [self.hero richterDiedAtLocation:self.hero.position  withTexture:[SKTexture textureWithImageNamed:RICHTER_DIE]];
        return;
    }

    [self enableUserInterface];
    [self.hero richterWalkAction];
}

- (void)enableUserInterface {

    self.view.userInteractionEnabled = YES;
}

#pragma mark - Delegates of scroll view

- (void)scrollBackgroundVwDone {

}

#pragma mark - Repetation  of obstacle and monster

- (void)repeatObstacleOntheWay {

    if (isCoinShow == NO) {

        if (isMonsterOrObstacle == YES ) {
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(addObstacleSprideNodeinDesert) userInfo:nil repeats:NO];
             } else {
                 [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(addMonsterOnDesertView) userInfo:nil repeats:NO];
                 isCoinShow = YES;
             }
    } else {

        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addCoinsOnView) userInfo:nil repeats:NO];
    }
}

#pragma mark - Add Coins

- (void)addCoinsOnView {

    if (isPauseGame == YES)  {
        [self repeatObstacleOntheWay];
        return;
    }

    Coin *coin = [[Coin alloc]initWithPosition:CGPointMake(self.size.width, heroYAxisThirdVw+90) withBackgroungTexture:nil];
    [self addChild:coin];

    coinCount ++;
    if (coinCount == 5) {

        isCoinShow = NO;
        coinCount = 0;//5;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addCoinsOnView) userInfo:nil repeats:NO];
        return;
    }
    [self repeatObstacleOntheWay];
}

#pragma mark - Add obstacle

- (void)addObstacleSprideNodeinDesert {

    if (isPauseGame == YES)  {

        [self repeatObstacleOntheWay];
        return;
    }

    NSString *strImgName;
    CGFloat speed = 1.00*2;//1.25;//
    CGFloat scale = 1.0;

    CGPoint point = CGPointMake(self.size.width, heroYAxisThirdVw-7);

    if (obstacle != nil) {
        obstacle = nil;
    }

   obstacleCount = obstacleCount + 1;
    if (obstacleCount == 1) {

        scale = 2.0;
        speed = 1.15*2;// 1.5;//
        strImgName = OBSTACLE_CACTUS;
        point = CGPointMake(self.size.width, heroYAxisThirdVw+8);

    } else if (obstacleCount == 2) {

        strImgName = OBSTACLE_STATUE;
    } else if (obstacleCount == 3) {
    
        speed = 1.03*2;//1.306;//
        strImgName = OBSTACLE_BARRIER;

    } else if (obstacleCount == 4) {

        speed = 1.12*2; //1.48;//
        strImgName = OBSTACLE_TREEBARIER;
        point = CGPointMake(self.size.width, heroYAxisThirdVw);
     
    } else {

        speed =  1.02*2;//1.378;//
        point = CGPointMake(self.size.width, heroYAxisThirdVw-10);
        strImgName =  OBSTACLE_DESERT_STONE;
        obstacleCount = 0;
    }

//    speed =  1.378*2;//1.378;//
//    point = CGPointMake(self.size.width, heroYAxis-10);
//    strImgName =  OBSTACLE_DESERT_CHASM;
//    obstacleCount = 0;

    obstacle = [[Obstacle alloc]initWithPosition:point withBackgroungTexture:[SKTexture textureWithImageNamed:strImgName]];
    obstacle.speed = speed;
    [obstacle runAction:[SKAction scaleXTo:scale y:scale duration:0.0]];
    [self addChild:obstacle];

    isCoinShow = YES;
    isMonsterOrObstacle = NO;

    if (obstacleCount == 4) {
        [self performSelector:@selector(obstacleTextureChange) withObject:nil afterDelay:0.6];
    }
    [self repeatObstacleOntheWay];
}

//Dynamic obstacle
- (void)obstacleTextureChange {

    int xAxis = obstacle.position.x;

    if (obstacle != nil) {

        [obstacle removeFromParent];
        obstacle = nil;
    }

    obstacle = [[Obstacle alloc]initWithPosition:CGPointMake(xAxis-5, heroYAxisThirdVw-27) withBackgroungTexture:[SKTexture textureWithImageNamed:OBSTACLE_TREEBARIER1]];

    obstacle.speed = 2.0;
    obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30, 100)];
    obstacle.physicsBody.dynamic = NO;
    [obstacle runAction:[SKAction scaleXTo:2.0 y:1 duration:0.0]];
    [self addChild:obstacle];
}


#pragma mark - Add power for richter

- (void)addPowersOnView {

    powerCount = powerCount + 1;

    if (powerCount == 1) {
        [self addSpecialPowersWithImgName:POWER_FIRE withPowerName:@"fire" withYAxis:90]; //fire power
    } else if (powerCount == 2) {
        [self addSpecialPowersWithImgName:POWER_BATS withPowerName:@"bats_fighter" withYAxis:20]; //fire power
    } else if (powerCount == 3) {
        [self addSpecialPowersWithImgName:POWER_STROME_WING withPowerName:@"strome_wing" withYAxis:130]; //fire power
    } else if (powerCount == 4) {
        [self addSpecialPowersWithImgName:POWER_BATS withPowerName:@"bats_fighter" withYAxis:120]; //fire power
    } else if (powerCount == 5 || powerCount == 6) {
        [self addSpecialPowersWithImgName:POWER_DRAGON withPowerName:@"dragon_fighter" withYAxis:120]; //fire power
    }
}

#pragma mark - Add monster and dragons

- (void)addMonsterOnDesertView {

  if (isPauseGame == YES)  {
        [self repeatObstacleOntheWay];
        return;
    }

    NSString *strImgName;
    NSArray *arryMonster;
    CGFloat speed;
    CGFloat scale;
        // NSTimeInterval timeInterval = 0.2;

    CGPoint point = CGPointMake(self.size.width, heroYAxisThirdVw);
    if (obstacle != nil) {

        [obstacle removeFromParent];
        obstacle = nil;
    }
    monsterCount = monsterCount + 1;

    if (monsterCount < 3) {

        if (monsterCount == 1) {

            strImgName = MONSTER_MUDATTACK_ATTACKE;
            arryMonster = SPRITE_MONSTER_MUDGOLEM_ATTACK;
            speed = 3.8;
            scale = 1.0;
        } else if (monsterCount == 2) {

            strImgName = MONSTER_BONES_ATTACKE;
                //point = CGPointMake(self.size.width, heroYAxis);
            arryMonster = SPRITE_MONSTER_BONES_ATTACK;
            speed = 3.8;
            scale = 0.7;
            [powerGun removeFromParent];
            gunStart = 1;
            [self performSelector:@selector(addPowersOnView) withObject:nil afterDelay:4.5];//add power
        }

        Monster *monster = [[Monster alloc]initWithPosition:point withBackgroungTexture:[SKTexture textureWithImageNamed:strImgName]];
        [monster runAction:[SKAction scaleXTo:scale y:scale duration:0.0]];
        [self addChild:monster];

        [monster runningTextureOfMonsterWithLocation:point withTextures:arryMonster];
        monster.speed = speed;
        isMonsterOrObstacle = YES;
        [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
        return;
    }

  [self addDragens];
}

//add dragon
- (void)addDragens {

    NSString *strImgName;
    NSTimeInterval timeInterval = 0.2;

    NSArray *arryMonster;
    CGFloat speed;
    CGFloat scale;
    CGPoint point;

    if (monsterCount == 3) {

        strImgName = MONSTER_MUMMIE_ATTACK;
        arryMonster = SPRITE_MONSTER_MOMMIE_ATTACK;
        speed = 7.5;
        scale = 0.9;
        point = CGPointMake(self.size.width, heroYAxisThirdVw+36);
        timeInterval = 0.38;
       [self performSelector:@selector(addPowersOnView) withObject:nil afterDelay:4.5];//add power
    } else if (monsterCount == 4) {

        batCount = 0;
        [self addBatsOnView];
        isMonsterOrObstacle = YES;

        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
        [self performSelector:@selector(addPowersOnView) withObject:nil afterDelay:4.5];//add power

        return;
    } else if (monsterCount == 5) {

        strImgName = STROME;
        arryMonster = SPRITE_STROME_ANIMATION;
        speed = 7;
        scale = 3.5;
        point = CGPointMake(self.size.width, heroYAxisThirdVw+20);
        timeInterval = 0.38;

        [self performSelector:@selector(addPowersOnView) withObject:nil afterDelay:4.5];//add power

    } else if (monsterCount == 6) {

        batCount = 0;
        [self addBatsOnView];
        isMonsterOrObstacle = YES;
            //[self addPowerOfDragon];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
        [self performSelector:@selector(addPowersOnView) withObject:nil afterDelay:4.5];//add power

        return;
    } else if (monsterCount == 7) {

        strImgName = MONSTER_DESERT_DYNASORE;
        arryMonster = SPRITE_MONSTER_DESERT_DYNASAR_ATTACK;

        speed = 3.5;
        scale = 1.0;
        point = CGPointMake(self.size.width, heroYAxisThirdVw+35);
        [self performSelector:@selector(addPowersOnView) withObject:nil afterDelay:4.5];//add power

//    } else if ( monsterCount == 8) {
//
//    [self addMonsterBehindRichter];
//    isMonsterOrObstacle = YES;
//
//    [NSTimer scheduledTimerWithTimeInterval:9.0 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
//    [self performSelector:@selector(addPowersOnView) withObject:nil afterDelay:5.5];//add power
//
//    return;
   } else {

        strImgName = MONSTER_FLYING_DRAGON;
        arryMonster = SPRITE_MONSTER_DRAGON_FLYING;

        speed = 4.0;
        scale = 0.9;
        point = CGPointMake(self.size.width, heroYAxisThirdVw+45);
        monsterCount = 0;
    }

    dragon = [[Dragon alloc]initWithPosition:point withBackgroungTexture:[SKTexture textureWithImageNamed:strImgName]];
    dragon.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:dragon.size];
    dragon.physicsBody.dynamic = YES;
    dragon.physicsBody.collisionBitMask = 0.0;

    [dragon runAction:[SKAction scaleXTo:scale y:scale duration:0.0]];
    [self addChild:dragon];
    NSLog(@"** %f", dragon.size.height);

    [dragon runningTextureOfDragonWithLocation:point withTextures:arryMonster withInterval:timeInterval];
    dragon.speed = speed;
    isMonsterOrObstacle = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
}

#pragma mark - Add negative point

- (void)addNegativeCoins {

    SKSpriteNode *negativepower = [[SKSpriteNode alloc]initWithImageNamed:POWER_WOLF];
    negativepower.name = @"powerForWolf";
    negativepower.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:negativepower.size];
    negativepower.physicsBody.dynamic = NO;
    negativepower.position = CGPointMake(self.size.width,heroYAxisThirdVw);
    [self addChild:negativepower];

    SKAction *actionFire = [SKAction moveToX:0 duration:2.3];
    SKAction *remove = [SKAction removeFromParent];
    [negativepower runAction:[SKAction sequence:@[actionFire,remove]]];
}

#pragma mark - Add special power
- (void)addSpecialPowersWithImgName:(NSString *)strname withPowerName:(NSString *)powerName withYAxis:(CGFloat)yAxis {

    SKSpriteNode *power = [[SKSpriteNode alloc]initWithImageNamed:strname];
    power.name = powerName;
    [power runAction:[SKAction  scaleTo:1.2 duration:0.0]];
    power.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30, 30)];
    power.physicsBody.dynamic = YES;
    power.physicsBody.collisionBitMask = 0.0;
    power.position = CGPointMake(self.size.width, yAxis);
    [self addChild:power];

    SKAction *actionFire = [SKAction moveToX:0 duration:2];
    SKAction *remove = [SKAction removeFromParent];
    [power runAction:[SKAction sequence:@[actionFire,remove]]];
}

#pragma mark - Add bats on scene
- (void)addBatsOnView {

    if (batCount < 5) {

        int yAxis = 110;
        if (batCount == 1 || batCount == 3) {
            yAxis = 50;
        } else if (batCount == 2 || batCount == 5) {
            yAxis = 170;
        }

        BatMan *batman = [[BatMan alloc]initWithPosition:CGPointMake(self.size.width + 50, yAxis) withBackgroungTexture:[SKTexture textureWithImageNamed:SPRITES_BAT]];
        [batman runAction:[SKAction scaleXTo:-0.9 y:0.9 duration:0.0]];
        batman.speed = 3.5;
        batman.name = @"Bats";
        [self addChild:batman];
        [batman runningTextureOfBats:CGPointMake(0, batman.position.y) withTextures:SPRITE_MONSTER_DESERT_BATS];

        batCount ++;

        [self performSelector:@selector(addBatsOnView) withObject:nil afterDelay:0.1];
    }
}

#pragma mark - Find Contact of richer with monster , obstacle and with power
- (void)didBeginContact:(SKPhysicsContact *)contact {

    SKPhysicsBody *firstBody, *secondBody;

    firstBody = contact.bodyB;
    secondBody = contact.bodyA;

    SKSpriteNode *node1 = (SKSpriteNode *) firstBody.node;
    SKSpriteNode *node2 = (SKSpriteNode *) secondBody.node;


    if ([node1.name isEqualToString:@"powerForWolf"] || [node2.name isEqualToString:@"powerForWolf"]) {

            // [self addPowerButtonWithImage:POWER_WOLF withPowerNumber:5];
    }

    if (([node1.name isEqualToString:@"fire"] && [node2.name isEqualToString:@"Richter"]) || ([node2.name isEqualToString:@"fire"] && [node1.name isEqualToString:@"Richter"])|| ([node1.name isEqualToString:@"strome_wing"] && [node2.name isEqualToString:@"Richter"]) || ([node2.name isEqualToString:@"strome_wing"]&& [node1.name isEqualToString:@"Richter"]) || ([node2.name isEqualToString:@"bats_fighter"] &&[node1.name isEqualToString:@"Richter"]) || ([node1.name isEqualToString:@"bats_fighter"]&&[node2.name isEqualToString:@"Richter"]) || ([node1.name isEqualToString:@"dragon_fighter"] &&[node2.name isEqualToString:@"Richter"])|| ([node2.name isEqualToString:@"dragon_fighter"]&& [node1.name isEqualToString:@"Richter"])) {

        [self addPowerToRicher:node1 didGetPower:node2];
        [GRModelOfLifeScore updateScoreOfNodeWithSpecialPower];

        return;
    } else if (([node1.name isEqualToString:@"RichterPower"] && ![node2.name isEqualToString:@"Weapon"]) || ([node2.name isEqualToString:@"RichterPower"] && ![node1.name isEqualToString:@"Weapon"])) {

        [self fireOnDragonsByRicher:node1 didCollideWithMonster:node2]; //animation of nodes
        return;
    } else if([node1.name isEqualToString:@"RichterMagicStick"] || [node2.name isEqualToString:@"RichterMagicStick"]) {
        if ([node1.name isEqualToString:@"coin"]) { //richter and coin

            [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
            [node1 removeFromParent];
            return;
        } else if ([node2.name isEqualToString:@"coin"]) {

            [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
            [node2 removeFromParent];
            return;
        }
    } else if([node1.name isEqualToString:@"RichterDragonFly"] || [node2.name isEqualToString:@"RichterDragonFly"]) {

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin];
        [self fireOnFlyDragonsByRicher:node1 didCollideWithMonster:node2]; //animation of nodes
    }

    [self richer:node1 didCollideWithObstacle:node2];
}

- (void)addMonsterBehindRichter {

    SKSpriteNode *monsterWolf = [[SKSpriteNode alloc]initWithImageNamed:@"monsterWolf1"];
    monsterWolf.name = @"Dragon";
    [monsterWolf runAction:[SKAction  scaleTo:1.0 duration:0.0]];
    monsterWolf.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    monsterWolf.physicsBody.dynamic = NO;
    monsterWolf.position = CGPointMake(40, heroYAxisThirdVw);
    [self addChild:monsterWolf];

    self.hero.position = CGPointMake(120, heroYAxisThirdVw-30);

    //run monster
    SKAction *run = [SKAction animateWithTextures:SPRITE_MONSTER_WOLF_LARGE timePerFrame:0.05];
    SKAction *repeatAction = [SKAction repeatActionForever:run];
    [monsterWolf runAction:repeatAction];

        // [self performSelector:@selector(addNegativeCoins) withObject:nil afterDelay:2.0];
}

- (void)fireOnFlyDragonsByRicher:(SKSpriteNode *)richer didCollideWithMonster:(SKSpriteNode *)monster {

    if ([richer.name isEqualToString:@"coin"]) { //richter and coin

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        [richer removeFromParent];
    } else if ([monster.name isEqualToString:@"coin"]) {

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        [monster removeFromParent];
    }

    if ([richer.name isEqualToString:@"Dragon"]) {
        [richer runAction:[SKAction sequence:@[[SKAction animateWithTextures:SPRITE_FIRE_ON_FLY_DRAGON timePerFrame:1.0], [SKAction removeFromParent]]]];
    } else if ([monster.name isEqualToString:@"Dragon"]) {
        [monster runAction:[SKAction sequence:@[[SKAction animateWithTextures:SPRITE_FIRE_ON_FLY_DRAGON timePerFrame:1.0], [SKAction removeFromParent]]]];
    }
}
    //convert obstacle into died animation
- (void)fireOnDragonsByRicher:(SKSpriteNode *)richer didCollideWithMonster:(SKSpriteNode *)monster {

    if ([richer.name isEqualToString:@"coin"]) { //richter and coin

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        [richer removeFromParent];
    } else if ([monster.name isEqualToString:@"coin"]) {

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        [monster removeFromParent];
    }

    if ([richer.name isEqualToString:@"Dragon"] || [richer.name isEqualToString:@"Bats"]) {

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin];

        [richer runAction:[SKAction sequence:@[[SKAction animateWithTextures:SPRITE_FIRE_ON_DRAGON timePerFrame:1.0], [SKAction removeFromParent]]]];
    } else if ([monster.name isEqualToString:@"Dragon"] || [monster.name isEqualToString:@"Bats"]){
        [monster runAction:[SKAction sequence:@[[SKAction animateWithTextures:SPRITE_FIRE_ON_DRAGON timePerFrame:1.0], [SKAction removeFromParent]]]];
        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin];

    }
}

- (void)richer:(SKSpriteNode *)richer didCollideWithObstacle:(SKSpriteNode *)obstacle1 {

    if (([richer.name isEqualToString:@"coin"] && [obstacle1.name isEqualToString:@"Richter"])) { //richter and coin

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        [richer removeFromParent];
        return;
    } else if ( ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"coin"])) {

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        [obstacle1 removeFromParent];
        return;
    }

    if (sharedAppDelegate.nodes.count > 1) {

        if (([richer.name isEqualToString:@"Obstacle"] && [obstacle1.name isEqualToString:@"Richter"]) ||  ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"Obstacle"])) {

            [self lostRichterLife:richer withObstacle:obstacle1];
        } else if ([richer.name isEqualToString:@"Weapon"] && [obstacle1.name isEqualToString:@"monster"]) {

            [GRModelOfLifeScore updateScoreOfNodeWithScoreToKillMonster];
            [richer removeFromParent];
            [obstacle1 removeFromParent];
        } else if (([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"monster"]) || ([richer.name isEqualToString:@"monster"] && [obstacle1.name isEqualToString:@"Richter"])) {

            [self lostRichterLife:richer withObstacle:obstacle1];
        } else if (([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"Dragon"]) || ([richer.name isEqualToString:@"Dragon"] && [obstacle1.name isEqualToString:@"Richter"]) || ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"Bats"]) || ([richer.name isEqualToString:@"Bats"] && [obstacle1.name isEqualToString:@"Richter"]) ) {

            [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin];
            [self lostRichterLife:richer withObstacle:obstacle1];
        }
    } else {

        [self runAction:[SKAction runBlock:^(){

            for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
                recognizer.enabled = NO;
                [self.view removeGestureRecognizer:recognizer];
            }
            [backgroundMusicPlayer stop];
            self.view.userInteractionEnabled = YES;

            GameOverScene *gameOver = [[GameOverScene alloc]initWithSize:self.size won:NO withCurrentScene:self.scene];
            SKTransition *trnsition = [SKTransition fadeWithDuration:0.1];
            [self.view presentScene:gameOver transition:trnsition];
        }]];
    }
}

#pragma mark - Add power to richter

- (void)addPowerToRicher:(SKSpriteNode *)richer didGetPower:(SKSpriteNode *)power  {

    [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin]; // update score

    if ([richer.name isEqualToString:@"fire"]) {

        [self addPowerButtonWithImage:POWER_FIRE withPowerNumber:0];
        [richer removeFromParent];
    } else if ( [power.name isEqualToString:@"fire"]) {

        [self addPowerButtonWithImage:POWER_FIRE withPowerNumber:0];
        [power removeFromParent];
    } else if ([richer.name isEqualToString:@"strome_wing"]) {

        [self addPowerButtonWithImage:POWER_STROME_WING withPowerNumber:1];
        [richer removeFromParent];
    } else if ([power.name isEqualToString:@"strome_wing"]) {

        [self addPowerButtonWithImage:POWER_STROME_WING withPowerNumber:1];
        [power removeFromParent];
    } else if ([richer.name isEqualToString:@"bats_fighter"]) {

        [self addPowerButtonWithImage:POWER_BATS withPowerNumber:2];
        [richer removeFromParent];
    } else if ([power.name isEqualToString:@"bats_fighter"]) {

        [self addPowerButtonWithImage:POWER_BATS withPowerNumber:2];
        [power removeFromParent];
    } else if ([richer.name isEqualToString:@"dragon_fighter"]) {

        [self addPowerButtonWithImage:POWER_DRAGON withPowerNumber:3];
        [richer removeFromParent];
    } else if ([power.name isEqualToString:@"dragon_fighter"]) {

        [self addPowerButtonWithImage:POWER_DRAGON withPowerNumber:3];
        [power removeFromParent];
    }
}

#pragma mark - Add power button when richter has take power
- (void)addPowerButtonWithImage:(NSString *)imgName withPowerNumber:(int)powerNumber {

    NSString *strPower;
    switch (powerNumber) {
        case 0:
            strPower = @"PowerBtn";
            yAxisOfRichtrPower = yAxisOfRichtrPower + 50;

            break;

        case 1:
                // xAxis = 48;
            strPower = @"PowerBtnStick";
            yAxisOfRichtrPower = yAxisOfRichtrPower + 50;

            break;

        case 2:
                // xAxis = 80;
            strPower = @"PowerBtnBats";
            yAxisOfRichtrPower = yAxisOfRichtrPower + 50;

            break;

        case 3:
                // xAxis = 115;
            strPower = @"PowerBtnDragon";
            yAxisOfRichtrPower = yAxisOfRichtrPower + 50;

            break;

        case 4:
                // xAxis = 115;
            strPower = @"PowerBtnDragonFly";
            yAxisOfRichtrPower = yAxisOfRichtrPower + 50;

            break;

        case 5:
                // xAxis = 115;
            strPower = @"PowerBtnWolf";
            break;

        default:
            break;
    }

    SKSpriteNode *powerBtn = [[SKSpriteNode alloc]initWithImageNamed:imgName];
    powerBtn.name = strPower;
    powerBtn.size = CGSizeMake(50, 50);
    powerBtn.zPosition = 1.0;
    powerBtn.position = CGPointMake(22, yAxisOfRichtrPower);
    [self addChild:powerBtn];
}

//power btn tapped to get those power
- (void)powerBtnTapped:(CGPoint)richterLocation withTextures:(NSArray *)texture withPowerNumber:(int)powerNumber {

    isSplPower = YES;

    [self.hero richterRemoveRunAction];
    self.hero.name = @"RichterPower";
    self.hero.position =  richterLocation;

    switch (powerNumber) {
        case 0:
            [self.hero runAction:[BaseAction addPowerToRichter:texture withTimeInterval:0.09]withKey:@"power"];
            [self.hero runAction:[SKAction scaleTo:1.5 duration:0.0]];
            break;

        case 1:
            isRichterFlying = YES;
            self.hero.name = @"RichterMagicStick"; // do nothing when have magic power
            [self.hero runAction:[BaseAction addPowerToRichter:texture withTimeInterval:0.09]withKey:@"power"];
            [self.hero runAction:[SKAction scaleTo:1.2 duration:0.0]];

        case 2:
            isRichterFlying = YES;
            [self.hero runAction:[BaseAction addPowerToRichter:texture withTimeInterval:0.09]withKey:@"power"];
            [self.hero runAction:[SKAction scaleTo:2.5 duration:0.0]];
            break;

        case 3:
            isRichterFlying = YES;
            [self.hero runAction:[BaseAction addPowerToRichter:texture withTimeInterval:.2]withKey:@"power"];
            [self.hero runAction:[SKAction scaleTo:5.0 duration:0.0]];
            break;

        case 4:
            isRichterFlying = YES;
            self.hero.name = @"RichterDragonFly";
            [self.hero runAction:[BaseAction addPowerToRichter:texture withTimeInterval:.2]withKey:@"power"];
            [self.hero runAction:[SKAction scaleTo:5.0 duration:0.0]];
            break;

        case 5:
            [self.hero runAction:[BaseAction addPowerToRichter:texture withTimeInterval:.2]withKey:@"power"];
            [self.hero runAction:[SKAction scaleTo:2.0 duration:0.0]];
            break;

        default:
            break;
    }

    self.hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 70)];
    self.hero.physicsBody.collisionBitMask = 0;

    if (powerNumber == 5) {
        [self performSelector:@selector(lostSpecialPowerOfRichter) withObject:nil afterDelay:6.4];
    } else {
        [self performSelector:@selector(lostSpecialPowerOfRichter) withObject:nil afterDelay:3.4];
    }
}

#pragma mark - Lost special power

- (void)lostSpecialPowerOfRichter {

    if (isSplPower == YES || isRichterFlying == YES) {

//        [self.hero removeActionForKey:@"power"];
//        [self.hero richterWalkAction];
//
//        self.hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.hero.size];
//        self.hero.physicsBody.collisionBitMask = 0;
//
//        self.hero.name = @"Richter";
//        self.hero.position = CGPointMake(heroXAxis, heroYAxis - 30);
//            //[self.hero runAction:[SKAction scaleTo:1.0 duration:0.0]];

        [self.hero removeFromParent];
        self.hero = nil;

        self.hero = [[RichterNode alloc]initWithPosition:CGPointMake(heroXAxis, heroYAxisThirdVw-30) withBackgroungTexture:nil];
        self.hero.zPosition = 1.0;
        self.hero.speed = 2.0;
        [self addChild:self.hero];

        isSplPower = NO;
        isRichterFlying = NO;
    }
}

- (void)addGunIcon {

    powerGun = [[SKSpriteNode alloc]initWithImageNamed:@"gun"];
    powerGun.physicsBody.dynamic = NO;
    powerGun.position = CGPointMake(170, self.size.height - 28);
    [self addChild:powerGun];
}

#pragma mark - Lost richter life

- (void)lostRichterLife:(SKSpriteNode *)richer withObstacle:(SKSpriteNode *)obstacle1 {

    if (isPauseGame == NO) {

        obstacle.paused = YES;
        [self.hero richterRemoveRunAction];
        [self.hero setTexture:[SKTexture textureWithImageNamed:RICHTER_DIE]];
        isPauseGame = YES;

        if (isJumpUp == NO) {
            [self.hero richterDiedAtLocation:self.hero.position withTexture:[SKTexture textureWithImageNamed:RICHTER_DIE]];
        }

            // [GRModelOfLifeScore removeNode:self];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(initializeHeroTextureInThirdScene) userInfo:nil repeats:NO];
    }
}

#pragma mark - UITouch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInNode:self];

    CGRect rectSwipeUp = CGRectMake(0, 50, (self.size.width/2) ,self.size.height);//(self.size.width -  (self.size.width/3)
    if (CGRectContainsPoint(rectSwipeUp, touchLocation)) {

        isIntersectFireArea = YES;
        [self addWeaponWithLocation:CGPointMake(568, self.hero.position.y)];
    } else {
        isIntersectFireArea = NO;
    }

    SKNode *node = [self nodeAtPoint:touchLocation];

    if ([node.name isEqualToString:@"pause"]) {

        [self playBtnTapped:@"pause"];
        node.name = @"playBtn";
        play.texture  = [SKTexture textureWithImageNamed:@"playBtn"];
        return;
    } else if ([node.name isEqualToString:@"playBtn"]) {

        [self playBtnTapped:@"playBtn"];
        node.name = @"pause";
        play.texture  = [SKTexture textureWithImageNamed:@"pause"];
        return;
    } else if ([node.name isEqualToString:@"PowerBtn"]) {

            // powerBtnNumber = 0;
        yAxisOfRichtrPower = yAxisOfRichtrPower - 50;
        [self powerBtnTapped:CGPointMake(heroXAxis,  heroYAxisThirdVw-30) withTextures:SPRITE_FIRE_POWER withPowerNumber:0];
        [node removeFromParent];
        return;
    } else if ([node.name isEqualToString:@"PowerBtnStick"]) {

            //powerBtnNumber = 0;
        yAxisOfRichtrPower = yAxisOfRichtrPower - 50;
        [self powerBtnTapped:CGPointMake(heroXAxis,  heroYAxisThirdVw+30) withTextures:SPRITE_RICHTER_MAGIC_STICK withPowerNumber:1];
        [node removeFromParent];
        return;
    } else if ([node.name isEqualToString:@"PowerBtnBats"]) {

            //powerBtnNumber = 0;
        yAxisOfRichtrPower = yAxisOfRichtrPower - 50;
        [self powerBtnTapped:CGPointMake(heroXAxis, heroYAxisThirdVw+5) withTextures:SPRITE_RICHTER_BATS withPowerNumber:2];
        [node removeFromParent];
        return;
    } else if ([node.name isEqualToString:@"PowerBtnDragon"]) {

            //powerBtnNumber = 0;
        yAxisOfRichtrPower = yAxisOfRichtrPower - 50;
        [self powerBtnTapped:CGPointMake(heroXAxis, heroYAxisThirdVw-5) withTextures:SPRITE_RICHTER_DRAGON withPowerNumber:3];
        [node removeFromParent];
        return;
    } else if ([node.name isEqualToString:@"PowerBtnDragonFly"]) {

        //powerBtnNumber = 0;
        yAxisOfRichtrPower = yAxisOfRichtrPower - 50;
        [self powerBtnTapped:CGPointMake(heroXAxis, heroYAxisThirdVw-5) withTextures:SPRITE_RICHTER_DRAGON withPowerNumber:4];
        [node removeFromParent];
        return;
    } else if ([node.name isEqualToString:@"PowerBtnWolf"]) {

        isRichterWolf = YES;
        yAxisOfRichtrPower = yAxisOfRichtrPower - 50;
        [self powerBtnTapped:CGPointMake(120, heroYAxisThirdVw-35) withTextures:SPRITE_RICHTER_WOLF withPowerNumber:5];
        [node removeFromParent];
        return;
    }

  /*  if (touch.tapCount == 2) {
        
        if (self.hero!= nil) {
            
            if (dragon != nil) {
                dragon.physicsBody.dynamic = NO;
            }
            [self addWeaponWithLocation:CGPointMake(568, self.hero.position.y)];
        }
    }*/
}

- (void)addPauseBtn {

    play = [[SKSpriteNode alloc]initWithImageNamed:@"pause"];
    play.position = CGPointMake(16, 14);
    play.name = @"pause";
    play.zPosition = 1.0;
    play.size = CGSizeMake(33,33);
    [self addChild:play];
}

- (void)playBtnTapped:(NSString *)btnName{

    if ([btnName isEqualToString:@"playBtn"]) {

        self.scene.paused = NO;
        isPauseGame = NO;
        [self.hero richterWalkAction];
    } else {

        self.scene.paused = YES;
        isPauseGame = YES;
        [self.hero richterRemoveRunAction];
    }
}


#pragma mark - fire when tapped on view

- (void)addWeaponWithLocation:(CGPoint)location {

    if (isPauseGame == NO && gunStart != 1) {

        [self.hero runAction:[BaseAction walkOfNodeWithWeapon]];

        NSString *firePath = [[NSBundle mainBundle] pathForResource:@"FireOfWeapon" ofType:@"sks"];

        SKEmitterNode *star = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
        star.position = CGPointMake(self.hero.position.x+20, self.hero.position.y + 10);
        star.name = @"Weapon";
        star.zPosition = 0;
        star.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
        star.physicsBody.categoryBitMask = weaponShipCategory;
        star.physicsBody.contactTestBitMask = monsterCategory;

        [self addChild:star];

        SKAction *laserMoveAction = [SKAction moveTo:CGPointMake(location.x, touchLocation.y) duration:0.3];
        SKAction *remove = [SKAction removeFromParent];
        [star runAction:[SKAction sequence:@[laserMoveAction, remove]]];
    }
}

- (void)playBackgroundMusic {

    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"find-the-key" withExtension:@"mp3"];
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops = -1;
    [backgroundMusicPlayer prepareToPlay];
    backgroundMusicPlayer.volume = 5.0;
    [backgroundMusicPlayer play];
}

@end
