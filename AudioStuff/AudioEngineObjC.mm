//
//  AudioEngineObjC.m
//  AudioStuff
//
//  Created by emsi on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioEngineObjC.h"
#include <math.h>
#include "Oscillator.h"
#include "Lfo.h"




#ifndef M_PI
#define M_PI  (3.14159265)
#endif
#define NUM_SECONDS   (30)
//#define SAMPLE_RATE   (44100)
#define AMPLITUDE     (0.9)
#define FRAMES_PER_BUFFER  (512)
#define OUTPUT_DEVICE Pa_GetDefaultOutputDevice()

// Call back function = synthesizer!

int patestCallback( const void *inputBuffer, void *outputBuffer,
                          unsigned long framesPerBuffer,
                          const PaStreamCallbackTimeInfo* timeInfo,
                          PaStreamCallbackFlags statusFlags,
                   void *userData );



@implementation AudioEngineObjC
@synthesize err;
@synthesize data;
@synthesize isPlaying;

+ (AudioEngineObjC * ) sharedInstance;
{

    static AudioEngineObjC * sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[AudioEngineObjC alloc] init];
    }
    return sharedInstance;
}


- (id)init;
{  NSLog(@"Constructeur");
    self = [super init];
    if (self) {
        data.osc1 = new Oscillator::Oscillator();
         data.osc2 = new Oscillator::Oscillator();
    }
    [self initAudio];
    return self;
}

- (void)dealloc
{   
    Pa_StopStream(&stream);
    [super dealloc];
   
}


-(void)initAudio
{
    
    
    int i;
    PaStreamParameters outputParameters;
    PaStreamParameters inputParameters;
    //PaError err;
    
    printf("PortAudio Test: output sine wave. SR = %d, BufSize = %d\n", SAMPLE_RATE, FRAMES_PER_BUFFER);
    
    /* initialise sinusoidal wavetable */
    ///for( i=0; i<TABLE_SIZE; i++ )
    //    {
    //data.sine[i] = (float) sin( ((double)i/(double)TABLE_SIZE) * M_PI * 2. );
    //    }
    data.left_phase = data.right_phase = 0;
    data.freq = 440;
    data.osc1 = new Oscillator();
    data.osc1->setWave(3);
    data.osc2 = new Oscillator();
    data.osc2->setWave(1);
    data.lfo1 = new Lfo();
    data.lfo1->setWave(1);
    data.lfo2 = new Lfo();
    data.lfo2->setWave(2);
    err = Pa_Initialize();
    if( err != paNoError )[self handleError];
    
    printf("tototo");
    
    int numDevices;
    
    numDevices = Pa_GetDeviceCount();
    if( numDevices < 0 )
        {
        NSLog(@"Pa_CountDevices returned ");
        printf( "ERROR: Pa_CountDevices returned 0x%x\n", numDevices );
        err = numDevices;
        [self handleError];
        }
    //If you want to get information about each device, simply loop through as follows:
    
    const   PaDeviceInfo *deviceInfo;
    
    for( i=0; i<numDevices; i++ )
        {
        deviceInfo = Pa_GetDeviceInfo( i );
        printf( "/////////////////////////////\n" );
        printf( "Device  %d %s\n",i, deviceInfo->name );
        printf( "Device  %d %d\n",i, deviceInfo->structVersion );
        printf( "Device  %d %f\n",i, deviceInfo->defaultSampleRate );
        printf( "Device  %d %d\n",i, deviceInfo->hostApi );
        }
    
    int numHostApi;
    numHostApi = Pa_GetHostApiCount();
    if( numHostApi < 0 )
        {
        printf( "ERROR: numHostApi returned 0x%x\n", numHostApi );
        err = numHostApi;
        [self handleError];
        }
    //If you want to get information about each device, simply loop through as follows:
    
    const   PaHostApiInfo *hostApiInfo;
    
    for( i=0; i<numHostApi; i++ )
        {
        hostApiInfo = Pa_GetHostApiInfo( i );
        printf( "/////////////////////////////\n" );
        printf( "PaHostApiInfo %d %s\n",i, hostApiInfo->name );
        printf( "PaHostApiInfo %d %d\n",i, hostApiInfo->structVersion );
        }
    
    
    outputParameters.device = OUTPUT_DEVICE;
    outputParameters.channelCount = Pa_GetDeviceInfo( outputParameters.device )->maxOutputChannels;       /* stereo output */
    outputParameters.sampleFormat = paFloat32; /* 32 bit floating point output */
    outputParameters.suggestedLatency = Pa_GetDeviceInfo( outputParameters.device )->defaultLowOutputLatency;
    outputParameters.hostApiSpecificStreamInfo = NULL;
    
    inputParameters.device = Pa_GetDefaultInputDevice();
    inputParameters.channelCount = Pa_GetDeviceInfo( inputParameters.device )->maxInputChannels;       /* stereo output */
    inputParameters.sampleFormat = paFloat32; /* 32 bit floating point output */
    inputParameters.suggestedLatency = Pa_GetDeviceInfo( inputParameters.device )->defaultLowInputLatency;
    inputParameters.hostApiSpecificStreamInfo = NULL;
    
    err = Pa_IsFormatSupported( &inputParameters, &outputParameters, SAMPLE_RATE );
    if( err == paFormatIsSupported )
        {
        printf( "Hooray!\n");
        NSLog(@"PHooray!\n ");
        }
    else
        {
        printf("Too Bad.\n");
        }
    
    if (outputParameters.device == paNoDevice) {
        fprintf(stderr,"Error: No default output device.\n");
        [self handleError];
    }
    printf( "Default Device 0x%d\n", outputParameters.device );
    
    
    //err = Pa_OpenDefaultStream(&stream, 0, 2, paFloat32, 44100, FRAMES_PER_BUFFER, patestCallback, &data);
    
    err = Pa_OpenStream(&stream, &inputParameters,&outputParameters,SAMPLE_RATE,FRAMES_PER_BUFFER,paClipOff,patestCallback, &data );
    
    if( err != paNoError ) [self handleError];
    
    //sprintf( data.message, "No Message" );
    //err = Pa_SetStreamFinishedCallback( &stream, &StreamFinished );
    // if( err != paNoError ) goto error;
    
    
    
    printf("Play " );
    //Pa_Sleep( NUM_SECONDS * 1000 );
    
    
    
    
    //return 0; 
    
    
}

