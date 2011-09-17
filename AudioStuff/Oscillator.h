//
//  Oscillator.h
//  AudioStuff
//
//  Created by emsi on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef _OSCILLATOR_H
#define _OSCILLATOR_H
    
class Oscillator {
    
    enum waveType {
        SINE = 1,
        SAWTOOTH = 2,
        TRIANGLE = 3,
    };
    float  frequency;
    long  phase;
    float  amplitude;
    waveType  wave;
    
public:
    Oscillator();
    ~Oscillator();
    
    void setFrequency(float  frequency);
    float  getFrequency();
    void setPhase(long  phase);
    long  getPhase();
    void setAmplitude(float  amplitude);
    float  getAmplitude();
    void setWave(waveType  wave);
    void setWave(int  wave);
    waveType  getWave();

    float  getValue();
    
    
    

    
};










#endif
