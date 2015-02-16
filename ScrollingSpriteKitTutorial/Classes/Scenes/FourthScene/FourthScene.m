//
//  FourthScene.m
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 04/02/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import "FourthScene.h"
#import "sprites.h"
#import "BaseAction.h"
#import "Coin.h"
#import "Obstacle.h"
#import "MonsterCollection.h"
#import "Monster.h"
#import "Dragon.h"
#import "BatMan.h"
#import "GRModelOfLifeScore.h"
#import <AVFoundation/AVFoundation.h>

#define heroXAxis   100

#define speed7      .50
#define speed9      1.0
#define speddd10    1.25

@interface FourthScene () {

    BOOL isMonsterOrObstacle;
    BOOL isCoinShow;
    BOOL isPauseGame;
    BOOL isSplPower;
    BOOL isRichterFlying;
    BOOL isRichterWolf;
    BOOL isJumpUp;
    BOOL isIntersectFireArea;

    int obstacleCount;
    int scrollCount;
    int monsterCount;
    int batCount;
    int coinCount;
    int gunCount;
    int yAxisOfRichtrPower;

    Obstacle *obstacle;
    Dragon *dragon;
    SKSpriteNode *play;
    SKSpriteNode *powerGun;

    CGPoint touchLocation;
    CGFloat jumpDownSpeed;
    AVAudioPlayer *backgroundMusicPlayer;
}

@end

@implementation FourthScene

- (id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {

        self.physicsWorld.gravity = CGVectorMake(0,0);
        NSString *imageName;
        if (IS_IPHONE_6P) {
            imageName = @"night_iPhone6";
        } else {
            imageName = @"night";
        }

        self.scrollingBackground = [ScrollingBackground scrollingNodeWithImageNamed:imageName inContainerWidth:size.width withSpeed:5.0];
        self.scrollingBackground.delegate = self;
        [self addChild:self.scrollingBackground];

        [self initializeHeroTextureFourthScene];
        [self repeatObstacleOntheWay];
        [self playBackgroundMusic];
        [self addGunIcon];
            // [self powerBtnTapped:CGPointMake(heroXAxis, heroYAxis-28) withTextures:SPRITE_RICHTER_BATS withPowerNumber:0];
        jumpDownSpeed = 0.6;
        yAxisOfRichtrPower = 0;
    }
    return self;
}

- (void)dealloc {

    [self.scrollingBackground removeFromParent];
    self.scrollingBackground = nil;

    [obstacle removeFromParent];
    obstacle = nil;

    [backgroundMusicPlayer pause];
    backgroundMusicPlayer = nil;
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
            [self.hero turnLeftOfRichterWithLocation:self.hero.position];
        }

        if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {

            if (isRichterFlying == NO && isPauseGame == NO) {

                isJumpUp = YES;
                self.view.userInteractionEnabled = NO;
                [self.hero richterRemoveRunAction];

                if(isRichterWolf == YES) {

                    [self.hero runAction: [BaseAction jumpUpOfRichterWolf:CGPointMake(heroXAxis, heroYAxis-30) withTexture:@[[SKTexture textureWithImageNamed: RICHTER_WOLF_JUMP]] Duration:1.0]];
                    isRichterWolf = NO;
                    return;
                }

                if (isSplPower == YES) {

                } else {
                    [self.hero jumpUpOfRichter:self.hero.position withUpTexture:SPRITES_ANIM_JUMP_UP textureDown:SPRITES_ANIM_JUMP_UP_DOWN Duration:0.7];

                }
                [self performSelector:@selector(jumpDownFromUpOfHeroInFourthView) withObject:nil afterDelay:0.6];
            }
        } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            [self.hero turnRightOfRichterWithLocation:self.hero.position];
        } else {
        }
    }
}

