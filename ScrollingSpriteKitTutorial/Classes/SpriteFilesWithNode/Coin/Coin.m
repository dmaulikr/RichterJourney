//
//  Monster.m
//  GoalingBall
//
//  Created by GrepRuby on 29/12/14.
//  Copyright (c) 2014 GrepRuby. All rights reserved.
//

#import "Coin.h"

@implementation Coin

- (instancetype)initWithPosition:(CGPoint)position withBackgroungTexture:(SKTexture *)textureBg {

    if(self = [super initWithPosition:position withBackgroungTexture:nil]) {

        self = [self initWithImageNamed:@"coin"];
        [self addCoinsWithPosition:position];
    }
    return self;
}

#pragma mark- Add monster

- (void)addCoinsWithPosition:(CGPoint)position {

    // Create sprite
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.collisionBitMask = 0.0;
    self.name = @"coin";
    self.physicsBody.categoryBitMask = coinCategory;
    self.physicsBody.contactTestBitMask =  RichterCategory;
    self.physicsBody.usesPreciseCollisionDetection = YES;

    // and along a random position along the Y axis as calculated above
    self.position = CGPointMake(position.x, position.y);

    SKAction *actionMove = [SKAction moveTo:CGPointMake(-20, position.y) duration:1.0];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

@end
