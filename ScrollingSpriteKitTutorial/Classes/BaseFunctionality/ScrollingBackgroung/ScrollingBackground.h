//
//  ScrollingBackground.h
//  ScrollingSpriteKitTutorial
//
//  Created by Arthur Knopper on 16-03-14.
//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@protocol scrollVwDelegate <NSObject>

- (void)scrollBackgroundVwDone;

@end

@interface ScrollingBackground : SKSpriteNode

@property (nonatomic) CGFloat scrollingSpeed;

@property (unsafe_unretained)id <scrollVwDelegate>delegate;

#pragma mark - Essential and Change Restricted Function
/*
 Function is to initialize scrollview with name and size with other scroll view.
 */
+ (id)scrollingNodeWithImageNamed:(NSString *)name inContainerWidth:(float)width withSpeed:(float)speed;

/*
 In this function both node is run simultaniously to perform infinite scrolling.
 This Function is run after each timeinterval to scroll the node.
 */
- (void)update:(NSTimeInterval)currentTime;


@end