- (void)jumpDownFromUpOfHeroInFourthView {

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

#pragma mark - Initialization of hero

- (void)initializeHeroTextureFourthScene {

    obstacle.paused = NO;
    if (self.hero != nil) {
        [self.hero removeFromParent];
        self.hero = nil;
    }
    self.hero = [[RichterNode alloc]initWithPosition:CGPointMake(heroXAxis, heroYAxis-30) withBackgroungTexture:nil];
    [self addChild:self.hero];
    self.hero.zPosition = 1.0;
    self.hero.speed = 1.1; //2.0;

    int scrollingSpeed = self.scrollingBackground.speed;

    if (scrollingSpeed == 7.0) {
        self.hero.speed = 1.7;
    } else if(scrollingSpeed == 9.0) {
        self.hero.speed = 2.0;
    } else if(scrollingSpeed == 10.0) {
        self.hero.speed = 2.0;
    }

    self.hero.physicsBody.dynamic = NO;
    self.hero.alpha = 0.5;

    isPauseGame = NO;

    [UIView animateWithDuration:4.0 animations:^{
        [self.hero runAction:[SKAction fadeInWithDuration:4.0]];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(setDyanamisBodyOfRichter) withObject:nil afterDelay:0.7];
    }];
}

- (void)setDyanamisBodyOfRichter {
    self.hero.physicsBody.dynamic = YES;
}

- (void)update:(CFTimeInterval)currentTime {

    if(isPauseGame == NO){
        [self.scrollingBackground update:currentTime];
    }
}

- (void)scrollBackgroundVwDone {

    scrollCount ++;
}

#pragma mark - Repetation  of obstacle and monster

- (void)repeatObstacleOntheWay {

    if (isCoinShow == NO) {

        if (isMonsterOrObstacle == YES ) {
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(addObstacleSprideNodeinDesert) userInfo:nil repeats:NO];
        } else {
          [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(addMonsterInNightView) userInfo:nil repeats:NO];
            isCoinShow = YES;
        }
    } else {

        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addCoinsOnView) userInfo:nil repeats:NO];
    }
}

#pragma mark - Add obstacle

- (void)addObstacleSprideNodeinDesert {

    if (isPauseGame == YES)  {

        [self repeatObstacleOntheWay];
        return;
    }

    if (scrollCount > 3 && scrollCount < 5) {//8
        [self  increaseSpeedOfScrollBackgroung:7];
        jumpDownSpeed = 0.5;
    } else if (scrollCount >= 5 && scrollCount < 10) {
        [self increaseSpeedOfScrollBackgroung:9];
        jumpDownSpeed = 0.6;
    } else if (scrollCount >= 10) {
        [self increaseSpeedOfScrollBackgroung:10];
        jumpDownSpeed = 0.6;
    }

    NSString *strImgName;
    CGFloat speed = 2.7;//1.25;//
    CGFloat scaleX = 1.0;
    CGFloat scaleY = 1.0;
    CGFloat addAdditionlSpeed = 0;
    int extraSpeed = 0;

    int scrollingSpeed = self.scrollingBackground.scrollingSpeed;
    if (scrollingSpeed == 7.0) {
        extraSpeed = 1;
        self.hero.speed = 1.7;
        addAdditionlSpeed = speed7;
    } else if(scrollingSpeed == 9.0) {
        extraSpeed = 3;
        self.hero.speed = 2.0;
        addAdditionlSpeed = speed9;
    } else if(scrollingSpeed == 10.0) {
        addAdditionlSpeed = speddd10;
        extraSpeed = 5;
        self.hero.speed = 2.0;
    }

    CGPoint point = CGPointMake(self.size.width, heroYAxis-10);

    if (obstacle != nil) {
        obstacle = nil;
    }

    obstacleCount = obstacleCount + 1;
    if (obstacleCount == 1) {

        scaleX = 1.0;
        scaleY = 1.4;
        speed = 1.36+addAdditionlSpeed+(0.025*extraSpeed);//2.7;// 1.5;//
        strImgName = OBSTACLE_STONE;

    } else if (obstacleCount == 2) {

        scaleY = 0.6;
        speed =  1.26+addAdditionlSpeed;//2.53;

        point = CGPointMake(self.size.width, heroYAxis-30);
        strImgName = OBSTACLE_CHASM;
        gunCount = 1;
        [powerGun removeFromParent];
    } else if (obstacleCount == 3) {

        speed = 1.33+addAdditionlSpeed+(0.025*extraSpeed);//1.306;//
        strImgName = OBSTACLE_GRASS_STONE;
        scaleY = 0.8;
    } else {

        scaleY = 0.6;
        speed =  1.26+addAdditionlSpeed;//2.53;

        point = CGPointMake(self.size.width, heroYAxis-30);
        strImgName = OBSTACLE_CHASM; //OBSTACLE_MOUNTAIN
        obstacleCount = 0;
    }

    obstacle = [[Obstacle alloc]initWithPosition:point withBackgroungTexture:[SKTexture textureWithImageNamed:strImgName]];
    obstacle.speed =  speed;
    obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(obstacle.size.width, 30)];
    obstacle.physicsBody.dynamic = NO;
    [obstacle runAction:[SKAction scaleXTo:scaleX y:scaleY duration:0.0]];
    [self addChild:obstacle];

    isCoinShow = YES;
    isMonsterOrObstacle = NO;
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
}

