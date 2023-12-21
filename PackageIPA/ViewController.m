//
//  ViewController.m
//  PackageIPA
//
//  Created by zd on 19/12/2023.
//

#import "ViewController.h"
#include "server.h"

static NSString *ipa_in_sandbox = @"ipa_sandbox";

@interface ViewController ()
{
    NSFileManager *fileManager;
    NSUserDefaults *defaults;
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    fileManager = [NSFileManager defaultManager];
    // 如果 ipa 没在 sandbox 里,就复制一份过去
    defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:ipa_in_sandbox]) {
        [self copy_ipa_to_sandbox];
    }
    
    // 在子进程中启动服务器
    [self performSelectorInBackground:@selector(start_server) withObject:nil];
//    [self start_server];
}

// 把项目中的 ipa 文件放到沙盒中去
-(void)copy_ipa_to_sandbox {
    NSError *error;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"ipa"];
    NSLog(@"%@", path);
    
    // 读取 sandbox 里的内容
    NSData *fileData = [fileManager contentsAtPath:path];
    
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    //    NSLog(@"docDir:\n%@",docDir);
    NSString *targetPath = [NSString stringWithFormat:@"%@/test.ipa", docDir];
    if([fileManager enumeratorAtPath:targetPath]) {
        BOOL suc = [fileManager removeItemAtPath:path error:&error];
        if (suc) {
            NSLog(@"%@:删除成功",path);
        }else {
            NSLog(@"%@:删除失败,%@",path,[error localizedFailureReason]);
        }
    }
    
    BOOL suc = [fileManager createFileAtPath:targetPath contents:fileData attributes:nil];
    if (suc) {
        [defaults setBool:YES forKey:ipa_in_sandbox];
        NSLog(@"%@  write success",targetPath);
    }else{
        NSLog(@"%@  write fail",targetPath);
    }
}

-(void)start_server {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    //    NSLog(@"docDir:\n%@",docDir);
    NSString *path = [NSString stringWithFormat:@"%@/test.ipa", docDir];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"%@ is exist", path);
        const char *path2 = [path UTF8String];
        printf("%s\n",path2);
//        while (1) {
            server_start(path2);
//        }
    }else {
        NSLog(@"%@ is not exist", path);
//        [self copy_ipa_to_sandbox];
//        [self start_server];
    }
}

- (IBAction)online_install_act:(UIButton *)sender {
    NSString *scheme = @"itms-services://?action=download-manifest&url=https://jobs8.cn:9000/download/manifest.plist";
    NSURL *url = [NSURL URLWithString:scheme];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:url options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"open %@",scheme);
        }else {
            NSLog(@"open fail");
        }
    }];
}

- (IBAction)offline_install_act:(UIButton *)sender {
    
}

@end
