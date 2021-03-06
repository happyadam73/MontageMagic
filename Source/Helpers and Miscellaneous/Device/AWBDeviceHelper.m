//
//  AWBDeviceHelper.m
//  Collage Maker
//
//  Created by Adam Buckley on 21/10/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBDeviceHelper.h"
#import <sys/utsname.h>

NSString *machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

NSString *machineFriendlyName()
{
    NSString *sysName = machineName();
    
    if ([sysName hasPrefix:@"iPhone"]) {
        return @"iPhone";
    } else if ([sysName hasPrefix:@"iPod"]) {
        return @"iPod";
    } else if ([sysName hasPrefix:@"iPad"]) {
        return @"iPad";
    } else {
        return @"iOS Device";
    }
}