- (void)increaseSpeedOfScrollBackgroung:(int)speed {

    self.scrollingBackground.scrollingSpeed = speed;
}
- (void)addMonsterInNightView {

    if (isPauseGame == YES)  {
        [self repeatObstacleOntheWay];
        return;
    }

    NSString *strImgName;
    NSArray *arryMonster;
    CGFloat speed;
    CGFloat scale;
    CGFloat width = 0;
    NSString *monsterName = @"monster";

    CGFloat addAdditionlSpeed = 0;
    int extraSpeed = 0;

    int scrollingSpeed = self.scrollingBackground.scrollingSpeed;
    if (scrollingSpeed == 7.0) {
        extraSpeed = 1;
        addAdditionlSpeed = speed7;
    } else if(scrollingSpeed == 9.0) {
        extraSpeed = 1.4;
        addAdditionlSpeed = speed9;
    } else if(scrollingSpeed == 10.0) {
        addAdditionlSpeed = speddd10;
        extraSpeed = 2;
    }

    CGPoint point = CGPointMake(self.size.width, heroYAxis);
    if (obstacle != nil) {
        obstacle = nil;
    }
    monsterCount = monsterCount + 1;
    if (monsterCount < 6) {

        if (monsterCount == 1) {

            strImgName = SPRITES_SPIDER;
            arryMonster = SPRITES_ANIM_SPIDER;
            speed = 2.0 + extraSpeed;
            scale = 2.5;
            width = 20;

        } else if (monsterCount == 2){

            strImgName = SPRITES_MONSTER5;
            arryMonster = SPRITES_ANIM_MONSTER5;
            point = CGPointMake(self.size.width, heroYAxis+20);
            speed = 2.0 + extraSpeed;
            scale = 2.0;
            [self performSelector:@selector(addPowersOnFourhtViewWithPowerCount:) withObject:[NSNumber numberWithInt:1]afterDelay:4.8];//add power

        } else if (monsterCount == 3){

            strImgName = SPRITES_WOLF;
            arryMonster = SPRITE_MONSTER_WOLF;
            speed = 5.5 + extraSpeed ;
            scale = 0.7;
            monsterName = @"animal";
            [self performSelector:@selector(addPowersOnFourhtViewWithPowerCount:) withObject:[NSNumber numberWithInt:2]afterDelay:4.8];//add power

        } else  if (monsterCount == 4){

            batCount = 0;
            [self addBatsOnView];
            isMonsterOrObstacle = YES;

            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
            [self performSelector:@selector(addPowersOnFourhtViewWithPowerCount:) withObject:[NSNumber numberWithInt:1]afterDelay:4.8];//add power

            return;
        } else if (monsterCount == 5) {
        
            strImgName = SPRITES_TIGER;
            arryMonster = SPRITES_ANIM_TIGER;
            speed = 6.0 + extraSpeed;
            scale = 2.0;
            monsterName = @"animal";
            [self performSelector:@selector(addPowersOnFourhtViewWithPowerCount:) withObject:[NSNumber numberWithInt:3]afterDelay:4.5];//add power
        }

        Monster *monster = [[Monster alloc]initWithPosition:point withBackgroungTexture:[SKTexture textureWithImageNamed:strImgName]];
        [monster runAction:[SKAction scaleXTo:scale y:scale duration:0.0]];
        if (width == 0){
            width = monster.size.width;
        }
        monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(width, 30)];
        monster.physicsBody.dynamic = NO;

        monster.name = monsterName;
        [self addChild:monster];

        [monster runningTextureOfMonsterWithLocation:point withTextures:arryMonster];
        monster.speed = speed;
        isMonsterOrObstacle = YES;
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
        return;
    }

    [self addDragon];
}

