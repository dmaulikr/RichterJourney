//
//  SecondScene.m
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 17/01/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import "SecondScene.h"
#import "BaseAction.h"
#import "Coin.h"
#import "Obstacle.h"
#import "Eagle.h"
#import "MonsterCollection.h"
#import "Monster.h"
#import "Dragon.h"
#import "BatMan.h"
#import <AVFoundation/AVFoundation.h>

#import "sprites.h"
#import "GameOverScene.h"
#import "GRModelOfLifeScore.h"

#define heroXAxis 100

@interface SecondScene () {

    BOOL isMonsterOrObstacle;
    BOOL isCoinShow;
    BOOL isDragonPower;
    BOOL isEaglePower;
    BOOL isPauseGame;
    BOOL isJumpUp;
    BOOL isIntersectFireArea;
    BOOL isPowerAdd;

    Obstacle *obstacle;
    Dragon *dragon;
    CGPoint touchLocation;

    int monsterCount;
    int obstacleCount;
    int coinCount;
    int scrollBgCount;
    Eagle *eagle;

    SKSpriteNode *play;
    SKSpriteNode *powerGun;
    AVAudioPlayer * backgroundMusicPlayer;
}

@end

@implementation SecondScene

- (id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {

        self.physicsWorld.gravity = CGVectorMake(0,0);
        NSString *imageName;
        if (IS_IPHONE_6P) {
            imageName = @"Forest_iPhone6";
        } else {
            imageName = @"Forest";
        }
        self.scrollingBackground = [ScrollingBackground scrollingNodeWithImageNamed:imageName inContainerWidth:size.width withSpeed:8.0];
        self.scrollingBackground.delegate = self;
        [self addChild:self.scrollingBackground];

        [self initializeHeroTextureInsecondScene];
        [self repeatObstacleOntheWay];

        [self addPauseBtn];
        [self playBackgroundMusic];
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
        //[self addMonkey];
//
//    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGestureOnSecondVw:)];
//    tapGesture1.numberOfTapsRequired = 2;
//    [self.view addGestureRecognizer:tapGesture1];
}

- (void)dealloc {

    [self.scrollingBackground removeFromParent];
    self.scrollingBackground = nil;

    [obstacle removeFromParent];
    obstacle = nil;

    [backgroundMusicPlayer pause];
    backgroundMusicPlayer = nil;
}

- (void)update:(CFTimeInterval)currentTime {

    if(isPauseGame == NO){
        [self.scrollingBackground update:currentTime];
    }
}

- (void)scrollBackgroundVwDone {

    if (eagle.children.count == 1) {
        [self performSelector:@selector(eagleDropRichter) withObject:nil afterDelay:1.5];
    }

    if(eagle == nil) {

        [eagle removeFromParent];
        eagle = nil;
    }

    eagle = [[Eagle alloc]initWithPosition:CGPointMake(30, 200) withBackgroungTexture:[SKTexture textureWithImageNamed:@"eagle1"]];
    eagle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(60,10)];
    eagle.physicsBody.dynamic = NO;
    [self addChild:eagle];

    eagle.speed = 2.5;
    [eagle runAction:[BaseAction flyingOfEagleOnSecondView:CGPointMake(heroXAxis, heroYAxis + 35)]];


    if (scrollBgCount == 35) {

        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            recognizer.enabled = NO;
            [self.view removeGestureRecognizer:recognizer];
        }

        [backgroundMusicPlayer stop];
        self.view.userInteractionEnabled = YES;

        SKTransition *transition = [SKTransition fadeWithDuration:0.0];
        GameOverScene *gameOver = [[GameOverScene alloc]initWithSize:self.size won:YES withCurrentScene:self.scene];
        [self.view presentScene:gameOver transition:transition];
    }
    scrollBgCount ++;
}

