//
//  Button.h
//  TappyPlane
//
//  Created by Kenneth Wilcox on 11/23/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SoundManager.h"

@class Button;

@protocol ButtonDelegate <NSObject>

-(void)buttonPressed:(Button*)button;

@end

@interface Button : SKSpriteNode

@property (nonatomic) CGFloat pressedScale;
@property (nonatomic, readonly, weak) id pressedTarget;
@property (nonatomic, readonly) SEL pressedAction;
@property (nonatomic, weak) id<ButtonDelegate> delegate;
@property (nonatomic) Sound *pressedSound;
@property (nonatomic) BOOL disabled;

+ (instancetype)spriteNodeWithTexture:(SKTexture *)texture;
+ (instancetype)spriteNodeWithTexture:(SKTexture *)texture andDisabledTexture:(SKTexture*)disabledTexture;
- (void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction;

@end
