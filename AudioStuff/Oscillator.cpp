//
//  Oscillator.cpp
//  AudioStuff
//
//  Created by emsi on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "Oscillator.h"
#include "Globals.h"
#include <math.h>
#include <stdio.h>
#define M_TWOPI 6.283185307179586




//////////////////////////////////////////////////
/*************************************************/
//Lmouhim....
/*************************************************/
//////////////////////////////////////////////////
float  Oscillator::getValue(){
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
    value *= amplitude;
    value = fmaxf(-1.0f, value);
    value = fminf(1.0f, value);
    return value;

};





//////////////////////////////////////////////////
/*************************************************/
//Utils
/*************************************************/
//////////////////////////////////////////////////
Oscillator::Oscillator():frequency(440.0f),phase(0),amplitude(0),wave(SINE) { }
Oscillator::~Oscillator() { }

//////////////////////////////////////////////////
/*************************************************/
//Getters and setters....
/*************************************************/
//////////////////////////////////////////////////

void Oscillator::setFrequency(float  _frequency)
{
    frequency = _frequency;
};

float  Oscillator::getFrequency()
{   
    return frequency;
};

void Oscillator::setPhase(long  _phase)
{   
    phase = _phase;
};

long  Oscillator::getPhase(){
    return phase;
};

void Oscillator::setAmplitude(float  _amplitude)
{
    amplitude = _amplitude;
    
};

float  Oscillator::getAmplitude(){
    return amplitude;
};

void Oscillator::setWave(waveType  _wave){
    wave = _wave;
};

void Oscillator::setWave(int  _wave){
    
    if (_wave==1) {
        wave=SINE;
    } else if (_wave==2) {
        wave= SAWTOOTH;
    }else{
        wave=TRIANGLE;
    }
};

Oscillator::waveType  Oscillator::getWave(){
    return wave;
};

