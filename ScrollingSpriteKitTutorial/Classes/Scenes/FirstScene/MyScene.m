//
//  MyScene.m
//  ScrollingSpriteKitTutorial
//
//  Created by Arthur Knopper on 13-03-14.
//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//


#import "MyScene.h"
#import "sprites.h"
#import "RichterNode.h"
#import "BaseAction.h"
#import "Obstacle.h"
#import "sprites.h"
#import "Coin.h"
#import "Eagle.h"
#import "Monster.h"
#import "MonsterCollection.h"

#import "GameOverScene.h"
#import <AVFoundation/AVFoundation.h>
#import "GRModelOfLifeScore.h"

#define heroYAxisFirstVw ((IS_IPHONE_6P) ? 50 : 40)
#define heroXAxis 100

@interface MyScene () <scrollVwDelegate> {

    Obstacle *obstacle;
    int obstacleCount;
    int monsterCount;
    int scrollBg;
    int coinCount;

    BOOL isCoinShow;
    BOOL isPauseGame;
    BOOL isJumpUp;
    BOOL isMonsterOrObstacle;
    BOOL isPowerAdd;
    BOOL isIntersectFireArea;

    CGPoint touchLocation;
    SKSpriteNode *play;
    SKSpriteNode *powerGun;
    AVAudioPlayer * backgroundMusicPlayer;

}

@end

/*static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

    // Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
} */

@implementation MyScene

#pragma mark - View life cycle

#pragma mark - Essential and Change Restricted Function

- (id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {

        NSString *imageName;
        if (IS_IPHONE_6P) {
            imageName = @"gr_iPhone6@2x.png";
        } else {
            imageName = @"gr@2x.png";
        }
		self.scaleMode = SKSceneScaleModeFill;
        self.physicsWorld.gravity = CGVectorMake(0,0);
        
        self.scrollingBackground = [ScrollingBackground scrollingNodeWithImageNamed:imageName inContainerWidth:size.width withSpeed:7.0];
        self.scrollingBackground.delegate = self;

        [self addChild:self.scrollingBackground];
        [self initializeHeroTexture];
        [self performSelector:@selector(arrowToMakeRichterAction) withObject:nil afterDelay:2];
        [self repeatObstacleOntheWay];

        [self addPauseBtn];

        [self playBackgroundMusic];
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

- (void)update:(CFTimeInterval)currentTime {

    if(isPauseGame == NO){
        [self.scrollingBackground update:currentTime];
    }
}

- (void)didMoveToView:(SKView *)view {

    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:recognizer];

    UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizerDown];

    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];

    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
}

- (void)playBackgroundMusic {

    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"find-the-key" withExtension:@"mp3"];
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops = -1;
    backgroundMusicPlayer.volume = 5.0;
    [backgroundMusicPlayer prepareToPlay];
    [backgroundMusicPlayer play];
}

#pragma mark - Add Coins

- (void)addCoins {

    if (isPauseGame == YES)  {
        [self repeatObstacleOntheWay];
        return;
    }

    Coin *coin = [[Coin alloc]initWithPosition:CGPointMake(self.size.width, heroYAxisFirstVw+60) withBackgroungTexture:nil];
    [self addChild:coin];

    coinCount ++;
    if (coinCount == 5) {
        isCoinShow = NO;
        coinCount = 0;//5;
    }
    [self repeatObstacleOntheWay];
}

- (void)addGunPower {
        //power_star

    SKSpriteNode *power = [[SKSpriteNode alloc]initWithImageNamed:@"coinWithStar"];
    power.name = @"Gun";
    power.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:power.size];
    power.physicsBody.dynamic = YES;
    power.physicsBody.collisionBitMask = 0.0;
    power.speed = 1.4;
    power.position = CGPointMake(self.size.width, 130);
    [self addChild:power];

    SKAction *actionFire = [SKAction moveToX:0 duration:2.5];
    SKAction *remove = [SKAction removeFromParent];
    [power runAction:[SKAction sequence:@[actionFire,remove]]];
}

