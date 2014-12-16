//
//  Player.m
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/13/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "Player.h"

@interface Player()

@property (nonatomic) BOOL didJumpPrevious;
@property (nonatomic) BOOL canFlipGravity;

@end

@implementation Player

static const CGFloat kGravity = -0.24;
static const CGFloat kAcceleration = 0.07;
static const CGFloat kMaxSpeed = 3.5;
static const CGFloat kJumpSpeed = 5.5;
static const CGFloat kJumpCutOffSpeed = 2.5;
static const BOOL kShowCollisionRect = YES;

- (instancetype)init
{
  self = [super initWithImageNamed:@"p1_walk01"];
  if (self) {
    
    // Set gravity to pull down by default
    self.gravityMultiplier = 1;
  }
  return self;
}

- (BOOL)gravityFlipped
{
  return self.gravityMultiplier == -1;
}

- (void)update
{
  if (kShowCollisionRect) {
    [self removeAllChildren];
    
    SKShapeNode *box = [SKShapeNode node];
    box.path = CGPathCreateWithRect([self collisionRectAtTarget], nil);
    box.strokeColor = [SKColor redColor];
    box.lineWidth = 0.1;
    box.position = CGPointMake(-self.targetPosition.x, -self.targetPosition.y);
    
    [self addChild:box];
  }
  
  // Apply gravity
  self.velocity = CGVectorMake(self.velocity.dx, self.velocity.dy + kGravity * self.gravityMultiplier);
  
  // Apply acceleration
  self.velocity = CGVectorMake(fminf(kMaxSpeed, self.velocity.dx + kAcceleration), self.velocity.dy);
  
  // Prevent ability to flip gravity when player lands on the ground
  if (self.onGround) {
    self.canFlipGravity = NO;
  }
  
  if (self.didJump && !self.didJumpPrevious) {
    // Starting a jump
    if (self.onGround) {
      // perform jump
      self.velocity = CGVectorMake(self.velocity.dx, kJumpSpeed * self.gravityMultiplier);
      self.canFlipGravity = YES;
    } else if (self.canFlipGravity) {
      // Flip gravity
      self.gravityMultiplier *= -1;
      self.canFlipGravity = NO;
    }
  } else if (!self.didJump) {
    // Cancel jump
    if (self.gravityFlipped) {
      if (self.velocity.dy < -kJumpCutOffSpeed) {
        self.velocity = CGVectorMake(self.velocity.dx, -kJumpCutOffSpeed);
      } else {
        if (self.velocity.dy > kJumpCutOffSpeed) {
          self.velocity = CGVectorMake(self.velocity.dx, kJumpCutOffSpeed);
        }
      }
    }
  }
  
  // Move player
  self.targetPosition = CGPointMake(self.position.x + self.velocity.dx, self.position.y + self.velocity.dy);
  
  // Track previous jump state
  self.didJumpPrevious = self.didJump;

}

- (CGRect)collisionRectAtTarget
{
  // Calculate smaller rectanlge based on frame
  CGRect collisionRect = CGRectInset(self.frame, 4, 2);
  
  // Move rectangle to target position
  CGPoint movement = CGPointMake(self.targetPosition.x - self.position.x, self.targetPosition.y - self.position.y);
  
  // having an inset of 2 on the y and -2 offset gives 4 pixel pading on top and 0 on bottom
  collisionRect = CGRectOffset(collisionRect, movement.x, movement.y - 2);
  return collisionRect;
}

@end
