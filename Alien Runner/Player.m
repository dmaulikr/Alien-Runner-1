//
//  Player.m
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/13/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "Player.h"

@implementation Player

static const CGFloat kGravity = -0.2;

- (instancetype)init
{
  self = [super initWithImageNamed:@"p1_walk01"];
  if (self) {
  }
  return self;
}

- (void)update
{
  // Apply gravity
  self.velocity = CGVectorMake(self.velocity.dx, self.velocity.dy + kGravity);
  
  // Move player
  self.position = CGPointMake(self.position.x + self.velocity.dx, self.position.y + self.velocity.dy);

}

@end
