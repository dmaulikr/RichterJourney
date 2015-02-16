//
//  GameOverScene.m
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "GameOverScene.h"
#import "MyScene.h"
#import "SecondScene.h"
#import "ThirdScene.h"
#import "GRModelOfLifeScore.h"
#import "ViewController.h"

@implementation GameOverScene
@synthesize gameOverdelegate;

#pragma mark - Initialize view with size

- (id)initWithSize:(CGSize)size won:(BOOL)won withCurrentScene:(SKScene *)scene {

    if (self = [super initWithSize:size]) {

        self.view.userInteractionEnabled = YES;
        isWon = won;
        sceneName = scene;

        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

        SKSpriteNode *scoreNode = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"scoreBoard"]];
        scoreNode.position = CGPointMake(self.size.width/2 , self.size.height/2);
        [self addChild:scoreNode];

        SKSpriteNode *richterScore = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"ScoreRichter"]];
        richterScore.position = CGPointMake(self.size.width - 90 , self.size.height - 70);
        richterScore.size = CGSizeMake(richterScore.size.width*2, richterScore.size.height*2);
            //[self addChild:richterScore];

        SKLabelNode *lblNodeCongratulation = [[SKLabelNode alloc]initWithFontNamed:@"Zapfino"];
        lblNodeCongratulation.physicsBody.dynamic = NO;
        if (won == YES) {
            lblNodeCongratulation.fontColor = [UIColor colorWithRed:38/256.0f green:94/256.0f blue:44/256.0f alpha:1.0];
            lblNodeCongratulation.text = @"Congratulation!!!";
        } else {
            lblNodeCongratulation.fontColor = [UIColor redColor];
            lblNodeCongratulation.text = @"Game Over";
        }
        lblNodeCongratulation.zPosition = 1.0;
        lblNodeCongratulation.fontSize = 27.0;
        lblNodeCongratulation.position = CGPointMake((self.size.width)/2+50 , (self.size.height - 100));
        lblNodeCongratulation.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [self addChild:lblNodeCongratulation];

        SKLabelNode *label = [[SKLabelNode alloc]initWithFontNamed:@"Zapfino"];
        label.text = [NSString stringWithFormat:@"Coins Score - %ld", (long)[GRModelOfLifeScore geNodeScore]];
        label.fontSize = 20;
        label.fontColor = [SKColor redColor];
        [self addChild:label];

        if (isWon == YES) {

            SKLabelNode *lblNodeTapHere = [[SKLabelNode alloc]initWithFontNamed:@"Zapfino"];
            lblNodeTapHere.physicsBody.dynamic = NO;
            lblNodeTapHere.fontColor = [UIColor blueColor];
            if (won == YES) {
                lblNodeTapHere.text = @"Tap to go to next lavel.";
            } else {
                lblNodeTapHere.text = @"Tap to go to lavel";
            }
            lblNodeTapHere.zPosition = 1.0;
            lblNodeTapHere.fontSize = 20.0;
            lblNodeTapHere.position = CGPointMake((self.size.width)/2+45, lblNodeCongratulation.frame.origin.y - 30);
            lblNodeTapHere.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            [self addChild:lblNodeTapHere];

            label.position = CGPointMake(self.size.width/2 + 35 , lblNodeTapHere.frame.origin.y - 40 );
        } else {
            label.position = CGPointMake(self.size.width/2 + 35 , lblNodeCongratulation.frame.origin.y - 40 );

            SKLabelNode *quit = [[SKLabelNode alloc]initWithFontNamed:@"Zapfino"];
            quit.text = @"Main Menu";
            quit.name = @"quit";
            quit.zPosition = 1.0;
            quit.position = CGPointMake(self.size.width/2 - 30, label.frame.origin.y - 60 );
            quit.fontSize = 17;
            quit.fontColor = [SKColor blackColor];
            [self addChild:quit];


            SKLabelNode *restart = [[SKLabelNode alloc]initWithFontNamed:@"Zapfino"];
            restart.text = @"Play Again";
            restart.zPosition = 1.0;
            restart.position = CGPointMake(self.size.width/2 + 120, label.frame.origin.y - 60 );
            restart.name = @"restart";
            restart.fontSize = 17;
            restart.fontColor = [SKColor brownColor];
            [self addChild:restart];
        }
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {

    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        recognizer.enabled = NO;
        [self.view removeGestureRecognizer:recognizer];
    }

//    recognizerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapped:)];
//    recognizerTapGesture.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:recognizerTapGesture];
}

//- (void)handleTapped:(UITapGestureRecognizer *)recognizer {
//
//    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
//        recognizer.enabled = NO;
//        [self.view removeGestureRecognizer:recognizer];
//    }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (isWon == YES) {
        [self tappedToGoToNextView];
    } else {

        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];

        SKNode *node = [self nodeAtPoint:touchLocation];
        
        if ([node.name isEqualToString:@"restart"]) {

            [sharedAppDelegate.nodes removeAllObjects];
            sharedAppDelegate.nodes = nil;
            [self tappedToGoToNextView];
        } else if ([node.name isEqualToString:@"quit"]){

            [sharedAppDelegate.nodes removeAllObjects];
            sharedAppDelegate.nodes = nil;

            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                //Call on the RootViewController to present the New View Controller
            [self.view.window.rootViewController presentViewController:vc animated:NO completion:nil];
        }
    }
}

- (void)tappedToGoToNextView {

    if (isWon == YES) {

        if ([sceneName isKindOfClass:[MyScene class]]) {

            [self runAction:[SKAction sequence:@[[SKAction runBlock:^{

                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.0];
                SKScene * myScene = [[SecondScene alloc] initWithSize:self.size];
                [self.view presentScene:myScene transition: reveal];
            }]]]];

        } else if ([sceneName isKindOfClass:[SecondScene class]]) {

            [self runAction:[SKAction sequence:@[[SKAction runBlock:^{

                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.0];
                SKScene * myScene = [[ThirdScene alloc] initWithSize:self.size];
                [self.view presentScene:myScene transition: reveal];
            }]]]];

        }
    } else {
        if ([sceneName isKindOfClass:[MyScene class]]) {

            [self runAction:[SKAction sequence:@[[SKAction runBlock:^{

                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.0];
                SKScene * myScene = [[MyScene alloc] initWithSize:self.size];
                [self.view presentScene:myScene transition: reveal];
            }]]]];

        } else if ([sceneName isKindOfClass:[SecondScene class]]) {

            [self runAction:[SKAction sequence:@[[SKAction runBlock:^{

                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.0];
                SKScene * myScene = [[SecondScene alloc] initWithSize:self.size];
                [self.view presentScene:myScene transition: reveal];
            }]]]];
        } else {

            [self runAction:[SKAction sequence:@[[SKAction runBlock:^{

                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.0];
                SKScene * myScene = [[ThirdScene alloc] initWithSize:self.size];
                [self.view presentScene:myScene transition: reveal];
            }]]]];
        }
    }
}

- (void)gotoOtherSceneAfterWon {

    SKTransition *transition = [SKTransition fadeWithDuration:0.0];
    SecondScene *gameOver = [[SecondScene alloc]initWithSize:self.size];
    [self.view presentScene:gameOver transition:transition];
}


@end
