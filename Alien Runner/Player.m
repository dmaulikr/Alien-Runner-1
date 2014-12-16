//
//  Player.m
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/13/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "Player.h"
#import "SoundManager.h"

@interface Player()

@property (nonatomic) BOOL didJumpPrevious;
@property (nonatomic) BOOL canDoubleJump;
@property (nonatomic) SKAction *runningAnimation;

@end

@implementation Player

static const CGFloat kGravity = -0.24;
static const CGFloat kAcceleration = 0.07;
static const CGFloat kMaxSpeed = 3.5;
static const CGFloat kJumpSpeed = 5.5;
static const CGFloat kDoubleJumpSpeed = 6.5;
static const CGFloat kJumpCutOffSpeed = 2.5;
static const BOOL kShowCollisionRect = NO;

- (instancetype)init
{
  self = [super initWithImageNamed:@"p1_walk01"];
  if (self) {
    
    // Create array for frames for run animation
    NSMutableArray *walkFrames = [NSMutableArray array];
    for (int i = 1; i < 12; i++) {
      SKTexture *frame = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"p1_walk%02d", i]];
      [walkFrames addObject:frame];
    }
    
    // Create action for run animation
    SKAction *animation = [SKAction animateWithTextures:walkFrames timePerFrame:(1.0/15.0) resize:NO restore:NO];
    self.runningAnimation = [SKAction repeatActionForever:animation];
    
    // Alien is falling my default
    self.state = Jumping;
    
    // Set gravity to pull down by default
    self.gravityMultiplier = 1;
  }
  return self;
}

- (BOOL)gravityFlipped
{
  return self.gravityMultiplier == -1;
}

- (void)setGravityMultiplier:(CGFloat)gravityMultiplier
{
  _gravityMultiplier = gravityMultiplier;
  // Set the texture orientation to match the pull of gravity (flip the image)
  self.yScale = gravityMultiplier;
}

- (void)setState:(PlayerState)state
{
  // only if it changes
  if (_state != state) {
    
    if (_state == Running) {
      [self removeActionForKey:@"Run"];
    }
    
    _state = state;
    switch (state) {
      case Running:
        // todo Play landing sound
        
        // todo add running loop sound
        [self runAction:self.runningAnimation withKey:@"Run"];
        break;
        
      case Jumping:
        self.texture = [SKTexture textureWithImageNamed:@"p1_jump"];
        break;
      
      case Hurt:
        [[SoundManager sharedManager] playSound:@"playerKilled.caf"];
        self.texture = [SKTexture textureWithImageNamed:@"p1_hurt"];
        break;
        
      default:
        break;
    }
  }
}

- (void)update
{
  if (kShowCollisionRect) {
    [self removeAllChildren];
    
    SKShapeNode *box = [SKShapeNode node];
    CGRect rect = [self collisionRectAtTarget];
    if (self.gravityFlipped) {
      rect.origin.y -= 4;
    }
    box.path = CGPathCreateWithRect(rect, nil);
    box.strokeColor = [SKColor redColor];
    box.lineWidth = 0.1;
    box.position = CGPointMake(-self.targetPosition.x, -self.targetPosition.y);
    
    [self addChild:box];
  }
  
  // Apply gravity
  self.velocity = CGVectorMake(self.velocity.dx, self.velocity.dy + kGravity * self.gravityMultiplier);
  
  if (self.state != Hurt) {
    // Apply acceleration
    self.velocity = CGVectorMake(fminf(kMaxSpeed, self.velocity.dx + kAcceleration), self.velocity.dy);
    
    // Prevent ability to flip gravity when player lands on the ground
    if (self.onGround) {
      self.canDoubleJump = NO;
      self.state = Running;
    } else {
      self.state = Jumping;
    }
    
    if (self.didJump && !self.didJumpPrevious) {
      // Starting a jump
      if (self.onGround) {
        [[SoundManager sharedManager] playSound:@"jump.caf"];
        
        // perform jump
        self.velocity = CGVectorMake(self.velocity.dx, kJumpSpeed * self.gravityMultiplier);
        self.canDoubleJump = YES;
      } else if (self.canDoubleJump) {
        [[SoundManager sharedManager] playSound:@"jump.caf"];
        
        // perform double jump
        self.velocity = CGVectorMake(self.velocity.dx, kDoubleJumpSpeed * self.gravityMultiplier);
        
        self.canDoubleJump = NO;
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
  }
  
  // Move player
  self.targetPosition = CGPointMake(self.position.x + self.velocity.dx, self.position.y + self.velocity.dy);
  
  // Track previous jump state
  self.didJumpPrevious = self.didJump;

}

- (CGRect)collisionRectAtTarget
{
  // Calculate smaller rectangle
  CGRect collisionRect = CGRectMake(self.targetPosition.x - (self.size.width * self.anchorPoint.x) + 4, self.targetPosition.y - (self.size.height * self.anchorPoint.y), self.size.width - 8, self.size.height - 4);
  
  if (self.gravityFlipped) {
    // move rectangle up because the bottom is now at the top
    collisionRect.origin.y += 4;
  }
  
  return collisionRect;
}

-(void)kill
{
  self.state = Hurt;
  self.velocity = CGVectorMake(0, kJumpSpeed * self.gravityMultiplier);
}

@end