- (void)addDragon {

    NSString *strImgName;
    NSArray *arryMonster;
    CGFloat speed;
    CGFloat scale;
    CGPoint point;
    CGFloat addAdditionlSpeed = 0;
    int extraSpeed = 0;

        //self.scrollingBackground.scrollingSpeed = 7.0;
    NSLog(@"%f",self.scrollingBackground.scrollingSpeed);

    int scrollingSpeed = self.scrollingBackground.scrollingSpeed;
    if (scrollingSpeed == 7.0) {
        extraSpeed = 1;
        addAdditionlSpeed = speed7;
    } else if(scrollingSpeed == 9.0) {
        extraSpeed = 1.4;
        addAdditionlSpeed = speed9;
    } else if(scrollingSpeed == 10.0) {
        addAdditionlSpeed = speddd10;
        extraSpeed = 2.4;
    }
    if (monsterCount == 6) {

        strImgName = SPRITES_DYNASOR;
        arryMonster = SPRITE_MONSTER_DYNASOR;

        speed = 2.2 + extraSpeed;
        scale = 2;
        point = CGPointMake(self.size.width, heroYAxis+20);
        [self performSelector:@selector(addPowersOnFourhtViewWithPowerCount:) withObject:[NSNumber numberWithInt:2]afterDelay:4.5];//add power
    } else  if (monsterCount == 7) {

        batCount = 0;
        [self addBatsOnView];
        isMonsterOrObstacle = YES;

        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(repeatObstacleOntheWay) userInfo:nil repeats:NO];
        monsterCount = 0;
        [self performSelector:@selector(addPowersOnFourhtViewWithPowerCount:) withObject:[NSNumber numberWithInt:3]afterDelay:4.5];//add power
        return;
    } else {

        strImgName = SPRITES_DYNASOR;
        arryMonster = SPRITE_MONSTER_DYNASOR;

        speed = 2.2 + extraSpeed;
        scale = 2;
        point = CGPointMake(self.size.width, heroYAxis+20);
        monsterCount = 0;
        [self performSelector:@selector(addGunPower) withObject:nil afterDelay:3.0];
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

- (void)addGunPower {
        //power_star

    SKSpriteNode *power = [[SKSpriteNode alloc]initWithImageNamed:@"coinWithStar"];
    power.name = @"Gun";
    power.physicsBody.dynamic = NO;
    power.speed = 1.4;
    power.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:power.size];
    power.position = CGPointMake(self.size.width, 130);
    [self addChild:power];

    SKAction *actionFire = [SKAction moveToX:0 duration:3.0];
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

        BatMan *batman = [[BatMan alloc]initWithPosition:CGPointMake(self.size.width + 50, yAxis) withBackgroungTexture:[SKTexture textureWithImageNamed:BAT_FOURTH]];
        [batman runAction:[SKAction scaleXTo:0.9 y:0.9 duration:0.0]];
        batman.speed = 3.5;
        batman.name = @"Bats";
        [self addChild:batman];
        [batman runningTextureOfBats:CGPointMake(0, batman.position.y) withTextures:SPRITE_MONSTER_BATS_FOURTHSCENE];

        batCount ++;

        [self performSelector:@selector(addBatsOnView) withObject:nil afterDelay:0.1];
    }
}

#pragma mark - Add power for richter

- (void)addPowersOnFourhtViewWithPowerCount:(NSNumber *)powerCount {

    if (powerCount.intValue == 1) {
        [self addSpecialPowersWithImgName:POWER_LION withPowerName:@"lion" withYAxis:140]; //fire power
    } else if (powerCount.intValue == 2) {
        [self addSpecialPowersWithImgName:POWER_BATS withPowerName:@"bats_fighter" withYAxis:150]; //fire power
    } else if (powerCount.intValue == 3) {
        [self addSpecialPowersWithImgName:POWER_DRAGON withPowerName:@"dragon_fighter" withYAxis:140]; //fire power
    }
}

