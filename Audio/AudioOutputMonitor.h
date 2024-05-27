#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioOutputMonitor : NSObject

- (void)startMonitoring;
- (void)stopMonitoring;
- (void)processAudioBuffer:(AudioQueueBufferRef)buffer;

@end
