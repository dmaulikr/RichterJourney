//
//  CommanAction.m
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 12/01/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import "BaseAction.h"
#import "sprites.h"

@implementation BaseAction

#pragma mark - Walking of node

+ (SKAction *)walkOfNode {

    SKAction *walk = [SKAction animateWithTextures:SPRITES_ANIM_WALK timePerFrame:0.09];
    SKAction *resetDirection   = [SKAction scaleXTo:1 y:1 duration:0.0];
    SKAction *walkAndMove = [SKAction group:@[resetDirection,walk]];
    SKAction *repeatAction = [SKAction repeatActionForever:walkAndMove];
    return repeatAction;
}

+ (SKAction *)walkOfNodeWithWeapon {

    SKAction *walk = [SKAction animateWithTextures:SPRITES_ANIM_WALK_WITH_WEAPON timePerFrame:0.09];
    SKAction *resetDirection   = [SKAction scaleXTo:1 y:1 duration:0.0];
    SKAction *walkAndMove = [SKAction group:@[resetDirection,walk]];
    return walkAndMove;
}

//+ (SKAction *)walkOfNode {
//
//    SKAction *walk = [SKAction animateWithTextures:SPRITES_ANIM_WALK timePerFrame:0.09];
//    SKAction *resetDirection   = [SKAction scaleXTo:1 y:1 duration:0.0];
//    SKAction *walkAndMove = [SKAction group:@[resetDirection,walk]];
//    SKAction *repeatAction = [SKAction repeatActionForever:walkAndMove];
//    return repeatAction;
//}

#pragma mark - Jumping of node

+ (SKAction *)jumpDownOfNode {

    SKAction *jumpDown = [SKAction animateWithTextures:SPRITES_ANIM_JUMP_DOWN timePerFrame:2.0];
    SKAction *resetDirection   = [SKAction scaleXTo:1 y:1 duration:2.0];
    SKAction *actionJumpDown = [SKAction group:@[resetDirection, jumpDown]];
    return actionJumpDown;
}

+ (SKAction *)jumpUpOfNode:(CGPoint)location withTexture:(NSArray *)arryTexture Duration:(NSTimeInterval)timeInterval {

    SKAction *jumpUP = [SKAction animateWithTextures:arryTexture timePerFrame:timeInterval];
    SKAction*jumpLocation = [SKAction moveTo:CGPointMake(location.x, location.y + 130) duration:timeInterval];
    SKAction *actionJumpUp = [SKAction group:@[jumpUP, jumpLocation, jumpUP]];
    return actionJumpUp;
}

+ (SKAction *)jumpDownFromUp:(CGPoint)location withTexture:(NSArray *)arryTexture duration:(NSTimeInterval)timeInterval {

    SKAction *jumpDown = [SKAction animateWithTextures:arryTexture timePerFrame:timeInterval];
    SKAction*jumpLocationDown = [SKAction moveTo:CGPointMake(location.x, location.y) duration:timeInterval];
    SKAction *actionJumpDown = [SKAction group:@[jumpLocationDown, jumpDown]];
    return actionJumpDown;
}

+ (SKAction *)standOnEagle:(CGPoint)location {

    SKAction *jumpUP = [SKAction animateWithTextures:SPRITES_ANIM_JUMP_UP timePerFrame:0.2];
    SKAction*jumpLocation = [SKAction moveTo:CGPointMake(location.x, location.y) duration:0.4];
    SKAction *actionJumpUp = [SKAction group:@[jumpUP, jumpLocation, jumpUP]];

    SKAction *standUp = [SKAction animateWithTextures:@[SPRITE_WALK_01] timePerFrame:0.1];
    SKAction*standLocation = [SKAction moveTo:location duration:0.1];
    SKAction *actionstandUp = [SKAction group:@[standUp, standLocation]];

//    SKAction *flyUp = [SKAction animateWithTextures:@[SPRITE_WALK_01] timePerFrame:0.1];
//    SKAction*flyLocationUp = [SKAction moveTo:CGPointMake(600, 320) duration:3];
//    SKAction *actionflyUp1 = [SKAction group:@[flyUp, flyLocationUp]];

    SKAction *sequenceAction = [SKAction sequence:@[actionJumpUp, actionstandUp]];

    return sequenceAction;
}

