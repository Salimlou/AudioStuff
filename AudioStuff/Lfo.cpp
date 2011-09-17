//
//  Lfo.cpp
//  AudioStuff
//
//  Created by emsi on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "Lfo.h"

//
//  Lfo.cpp
//  AudioStuff
//
//  Created by emsi on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "Globals.h"
#include <math.h>
#include <stdio.h>
#define M_TWOPI 6.283185307179586




//////////////////////////////////////////////////
/*************************************************/
//Lmouhim....
/*************************************************/
//////////////////////////////////////////////////
float  Lfo::getValue(){
    if (frequency == 0) {
        return 0.0f;
    }
    
    if (frequency < 0.01f) {
        return 0.0f;
    }
    long period_samples = SAMPLE_RATE / frequency;
    if (period_samples == 0) {
        return 0.0f;
    }
    float x = (phase / (float)period_samples);
    float value = 0;
    switch (wave) {
        case SINE:
            value = sinf(M_TWOPI * x);
            break;
        case TRIANGLE:
            value = (2.0f * fabs(2.0f * x - 2.0f * floorf(x) - 1.0f) - 1.0f);
            break;
        case SAWTOOTH:
            value = 2.0f * (x - floorf(x) - 0.5f);
            break;
            
    }
    phase = (phase + 1) % (long)period_samples;
    float m = 0.5f * amplitude;
    float b = 1.0f - m;
    
    value = m * value +b;
    
    value = fmaxf(0.0f, value);
    value = fminf(1.0f, value);
    return value;
    
};





//////////////////////////////////////////////////
/*************************************************/
//Utils
/*************************************************/
//////////////////////////////////////////////////
Lfo::Lfo():frequency(440.0f),phase(0),amplitude(0),wave(SINE) { }

Lfo::~Lfo() { }

//////////////////////////////////////////////////
/*************************************************/
//Getters and setters....
/*************************************************/
//////////////////////////////////////////////////

void Lfo::setFrequency(float  _frequency)
{
    frequency = _frequency;
};

float  Lfo::getFrequency()
{   
    return frequency;
};

void Lfo::setPhase(long  _phase)
{   
    phase = _phase;
};

long  Lfo::getPhase(){
    return phase;
};

void Lfo::setAmplitude(float  _amplitude)
{
    amplitude = _amplitude;
    
};

float  Lfo::getAmplitude(){
    return amplitude;
};

void Lfo::setWave(waveType  _wave){
    wave = _wave;
};

void Lfo::setWave(int  _wave){
    
    if (_wave==1) {
        wave=SINE;
    } else if (_wave==2) {
        wave= SAWTOOTH;
    }else{
        wave=TRIANGLE;
    }
};

Lfo::waveType  Lfo::getWave(){
    return wave;
};

