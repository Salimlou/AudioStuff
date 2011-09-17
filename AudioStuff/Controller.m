//
//  Controller.m
//  AudioStuff
//
//  Created by emsi on 09/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Controller.h"



@implementation Controller



@synthesize audioEngine;

- (id)init
{
    self = [super init];
    if (self) {
        audioEngine = [[AudioEngineObjC sharedInstance]init] ;
       
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


-(void)awakeFromNib{
    
    [[AudioEngineObjC sharedInstance] startStream];
    counter = 1;
    counter = 2;
    
}


- (IBAction)setLfoRate:(id)sender {
    [[AudioEngineObjC sharedInstance] setLfoFrequency:[sender floatValue]];
    
}

- (IBAction)setLfoAmount:(id)sender {
    [[AudioEngineObjC sharedInstance] setLfoAmount:[sender floatValue]];
    
}

- (IBAction)setLfoWave:(id)sender {
    [[AudioEngineObjC sharedInstance] setLfo1Wave:counter3];
    counter3++;
    if (counter3>3) {
        counter3=1;
    }
}

- (IBAction)setLfo2Rate:(id)sender {
    [[AudioEngineObjC sharedInstance] setLfo2Frequency:[sender floatValue]];
}

- (IBAction)setLfo2wave:(id)sender {
    [[AudioEngineObjC sharedInstance] setLfo2Wave:counter4];
    counter4++;
    if (counter4>3) {
        counter4=1;
    }
    
}

- (IBAction)setLfo2Amount:(id)sender {
    [[AudioEngineObjC sharedInstance] setLfo2Amount:[sender floatValue]];
}

- (IBAction)setPlay:(id)sender {
    [[AudioEngineObjC sharedInstance] play];
}

- (IBAction)setWav:(id)sender {
    [[AudioEngineObjC sharedInstance] setWave:counter];
    counter++;
    if (counter>3) {
        counter=1;
    }
}

- (IBAction)setWav2:(id)sender {
    [[AudioEngineObjC sharedInstance] setWave2:counter2];
    counter2++;
    if (counter2>3) {
        counter2=1;
    }
}



- (IBAction)setOsc1freq:(id)sender {
    [[AudioEngineObjC sharedInstance] setFrequency:[sender floatValue]];
    
    
}

- (IBAction)setOsc1Vol:(id)sender {
    [[AudioEngineObjC sharedInstance] setAmplitude:[sender floatValue]];
    
}



- (IBAction)setOsc2Freq:(id)sender {
    [[AudioEngineObjC sharedInstance] setFrequency2:[sender floatValue]];
    
}

- (IBAction)setOsc2Vol:(id)sender {
    [[AudioEngineObjC sharedInstance] setAmplitude2:[sender floatValue]];
    
}



@end