#pragma mark - Add special power
- (void)addSpecialPowersWithImgName:(NSString *)strname withPowerName:(NSString *)powerName withYAxis:(CGFloat)yAxis {

    SKSpriteNode *power = [[SKSpriteNode alloc]initWithImageNamed:strname];
    power.name = powerName;
    [power runAction:[SKAction  scaleTo:1.2 duration:0.0]];
    power.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(33, 33)];
    power.physicsBody.dynamic = NO;
    power.position = CGPointMake(self.size.width, yAxis);
    [self addChild:power];

    SKAction *actionFire = [SKAction moveToX:-20 duration:2];
    SKAction *remove = [SKAction removeFromParent];
    [power runAction:[SKAction sequence:@[actionFire,remove]]];
}

#pragma mark - Find Contact of richer with monster , obstacle and with power
- (void)didBeginContact:(SKPhysicsContact *)contact {

    SKPhysicsBody *firstBody, *secondBody;

    firstBody = contact.bodyB;
    secondBody = contact.bodyA;

    SKSpriteNode *node1 = (SKSpriteNode *) firstBody.node;
    SKSpriteNode *node2 = (SKSpriteNode *) secondBody.node;

    NSLog(@"*** %@ ** %@", node1.name, node2.name);
    if (![node1.name isEqualToString:@"Weapon"] && ![node2.name isEqualToString:@"Weapon"]) {


        if (([node1.name isEqualToString:@"fire"] && [node2.name isEqualToString:@"Richter"]) || ([node2.name isEqualToString:@"fire"] && [node1.name isEqualToString:@"Richter"])|| ([node1.name isEqualToString:@"lion"] && [node2.name isEqualToString:@"Richter"]) || ([node2.name isEqualToString:@"lion"]&& [node1.name isEqualToString:@"Richter"]) || ([node2.name isEqualToString:@"bats_fighter"] &&[node1.name isEqualToString:@"Richter"]) || ([node1.name isEqualToString:@"bats_fighter"]&&[node2.name isEqualToString:@"Richter"]) || ([node1.name isEqualToString:@"dragon_fighter"] &&[node2.name isEqualToString:@"Richter"])|| ([node2.name isEqualToString:@"dragon_fighter"]&& [node1.name isEqualToString:@"Richter"])) {
            [self addPowerToRicher:node1 didGetPower:node2];
            [GRModelOfLifeScore updateScoreOfNodeWithSpecialPower];
            return;
        } else if ([node1.name isEqualToString:@"RichterPower"] || [node2.name isEqualToString:@"RichterPower"]) {

            [self fireOnDragonsByRicher:node1 didCollideWithMonster:node2]; //animation of nodes
            return;
        }
    }
    
    [self richer:node1 didCollideWithObstacle:node2];
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
    } else  if (([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"Gun"])) {

        gunCount = 0;
        [self addGunIcon];
        [obstacle1 removeFromParent];
        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfLife];
        return;
    } else if ([richer.name isEqualToString:@"Gun"] && [obstacle1.name isEqualToString:@"Richter"]) {

        gunCount = 0;
        [self addGunIcon];
        [richer removeFromParent];
        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        return;
    }

    if (sharedAppDelegate.nodes.count > 1) {

        if (([richer.name isEqualToString:@"Obstacle"] && [obstacle1.name isEqualToString:@"Richter"]) || ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"Obstacle"])) {

            [self lostRichterLife:obstacle1 withObstacle:richer];
        }  else if (([richer.name isEqualToString:@"animal"] && [obstacle1.name isEqualToString:@"Richter"]) || ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"animal"])) {

            [self lostRichterLife:obstacle1 withObstacle:richer];
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

    //convert obstacle into died animation
- (void)fireOnDragonsByRicher:(SKSpriteNode *)richer didCollideWithMonster:(SKSpriteNode *)monster {

    if ([richer.name isEqualToString:@"coin"]) { //richter and coin

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        [richer removeFromParent];
    } else if ([monster.name isEqualToString:@"coin"]) {

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        [monster removeFromParent];
    }

    if ([richer.name isEqualToString:@"Dragon"] || [richer.name isEqualToString:@"Bats"] || [richer.name isEqualToString:@"animal"]) {

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin];
        [richer runAction:[SKAction sequence:@[[SKAction animateWithTextures:SPRITE_FIRE_ON_DRAGON timePerFrame:1.0], [SKAction removeFromParent]]]];
    } else if ([monster.name isEqualToString:@"Dragon"] || [monster.name isEqualToString:@"Bats"] || [monster.name isEqualToString:@"animal"]){

        [monster runAction:[SKAction sequence:@[[SKAction animateWithTextures:SPRITE_FIRE_ON_DRAGON timePerFrame:1.0], [SKAction removeFromParent]]]];
        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin];
    }
}

