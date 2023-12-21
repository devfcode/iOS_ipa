//
//  RunWhenBackground.h
//  Background
//
//  Created by Dio Brand on 2023/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunWhenInBackground : NSObject

+ (instancetype)sharedManager;

// 进程进入后台时调用,可让进程一直保活
-(void)start;
// 进程进入前台时调用,关掉音乐
-(void)stop;

@end

NS_ASSUME_NONNULL_END
