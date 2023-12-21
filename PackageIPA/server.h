//
//  server.h
//  PackageIPA
//
//  Created by zd on 20/12/2023.
//

#ifndef server_h
#define server_h

#include <stdio.h>

// 局域网内 建立一个 server , 下载 ipa包。最终实现 ipa 包从本地安装的功能
int server_start(const char *path);

#endif /* server_h */