- (void)addCoinsAtUpAndDown {

    int x = self.size.width;
    int y = heroYAxisFirstVw;
    for (int i=1; i<=4 ; i++) {

        Coin *coin = [[Coin alloc]initWithPosition:CGPointMake(x, y) withBackgroungTexture:nil];
        [self addChild:coin];

        x = x-40;
        if (i%2){
            y = heroYAxisFirstVw+90;
        } else {
            y = heroYAxisFirstVw;
        }
    }

    isCoinShow = NO;
    coinCount = 0;
    [self repeatObstacleOntheWay];
}

#pragma mark - Changable Function

- (void)handleSwipe:(UISwipeGestureRecognizer*)recognizer {

    if (isIntersectFireArea == YES) {
        isIntersectFireArea = NO;
        return;
    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {

        if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
            [self.hero turnLeftOfRichterWithLocation:self.hero.position];
        } else if (recognizer.direction == UISwipeGestureRecognizerDirectionUp){

            if (isPauseGame == NO) {

                isJumpUp = YES;
                [self.hero richterRemoveRunAction];

                self.view.userInteractionEnabled = NO;

                [self.hero jumpUpOfRichter:self.hero.position withUpTexture:SPRITES_ANIM_JUMP_UP textureDown:SPRITES_ANIM_JUMP_UP_DOWN Duration:1.0];
                [NSTimer scheduledTimerWithTimeInterval:1.4 target:self selector:@selector(jumpDownFromUpOfHero) userInfo:nil repeats:NO];
            }
        } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            [self.hero turnRightOfRichterWithLocation:self.hero.position];
        } else {
            [self.hero turnLeftOfRichterWithLocation:self.hero.position];

        }
    }
}

#pragma mark - Hero's Action

- (void)jumpDownFromUpOfHero {

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInNode:self.scene];

    SKNode *node = [self nodeAtPoint:touchLocation];
    if ([node.name isEqualToString:@"pause"]) {
        [self playBtnTapped:@"pause"];
        node.name = @"playBtn";
        play.texture  = [SKTexture textureWithImageNamed:@"playBtn"];
    } else  if ([node.name isEqualToString:@"playBtn"]){
        [self playBtnTapped:@"playBtn"];
        node.name = @"pause";
        play.texture  = [SKTexture textureWithImageNamed:@"pause"];
    }

    CGRect rectSwipeUp = CGRectMake(0, 0, (self.size.width/2) ,self.size.height);//(self.size.width -  (self.size.width/3)
    if (CGRectContainsPoint(rectSwipeUp, touchLocation)) {

        isIntersectFireArea = YES;
        if(isPowerAdd == YES) {
            [self addWeaponWithLocation:CGPointMake(568, self.hero.position.y)];
        }
    } else {
        isIntersectFireArea = NO;
    }
}

- (void)initializeHeroTexture {

    obstacle.paused = NO;

    [self.hero removeFromParent];

    if (self.hero != nil) {
        self.hero = nil;
    }
    self.hero = [[RichterNode alloc]initWithPosition:CGPointMake(heroXAxis, heroYAxisFirstVw) withBackgroungTexture:nil];
    [self addChild:self.hero];
    isPauseGame = NO;

    self.hero.physicsBody.dynamic = NO;
    self.hero.alpha = 0.5;
    self.hero.speed = 1.5;
    self.hero.zPosition = 0.0;

    [UIView animateWithDuration:4.0 animations:^{
        [self.hero runAction:[SKAction fadeInWithDuration:4.0]];
    } completion:^(BOOL finished) {

        [self performSelector:@selector(setDyanamisBodyOfRichter) withObject:nil afterDelay:1.6];
        [self performSelector:@selector(addGunPower) withObject:nil afterDelay:0.7];
    }];
}

- (void)setDyanamisBodyOfRichter {
    self.hero.physicsBody.dynamic = YES;
}

#pragma mark - Scroll View Delegate

