#import "kGLView.h"
#include <OpenGL/gl.h>

@implementation kGLView

- (id) init {
	self = [super init];
	if (self != nil) {
		rotX=0;
	}
	return self;
}


static void drawAnObject ()
{
	glColor3f(1.0f, 0.85f, 0.35f);
	glBegin(GL_TRIANGLES);
	{
    glVertex3f(  0.0,  0.6, 0.0);
    glVertex3f( -0.2, -0.3, 0.0);
    glVertex3f(  0.2, -0.3 ,0.0);
	}
	glEnd();	
}

-(void) drawRect: (NSRect) bounds
{
	glClearColor(0, 0, 0, 0);
	glClear(GL_COLOR_BUFFER_BIT);
	glLoadIdentity();
	glRotatef(rotX,1,1,1);
	drawAnObject();
	glFlush();	
}

-(void) rotate
{
	rotX += 1;
	[self drawRect:[self bounds]];
}

-(void) resetGLView
{
	rotX = 0;
	[self drawRect:[self bounds]];
}

@end
