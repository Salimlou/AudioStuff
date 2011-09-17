//
//  AudioEngineObjC.h
//  AudioStuff
//
//  Created by emsi on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "portaudio.h"
#import "Globals.h"






@interface AudioEngineObjC : NSObject {
@private
    PaStream * stream;
    paTestData data;
    PaError err;
    BOOL isPlaying;
    
    
}

/*@property (nonatomic ) PaStream * stream;
@property (nonatomic ) PaStreamParameters outputParameters;
@property (nonatomic ) PaStreamParameters inputParameters;
*/
@property (readwrite) paTestData data;
@property (readwrite) PaError err;
@property (readwrite)  BOOL isPlaying;

+(AudioEngineObjC *) sharedInstance;
-(void) initAudio;
-(PaError) startStream;
-(PaError) stopEndStream;
-(PaError) handleError;

-(void) setFrequency:(float) freq;
-(void) setAmplitude:(float) freq;
-(void) setWave:(int) wave;

-(void) setFrequency2:(float) freq;
-(void) setAmplitude2:(float) freq;
-(void) setWave2:(int) wave;

-(void) setLfoFrequency:(float) freq;
-(void) setLfoAmount:(float) freq;
-(void) setLfo1Wave:(int) wave;

-(void) setLfo2Frequency:(float) freq;
-(void) setLfo2Amount:(float) freq;
-(void) setLfo2Wave:(int) wave;

-(void) play;
@end
