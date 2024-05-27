#import "AudioOutputMonitor.h"

static void audioQueueOutputCallback(void * __nullable inUserData,
                                     AudioQueueRef inAQ,
                                     AudioQueueBufferRef inBuffer) {
    // Retrieve user data
    AudioOutputMonitor *monitor = (__bridge AudioOutputMonitor *)inUserData;
    [monitor processAudioBuffer:inBuffer];

    // Enqueue buffer back to audio queue
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

@interface AudioOutputMonitor ()
@property (nonatomic, assign) AudioQueueRef audioQueue;
@end

@implementation AudioOutputMonitor

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupAudioQueue];
    }
    return self;
}

- (void)setupAudioQueue {
    AudioStreamBasicDescription format;
    memset(&format, 0, sizeof(format));
    format.mSampleRate = 44100.0;
    format.mFormatID = kAudioFormatLinearPCM;
    format.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    format.mBitsPerChannel = 16;
    format.mChannelsPerFrame = 2;
    format.mBytesPerPacket = format.mBytesPerFrame = 4;
    format.mFramesPerPacket = 1;

    AudioQueueNewOutput(&format, audioQueueOutputCallback, (__bridge void *)self, NULL, NULL, 0, &_audioQueue);

    // Allocate and enqueue buffers
    for (int i = 0; i < 3; ++i) {
        AudioQueueBufferRef buffer;
        AudioQueueAllocateBuffer(self.audioQueue, 1024, &buffer);
        AudioQueueEnqueueBuffer(self.audioQueue, buffer, 0, NULL);
    }

    AudioQueueStart(self.audioQueue, NULL);
}

- (void)processAudioBuffer:(AudioQueueBufferRef)buffer {
    SInt16 *samples = (SInt16 *)buffer->mAudioData;
    UInt32 numSamples = buffer->mAudioDataByteSize / sizeof(SInt16);

    // Calculate RMS and dB
    double rms = 0.0;
    for (UInt32 i = 0; i < numSamples; i += 2) {
        SInt16 leftSample = samples[i];
        SInt16 rightSample = samples[i + 1];
        rms += leftSample * leftSample + rightSample * rightSample;
    }
    rms = sqrt(rms / (numSamples / 2));
    double dB = 20 * log10(rms);

    // Post notification or update delegate
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AudioLevelUpdated" object:@(dB)];
    });
}

- (void)startMonitoring {
    [self setupAudioQueue];
}

- (void)stopMonitoring {
    AudioQueueStop(self.audioQueue, true);
    AudioQueueDispose(self.audioQueue, true);
}

- (void)dealloc {
    [self stopMonitoring];
}

@end
