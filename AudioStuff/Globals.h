//
//  Globals.h
//  AudioStuff
//
//  Created by emsi on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef __GLO__H_
#define __GLO__H_


typedef struct Oscillator Oscillator;   // forward struct declaration
typedef struct Lfo  Lfo;




#define SAMPLE_RATE 44100



typedef struct
{
    float left_phase;
    float right_phase;
    float freq;
    bool isPlaying;
    Oscillator * osc1;
    Oscillator * osc2;
    Lfo * lfo1;
    Lfo * lfo2;
}   
paTestData;


#endif