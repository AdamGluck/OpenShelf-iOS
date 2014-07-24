//
//  OSVideoBackgroundViewController.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/24/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSVideoBackgroundViewController.h"

@interface OSVideoBackgroundViewController ()
{
    AVPlayer * avPlayer;
    AVPlayerLayer *avPlayerLayer;
    CMTime time;
    
    //blur
    GPUImageiOSBlurFilter *_blurFilter;
    GPUImageBuffer *_videoBuffer;
    GPUImageMovie *_liveVideo;
}
@end

@implementation OSVideoBackgroundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    // ---------------------------AVPLAYER STUFF -------------------------------
    
    
    NSString * ressource = [[NSBundle mainBundle] pathForResource:@"demoVideo" ofType:@".mp4"];
    
    
    NSURL * urlPathOfVideo = [NSURL fileURLWithPath:ressource];
    avPlayer = [AVPlayer playerWithURL:urlPathOfVideo];
    avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
    avPlayerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view.layer addSublayer: avPlayerLayer];

    
    [avPlayer play];
    time = kCMTimeZero;
    
    //prevent music coming from other app to be stopped
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    
    // -------------------------------------------------------------------------
    
    
    //AVPlayer Notifications
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[avPlayer currentItem]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseVideo)
                                                 name:@"PauseBgVideo"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeVideo)
                                                 name:@"ResumeBgVideo"
                                               object:nil];
    
    
    
    
    // ---------------------------BLUR STUFF -------------------------------
    
    
    _blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    //change the float value in order to change the blur effect
    _blurFilter.blurRadiusInPixels = 12.0f;
    _blurFilter.downsampling = 1.0f;
    _videoBuffer = [[GPUImageBuffer alloc] init];
    [_videoBuffer setBufferSize:1];
    

    
    // ---------------------------------------------------------------------
  
}

-(void)viewDidLayoutSubviews{
    [self processBlurWIthBackgroundVideoOnViews:self.blurViews];

}

#pragma mark - AVPlayer methods


- (void)pauseVideo
{
    [avPlayer pause];
    time = avPlayer.currentTime;
}


- (void)resumeVideo
{
    [avPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [avPlayer play];
    
    [self processBlurWIthBackgroundVideoOnViews:self.blurViews];
    

}


- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

-(void)processBlurWIthBackgroundVideoOnViews:(NSMutableArray *)views{
    for (BlurView *view in views) {
        [self processBlurWithBackgroundVideoOnView:view];
    }
}
- (void) processBlurWithBackgroundVideoOnView:(BlurView*)view
{
    
    _liveVideo = [[GPUImageMovie alloc] initWithPlayerItem:avPlayer.currentItem];
    
    [_liveVideo addTarget:_videoBuffer];
    [_videoBuffer addTarget:_blurFilter];
    [_blurFilter addTarget:view];
    [_liveVideo startProcessing];
}

-(NSMutableArray *)blurViews{
    if (!_blurViews) {
        _blurViews = [NSMutableArray new];
    }
    return _blurViews;
}

@end
