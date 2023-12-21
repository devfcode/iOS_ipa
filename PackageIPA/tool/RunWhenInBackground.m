//
//  RunWhenInBackground.m
//  Background
//
//  Created by Dio Brand on 2023/4/1.
//

#import "RunWhenInBackground.h"
#import <AVFoundation/AVFoundation.h>

@interface RunWhenInBackground()

@property(nonatomic, strong)AVAudioPlayer *player;

@end

@implementation RunWhenInBackground

+ (instancetype)sharedManager {
    static RunWhenInBackground *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[super allocWithZone:NULL] init];
    });
    return staticInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

- (AVAudioPlayer *)player{
    if (!_player) {
        // 1. 创建播放器对象
        // 虽然传递的参数是NSURL地址, 但是只支持播放本地文件, 远程音乐文件路径不支持
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"JM" withExtension:@"wav"];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //允许调整速率,此设置必须在prepareplay 之前
        //        _player.enableRate = YES;
        _player.numberOfLoops = MAXBSIZE;//循环播放次数
        [_player prepareToPlay];
        
        // 进程后台保活,app进入后台音乐播放也不暂停
        AVAudioSession  *session = [AVAudioSession  sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return _player;
}

-(void)start {
    [self.player play];
}

-(void)stop {
    [self.player stop];
}

@end
