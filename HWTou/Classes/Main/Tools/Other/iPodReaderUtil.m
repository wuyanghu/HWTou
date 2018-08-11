//
//  iPodReaderUtil.m
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "iPodReaderUtil.h"
#import <AVFoundation/AVFoundation.h>

#define EXPORT_NAME @"exported.caf"

@implementation iPodReaderUtil

+ (void)exportAudioWithMPItem:(MPMediaItem *)item exportPath:(NSString *)exportPath success:(void (^)(NSString *type,NSInteger size))success progress:(void (^)(NSInteger currentSize,NSInteger totalSize))progress failure:(void (^)())failure {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL existed = [fileManager fileExistsAtPath:exportPath isDirectory:&isDir];
    if (!existed) {
        [fileManager createDirectoryAtPath:exportPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSURL *assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    NSError *assetError = nil;
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
                                                                error:&assetError];
    if (assetError) {
        NSLog (@"error: %@", assetError);
        failure();
    }
    
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks audioSettings: nil];
    if (! [assetReader canAddOutput: assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        return;
    }
    NSLog (@"assetReaderOutput.mediaType = %@", assetReaderOutput.mediaType);
    [assetReader addOutput: assetReaderOutput];
    
    NSString *exportPPP = [exportPath stringByAppendingPathComponent:EXPORT_NAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPPP]) {
        [[NSFileManager defaultManager] removeItemAtPath:exportPPP error:nil];
    }
    NSURL *exportURL = [NSURL fileURLWithPath:exportPPP];
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL fileType:AVFileTypeCoreAudioFormat error:&assetError];
    if (assetError) {
        NSLog (@"error: %@", assetError);
        failure();
    }
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:32000.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                    [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:outputSettings];
    if ([assetWriter canAddInput:assetWriterInput]) {
        [assetWriter addInput:assetWriterInput];
    } else {
        NSLog (@"can't add asset writer input... die!");
        failure();
    }
    
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter startWriting];
    [assetReader startReading];
    
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
    [assetWriter startSessionAtSourceTime: startTime];
    
    __block UInt64 convertedByteCount = 0;
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                            usingBlock: ^
     {
         // NSLog (@"top of block");
         while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (!nextBuffer) {
                 // done?
                 [assetWriterInput markAsFinished];
                 [assetWriter finishWriting];
                 [assetReader cancelReading];
                 NSDictionary *outputFileAttributes = [[NSFileManager defaultManager]
                                                       attributesOfItemAtPath:exportPPP
                                                       error:nil];
                 NSLog (@"done. file size is %ld",[outputFileAttributes fileSize]);
                 NSNumber *doneFileSize = [NSNumber numberWithLong:[outputFileAttributes fileSize]];
                 
                 success(@"caf",[doneFileSize integerValue]);
                 
//                 [self performSelectorOnMainThread:@selector(updateCompletedSizeLabel:)
//                                        withObject:doneFileSize
//                                     waitUntilDone:NO];
                 break;
             } else {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
                 //                NSLog (@"appended a buffer (%d bytes)",
                 //                       CMSampleBufferGetTotalSampleSize (nextBuffer));
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 // oops, no
                 // sizeLabel.text = [NSString stringWithFormat: @"%ld bytes converted", convertedByteCount];
                 
                 NSNumber *convertedByteCountNumber = [NSNumber numberWithLong:convertedByteCount];
                 
                 NSLog(@"__________%@",convertedByteCountNumber);
                 
                 progress([convertedByteCountNumber integerValue],0);
                 
//                 [self performSelectorOnMainThread:@selector(updateSizeLabel:)
//                                        withObject:convertedByteCountNumber
//                                     waitUntilDone:NO];
             }
         }
         
     }];
    NSLog (@"bottom of convertTapped:");
}


@end