- (void)scrollBackgroundVwDone {

    Eagle *eagle = [[Eagle alloc]initWithPosition:CGPointMake(30, 200) withBackgroungTexture:[SKTexture textureWithImageNamed:@"eagle1"]];
    [self addChild:eagle];
    eagle.speed = 2.2;
    [eagle runAction:[BaseAction flyingOfEagle:CGPointMake(self.hero.position.x, self.hero.position.y+35)]];

    scrollBg ++;

    if (scrollBg == 30) {//30

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
    if (isPowerAdd == NO && scrollBg%5 == 0) {
        [self addGunPower];
    }
}

- (void)addMonster {

    if (isPauseGame == YES)  {
        [self repeatObstacleOntheWay];
        return;
    }

    NSString *strImgName;
    NSArray *arryMonster;
    CGFloat speed;
    CGFloat scale;

    CGPoint point = CGPointMake(self.size.width, heroYAxisFirstVw+25);
    if (obstacle != nil) {
        obstacle = nil;
    }
    monsterCount = monsterCount + 1;
    if (monsterCount == 1) {
        strImgName = @"snake1";
        arryMonster = SNAKE;
        speed = 1.6;
        scale = 2.0;
    } else if (monsterCount == 2){
        strImgName = SPRITES_SPIDER;
        arryMonster = SPRITES_ANIM_SPIDER;
        speed = 3.0;
        scale = 2.0;
    } else {
        strImgName = SPRITES_MONSTER5;
        arryMonster = SPRITES_ANIM_MONSTER5;
        speed = 2.5;
        scale = 2.0;
        monsterCount = 0;
        point = CGPointMake(self.size.width, heroYAxisFirstVw+60);
    }
    Monster *monster = [[Monster alloc]initWithPosition:point withBackgroungTexture:[SKTexture textureWithImageNamed:strImgName]];
    [monster runAction:[SKAction scaleXTo:scale y:scale duration:0.0]];
    monster.name = @"monster";
    [self addChild:monster];

    [monster runningTextureOfMonsterWithLocation:point withTextures:arryMonster];
    monster.speed = speed;
    isMonsterOrObstacle = YES;
    [self repeatObstacleOntheWay];
}

#pragma mark - Add obstacle

- (void)addObstacleSprideNode {

    CGFloat speed = 1.95; //0.9
    if (isPauseGame == YES)  {
        [self repeatObstacleOntheWay];
        return;
    }
    NSString *strImgName;
    CGPoint point = CGPointMake(self.size.width, heroYAxisFirstVw+20);

    if (obstacle != nil) {
        obstacle = nil;
    }
    obstacleCount = obstacleCount + 1;
    
    if (obstacleCount == 1) {
        strImgName = OBSTACLE_STONE;
    } else {
        strImgName = OBSTACLE_TREE;
        obstacleCount = 0;
    }

    obstacle = [[Obstacle alloc]initWithPosition:point withBackgroungTexture:[SKTexture textureWithImageNamed:strImgName]];
    [self addChild:obstacle];
    obstacle.speed = speed;
    [obstacle runAction:[SKAction scaleXTo:1.5 y:1 duration:0.0]];

    isCoinShow = YES;
    isMonsterOrObstacle = NO;
    [self repeatObstacleOntheWay];
}

- (void)addGunIcon {

    powerGun = [[SKSpriteNode alloc]initWithImageNamed:@"gun"];
    powerGun.physicsBody.dynamic = NO;
    powerGun.position = CGPointMake(170, self.size.height - 28);
    [self addChild:powerGun];
}

- (void)repeatObstacleOntheWay {

    if (isCoinShow == NO) {
        if (isMonsterOrObstacle == YES ) {
          [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(addObstacleSprideNode) userInfo:nil repeats:NO];
        } else {
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addMonster) userInfo:nil repeats:NO];
        }
    } else {
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(addCoins) userInfo:nil repeats:NO];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact {

    SKPhysicsBody *firstBody, *secondBody;

    firstBody = contact.bodyB;
    secondBody = contact.bodyA;

    [self richer:(SKSpriteNode *) firstBody.node didCollideWithObstacle:(SKSpriteNode *) secondBody.node];
}

