//
//  ImagesConvertVideo.m
//  Component
//
//  Created by Ansel on 2018/11/14.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "ImagesConvertVideo.h"
#import <AVFoundation/AVFoundation.h>

CGSize const DefaultSize = {.width = 1280, .height = 720};
NSInteger const DefaultPFS = 1;

@implementation ImagesConvertVideo

+ (void)videoFromImages:(NSArray<UIImage *> *)images callback:(void(^)(NSString *videoPath))callback {
    return [self videoFromImages:images fps:DefaultPFS size:DefaultSize callback:callback];
}

+ (void)videoFromImages:(NSArray<UIImage *> *)images fps:(NSInteger)fps callback:(void(^)(NSString *videoPath))callback {
    return [self videoFromImages:images fps:fps size:DefaultSize callback:callback];
}

+ (void)videoFromImages:(NSArray<UIImage *> *)images size:(CGSize)size callback:(void(^)(NSString *videoPath))callback {
    return [self videoFromImages:images fps:DefaultPFS size:size callback:callback];
}

+ (void)videoFromImages:(NSArray<UIImage *> *)images fps:(NSInteger)fps size:(CGSize)size callback:(void(^)(NSString *videoPath))callback {
    if (!images || images.count == 0) {
        callback ? callback(nil) : nil;
        return;
    }
    
    __block NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"ImagesConvertVideoTemp.mp4"]];
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:NULL];
    
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:tempPath] fileType:AVFileTypeQuickTimeMovie error:&error];
    if (error) {
        callback ? callback(nil) : nil;
        return;
    }
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = @{AVVideoCodecKey: AVVideoCodecH264, AVVideoWidthKey:@(1280), AVVideoHeightKey:@(720)};
    AVAssetWriterInput *writeInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writeInput sourcePixelBufferAttributes:nil];
    NSParameterAssert(writeInput);
    NSParameterAssert([videoWriter canAddInput:writeInput]);
    [videoWriter addInput:writeInput];
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    [writeInput requestMediaDataWhenReadyOnQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) usingBlock:^{
        CVPixelBufferRef buffer = NULL;
        NSInteger index = 0;
        while (1) {
            if (writeInput.readyForMoreMediaData) {
                CMTime presentationTime = CMTimeMake((int64_t)index, (int32_t)fps);
                if (index >= images.count) {
                    break;
                } else {
                    buffer = [self pixelBufferFromImage:images[index]];
                }
                
                if (buffer) {
                    [adaptor appendPixelBuffer:buffer withPresentationTime:presentationTime];
                    index++;
                }
            }
        }
        
        [writeInput markAsFinished];
        [videoWriter finishWritingWithCompletionHandler:^{
            if (videoWriter.status != AVAssetWriterStatusCompleted) {
                [[NSFileManager defaultManager] removeItemAtPath:tempPath error:NULL];
                tempPath = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callback ? callback(tempPath) : nil;
            });
        }];
    }];
}

+ (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image {
    NSDictionary *options = @{(__bridge NSString *)kCVPixelBufferCGImageCompatibilityKey: @YES, (__bridge NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES};
    CVPixelBufferRef pixelBuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, image.size.width, image.size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef)options, &pixelBuffer);
    NSParameterAssert(status == kCVReturnSuccess && pixelBuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *pixelData = CVPixelBufferGetBaseAddress(pixelBuffer);
    NSParameterAssert(pixelData != NULL);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixelData, image.size.width, image.size.height, 8, 4*image.size.width, colorSpace, kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return pixelBuffer;
}


@end
