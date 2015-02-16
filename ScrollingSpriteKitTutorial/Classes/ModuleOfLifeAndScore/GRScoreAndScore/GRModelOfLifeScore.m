//
//  GRModelOfLifeScoreAndDemo.m
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 08/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "GRModelOfLifeScore.h"

static NSMutableArray *arryOfNodes;
static GRNodeScore *nodeScore;

@implementation GRModelOfLifeScore

@synthesize grModelOfLifeScoreDlegate;

#pragma mark - Node life cycle

+ (id)initWithSize:(CGSize)size {

    if (self) {
        arryOfNodes = [[NSMutableArray alloc]init];
        arryOfNodes  = [self arryOfNodesWithSize:size];
    }
    return arryOfNodes;
}

#pragma mark - Add array of node with life and score

+ (NSMutableArray *)arryOfNodesWithSize:(CGSize)size {

    NSMutableArray *nodes = [[NSMutableArray alloc]init];
    int x = 40;
    for (int i=0; i<3 ; i++) { //life

        GRNodeLife *nodeLife = [[GRNodeLife alloc]initWithPosition:CGPointMake(x, size.height-27)];
        [nodes addObject:nodeLife];
        x = x + 30;
    }

    nodeScore = [[GRNodeScore alloc]initWithPosition:CGPointMake(size.width - 55, size.height - 38) withLabelFont:@"Arial"];
    nodeScore.text = @"0";
    [nodes addObject:nodeScore];

    return nodes;
}

#pragma mark - Update score of node

//when get stars
+ (void)updateScoreOfNodeWithScoreOfStar {

    NSInteger scoreCount = [GRModelOfLifeScore geNodeScore];
    scoreCount = scoreCount + 10;
    nodeScore.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:scoreCount]];
}

//when get life
+ (void)updateScoreOfNodeWithScoreOfLife {

    NSInteger scoreCount = [GRModelOfLifeScore geNodeScore];
    scoreCount = scoreCount + 15;
    nodeScore.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:scoreCount]];
}

//when kill monster
+ (void)updateScoreOfNodeWithScoreToKillMonster {

    NSInteger scoreCount = [GRModelOfLifeScore geNodeScore];
    scoreCount = scoreCount + 20;
    nodeScore.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:scoreCount]];
}

+ (void)updateScoreOfNodeWithScoreOfBirdAndCoin {

    NSInteger scoreCount = [GRModelOfLifeScore geNodeScore];
    scoreCount = scoreCount + 50;
    nodeScore.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:scoreCount]];
}

+ (void)updateScoreOfNodeWithSpecialPower {

    NSInteger scoreCount = [GRModelOfLifeScore geNodeScore];
    scoreCount = scoreCount + 40;
    nodeScore.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:scoreCount]];
}


+ (void)updateWithPowerOfEagleAndDragon {

    NSInteger scoreCount = [GRModelOfLifeScore geNodeScore];
    scoreCount = scoreCount + 30;
    nodeScore.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:scoreCount]];
}

#pragma mark - Get node score

+ (NSInteger)geNodeScore {

    return nodeScore.text.integerValue;
}

#pragma mark - Node life

//Remove node life
+ (void)removeNode:(id)sceneName {

    GRNodeLife *node;

    if (arryOfNodes.count > 1) {

        node = [arryOfNodes objectAtIndex:arryOfNodes.count-2];
        [arryOfNodes removeObject:node];
         [node removeFromParent];
    }
}

// Add extra life
+ (GRNodeLife *)addNodeLife {

    GRNodeLife *nodeLife;
    int xAxis;
    int yAxis;

    if(arryOfNodes.count > 1) {

        nodeLife = [arryOfNodes objectAtIndex:arryOfNodes.count - 2];
        xAxis =  nodeLife.frame.origin.x + nodeLife.frame.size.width + 35;
        yAxis = nodeLife.frame.origin.y + 25;
    } else {

        nodeLife = [arryOfNodes objectAtIndex:arryOfNodes.count - 1];
        xAxis = 30;
        yAxis = nodeLife.frame.origin.y + 25;
    }

    GRNodeLife *nodeLife1 = [[GRNodeLife alloc]initWithPosition:CGPointMake(xAxis, yAxis)];
    [arryOfNodes addObject:nodeLife];
    return nodeLife1;
}

@end
