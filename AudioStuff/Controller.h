//
//  Controller.h
//  AudioStuff
//
//  Created by emsi on 09/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "AudioEngineObjC.h"

@class AudioEngineObjC;
@interface Controller : NSObject {
@private
    AudioEngineObjC * audioEgine;
    IBOutlet NSButton *playButton;
    
   
    IBOutlet NSSlider *osc1Freq;
    IBOutlet NSSlider *osc1Vol;
    
    
    
    
    IBOutlet NSSlider *osc2FReq;
    IBOutlet NSSlider *osc2Vol;
    int counter;
    int counter2;
    int counter3;
    int counter4;
}

@property (nonatomic , retain) AudioEngineObjC * audioEngine;


- (IBAction)setLfoRate:(id)sender;
- (IBAction)setLfoAmount:(id)sender;
- (IBAction)setLfoWave:(id)sender;

- (IBAction)setLfo2Rate:(id)sender;
- (IBAction)setLfo2wave:(id)sender;


- (IBAction)setPlay:(id)sender;

- (IBAction)setWav:(id)sender;
- (IBAction)setWav2:(id)sender;

- (IBAction)setOsc1freq:(id)sender;
- (IBAction)setOsc1Vol:(id)sender;


- (IBAction)setOsc2Freq:(id)sender;
- (IBAction)setOsc2Vol:(id)sender;



@end