- (void)richer:(SKSpriteNode *)richer didCollideWithObstacle:(SKSpriteNode *)obstacle1 {

    if (([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"eagle1"]) || ([richer.name isEqualToString:@"eagle1"] && [obstacle1.name isEqualToString:@"Richter"])) {
        return;
    } else if ([richer.name isEqualToString:@"coin"] && [obstacle1.name isEqualToString:@"Richter"]){

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        [richer removeFromParent];
        return;
    } else if (([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"coin"])){

        [GRModelOfLifeScore updateScoreOfNodeWithScoreOfStar];
        [obstacle1 removeFromParent];
        return;
    } else  if (([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"Gun"])) {

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

        if (([richer.name isEqualToString:@"Obstacle"] && [obstacle1.name isEqualToString:@"Richter"]) || ([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"Obstacle"])) {

            [self lostRichterLife:richer withObstacle:obstacle1];
        } else if (([richer.name isEqualToString:@"Weapon"] && [obstacle1.name isEqualToString:@"monster"]) || ([richer.name isEqualToString:@"monster"] && [obstacle1.name isEqualToString:@"Weapon"])) {

            [self monsterDeadAnimation:obstacle1];
            [GRModelOfLifeScore updateScoreOfNodeWithScoreToKillMonster];
            [richer removeFromParent];
        } else if (([richer.name isEqualToString:@"Richter"] && [obstacle1.name isEqualToString:@"monster"]) || ([richer.name isEqualToString:@"monster"] && [obstacle1.name isEqualToString:@"Richter"])) {

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

- (void)monsterDeadAnimation:(SKSpriteNode *)monster {

    [monster removeFromParent];

    [GRModelOfLifeScore updateScoreOfNodeWithScoreOfBirdAndCoin];

    SKSpriteNode *monsterDeadAnim = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"Fire1"]];
    monsterDeadAnim.physicsBody.dynamic = NO;
    monsterDeadAnim.size = CGSizeMake(33, 33);
    [self addChild:monsterDeadAnim];

    [monsterDeadAnim runAction:[SKAction sequence:@[[SKAction animateWithTextures:SPRITE_MONSTER_DEAD timePerFrame:1.0]]]];
}

- (void)lostRichterLife:(SKSpriteNode *)richer withObstacle:(SKSpriteNode *)obstacle1 {

    if (isPauseGame == NO) {

        obstacle.paused = YES;
        [self.hero setTexture:[SKTexture textureWithImageNamed:RICHTER_DIE]];
        [self.hero richterRemoveRunAction];

        isPowerAdd = NO;
        [powerGun removeFromParent];

        isPauseGame = YES;
        [GRModelOfLifeScore removeNode:self];

        if (isJumpUp == NO) {
            [self.hero  richterDiedAtLocation:self.hero.position withTexture:[SKTexture textureWithImageNamed:RICHTER_DIE]];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(initializeHeroTexture) userInfo:nil repeats:NO];
        } else {
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(initializeHeroTexture) userInfo:nil repeats:NO];
        }
    }
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

- (void)arrowToMakeRichterAction {

    SKSpriteNode *arrow = [[SKSpriteNode alloc]initWithImageNamed:@"upArrow"];
    arrow.position = CGPointMake(heroXAxis, heroYAxisFirstVw + 70);
    arrow.name = @"upArrow";
    arrow.size = CGSizeMake(33,33);
    [self addChild:arrow];

    SKAction *action = [SKAction moveTo:CGPointMake(heroXAxis+10, heroYAxisFirstVw + 50 + 70) duration:0.2];
    SKAction *action1 = [SKAction moveTo:CGPointMake(heroXAxis+10, heroYAxisFirstVw + 70) duration:0.2];

    SKAction *sequence = [SKAction sequence:@[action, action1, action, action1, action, action1, action, action1, [SKAction removeFromParent]]];
    [arrow runAction: sequence];
}

@end