- (void)initializeHeroTextureInsecondScene {

    isPauseGame = YES;
    obstacle.paused = NO;
    self.view.userInteractionEnabled = YES;

    if (self.hero != nil) {
        [self.hero removeFromParent];
        self.hero = nil;
    }
    self.hero = [[RichterNode alloc]initWithPosition:CGPointMake(heroXAxis, heroYAxis) withBackgroungTexture:nil];
    [self addChild:self.hero];
    self.hero.speed = 2.0;
    isPauseGame = NO;

    self.hero.physicsBody.dynamic = NO;
    self.hero.alpha = 0.5;

    [UIView animateWithDuration:4.0 animations:^{
        [self.hero runAction:[SKAction fadeInWithDuration:4.0]];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(setDyanamisBodyOfRichter) withObject:nil afterDelay:1.6];
    }];
    [self performSelector:@selector(addGunPower) withObject:nil afterDelay:1.0];
}

- (void)eagleDropRichter {

    if (self.hero != nil) {

        [self.hero removeFromParent];
        self.hero = nil;
    }

    self.hero = [[RichterNode alloc]initWithPosition:CGPointMake(heroXAxis, heroYAxis) withBackgroungTexture:nil];
    self.hero.speed = 2.0;
    [self.hero runAction:[BaseAction jumpDownFromUp:CGPointMake(heroXAxis, heroYAxis) withTexture:SPRITES_ANIM_JUMP_UP_DOWN duration:1.0]];
    [self addChild:self.hero];

    isPauseGame = NO;

    self.hero.physicsBody.dynamic = NO;
    self.hero.alpha = 0.5;

    [UIView animateWithDuration:2.0 animations:^{
        [self.hero runAction:[SKAction fadeInWithDuration:2.0]];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(setDyanamisBodyOfRichter) withObject:nil afterDelay:1.0];
    }];
}

- (void)setDyanamisBodyOfRichter {
       self.hero.physicsBody.dynamic = YES;
}

- (void)addCoinsAtUpAndDown {

    int x = self.size.width+40;
    int y = heroYAxis+80;
    for (int i=1; i<=2; i++) {

        Coin *coin = [[Coin alloc]initWithPosition:CGPointMake(x, y) withBackgroungTexture:nil];
        [self addChild:coin];

        x = x-40;
        if (i%2){
            y = heroYAxis+120;
        } else {
            y = heroYAxis;
        }
    }
    coinCount ++;
    if (coinCount == 3) {
        isCoinShow = NO;
        coinCount = 0;//5;
    }
    [self repeatObstacleOntheWay];
}


- (void)addCoinsOnView {

    if (isPauseGame == YES)  {
        [self repeatObstacleOntheWay];
        return;
    }

    Coin *coin = [[Coin alloc]initWithPosition:CGPointMake(self.size.width, heroYAxis+90) withBackgroungTexture:nil];
    [self addChild:coin];

    coinCount ++;
    if (coinCount == 5) {
        isCoinShow = NO;
        coinCount = 0;//5;
    }
    [self repeatObstacleOntheWay];
}

- (void)repeatObstacleOntheWay {

    if (isCoinShow == NO) {
          if (isMonsterOrObstacle == YES ) {
                [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addObstacleSprideNodeinForest) userInfo:nil repeats:NO];
            } else {
                [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addMonsterOnView) userInfo:nil repeats:NO];
                 isCoinShow = YES;
            }
    } else {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addCoinsOnView) userInfo:nil repeats:NO];
    }
}


- (void)addBirdPowerWithCoins {

    SKSpriteNode *power = [[SKSpriteNode alloc]initWithImageNamed:@"birdCoin"];
    power.name = @"birdCoin";
    power.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:power.size];
    power.physicsBody.dynamic = YES;
    power.physicsBody.collisionBitMask = 0.0;
    power.position = CGPointMake(self.size.width, 120);
    [self addChild:power];

    SKAction *actionFire = [SKAction moveToX:0 duration:2.3];
    SKAction *remove = [SKAction removeFromParent];
    [power runAction:[SKAction sequence:@[actionFire,remove]]];
}

