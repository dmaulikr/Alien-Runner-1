//
//  Button.m
//  TappyPlane
//
//  Created by Kenneth Wilcox on 11/23/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "Button.h"
#import <objc/message.h>

@interface Button()

@property (nonatomic) CGRect fullSizeFrame;
@property (nonatomic) BOOL pressed;

@end

@implementation Button

+ (instancetype)spriteNodeWithTexture:(SKTexture *)texture
{
  Button *instance = [super spriteNodeWithTexture:texture];
  instance.pressedScale = 0.9;
  instance.userInteractionEnabled = YES;
  return instance;
}

- (void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction
{
  _pressedTarget = pressedTarget;
  _pressedAction = pressedAction;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  self.fullSizeFrame = self.frame;
  [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch *touch in touches) {
    if (self.pressed != CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
      self.pressed = !self.pressed;
      if (self.pressed) {
        [self setScale:self.pressedScale];
        [self.pressedSound play];
      } else {
        [self setScale:1.0];
      }
    }
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self setScale:1.0];
  self.pressed = NO;
  for (UITouch *touch in touches) {
    if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
      // Pressed button
      //[self.pressedTarget performSelector:self.pressedAction]; // <-- Leak Warning
      
      // EXC_BAD_ACCESS
      //id (*typed_msgSend)(id, SEL) = (void *)objc_msgSend;
      //typed_msgSend(self.pressedTarget, self.pressedAction);
      
      // EXC_BAD_ACCESS
      //((id (*)(id, SEL))objc_msgSend)(self.pressedTarget, self.pressedAction);
      
      // Disable "Enable Strict Checking of objc_msgSend calls" in project settings...
      objc_msgSend(self.pressedTarget, self.pressedAction);
    }
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self setScale:1.0];
  self.pressed = NO;
}

@end