+ (SKAction *)turnRight:(CGPoint)location {

    if (location.y> 55) {
        return nil;
    }
    SKAction *turn = [SKAction animateWithTextures:SPRITES_ANIM_TURN_LEFT timePerFrame:0.5];
    SKAction*turnLocation = [SKAction moveTo:CGPointMake(location.x, location.y+10) duration:0.5];

    SKAction *actionTurn = [SKAction group:@[turn,turnLocation]];
    return actionTurn;
}

+ (SKAction *)turnLeft:(CGPoint)location {

    if (location.y < 20) {
        return nil;
    }

    SKAction *turn = [SKAction animateWithTextures:SPRITES_ANIM_TURN timePerFrame:0.5];
    SKAction*turnLocation = [SKAction moveTo:CGPointMake(location.x, location.y-10) duration:0.5];

    SKAction *actionTurn = [SKAction group:@[turn, turnLocation]];
    return actionTurn;
}

+ (SKAction *)flyingOfEagle:(CGPoint)location {

    SKAction *fly = [SKAction animateWithTextures:EAGLE_IMG timePerFrame:0.1];
    SKAction*flyLocation = [SKAction moveTo:CGPointMake(location.x, location.y+50) duration:2.0];
    SKAction *actionflyUp = [SKAction group:@[fly, flyLocation]];

    SKAction *flyUp = [SKAction animateWithTextures:EAGLE_IMG timePerFrame:0.15];
    SKAction*flyLocationUp = [SKAction moveTo:CGPointMake(600, 300) duration:4];
    SKAction *actionflyUp1 = [SKAction group:@[flyUp, flyLocationUp]];

    SKAction *remove = [SKAction removeFromParent];

    SKAction *sequence = [SKAction sequence:@[actionflyUp, actionflyUp1, remove]];
    SKAction *repeatAction = [SKAction repeatActionForever:  sequence];
    return repeatAction;
}


+ (SKAction *)flyingOfEagleOnSecondView:(CGPoint)location {

    SKAction *fly = [SKAction animateWithTextures:EAGLE_IMG timePerFrame:0.1];
    SKAction*flyLocation = [SKAction moveTo:CGPointMake(location.x, location.y+50) duration:3.0];
    SKAction *actionflyUp = [SKAction group:@[fly, flyLocation]];

    SKAction *flyUp = [SKAction animateWithTextures:EAGLE_IMG timePerFrame:0.15];
    SKAction*flyLocationUp = [SKAction moveTo:CGPointMake(600, 300) duration:4];
    SKAction *actionflyUp1 = [SKAction group:@[flyUp, flyLocationUp]];

    SKAction *remove = [SKAction removeFromParent];

    SKAction *sequence = [SKAction sequence:@[actionflyUp, actionflyUp1, remove]];
    SKAction *repeatAction = [SKAction repeatActionForever:  sequence];
    return repeatAction;
}

+ (SKAction *)monsterActionWithTexture:(NSArray*)texture ofLocation:(CGPoint)location withTimeFrame:(NSTimeInterval)sec{

    SKAction *monsterTexture = [SKAction animateWithTextures:texture timePerFrame:sec];//0.33
    SKAction *monsterAnimation = [SKAction sequence:@[monsterTexture, monsterTexture, monsterTexture, monsterTexture, monsterTexture,monsterTexture,monsterTexture]];
    SKAction*moveLocation = [SKAction moveToX:0 duration:monsterAnimation.duration];//1.5
    SKAction *actionGroup = [SKAction group:@[monsterAnimation, moveLocation]];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[actionGroup, remove]];
    SKAction *repeatAction = [SKAction repeatActionForever: sequence];

    return repeatAction;
}