- (void)addIconOfRichterPower:(NSString *)strIconImgName withYAxis:(CGFloat)yAxis withName:(NSString*)name {

    SKSpriteNode *power = [[SKSpriteNode alloc]initWithImageNamed:strIconImgName];
    power.physicsBody.dynamic = YES;
    power.name = name;
    power.physicsBody.collisionBitMask = 0.0;
    power.size = CGSizeMake(50, 50);
    power.zPosition = 1.0;
    power.position = CGPointMake(22, yAxis);
    [self addChild:power];
}

- (void)addPowerOfDragon {

    SKSpriteNode *power = [[SKSpriteNode alloc]initWithImageNamed:@"powerCoin_Dragon1"];
    power.name = @"dragonCoin";
    power.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:power.size];
    power.physicsBody.dynamic = NO;
    power.size = CGSizeMake(33, 33);
    power.position = CGPointMake(self.size.width, 100);
    [self addChild:power];

    SKAction *actionFire = [SKAction moveToX:-20 duration:2.3];
    SKAction *remove = [SKAction removeFromParent];
    [power runAction:[SKAction sequence:@[actionFire,remove]]];
}

- (void)addMonsterOnView {

    if (isPauseGame == YES)  {
        [self repeatObstacleOntheWay];
        return;
    }

    NSString *strImgName;
    NSArray *arryMonster;
    CGFloat speed;
    CGFloat scale;

    CGPoint point = CGPointMake(self.size.width, heroYAxis+33);
    if (obstacle != nil) {

        [obstacle removeFromParent];
        obstacle = nil;
    }
    monsterCount = monsterCount + 1;

    if (monsterCount < 5) {

        if (monsterCount == 1) {

            isEaglePower = NO;
            isDragonPower = NO;

            strImgName = SPRITES_TIGER;
            arryMonster = SPRITES_ANIM_TIGER;
            speed = 6.0;
            scale = 2.0;
        } else if (monsterCount == 2){

            strImgName = SPRITES_EYEMONSTER;
            arryMonster = SPRITE_MONSTER_EYE;
            point = CGPointMake(self.size.width, heroYAxis+48);
            speed = 6.5;
            scale = 1.5;
        } else if (monsterCount == 3){

            strImgName = SPRITES_WOLF;
            point = CGPointMake(self.size.width, heroYAxis+26);
            arryMonster = SPRITE_MONSTER_WOLF;
            speed = 6;
            scale = 0.5;
        }  else if (monsterCount == 4){

            [self performSelector:@selector(addBirdPowerWithCoins) withObject:nil afterDelay:1.0];

            strImgName = SPRITES_LION;
            arryMonster = SPRITE_MONSTER_LION;
            speed = 7;
            scale = 2;
        }

        Monster *monster = [[Monster alloc]initWithPosition:point withBackgroungTexture:[SKTexture textureWithImageNamed:strImgName]];
        [monster runAction:[SKAction scaleXTo:scale y:scale duration:0.0]];
        [self addChild:monster];

        [monster runningTextureOfMonsterWithLocation:point withTextures:arryMonster];
        monster.speed = speed;
        isMonsterOrObstacle = YES;
        [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
        return;
    }

    [self addDragens];
}

- (void)addDragens {

    NSString *strImgName;
    NSArray *arryMonster;
    CGFloat speed;
    CGFloat scale;
    CGPoint point;

    if (monsterCount == 5) {

            //[self makeFastSpeedOfEagle];
        [self addBatsOnView];
        isMonsterOrObstacle = YES;
        [self repeatObstacleOntheWay];
        [self performSelector:@selector(addBirdPowerWithCoins) withObject:nil afterDelay:1.0];

        return;
    } else if (monsterCount == 6) {

        [self addBatsOnView];
        isMonsterOrObstacle = YES;
        [self addPowerOfDragon];
        [self repeatObstacleOntheWay];
        return;
    } else if (monsterCount == 7) {

        strImgName = SPRITES_DYNASOR;
        arryMonster = SPRITE_MONSTER_DYNASOR;

        speed = 3;
        scale = 2;
        point = CGPointMake(self.size.width, heroYAxis+60);
    } else if (monsterCount == 8) {

        [self addBatsOnView];
        isMonsterOrObstacle = YES;
        [self repeatObstacleOntheWay];
        return;
    } else if(monsterCount == 9){

        strImgName = SPRITES_DYNASOR;
        arryMonster = SPRITE_MONSTER_DYNASOR;

        speed = 3;
        scale = 2;
        point = CGPointMake(self.size.width, heroYAxis+60);
        monsterCount = 0;
    }

    dragon = [[Dragon alloc]initWithPosition:point withBackgroungTexture:[SKTexture textureWithImageNamed:strImgName]];
    [dragon runAction:[SKAction scaleXTo:scale y:scale duration:0.0]];
    dragon.physicsBody.dynamic = YES;
    dragon.physicsBody.collisionBitMask = 0.0;
    [self addChild:dragon];

    [dragon runningTextureOfDragonWithLocation:point withTextures:arryMonster withInterval:0.2];
    dragon.speed = speed;
    isMonsterOrObstacle = YES;

    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
}

- (void)addBatsOnView {

    BatMan *batman = [[BatMan alloc]initWithPosition:CGPointMake(self.size.width + 50, 120) withBackgroungTexture:[SKTexture textureWithImageNamed:SPRITES_BAT]];
    [batman runAction:[SKAction scaleXTo:1.3 y:1.3 duration:0.0]];
    batman.speed = 3.0;
    [self addChild:batman];
    [batman runningTextureOfBats:CGPointMake(0, batman.position.y) withTextures:SPRITE_MONSTER_BATS];
}

- (void)addGunIcon {

    powerGun = [[SKSpriteNode alloc]initWithImageNamed:@"gun"];
    powerGun.physicsBody.dynamic = NO;
    powerGun.position = CGPointMake(170, self.size.height - 28);
    [self addChild:powerGun];
}

- (void)addGunPower {
        //power_star

    SKSpriteNode *power = [[SKSpriteNode alloc]initWithImageNamed:@"coinWithStar"];
    power.name = @"Gun";
    power.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:power.size];
    power.physicsBody.dynamic = NO;
    power.speed = 1.4;
    power.physicsBody.collisionBitMask = 0.0;
    power.position = CGPointMake(self.size.width, 130);
    [self addChild:power];

    SKAction *actionFire = [SKAction moveToX:0 duration:3.0];
    SKAction *remove = [SKAction removeFromParent];
    [power runAction:[SKAction sequence:@[actionFire,remove]]];
}

