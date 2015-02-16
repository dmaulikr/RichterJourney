//
//  GRModelOfLifeScoreAndDemo.hscore
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 08/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GRNodeLife.h"
#import "GRNodeScore.h"
#import "MyScene.h"

@protocol GRModelOfLifeScoreDlegate;

@interface GRModelOfLifeScore : NSObject {
    
}

@property (unsafe_unretained)id <GRModelOfLifeScoreDlegate> grModelOfLifeScoreDlegate;

#pragma mark - Essential and Change restricted Function
/*
 This function is used to initializse hero's life and score at starting time of game.
 This Function is mendatory to use this module.
 */
+ (id)initWithSize:(CGSize)size;

    //get Score
+ (NSInteger)geNodeScore;

/*
 This function is used to add node's other life.
 */
+ (GRNodeLife *)addNodeLife;

/*
 This function is used to remove node's life when node is die.
 */
+ (void)removeNode:(id)sceneName;


#pragma mark - Changable function
/*
 In all given function changes can perform according to requirment to increase hero score.
 */

+ (void)updateScoreOfNodeWithScoreOfStar;
+ (void)updateScoreOfNodeWithScoreOfLife;
+ (void)updateScoreOfNodeWithScoreToKillMonster;
+ (void)updateScoreOfNodeWithScoreOfBirdAndCoin;
+ (void)updateWithPowerOfEagleAndDragon;
+ (void)updateScoreOfNodeWithSpecialPower;


@end

@protocol GRModelOfLifeScoreDlegate <NSObject>

@end
