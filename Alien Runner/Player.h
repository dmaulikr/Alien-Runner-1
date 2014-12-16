//
//  Player.h
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/13/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
  Running,
  Jumping,
  Hurt,
} PlayerState;

@interface Player : SKSpriteNode

@property (nonatomic) CGVector velocity;
@property (nonatomic) CGPoint targetPosition;
@property (nonatomic) BOOL didJump;
@property (nonatomic) BOOL onGround;
@property (nonatomic) CGFloat gravityMultiplier;
@property (nonatomic) PlayerState state;

- (void)update;
- (CGRect)collisionRectAtTarget;
- (BOOL)gravityFlipped;

@end
