//
//  Player.h
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/13/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode

@property (nonatomic) CGVector velocity;
@property (nonatomic) CGPoint targetPosition;

- (void)update;

@end