+ (SKAction *)addPowerToRichter:(NSArray*)arryTexture withTimeInterval:(NSTimeInterval)timeInterval {

    SKAction *walk = [SKAction animateWithTextures:arryTexture timePerFrame:timeInterval];
    SKAction *repeatAction = [SKAction repeatActionForever:walk];
    return repeatAction;
}

#pragma mark - Node has Die 

+ (SKAction *)dieNode {

    SKAction *jumpDown = [SKAction animateWithTextures:SPRITES_ANIM_JUMP_DOWN timePerFrame:0.5];
    return jumpDown;
}


+ (SKAction *)jumpUpOfRichterWolf:(CGPoint)location withTexture:(NSArray *)arryTexture Duration:(NSTimeInterval)timeInterval {

    SKAction *jumpUP = [SKAction animateWithTextures:arryTexture timePerFrame:0.4];
    SKAction*jumpLocation = [SKAction moveTo:CGPointMake(location.x, location.y + 20) duration:0.3];

    SKAction *jumpDown = [SKAction animateWithTextures:arryTexture timePerFrame:0.4];
    SKAction*jumpDownLocation = [SKAction moveTo:CGPointMake(location.x, location.y) duration:0.1];

    SKAction *actionJumpUp = [SKAction sequence:@[jumpUP, jumpLocation, jumpDown, jumpDownLocation]];
    return actionJumpUp;
}

+ (SKAction *)jumpUpDownOfDieNode:(CGPoint)location withTexture:(SKTexture *)texture {

    SKAction *jumpUp = [SKAction animateWithTextures:@[SPRITE_WALK_01] timePerFrame:0.15];
    SKAction *jumpLocation = [SKAction moveTo:CGPointMake(location.x, location.y + 60) duration:0.5];

    SKAction *jumpDown = [SKAction animateWithTextures:@[texture] timePerFrame:0.5];
    SKAction*jumpLocationDown = [SKAction moveTo:CGPointMake(location.x, 0) duration:1.0];

    SKAction *actionJumpUpDown = [SKAction sequence:@[jumpUp, jumpLocation, jumpDown, jumpLocationDown]];
    return actionJumpUpDown;
}

/* + (SKAction *)dieAtDownOnlyAtRichterJumpLocation:(CGPoint)location withTexture:(SKTexture *)texture {

    SKAction *jumpDown = [SKAction animateWithTextures:@[texture] timePerFrame:.1];
    SKAction*jumpLocationDown = [SKAction moveTo:CGPointMake(location.x, 0) duration:1];

    SKAction *actionJumpUpDown = [SKAction sequence:@[jumpDown, jumpLocationDown]];
    return actionJumpUpDown;
} */

+ (SKAction *)jumpUpOfNode:(CGPoint)location withTextureUp:(NSArray *)texturesUp textureDown:(NSArray *)texturesDown Duration:(NSTimeInterval)timeInterval {

    SKAction *jumpUP = [SKAction animateWithTextures:texturesUp timePerFrame:timeInterval];
    SKAction*jumpLocation = [SKAction moveTo:CGPointMake(location.x, location.y + 130) duration:timeInterval];
    SKAction *actionJumpUp = [SKAction group:@[jumpUP, jumpLocation]];

    SKAction *jumpDown = [SKAction animateWithTextures:texturesDown timePerFrame:timeInterval];
    SKAction*jumpLocationDown = [SKAction moveTo:CGPointMake(location.x, location.y) duration:timeInterval];
    SKAction *actionJumpDown = [SKAction group:@[jumpLocationDown, jumpDown]];

    SKAction *sequenceUpAndDown = [SKAction sequence:@[actionJumpUp, actionJumpDown]];
    return sequenceUpAndDown;
}

@end