- (void)addPowerToRicher:(SKSpriteNode *)richer didGetPower:(SKSpriteNode *)power  {

    [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin]; // update score

    if ([richer.name isEqualToString:@"lion"]) {

        [self addPowerButtonWithImage:POWER_LION withPowerNumber:0];
        [richer removeFromParent];
    } else if ( [power.name isEqualToString:@"lion"]) {

        [self addPowerButtonWithImage:POWER_LION withPowerNumber:0];
        [power removeFromParent];
    } else if ([richer.name isEqualToString:@"bats_fighter"]) {

        [self addPowerButtonWithImage:POWER_BATS withPowerNumber:1];
        [richer removeFromParent];
    } else if ([power.name isEqualToString:@"bats_fighter"]) {

        [self addPowerButtonWithImage:POWER_BATS withPowerNumber:1];
        [power removeFromParent];
    } else if ([richer.name isEqualToString:@"dragon_fighter"]) {

        [self addPowerButtonWithImage:POWER_DRAGON withPowerNumber:2];
        [richer removeFromParent];
    } else if ([power.name isEqualToString:@"dragon_fighter"]) {

        [self addPowerButtonWithImage:POWER_DRAGON withPowerNumber:2];
        [power removeFromParent];
    }
}

- (void)addGunIcon {

    powerGun = [[SKSpriteNode alloc]initWithImageNamed:@"gun"];
    powerGun.physicsBody.dynamic = NO;
    powerGun.position = CGPointMake(170, self.size.height - 28);
    powerGun.size = CGSizeMake(33, 33);
    [self addChild:powerGun];
}

#pragma mark - Add power button when richter has take power
- (void)addPowerButtonWithImage:(NSString *)imgName withPowerNumber:(int)powerNumber {

    NSString *strPower;
    switch (powerNumber) {
        case 0:
            yAxisOfRichtrPower = yAxisOfRichtrPower + 50;
            strPower = @"PowerBtnLion";
            break;

        case 1:
            strPower = @"PowerBtnBats";
            yAxisOfRichtrPower = yAxisOfRichtrPower + 50;
            break;

        case 2:
            yAxisOfRichtrPower = yAxisOfRichtrPower + 50;
            strPower = @"PowerBtnDragon";
            break;

        default:
            break;
    }

    SKSpriteNode *powerBtn = [[SKSpriteNode alloc]initWithImageNamed:imgName];
    powerBtn.name = strPower;
    powerBtn.size = CGSizeMake(44, 44);
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

            isRichterFlying = YES;
            [self.hero runAction:[BaseAction addPowerToRichter:texture withTimeInterval:0.09]withKey:@"power"];
            [self.hero runAction:[SKAction scaleTo:3.3 duration:0.0]];
            break;

        case 1:
            isRichterFlying = YES;
            [self.hero runAction:[BaseAction addPowerToRichter:texture withTimeInterval:0.09]withKey:@"power"];
            [self.hero runAction:[SKAction scaleTo:2.5 duration:0.0]];
            break;

        case 2:
            isRichterFlying = YES;
            [self.hero runAction:[BaseAction addPowerToRichter:texture withTimeInterval:.2]withKey:@"power"];
            [self.hero runAction:[SKAction scaleTo:4.0 duration:0.0]];
            break;

        case 5:
            [self.hero runAction:[BaseAction addPowerToRichter:texture withTimeInterval:.2]withKey:@"power"];
            [self.hero runAction:[SKAction scaleTo:2.0 duration:0.0]];
            break;

        default:
            break;
    }

   NSLog(@"%f %f", self.hero.size.width, self.hero.size.height);
    self.hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 130)];
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

        [self.hero removeFromParent];
        self.hero = nil;

        self.hero = [[RichterNode alloc]initWithPosition:CGPointMake(heroXAxis, heroYAxis-30) withBackgroungTexture:nil];
        self.hero.zPosition = 1.0;
        self.hero.speed = 2.0;
        [self addChild:self.hero];

        isSplPower = NO;
        isRichterFlying = NO;
    }
}

