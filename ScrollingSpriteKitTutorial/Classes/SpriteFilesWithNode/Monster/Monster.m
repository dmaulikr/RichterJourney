//
//  Richter.m
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 02/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "Monster.h"
#import "sprites.h"
#import "BaseAction.h"

@implementation Monster

- (instancetype)initWithPosition:(CGPoint)position withBackgroungTexture:(SKTexture *)textureBg {

    if(self = [super initWithPosition:position withBackgroungTexture:nil]) {

        self = [self initWithTexture:textureBg];
        [self addObstacleWithPosition:position withTexture:textureBg];
        self.position = CGPointMake(position.x, position.y);

    }
    return self;
}


#pragma mark- Add monster

- (void)addObstacleWithPosition:(CGPoint)position withTexture:(SKTexture *)textureBg {

    CGFloat width;
    if (self.size.width > 60) {
        width = self.size.width - 100;
    }
    CGSize size = CGSizeMake(5, self.size.height);//(width, self.size.height);
    // Create sprite
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.color = [UIColor redColor];
    self.color = [SKColor blackColor];
        //self.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(10,0) toPoint:CGPointMake(50, 30)];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];//CGSizeMake(30,60)];
    self.physicsBody.dynamic = NO;
    self.name = @"monster";
    self.physicsBody.categoryBitMask =  monsterCategory;
    self.physicsBody.collisionBitMask = 0.0;
    self.physicsBody.contactTestBitMask =  RichterCategory|weaponShipCategory;
        // and along a random position along the Y axis as calculated above
}

- (void)runningTextureOfMonsterWithLocation:(CGPoint)location withTextures:(NSArray *)arryTexture {

    [self runAction:[BaseAction monsterActionWithTexture:arryTexture ofLocation:location withTimeFrame:0.2]];
}

@end
