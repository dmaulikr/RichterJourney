//
//  Richter.m
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 02/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle

- (instancetype)initWithPosition:(CGPoint)position withBackgroungTexture:(SKTexture *)textureBg {

    if(self = [super initWithPosition:position withBackgroungTexture:nil]) {

        self = [self initWithTexture:textureBg];
        [self addObstacleWithPosition:CGPointMake(position.x + self.size.width, position.y)];
        self.size = CGSizeMake(self.size.width,self.size.height);
    }
    return self;
}


#pragma mark- Add monster

- (void)addObstacleWithPosition:(CGPoint)position {

    // Create sprite
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30, 40)];
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask =  monsterCategory;
    self.physicsBody.contactTestBitMask =  RichterCategory;
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, 0.0);
    self.physicsBody.collisionBitMask = 0.0;
    self.name = @"Obstacle";

    // and along a random position along the Y axis as calculated above
    self.position = CGPointMake(position.x, position.y);

    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-200, position.y) duration:4];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}


@end
