//
//  SuperScene.m
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 09/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "BaseScene.h"
#import "GRModelOfLifeScore.h"

@implementation BaseScene

#pragma mark - View life cycle

- (id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {

        self.physicsWorld.gravity = CGVectorMake(0,0);

        if (sharedAppDelegate.nodes == nil) {

            sharedAppDelegate.nodes = [[NSMutableArray alloc]init];
            id arryOfNode = [GRModelOfLifeScore initWithSize:CGSizeMake(self.size.width, self.size.height)];
            sharedAppDelegate.nodes = (NSMutableArray *)arryOfNode; //Add Nodes
        }
        
        self.physicsWorld.contactDelegate = self;

        [self spriteNodeOfBackgroundOfLife:size];
        [self addNodeLife];
    }
    return self;
}

#pragma mark - Add node life

- (void)addNodeLife {

        //Add nodes on scene
    for (id node in sharedAppDelegate.nodes) {
        [node removeFromParent];
    }
    for (id node in sharedAppDelegate.nodes) {
        [self addChild:node];
    }
}

- (void)spriteNodeOfBackgroundOfLife:(CGSize)size {

    SKSpriteNode *spriteNodeLifeBg = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"board"]];
    spriteNodeLifeBg.position = CGPointMake(62, size.height - 27);
    spriteNodeLifeBg.size = CGSizeMake(140, 35);
    spriteNodeLifeBg.zPosition = 1.0;
    [self addChild:spriteNodeLifeBg];

    SKSpriteNode *spriteNodeLife = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"head"]];
    spriteNodeLife.position = CGPointMake(10, size.height - 25);
    spriteNodeLife.size = CGSizeMake(20, 20);
    spriteNodeLife.zPosition = 1;
    [self addChild:spriteNodeLife];

    SKSpriteNode *spriteNodeNumber = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"Score"]];
    spriteNodeNumber.position = CGPointMake(size.width - 55, size.height - 30);
    spriteNodeNumber.size = CGSizeMake(100, 40);
    spriteNodeNumber.zPosition = 1;
    [self addChild:spriteNodeNumber];
}

@end