#pragma mark - Add obstacle

- (void)addObstacleSprideNodeinForest {

    if (isPauseGame == YES)  {

        [self repeatObstacleOntheWay];
        return;
    }

    NSString *strImgName;
    CGFloat xScale = 1.5;
    CGFloat speed = 1.1*2;

    CGPoint point = CGPointMake(self.size.width, heroYAxis+26);

    if (obstacle != nil) {
        obstacle = nil;
    }

    obstacleCount = obstacleCount + 1;
    if (obstacleCount == 1) {
        strImgName = OBSTACLE_STONES;
        speed = 1.16*2;//1.5*2;
    } else if (obstacleCount == 2) {
        strImgName = OBSTACLE_TREE;
        speed = 1.1*2;//1.47*2;
    } else {
        xScale = 1.0;
        strImgName = OBSTACLE_POND;
        obstacleCount = 0;
         
        point = CGPointMake(self.size.width, heroYAxis-7);
    }
    obstacle = [[Obstacle alloc]initWithPosition:point withBackgroungTexture:[SKTexture textureWithImageNamed:strImgName]];
    obstacle.speed = speed;
    [obstacle runAction:[SKAction scaleXTo:xScale y:1 duration:0.0]];
    [self addChild:obstacle];

    isCoinShow = YES;
    isMonsterOrObstacle = NO;
    [self repeatObstacleOntheWay];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {

    SKPhysicsBody *firstBody, *secondBody;

    firstBody = contact.bodyB;
    secondBody = contact.bodyA;

    SKSpriteNode *node1 = (SKSpriteNode *) firstBody.node;
    SKSpriteNode *node2 = (SKSpriteNode *) secondBody.node;

    if ([node1.name isEqualToString:@"dragonCoin"] && [node2.name isEqualToString:@"Richter"]) {

        [self addIconOfRichterPower:@"powerCoin_Dragon1" withYAxis:120 withName:@"dragonPowerBtn"];
        [GRModelOfLifeScore updateWithPowerOfEagleAndDragon];
        isDragonPower = YES;
        [node1 removeFromParent];
        return;
    } else if ([node1.name isEqualToString:@"Richter"] && [node2.name isEqualToString:@"dragonCoin"]) {

        [self addIconOfRichterPower:@"powerCoin_Dragon1" withYAxis:120 withName:@"dragonPowerBtn"];
        [GRModelOfLifeScore updateWithPowerOfEagleAndDragon];
        isDragonPower = YES;
        [node2 removeFromParent];
        return;
    }

    [self richer:(SKSpriteNode *) firstBody.node didCollideWithObstacle:(SKSpriteNode *) secondBody.node];
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
    } else if (([richer.name isEqualToString:@"eagle"] && [obstacle1.name isEqualToString:@"Richter"]) || ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"eagle"])) { //richter and eagle

        return;
    } else if (([richer.name isEqualToString:@"RichterDragon"] && [obstacle1.name isEqualToString:@"Richter"]) || ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"RichterDragon"])) {//richter and his dragon

        return;
    } else if ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"birdCoin"]) {

        [obstacle1 removeFromParent];
        [GRModelOfLifeScore updateWithPowerOfEagleAndDragon];
        [self addIconOfRichterPower:@"birdCoin" withYAxis:60 withName:@"eagleCoin"];
        isEaglePower = YES;
        return;
    } else if ([richer.name isEqualToString:@"birdCoin"] && [obstacle1.name isEqualToString:@"Richter"]) {

        [richer removeFromParent];
        [GRModelOfLifeScore updateWithPowerOfEagleAndDragon];
        [self addIconOfRichterPower:@"birdCoin" withYAxis:60 withName:@"eagleCoin"];
        isEaglePower = YES;
        return;
    } else if (([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"Gun"])) {

        isPowerAdd = YES;
        [self addGunIcon];
        [obstacle1 removeFromParent];
        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfLife];
        return;
    } else if ([richer.name isEqualToString:@"Gun"] && [obstacle1.name isEqualToString:@"Richter"]) {

        isPowerAdd = YES;
        [self addGunIcon];
        [richer removeFromParent];
        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        return;
    }

    if (sharedAppDelegate.nodes.count > 1) {

        if (([richer.name isEqualToString:@"Obstacle"] && [obstacle1.name isEqualToString:@"Richter"]) ||  ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"Obstacle"])) {

            [self lostRichterLife:richer withObstacle:obstacle1];
        } else if (([richer.name isEqualToString:@"Weapon"] && [obstacle1.name isEqualToString:@"monster"]) || ([richer.name isEqualToString:@"monster"] && [obstacle1.name isEqualToString:@"Weapon"])) {

            [self monsterDeadAnimation:obstacle1];
            [GRModelOfLifeScore updateScoreOfNodeWithScoreToKillMonster];
            [richer removeFromParent];
            [obstacle1 removeFromParent];
        } else if (([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"monster"]) || ([richer.name isEqualToString:@"monster"] && [obstacle1.name isEqualToString:@"Richter"])) {

             [self lostRichterLife:richer withObstacle:obstacle1];
            return;
        } else if ([richer.name isEqualToString:@"bat"] && [obstacle1.name isEqualToString:@"eagle"]) {

            [GRModelOfLifeScore updateScoreOfNodeWithScoreToKillMonster];
            [self monsterDeadAnimation:richer];

            [richer removeFromParent];
        } else if ([richer.name isEqualToString:@"eagle"] && [obstacle1.name isEqualToString:@"bat"]) {

            [self monsterDeadAnimation:obstacle1];
            [GRModelOfLifeScore updateScoreOfNodeWithScoreToKillMonster];
            [obstacle1 removeFromParent];
        } else if (([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"Dragon"]) || ([richer.name isEqualToString:@"Dragon"] && [obstacle1.name isEqualToString:@"Richter"]) || ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"bat"]) || ([richer.name isEqualToString:@"bat"] && [obstacle1.name isEqualToString:@"Richter"]) ) {

            [self lostRichterLife:richer withObstacle:obstacle1];
        } else if (([richer.name isEqualToString:@"eagle"] && [obstacle1.name isEqualToString:@"Dragon"])||([richer.name isEqualToString:@"Dragon"] && [obstacle1.name isEqualToString:@"eagle"])) {

            [eagle removeFromParent];
            [self.hero removeFromParent];
            [GRModelOfLifeScore removeNode:self];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(initializeHeroTextureInsecondScene) userInfo:nil repeats:NO];
        } else if (([richer.name isEqualToString:@"Dragon"] && [obstacle1.name isEqualToString:@"RichterDragon"])) {

            [self dragonHasDied:CGPointMake(340, richer.position.y)];
            [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin];

            [richer removeFromParent];
        } else if (([richer.name isEqualToString:@"RichterDragon"] && [obstacle1.name isEqualToString:@"Dragon"])) {

            [self dragonHasDied:CGPointMake(340, richer.position.y)];
            [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin];

            [obstacle1 removeFromParent];
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

- (void)monsterDeadAnimation:(SKSpriteNode *)monster {

    [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin];
    [monster runAction:[SKAction sequence:@[[SKAction animateWithTextures:SPRITE_MONSTER_DEAD timePerFrame:1.0], [SKAction removeFromParent]]]];
}

- (void)lostRichterLife:(SKSpriteNode *)richer withObstacle:(SKSpriteNode *)obstacle1 {

    if (isPauseGame == NO) {

        obstacle.paused = YES;
        self.hero.physicsBody.dynamic = NO;
        [self.hero richterRemoveRunAction];
        [self.hero setTexture:[SKTexture textureWithImageNamed:RICHTER_DIE]];
        isPauseGame = YES;

        isPowerAdd = NO;
            // [GRModelOfLifeScore removeNode:self];

        [powerGun removeFromParent];

        if (isJumpUp == NO) {
            [self.hero  richterDiedAtLocation:self.hero.position withTexture:[SKTexture textureWithImageNamed:RICHTER_DIE]];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(initializeHeroTextureInsecondScene) userInfo:nil repeats:NO];
        } else {
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(initializeHeroTextureInsecondScene) userInfo:nil repeats:NO];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInNode:self];

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
    } else if ([node.name isEqualToString:@"dragonPowerBtn"]) {

        [self.hero setHidden:YES];
        [node removeFromParent];

        [self addDragonOfRichter];
        return;
    } else if ([node.name isEqualToString:@"eagleCoin"]) {

        [self.hero richterRemoveRunAction];
        [self sitRichterOnEagle];
        return;
    }

    CGRect rectSwipeUp = CGRectMake(0, 50, (self.size.width/2) ,self.size.height);//(self.size.width -  (self.size.width/3)
    if (CGRectContainsPoint(rectSwipeUp, touchLocation)) {

        isIntersectFireArea = YES;
        if (isPowerAdd == YES) {
            [self addWeaponWithLocation:CGPointMake(568, self.hero.position.y)];
        }
    } else {
        isIntersectFireArea = NO;
    }

    /*if (touch.tapCount == 2) {

        if (self.hero!= nil) {

            if (dragon != nil) {
                dragon.physicsBody.dynamic = NO;
            }
            [self addWeaponWithLocation:CGPointMake(568, self.hero.position.y)];
        }
    }*/
}