- (void)lostRichterLife:(SKSpriteNode *)richer withObstacle:(SKSpriteNode *)obstacle1 {

    if (isPauseGame == NO) {

        [self.hero richterRemoveRunAction];
        obstacle.paused = YES;

        NSLog(@"lost");
        [self.hero setTexture:[SKTexture textureWithImageNamed:RICHTER_DIE]];
        isPauseGame = YES;

        if (isJumpUp == NO) {
            [self.hero richterDiedAtLocation:self.hero.position withTexture:[SKTexture textureWithImageNamed:RICHTER_DIE]];
        }

            // [GRModelOfLifeScore removeNode:self];
        [NSTimer scheduledTimerWithTimeInterval:1.6 target:self selector:@selector(initializeHeroTextureFourthScene) userInfo:nil repeats:NO];
    }
}


#pragma mark - Add Coins

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
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addCoinsOnView) userInfo:nil repeats:NO];
        return;
    }
    [self repeatObstacleOntheWay];
}


#pragma mark - UITouch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInNode:self];

    CGRect rectSwipeUp = CGRectMake(0, 60, (self.size.width/2) ,self.size.height);//(self.size.width -  (self.size.width/3)
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
    } else if ([node.name isEqualToString:@"PowerBtnLion"]) {
        yAxisOfRichtrPower = yAxisOfRichtrPower - 50;
        [self powerBtnTapped:CGPointMake(heroXAxis, heroYAxis-15) withTextures:SPRITE_RICHTER_LION withPowerNumber:0];
        [node removeFromParent];
        return;
    } else if ([node.name isEqualToString:@"PowerBtnBats"]) {

        yAxisOfRichtrPower = yAxisOfRichtrPower - 50;
        [self powerBtnTapped:CGPointMake(heroXAxis, heroYAxis+5) withTextures:SPRITE_RICHTER_BATS withPowerNumber:1];
        [node removeFromParent];
        return;
    } else if ([node.name isEqualToString:@"PowerBtnDragon"]) {

        yAxisOfRichtrPower = yAxisOfRichtrPower - 50;
        [self powerBtnTapped:CGPointMake(heroXAxis, heroYAxis+5) withTextures:SPRITE_RICHTER_DRAGON withPowerNumber:2];
        [node removeFromParent];
        return;
    } else if ([node.name isEqualToString:@"PowerBtnWolf"]) {

        isRichterWolf = YES;
        [self powerBtnTapped:CGPointMake(120, heroYAxis-35) withTextures:SPRITE_RICHTER_WOLF withPowerNumber:5];
        [node removeFromParent];
        return;
    }
}


#pragma mark - fire when tapped on view

- (void)addWeaponWithLocation:(CGPoint)location {

    if (self.hero != nil && gunCount < 1 && isPauseGame == NO) {

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

- (void)playBackgroundMusic {

    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"ExploreThemeMusic" withExtension:@"mp3"];
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops = -1;
    [backgroundMusicPlayer prepareToPlay];
    backgroundMusicPlayer.volume = 5.0;
    [backgroundMusicPlayer play];
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

- (void)addPauseBtn {

    play = [[SKSpriteNode alloc]initWithImageNamed:@"pause"];
    play.position = CGPointMake(16, 14);
    play.name = @"pause";
    play.zPosition = 1.0;
    play.size = CGSizeMake(33,33);
    [self addChild:play];
}

@end
