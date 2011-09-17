/*
     File: OpenGLRenderer.m
 Abstract: The OpenGLRenderer class creates and draws the shaders.
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010~2011 Apple Inc. All Rights Reserved.
 
 */

#import "OpenGLRenderer.h"
#import "imageUtil.h"



#define GetGLError()									\
{														\
	GLenum err = glGetError();							\
	while (err != GL_NO_ERROR) {						\
		NSLog(@"GLError %s set in File:%s Line:%d\n",	\
				GetGLErrorString(err),					\
				__FILE__,								\
				__LINE__);								\
		err = glGetError();								\
	}													\
}

// Toggle this to disable vertex buffer objects
// (i.e. use client-side vertex array objects)
#define USE_VERTEX_BUFFER_OBJECTS 1

// Toggle this to disable the rendering the reflection
// and setup of the GLSL progam, model and FBO used for 
// the reflection.
#define RENDER_REFLECTION 1


// Indicies to which we will set vertex array attibutes
// See buildVAO and buildProgram
enum {
	POS_ATTRIB_IDX,
	NORMAL_ATTRIB_IDX,
	TEXCOORD_ATTRIB_IDX
};

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@implementation OpenGLRenderer




GLuint _viewWidth;
GLuint _viewHeight;

static GLfloat rotx;

- (void) resizeWithWidth:(GLuint)width AndHeight:(GLuint)height
{
	glViewport(0, 0, width, height);
	
	_viewWidth = width;
	_viewHeight = height;
	
}

- (void) render
{  

	glClear(GL_COLOR_BUFFER_BIT);
	glViewport(0, 0, _viewWidth , _viewHeight);
    
	glPushMatrix();
    glLoadIdentity();
    
    glTranslatef(0.0f, 0.0f, 0.0f);
    
    //glRotatef(rotx, 0, 1, 0);
    glPopMatrix();
	glBegin(GL_TRIANGLES);
	{
    if (rotx>10) {
        glColor3f(1.0f, 0.85f, 0.35f);
         NSLog(@" 1x : %f           " ,rotx);
    }else{
        glColor3f(1.0f, 0.2f, 0.35f);
         NSLog(@" 2x : %f           " ,rotx);
    }
    glVertex3f(  0.0f +rotx,  0.6f, 0.0f);
    glVertex3f( -0.2f, -0.3f +rotx, 0.0f);
    glVertex3f(  0.2f, -0.3f ,0.0f +rotx);
    
	}
	glEnd();
    
    
 // glFlush();
    rotx++;
    if (rotx>100) {
        rotx = 0;
    }
    
   // NSLog(@" rotx : %f           " ,rotx);
    
		
}

static GLsizei GetGLTypeSize(GLenum type)
{
	switch (type) {
		case GL_BYTE:
			return sizeof(GLbyte);
		case GL_UNSIGNED_BYTE:
			return sizeof(GLubyte);
		case GL_SHORT:
			return sizeof(GLshort);
		case GL_UNSIGNED_SHORT:
			return sizeof(GLushort);
		case GL_INT:
			return sizeof(GLint);
		case GL_UNSIGNED_INT:
			return sizeof(GLuint);
		case GL_FLOAT:
			return sizeof(GLfloat);
	}
	return 0;
}


-(GLuint) buildTexture:(demoImage*) image
{
	GLuint texName;
	
	// Create a texture object to apply to model
	glGenTextures(1, &texName);
	glBindTexture(GL_TEXTURE_2D, texName);
	
	// Set up filter and wrap modes for this texture object
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
	
	// Indicate that pixel rows are tightly packed 
	//  (defaults to stride of 4 which is kind of only good for
	//  RGBA or FLOAT data types)
	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
	
	// Allocate and load image data into texture
	glTexImage2D(GL_TEXTURE_2D, 0, image->format, image->width, image->height, 0,
				 image->format, image->type, image->data);

	// Create mipmaps for this texture for better image quality
	glGenerateMipmap(GL_TEXTURE_2D);
	
	GetGLError();
	
	return texName;
}



- (id) init
{
	if((self = [super init]))
	{
		NSLog(@"%s %s", glGetString(GL_RENDERER), glGetString(GL_VERSION));
		
		
		
		_viewWidth = 300;
		_viewHeight = 300;
		
    rotx = 0;
		
		
		NSString* filePathName = nil;

		//////////////////////////////
		// Load our character model //
		//////////////////////////////
		
		filePathName = [[NSBundle mainBundle] pathForResource:@"demon" ofType:@"model"];
			
		
		////////////////////////////////////
		// Load texture for our character //
		////////////////////////////////////
		
	/*	filePathName = [[NSBundle mainBundle] pathForResource:@"demon" ofType:@"png"];
		demoImage *image = imgLoadImage([filePathName cStringUsingEncoding:NSASCIIStringEncoding], false);
		
		// Build a texture object with our image data
		_characterTexName = [self buildTexture:image];
		
		// We can destroy the image once it's loaded into GL
		imgDestroyImage(image);*/
	
		
		////////////////////////////////////////////////////
		// Load and Setup shaders for character rendering //
		////////////////////////////////////////////////////
		
				
		////////////////////////////////////////////////
		// Set up OpenGL state that will never change //
		////////////////////////////////////////////////
		
		// Depth test will always be enabled
		///glEnable(GL_DEPTH_TEST);
	
		// We will always cull back faces for better performance
		//glEnable(GL_CULL_FACE);
		
		// Always use this clear color
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		
		// Draw our scene once without presenting the rendered image.
		//   This is done in order to pre-warm OpenGL
		// We don't need to present the buffer since we don't actually want the 
		//   user to see this, we're only drawing as a pre-warm stage
		[self render];
		
		// Reset the _characterAngle which is incremented in render
		
		// Check for errors to make sure all of our setup went ok
		GetGLError();
	}
	
	return self;
}


- (void) dealloc
{
	
	// Cleanup all OpenGL objects and 
	//glDeleteTextures(1, &_characterTexName);
		
		
	[super dealloc];	
}

@end
