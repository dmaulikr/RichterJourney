//
//  CommanAction.h
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 12/01/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface BaseAction : NSObject

#pragma mark - Essential and Changable Function

/*
  Base Function to walking the node.Its essential because it show only walking animation of node.
  You can change cordinate to jumping node. In this change images of walking by using "sprites.h".
  Change:

 */
+ (SKAction *)walkOfNode;
+ (SKAction *)walkOfNodeWithWeapon;

/*
  Base Function to jump down the node.Its essential because it show only jumping animation of node.
  You can change cordinate to jumping node.In this change images of walking by using "sprites.h".
 */

+ (SKAction *)jumpUpOfNode:(CGPoint)location withTextureUp:(NSArray *)texturesUp textureDown:(NSArray *)texturesDown Duration:(NSTimeInterval)timeInterval;





+ (SKAction *)jumpDownOfNode;
+ (SKAction *)jumpUpOfNode:(CGPoint)location withTexture:(NSArray *)arryTexture Duration:(NSTimeInterval)timeInterval;
+ (SKAction *)jumpDownFromUp:(CGPoint)location withTexture:(NSArray *)arryTexture duration:(NSTimeInterval)timeInterval;

+ (SKAction *)jumpUpOfRichterWolf:(CGPoint)location withTexture:(NSArray *)arryTexture Duration:(NSTimeInterval)timeInterval;
+ (SKAction *)jumpUpDownOfDieNode:(CGPoint)location withTexture:(SKTexture *)texture;
+ (SKAction *)dieAtDownOnlyAtRichterJumpLocation:(CGPoint)location withTexture:(SKTexture *)texture;


+ (SKAction *)standOnEagle:(CGPoint)location;

+ (SKAction *)turnRight:(CGPoint)location;
+ (SKAction *)turnLeft:(CGPoint)location;

+ (SKAction *)flyingOfEagle:(CGPoint)location;
+ (SKAction *)flyingOfEagleOnSecondView:(CGPoint)location;

+ (SKAction *)dieNode;

+ (SKAction *)addPowerToRichter:(NSArray*)arryTexture withTimeInterval:(NSTimeInterval)timeInterval;

+ (SKAction *)monsterActionWithTexture:(NSArray*)texture ofLocation:(CGPoint)location withTimeFrame:(NSTimeInterval)sec;

@end