- (void)handleTapGestureOnSecondVw:(UITapGestureRecognizer *)recognizer {


}

- (void)addWeaponWithLocation:(CGPoint)location {

    if (isPauseGame == NO) {

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

        dragon.physicsBody.dynamic = YES;
    }
}

- (void)dragonHasDied:(CGPoint)location {

    if (self.hero != nil) {

        NSString *firePath = [[NSBundle mainBundle] pathForResource:@"DynasorFire" ofType:@"sks"];
        SKEmitterNode *dynasor = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
        dynasor.position = CGPointMake(location.x, location.y);
        dynasor.zPosition = 1;
        [self addChild:dynasor];

        [dynasor runAction:[SKAction sequence:@[[SKAction waitForDuration:0.6], [SKAction removeFromParent]]]]; //fire dragon
    }
}

- (void)addDragonOfRichter {

    SKSpriteNode *richterDragon = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:SPRITES_DRAGON]];
    richterDragon.physicsBody =  [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(richterDragon.size.width, richterDragon.size.height)];
    richterDragon.physicsBody.dynamic = NO;
    richterDragon.name = @"RichterDragon";
    richterDragon.position = CGPointMake(heroXAxis-60, heroYAxis+85);
    richterDragon.zPosition = 1;
    [self addChild:richterDragon];

    SKAction *action = [SKAction animateWithTextures:SPRITE_RICHTER_FIREDRAGON  timePerFrame:0.1];
    [richterDragon runAction:[SKAction scaleXTo:-1.3 y:1.3 duration:0.0]];
    SKAction *actionSequence = [SKAction sequence:@[action]];
    [richterDragon runAction:[SKAction sequence:@[[SKAction repeatAction:actionSequence count:3] ,[SKAction waitForDuration:0.5], [SKAction removeFromParent]]]];//
    isDragonPower = NO;

    [self performSelector:@selector(richterShow) withObject:nil afterDelay:1.0];
}

