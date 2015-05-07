//
//  LYStrAnalysis.m
//  TheReading
//
//  Created by mac on 15/5/5.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "LYStrAnalysis.h"
static NSString *finStr;
@implementation LYStrAnalysis

+ (NSString *)stringAnalysisFromStr: (NSString *)oriStr {
    finStr = [oriStr stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
    finStr = [finStr stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"-"];
    finStr = [finStr stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
    finStr = [finStr stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
    finStr = [finStr stringByReplacingOccurrencesOfString:@"&bdquo;" withString:@"\""];
    finStr = [finStr stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"..."];
    finStr = [finStr stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@"'"];
    finStr = [finStr stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
    finStr = [finStr stringByReplacingOccurrencesOfString:@"&sbquo;" withString:@"'"];
    finStr = [finStr stringByReplacingOccurrencesOfString:@"&circ;" withString:@"^"];
    return finStr;
}

@end