-(void) setLfoFrequency:(float) freq;
{
    //data.freq =freq;
    data.lfo1->setFrequency(freq);
    
}

-(void) setLfoAmount:(float) freq;
{
    data.lfo1->setAmplitude(freq);
    
}
-(void) setLfo1Wave:(int) wave;
{
    data.lfo1->setWave(wave);
    
}
-(void) setLfo2Frequency:(float) freq;
{
    //data.freq =freq;
    data.lfo2->setFrequency(freq);
    
}

-(void) setLfo2Amount:(float) freq;
{
    data.lfo2->setAmplitude(freq);
    
}
-(void) setLfo2Wave:(int) wave;
{
    data.lfo2->setWave(wave);
    
}

-(void) setFrequency:(float) freq;
{
    //data.freq =freq;
    data.osc1->setFrequency(freq);

}

-(void) setAmplitude:(float) freq;
{
    data.osc1->setAmplitude(freq);
    
}

-(void) setWave:(int) wave;
{
    data.osc1->setWave(wave);
    
}

-(void) setFrequency2:(float) freq;
{
    
    data.osc2->setFrequency(freq);
    
}

-(void) setAmplitude2:(float) freq;
{
    data.osc2->setAmplitude(freq);
    
}

-(void) setWave2:(int) wave;
{
    data.osc2->setWave(wave);
    
}

-(void) play;
{
if(data.isPlaying)
    {
    data.isPlaying=false;
    }else{
        data.isPlaying = true;
    }

}

-(PaError) handleError{
    Pa_Terminate();
    fprintf( stderr, "An error occured while using the portaudio stream\n" );
    fprintf( stderr, "Error number: %d\n", err );
    fprintf( stderr, "Error message: %s\n", Pa_GetErrorText( err ) );
    return err;
}

-(PaError) startStream{
    
    err = Pa_StartStream( stream );
    if( err != paNoError ) [self handleError];
     printf("Test start.\n");
    return err;
}

-(PaError) stopEndStream{
    err = Pa_StopStream( stream );
    if( err != paNoError )  [self handleError];
    err = Pa_CloseStream( stream );
    if( err != paNoError ) [self handleError];
    
    Pa_Terminate();
    printf("Test finished.\n");
    
    return err;
}


/*float fRand(void) {
 return(((float)rand() - 1) / (float)RAND_MAX);
 }*/

int patestCallback( const void *inputBuffer, void *outputBuffer,
                   unsigned long framesPerBuffer,
                   const PaStreamCallbackTimeInfo* timeInfo,
                   PaStreamCallbackFlags statusFlags,
                   void *userData )
{
    /* Cast data passed through stream to our structure. */
    paTestData *data = (paTestData*)userData; 
    float *out = (float*)outputBuffer;
    unsigned int i;
    (void) inputBuffer; /* Prevent unused variable warning. */
    
    
    if(!data->isPlaying){
        //Silence
        for( i=0; i<framesPerBuffer; i++ )
            {
            *out++ = 0;  /* left */
            *out++ = 0;  /* right */
            }

    }else{
        for( i=0; i<framesPerBuffer; i++ )
            {
            *out++ =*out++ = (data->osc1->getValue() *data->lfo1->getValue() + data->osc2->getValue()*data->lfo2->getValue()); 
            }

    }
        
        return 0;
}





@end