- (void)richterShow {

    [self.hero setHidden:NO];
}

- (void)sitRichterOnEagle {

    if (eagle.position.y < 270) {

        if (isEaglePower == YES) {

            [self.hero runAction: [BaseAction standOnEagle:eagle.position]];

            if (self.hero!= nil) {
                [self.hero removeFromParent];
                self.hero = nil;
            }
            self.hero = [[RichterNode alloc]initWithPosition:CGPointMake(-1,15) withBackgroungTexture:nil];
            [self.hero runAction:[SKAction scaleTo:0.5 duration:0]];
            [self.hero richterRemoveRunAction];

            self.hero.zPosition = 0;
            [eagle addChild:self.hero];
            return;
        }
    }
}

#pragma mark - Changable Function

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
            [self.hero runAction:[BaseAction jumpDownOfNode]];
        }

        if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {

             if (isPauseGame == NO) {

                 isJumpUp = YES;
                 self.view.userInteractionEnabled = NO;
                 [self.hero richterRemoveRunAction];

                 [self.hero jumpUpOfRichter:self.hero.position withUpTexture:SPRITES_ANIM_JUMP_UP textureDown:SPRITES_ANIM_JUMP_UP_DOWN Duration:1.0];
                 [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(jumpDownFromUpOfHeroInSecondView) userInfo:nil repeats:NO];
             }
        }
    }
}

- (void)jumpDownFromUpOfHeroInSecondView {

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

- (void)playBackgroundMusic {

    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"ExploreThemeMusic" withExtension:@"mp3"];
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops = -1;
    [backgroundMusicPlayer prepareToPlay];
    backgroundMusicPlayer.volume = 5.0;
    [backgroundMusicPlayer play];
}

@end
