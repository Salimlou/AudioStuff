//
//  kGLView.h
//  CocoaGL
//
//  Created by Katherine Tattersall on Thu Jul 11 2002.
//  Copyright (c) 2001 ZeroByZero. All rights reserved.
//

#import  <Cocoa/Cocoa.h>
#import  <OpenGL/OpenGL.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <OpenGL/glext.h>



@interface kGLView : NSOpenGLView
{
	float rotX;
}

- (void) drawRect: (NSRect) bounds ;
- (void) rotate;
- (void) resetGLView;
@end