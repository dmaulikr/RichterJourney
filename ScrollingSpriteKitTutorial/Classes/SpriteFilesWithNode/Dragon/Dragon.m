//
//  Richter.m
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 02/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "Dragon.h"
#import "BaseAction.h"

@implementation Dragon

- (instancetype)initWithPosition:(CGPoint)position withBackgroungTexture:(SKTexture *)textureBg {

    if(self = [super initWithPosition:position withBackgroungTexture:nil]) {

        self = [self initWithTexture:textureBg];
        [self addObstacleWithPosition:position];
    }
    return self;
}


#pragma mark- Add monster

- (void)addObstacleWithPosition:(CGPoint)position {

    // Create sprite
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width,70)];
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask =  monsterCategory;
    self.physicsBody.contactTestBitMask =  RichterCategory|weaponShipCategory;
    // and along a random position along the Y axis as calculated above
    self.name = @"Dragon";
        //self.physicsBody.collisionBitMask = 0;
    self.position = CGPointMake(position.x+self.size.width, position.y);
}

- (void)runningTextureOfDragonWithLocation:(CGPoint)location withTextures:(NSArray *)arryTexture withInterval:(NSTimeInterval)timeInterval {

    [self runAction:[BaseAction monsterActionWithTexture:arryTexture ofLocation:location withTimeFrame:timeInterval]];
}

@end
