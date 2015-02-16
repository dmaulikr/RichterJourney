//
//  ScrollingBackground.m
//  ScrollingSpriteKitTutorial
//
//  Created by Arthur Knopper on 16-03-14.
//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//

#import "ScrollingBackground.h"

@interface ScrollingBackground ()

@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) SKSpriteNode *clonedBackground;
@property (nonatomic) CGFloat currentSpeed;

@end

@implementation ScrollingBackground
@synthesize delegate;

/*- (id)initWithBackground:(NSString *)background
					size:(CGSize)size
				   speed:(CGFloat)speed
{
	self = [super init];
	if (self) {

		// load background image
		self.background = [[SKSpriteNode alloc] initWithImageNamed:background];
		
		// position background
		self.position = CGPointMake(size.width / 2, size.height / 2);
		
		// speed
		self.currentSpeed = speed;
		
		// create duplicate background and insert location
        SKSpriteNode *node = self.background;// assign node with speed
        node.position = CGPointMake(0, 0);
		
        self.clonedBackground = [node copy]; // make copy with all location
        CGFloat clonedPosX = node.position.x;
        CGFloat clonedPosY = node.position.y;
        clonedPosX = +node.size.width;

		self.clonedBackground.position = CGPointMake(clonedPosX, clonedPosY);

        [self addChild:self.clonedBackground]; // point = -self.size.width, 0
        [self addChild:node]; // point = 0, 0
	}
	
	return self;
}

- (void)update:(NSTimeInterval)currentTime {

	CGFloat speed = self.currentSpeed;
	SKSpriteNode *bg = self.background;
	SKSpriteNode *cBg = self.clonedBackground;
	
    CGFloat newBgX = bg.position.x;
    CGFloat newBgY = bg.position.y;

    CGFloat	newCbgX = cBg.position.x;
    CGFloat newCbgY = cBg.position.y;
	
    newBgX  += speed*7;
    newCbgX += speed*7;

    if (newBgX >= bg.size.width) {
        newBgX = newCbgX - cBg.size.width;
    }
    if (newCbgX >= cBg.size.width) {
        newCbgX =  newBgX - bg.size.width;
    }

	cBg.position = CGPointMake(newBgX, newBgY);
	bg.position = CGPointMake(newCbgX, newCbgY);
} */

#pragma mark - Initialization of scrolling node

+ (id)scrollingNodeWithImageNamed:(NSString *)name inContainerWidth:(float)width withSpeed:(float)speed {

    UIImage * image = [UIImage imageNamed:name];

    ScrollingBackground * realNode = [ScrollingBackground spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(width, image.size.height)];
    realNode.scrollingSpeed = speed;

    float total = 0;
    while(total<(width + image.size.width)){
        SKSpriteNode * child = [SKSpriteNode spriteNodeWithImageNamed:name];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(total, 0)];
        [realNode addChild:child];
        total+=child.size.width;
    }

    return realNode;
}

- (void)update:(NSTimeInterval)currentTime {

    [self.children enumerateObjectsUsingBlock:^(SKSpriteNode * child, NSUInteger idx, BOOL *stop) {
        child.position = CGPointMake(child.position.x-self.scrollingSpeed, child.position.y);
        if (child.position.x <= -child.size.width){

            float delta = child.position.x+child.size.width;
            child.position = CGPointMake(child.size.width*(self.children.count-1)+delta, child.position.y);

            if ([self.delegate respondsToSelector:@selector(scrollBackgroundVwDone)]) {
                [self.delegate scrollBackgroundVwDone];
            }
        }
    }];
}

@end
