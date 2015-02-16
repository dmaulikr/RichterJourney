//
//  SuperScene.h
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 09/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol BaseSceneDelegate <NSObject>

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer;

@end

@interface BaseScene : SKScene <SKPhysicsContactDelegate> {

}

@property (unsafe_unretained)id <BaseSceneDelegate> baseDelegate;

#pragma mark - Essential and Change Restricted Function

/*
 This function initialize "GRModelOfLifeScore" class to show life and score of hero.
 There should not be any changes in this funtion. All things all mendatory to initialize all scene classes.
 */
- (id)initWithSize:(CGSize)size;

/*
 Remove existing child node and add these child node again.
 There would not be any changes.
 */
- (void)addNodeLife;
@end
